import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/config.dart';
import '../domain/cycle_engine.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/prediction.dart';
import '../domain/recommendations.dart';
import '../domain/reminder_schedule.dart';
import '../domain/softened_check.dart';
import '../domain/species.dart';
import '../domain/species_catalog.dart';
import '../domain/tank_conditions.dart';
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

final speciesCatalogProvider = FutureProvider<SpeciesCatalog>(
  (ref) => loadSpeciesCatalog(rootBundle.loadString),
);

final tankStockEntriesProvider = StreamProvider.family<List<StockEntry>, int>((
  ref,
  tankId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.stockEntries,
  )..where((s) => s.tankId.equals(tankId))).watch();
});

class StockedSpecies {
  const StockedSpecies({
    required this.type,
    required this.speciesId,
    required this.count,
    this.animal,
    this.plant,
  });

  final SpeciesType type;
  final String speciesId;
  final int count;
  final AnimalSpecies? animal;
  final PlantSpecies? plant;

  // A species dropped from a later catalog still shows, by its id.
  String get name => animal?.commonName ?? plant?.commonName ?? speciesId;
}

class StockContext {
  const StockContext({
    required this.catalog,
    required this.setup,
    required this.conditions,
    required this.maturity,
    required this.status,
    required this.fishGated,
    required this.stock,
    required this.alerts,
    required this.now,
    required this.conditionsMaxAgeDays,
  });

  final SpeciesCatalog catalog;
  final TankSetup setup;
  final TankConditions conditions;
  final Maturity maturity;
  final CycleStatus status;
  final bool fishGated;
  final List<StockedSpecies> stock;
  final List<SpeciesAlert> alerts;
  final DateTime now;
  final int conditionsMaxAgeDays;

  List<AnimalSpecies> get animals => [for (final s in stock) ?s.animal];

  List<PlantSpecies> get plants => [for (final s in stock) ?s.plant];

  int countOf(SpeciesType type, String speciesId) =>
      stock
          .where((s) => s.type == type && s.speciesId == speciesId)
          .firstOrNull
          ?.count ??
      0;
}

final stockContextProvider = Provider.family<AsyncValue<StockContext>, Tank>((
  ref,
  tank,
) {
  final catalog = ref.watch(speciesCatalogProvider);
  final readings = ref.watch(tankReadingsProvider(tank.id));
  final events = ref.watch(tankEventsProvider(tank.id));
  final entries = ref.watch(tankStockEntriesProvider(tank.id));
  for (final value in [catalog, readings, events, entries]) {
    if (value case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  if ((catalog.value, readings.value, events.value, entries.value) case (
    final c?,
    final r?,
    final e?,
    final s?,
  )) {
    return AsyncData(
      _buildStockContext(
        tank,
        c,
        [for (final x in r) x.toLogged()],
        e,
        [for (final x in s) x.toLogged()],
        ref.watch(clockProvider)(),
        ref.watch(domainConfigProvider),
      ),
    );
  }
  return const AsyncLoading();
});

StockContext _buildStockContext(
  Tank tank,
  SpeciesCatalog catalog,
  List<LoggedReading> readings,
  List<Event> events,
  List<LoggedStock> entries,
  DateTime now,
  DomainConfig config,
) {
  final profile = tank.toProfile();
  final loggedEvents = [for (final e in events) e.toLogged()];
  final effectiveIds = {for (final e in effectiveOnly(loggedEvents)) e.id};
  final usesRootTabs = events.any(
    (e) =>
        effectiveIds.contains(e.id) &&
        (e.product?.toLowerCase().contains('root tab') ?? false),
  );
  final setup = tank.toSetup(usesRootTabs: usesRootTabs);
  final status = evaluateCycle(
    tank: profile,
    readings: readings,
    events: loggedEvents,
    now: now,
    config: config,
  );
  final animals = {for (final a in catalog.animals) a.id: a};
  final plants = {for (final p in catalog.plants) p.id: p};
  final stock = [
    for (final MapEntry(key: key, value: count) in stockCounts(entries).entries)
      StockedSpecies(
        type: key.type,
        speciesId: key.speciesId,
        count: count,
        animal: key.type == SpeciesType.animal ? animals[key.speciesId] : null,
        plant: key.type == SpeciesType.plant ? plants[key.speciesId] : null,
      ),
  ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  final conditions = tankConditions(
    setup: setup,
    readings: readings,
    now: now,
    config: config,
  );
  return StockContext(
    catalog: catalog,
    setup: setup,
    conditions: conditions,
    maturity: tankMaturity(
      tank: profile,
      readings: readings,
      events: loggedEvents,
      config: config,
    ),
    status: status,
    fishGated: fishGated(tank.cycleMethod, status.stage),
    stock: stock,
    alerts: speciesAlerts(
      animals: [for (final s in stock) ?s.animal],
      plants: [for (final s in stock) ?s.plant],
      setup: setup,
      conditions: conditions,
      config: config,
    ),
    now: now,
    conditionsMaxAgeDays: config.conditionsMaxAgeDays.value,
  );
}
