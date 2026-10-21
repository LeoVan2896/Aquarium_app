import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  Future<void> setAmmoniaSteps() =>
      (db.update(
        db.kitParameters,
      )..where((p) => p.parameter.equalsValue(Parameter.ammonia))).write(
        const KitParametersCompanion(stepsJson: Value([0, 0.25, 0.5, 1, 3, 6])),
      );

  Future<void> openTank(WidgetTester tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
  }

  Future<void> openAddReading(WidgetTester tester) async {
    await openTank(tester);
    await tester.tap(find.text('Add reading'));
    await tester.pumpAndSettle();
  }

  testWidgets('logs a reading by tapping a color chart step', (tester) async {
    await setAmmoniaSteps();
    await openAddReading(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '0.5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save reading'));
    await tester.pumpAndSettle();

    await scrollTo(tester, find.widgetWithText(ListTile, '0.5 ppm'));
    expect(find.widgetWithText(ListTile, '0.5 ppm'), findsOneWidget);
    final reading = await db.select(db.readings).getSingle();
    expect(reading.parameter, Parameter.ammonia);
    expect(reading.value, 0.5);
    expect(reading.unit, 'ppm');
    expect(reading.takenAt, DateTime(2026, 10, 21));
    await tearDownApp(tester, db);
  });

  testWidgets('asks for at least one value', (tester) async {
    await setAmmoniaSteps();
    await openAddReading(tester);

    await tester.tap(find.text('Save reading'));
    await tester.pumpAndSettle();

    expect(find.text('Enter at least one value.'), findsOneWidget);
    expect(await db.select(db.readings).get(), isEmpty);
    await tearDownApp(tester, db);
  });

  testWidgets('prompts to set up steps when a kit has none', (tester) async {
    await openAddReading(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '8-in-1 strip'));
    await tester.pumpAndSettle();
    expect(find.text('No steps yet.'), findsWidgets);

    await tester.tap(find.text('Set up steps'));
    await tester.pumpAndSettle();
    expect(find.text('Edit kit'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('one save writes a row only for each value entered', (
    tester,
  ) async {
    await db.saveKit(
      name: 'Liquid kit',
      parameters: const [
        KitParametersCompanion(
          parameter: Value(Parameter.nitrate),
          inputMode: Value(InputMode.free),
          unit: Value('ppm'),
        ),
        KitParametersCompanion(
          parameter: Value(Parameter.ph),
          inputMode: Value(InputMode.free),
          unit: Value('pH'),
        ),
      ],
    );
    await openAddReading(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Liquid kit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Nitrate'), '10');
    await tester.enterText(find.widgetWithText(TextField, 'pH'), '7.4');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save reading'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.readings).get();
    expect(rows.map((r) => (r.parameter, r.value, r.unit)), {
      (Parameter.nitrate, 10.0, 'ppm'),
      (Parameter.ph, 7.4, 'pH'),
    });
    expect(rows.map((r) => r.takenAt).toSet(), hasLength(1));
    await tearDownApp(tester, db);
  });

  testWidgets('a correction adds a new row and replaces the shown value', (
    tester,
  ) async {
    await setAmmoniaSteps();
    final tank = await db.select(db.tanks).getSingle();
    final kit = await db.select(db.testKits).get().then((k) => k.first);
    await db.addReadings([
      ReadingsCompanion.insert(
        tankId: tank.id,
        kitId: Value(kit.id),
        parameter: Parameter.ammonia,
        value: 1,
        unit: 'ppm',
        takenAt: DateTime(2026, 10, 20, 9),
      ),
    ]);
    await openTank(tester);

    await scrollTo(tester, find.widgetWithText(ListTile, '1 ppm'));
    await tester.tap(find.widgetWithText(ListTile, '1 ppm'));
    await tester.pumpAndSettle();
    expect(find.text('Correct Ammonia reading'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, '0.5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save correction'));
    await tester.pumpAndSettle();

    await scrollTo(tester, find.widgetWithText(ListTile, '0.5 ppm'));
    expect(find.widgetWithText(ListTile, '0.5 ppm'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '1 ppm'), findsNothing);
    expect(find.textContaining('Corrected · was 1 ppm'), findsOneWidget);

    final rows = await (db.select(
      db.readings,
    )..orderBy([(r) => OrderingTerm.asc(r.id)])).get();
    expect(rows, hasLength(2));
    expect(rows.first.value, 1);
    expect(rows.last.value, 0.5);
    expect(rows.last.correctsId, rows.first.id);
    await tearDownApp(tester, db);
  });
}
