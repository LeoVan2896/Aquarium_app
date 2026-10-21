import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/ui/dashboard.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;
  late Tank tank;

  setUp(() async {
    db = testDatabase();
    tank = await db.select(db.tanks).getSingle();
  });

  Future<void> startCycle() => db.updateTank(
    tank.id,
    TanksCompanion(cycleStartedAt: Value(DateTime(2026, 10, 18))),
  );

  Future<void> log(
    Parameter p,
    double value,
    DateTime at, [
    String unit = 'ppm',
  ]) => db.addReadings([
    ReadingsCompanion.insert(
      tankId: tank.id,
      parameter: p,
      value: value,
      unit: unit,
      takenAt: at,
    ),
  ]);

  Future<void> openTank(WidgetTester tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
  }

  Finder inLatest(String text) =>
      find.descendant(of: find.byType(LatestValues), matching: find.text(text));

  testWidgets('cycle card shows stage, next step and a soil-range prediction', (
    tester,
  ) async {
    await startCycle();
    await log(Parameter.ammonia, 2, DateTime(2026, 10, 19, 9));
    await openTank(tester);

    expect(
      find.descendant(
        of: find.byType(CycleCard),
        matching: find.text('Ammonia phase'),
      ),
      findsOneWidget,
    );
    expect(
      find.text("Ammonia is 2 ppm. Nitrite hasn't shown up yet."),
      findsOneWidget,
    );
    expect(find.text('Next step'), findsOneWidget);
    expect(find.text('Nov 29 – Dec 13, 2026'), findsOneWidget);
    expect(find.text('Low confidence'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('no prediction until the cycle has a start date', (tester) async {
    await openTank(tester);

    expect(
      find.text('Set the day you started cycling this tank.'),
      findsOneWidget,
    );
    expect(find.text('Predicted finish'), findsNothing);
    await tearDownApp(tester, db);
  });

  testWidgets('softened banner shows for GH 0 / KH 6 dKH only', (tester) async {
    await log(Parameter.gh, 0, DateTime(2026, 10, 20), 'dGH');
    await log(Parameter.kh, 6, DateTime(2026, 10, 20), 'dKH');
    await openTank(tester);

    expect(find.text('Softened water?'), findsOneWidget);
    expect(find.text('GH 0.0 dGH · KH 6.0 dKH'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('no softened banner for GH 8 / KH 6 dKH', (tester) async {
    await log(Parameter.gh, 8, DateTime(2026, 10, 20), 'dGH');
    await log(Parameter.kh, 6, DateTime(2026, 10, 20), 'dKH');
    await openTank(tester);

    expect(find.text('Softened water?'), findsNothing);
    await tearDownApp(tester, db);
  });

  testWidgets('latest values show the newest reading per parameter', (
    tester,
  ) async {
    await log(Parameter.ammonia, 2, DateTime(2026, 10, 19, 9));
    await log(Parameter.ammonia, 1, DateTime(2026, 10, 20, 9));
    await log(Parameter.nitrate, 10, DateTime(2026, 10, 20, 9));
    await openTank(tester);

    expect(find.text('Latest'), findsOneWidget);
    expect(inLatest('1 ppm'), findsOneWidget);
    expect(inLatest('2 ppm'), findsNothing);
    expect(inLatest('10 ppm'), findsOneWidget);
    expect(inLatest('Oct 20 · 9:00 AM'), findsNWidgets(2));
    await tearDownApp(tester, db);
  });
}
