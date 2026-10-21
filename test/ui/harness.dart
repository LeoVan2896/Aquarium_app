import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/data/providers.dart';
import 'package:aquarium_app/main.dart';
import 'package:aquarium_app/domain/chart_reader.dart';
import 'package:aquarium_app/notifications/reminder_notifier.dart';
import 'package:aquarium_app/scanning/chart_scanner.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Without closeStreamsSynchronously, close() waits on stream-cleanup timers that fake-async never fires.
AppDatabase testDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}

Future<void> pumpApp(
  WidgetTester tester,
  AppDatabase db, {
  ReminderNotifier? notifier,
  ChartScanner? scanner,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 21)),
        reminderNotifierProvider.overrideWithValue(
          notifier ?? FakeReminderNotifier(),
        ),
        chartScannerProvider.overrideWithValue(scanner ?? FakeChartScanner()),
      ],
      child: const AquariumApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tearDownApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  await db.close();
  await tester.pump(Duration.zero);
}

Future<void> scrollTo(WidgetTester tester, Finder finder) => tester
    .scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);

class FakeReminderNotifier implements ReminderNotifier {
  FakeReminderNotifier({this.granted = true});

  bool granted;
  final scheduled = <List<PlannedReminder>>[];
  final tests = <String>[];

  @override
  Future<bool> requestPermission() async => granted;

  @override
  Future<void> replaceAll(List<PlannedReminder> reminders) async =>
      scheduled.add(reminders);

  @override
  Future<void> sendTest(String tankName) async => tests.add(tankName);
}

class FakeChartScanner implements ChartScanner {
  FakeChartScanner([this.tokens]);

  final List<ChartToken>? tokens;
  final sources = <PhotoSource>[];

  @override
  Future<List<ChartToken>?> scan(PhotoSource source) async {
    sources.add(source);
    return tokens;
  }
}
