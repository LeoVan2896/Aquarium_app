import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;
  late FakeReminderNotifier notifier;

  setUp(() {
    db = testDatabase();
    notifier = FakeReminderNotifier();
  });

  Future<void> openReminders(WidgetTester tester) async {
    await pumpApp(tester, db, notifier: notifier);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Reminders'));
    await tester.pumpAndSettle();
  }

  testWidgets('saving schedules six reminders counted from today', (
    tester,
  ) async {
    await openReminders(tester);
    expect(find.text('Every day'), findsOneWidget);

    await tester.tap(find.byTooltip('More days'));
    await tester.pumpAndSettle();
    expect(find.text('Every 2 days'), findsOneWidget);
    expect(find.text('Oct 21, 2026 · 9:00 AM'), findsOneWidget);
    expect(find.text('Oct 23, 2026 · 9:00 AM'), findsOneWidget);

    await tester.tap(find.text('Save reminders'));
    await tester.pumpAndSettle();

    final row = await db.select(db.reminders).getSingle();
    expect((row.everyNDays, row.timeOfDay, row.enabled), (2, '09:00', true));
    final plan = notifier.scheduled.last;
    expect(plan, hasLength(6));
    expect(plan.first.at, DateTime(2026, 10, 21, 9));
    expect(plan[1].at, DateTime(2026, 10, 23, 9));
    expect(plan.first.title, 'Time to test 20 gal planted');
    expect(find.text('Reminders'), findsNothing);
    await tearDownApp(tester, db);
  });

  testWidgets('logging a reading moves the next reminder', (tester) async {
    final tank = await db.select(db.tanks).getSingle();
    await db.saveReminder(
      tankId: tank.id,
      everyNDays: 3,
      timeOfDay: '19:30',
      enabled: true,
    );
    await db.addReadings([
      ReadingsCompanion.insert(
        tankId: tank.id,
        parameter: Parameter.ammonia,
        value: 1,
        unit: 'ppm',
        takenAt: DateTime(2026, 10, 20, 8),
      ),
    ]);
    await pumpApp(tester, db, notifier: notifier);

    expect(notifier.scheduled.last.first.at, DateTime(2026, 10, 23, 19, 30));
    await tearDownApp(tester, db);
  });

  testWidgets('turning reminders off clears the schedule', (tester) async {
    final tank = await db.select(db.tanks).getSingle();
    await db.saveReminder(
      tankId: tank.id,
      everyNDays: 1,
      timeOfDay: '09:00',
      enabled: true,
    );
    await openReminders(tester);
    expect(notifier.scheduled.last, hasLength(6));

    await tester.tap(find.text('Remind me to test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save reminders'));
    await tester.pumpAndSettle();

    expect(notifier.scheduled.last, isEmpty);
    expect((await db.select(db.reminders).getSingle()).enabled, isFalse);
    await tearDownApp(tester, db);
  });

  testWidgets('denied permission keeps the screen open with a banner', (
    tester,
  ) async {
    notifier.granted = false;
    await openReminders(tester);

    await tester.tap(find.text('Save reminders'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Notifications are off'), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(await db.select(db.reminders).get(), hasLength(1));
    await tearDownApp(tester, db);
  });

  testWidgets('send a test reminder', (tester) async {
    await openReminders(tester);

    await tester.tap(find.text('Send a test reminder'));
    await tester.pumpAndSettle();

    expect(notifier.tests, ['20 gal planted']);
    expect(
      find.text('Sent. It should appear within a minute.'),
      findsOneWidget,
    );
    await tearDownApp(tester, db);
  });

  testWidgets('archived tanks get no reminders', (tester) async {
    final tank = await db.select(db.tanks).getSingle();
    await db.saveReminder(
      tankId: tank.id,
      everyNDays: 1,
      timeOfDay: '09:00',
      enabled: true,
    );
    await db.setTankArchived(tank.id, archived: true);
    await pumpApp(tester, db, notifier: notifier);

    expect(notifier.scheduled.last, isEmpty);
    await tearDownApp(tester, db);
  });
}
