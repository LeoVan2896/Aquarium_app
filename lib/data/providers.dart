import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/config.dart';
import '../domain/cycle_engine.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/prediction.dart';
import '../domain/reminder_schedule.dart';
import '../domain/softened_check.dart';
import '../notifications/reminder_notifier.dart';
import '../scanning/chart_scanner.dart';
import 'database.dart';
import 'mappers.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final domainConfigProvider = Provider<DomainConfig>(
  (ref) => const DomainConfig(),
);

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final tanksProvider = StreamProvider<List<Tank>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.tanks)..orderBy([
        (t) => OrderingTerm.asc(t.createdAt),
        (t) => OrderingTerm.asc(t.id),
      ]))
      .watch();
});

final testKitsProvider = StreamProvider<List<TestKit>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.testKits).watch();
});

final kitParametersProvider = StreamProvider<List<KitParameter>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.kitParameters).watch();
});

final tankReadingsProvider = StreamProvider.family<List<Reading>, int>((
  ref,
  tankId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.readings,
  )..where((r) => r.tankId.equals(tankId))).watch();
});

final tankEventsProvider = StreamProvider.family<List<Event>, int>((
  ref,
  tankId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.events)..where((e) => e.tankId.equals(tankId))).watch();
});

class TankDashboard {
  const TankDashboard({
    required this.status,
    required this.prediction,
    required this.softened,
    required this.latest,
    required this.readings,
    required this.events,
  });

  final CycleStatus status;
  final CyclePrediction? prediction;
  final SoftenedWarning? softened;
  final List<LoggedReading> latest;
  final List<LoggedReading> readings;
  final List<LoggedEvent> events;
}

final tankDashboardProvider = Provider.family<AsyncValue<TankDashboard>, Tank>((
  ref,
  tank,
) {
  final readings = ref.watch(tankReadingsProvider(tank.id));
  final events = ref.watch(tankEventsProvider(tank.id));
  return switch ((readings, events)) {
    (AsyncData(value: final r), AsyncData(value: final e)) => AsyncData(
      _buildDashboard(
        tank.toProfile(),
        [for (final x in r) x.toLogged()],
        [for (final x in e) x.toLogged()],
        ref.watch(clockProvider)(),
        ref.watch(domainConfigProvider),
      ),
    ),
    (AsyncError(:final error, :final stackTrace), _) ||
    (
      _,
      AsyncError(:final error, :final stackTrace),
    ) => AsyncError(error, stackTrace),
    _ => const AsyncLoading(),
  };
});

final cycleStatusProvider = Provider.family<AsyncValue<CycleStatus>, Tank>(
  (ref, tank) =>
      ref.watch(tankDashboardProvider(tank)).whenData((d) => d.status),
);

TankDashboard _buildDashboard(
  TankProfile tank,
  List<LoggedReading> readings,
  List<LoggedEvent> events,
  DateTime now,
  DomainConfig config,
) {
  final status = evaluateCycle(
    tank: tank,
    readings: readings,
    events: events,
    now: now,
    config: config,
  );
  final effectiveReadings = effectiveOnly(readings)
    ..sort((a, b) => a.takenAt.compareTo(b.takenAt));
  final latest = <Parameter, LoggedReading>{};
  for (final r in effectiveReadings) {
    final current = latest[r.parameter];
    if (current == null || r.takenAt.isAfter(current.takenAt)) {
      latest[r.parameter] = r;
    }
  }
  return TankDashboard(
    status: status,
    prediction: predictFinish(
      tank: tank,
      status: status,
      readings: readings,
      now: now,
      config: config,
    ),
    softened: checkSoftenedWater(readings, config: config),
    latest: latest.values.toList()
      ..sort((a, b) => a.parameter.index.compareTo(b.parameter.index)),
    readings: effectiveReadings,
    events: effectiveOnly(events)
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt)),
  );
}

final reminderNotifierProvider = Provider<ReminderNotifier>(
  (ref) => throw UnimplementedError('Override with a ReminderNotifier'),
);

final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.reminders).watch();
});

final allReadingsProvider = StreamProvider<List<Reading>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.readings).watch();
});

final reminderPlanProvider = Provider<List<PlannedReminder>?>((ref) {
  final tanks = ref.watch(tanksProvider).value;
  final reminders = ref.watch(remindersProvider).value;
  final readings = ref.watch(allReadingsProvider).value;
  if (tanks == null || reminders == null || readings == null) return null;
  return planReminders(
    tanks: tanks,
    reminders: reminders,
    readings: readings,
    now: ref.watch(clockProvider)(),
  );
});

List<PlannedReminder> planReminders({
  required List<Tank> tanks,
  required List<Reminder> reminders,
  required List<Reading> readings,
  required DateTime now,
}) => [
  for (final reminder in reminders)
    if (reminder.enabled)
      if (tanks.where((t) => t.id == reminder.tankId && !t.archived).firstOrNull
          case final tank?)
        if (parseTimeOfDay(reminder.timeOfDay) case final time?)
          for (final (i, at) in upcomingReminders(
            everyNDays: reminder.everyNDays,
            time: time,
            now: now,
            lastTestAt: lastTestFor(readings, tank.id),
          ).indexed)
            (
              id: tank.id * 10 + i,
              at: at,
              title: 'Time to test ${tank.name}',
              body: 'Log a reading to keep the cycle estimate accurate.',
            ),
];

DateTime? lastTestFor(List<Reading> readings, int tankId) {
  DateTime? latest;
  for (final r in effectiveOnly([
    for (final r in readings)
      if (r.tankId == tankId) r.toLogged(),
  ])) {
    if (latest == null || r.takenAt.isAfter(latest)) latest = r.takenAt;
  }
  return latest;
}

final chartScannerProvider = Provider<ChartScanner>(
  (ref) => MlKitChartScanner(),
);
