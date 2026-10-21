import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/species.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

// Made-up species for tests only. Values are arbitrary, not real care ranges.
const _sources = {'a': 'https://example.test/a'};

const _small = AnimalSpecies(
  id: 'small',
  commonName: 'Small fixture',
  scientificName: 'Fixturus minor',
  kind: AnimalKind.fish,
  tier: Tier.beginner,
  sources: _sources,
  tempF: [RangeReport(optimal: Span(70, 78), source: 'a')],
  minTank: [TankSize(gallons: 10, source: 'a')],
);

const _big = AnimalSpecies(
  id: 'big',
  commonName: 'Big fixture',
  scientificName: 'Fixturus major',
  kind: AnimalKind.fish,
  tier: Tier.beginner,
  sources: _sources,
  tempF: [RangeReport(optimal: Span(70, 78), source: 'a')],
  minTank: [TankSize(gallons: 55, source: 'a')],
);

const _phFussy = AnimalSpecies(
  id: 'fussy',
  commonName: 'Fussy fixture',
  scientificName: 'Fixturus acidus',
  kind: AnimalKind.fish,
  tier: Tier.intermediate,
  sources: _sources,
  ph: [
    RangeReport(optimal: Span(6, 6.8), tolerated: Span(5.5, 7.2), source: 'a'),
  ],
);

const _catalog = SpeciesCatalog(animals: [_small, _big, _phFussy]);

Future<Tank> seedTank(AppDatabase db) => db.select(db.tanks).getSingle();

Future<void> addStock(AppDatabase db, String speciesId) async {
  final tank = await seedTank(db);
  await db.addStockEntry(
    StockEntriesCompanion.insert(
      tankId: tank.id,
      speciesId: speciesId,
      speciesType: SpeciesType.animal,
      change: 2,
      occurredAt: DateTime(2026, 10, 20),
    ),
  );
}

Future<void> logReading(
  AppDatabase db,
  Parameter parameter,
  double value,
) async {
  final tank = await seedTank(db);
  await db.addReadings([
    ReadingsCompanion.insert(
      tankId: tank.id,
      parameter: parameter,
      value: value,
      unit: switch (parameter) {
        Parameter.ph => 'pH',
        Parameter.gh => 'dGH',
        Parameter.kh => 'dKH',
        _ => 'ppm',
      },
      takenAt: DateTime(2026, 10, 20),
    ),
  ]);
}

Future<void> openTank(WidgetTester tester, AppDatabase db) async {
  await pumpApp(tester, db, catalog: _catalog);
  await tester.tap(find.text('20 gal planted'));
  await tester.pumpAndSettle();
}

Future<void> openWhatFits(WidgetTester tester, AppDatabase db) async {
  await openTank(tester, db);
  await scrollTo(tester, find.text('What fits this tank'));
  await tester.tap(find.text('What fits this tank'));
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  testWidgets('ranks species and can hide problems and cautions', (
    tester,
  ) async {
    await openWhatFits(tester, db);

    final small = tester.getTopLeft(find.text('Small fixture')).dy;
    final fussy = tester.getTopLeft(find.text('Fussy fixture')).dy;
    final big = tester.getTopLeft(find.text('Big fixture')).dy;
    expect(small < fussy && fussy < big, isTrue);
    expect(find.text('3 unknown'), findsOneWidget);
    expect(find.text('1 problem · 3 unknown'), findsOneWidget);

    await tester.tap(find.text('Hide problems and cautions'));
    await tester.pumpAndSettle();
    expect(find.text('Small fixture'), findsOneWidget);
    expect(find.text('Big fixture'), findsNothing);

    await tearDownApp(tester, db);
  });

  testWidgets('says which reading would settle an unknown', (tester) async {
    await openWhatFits(tester, db);

    expect(find.text('To settle: Log a pH reading'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('tapping a species opens Add with it chosen', (tester) async {
    await openWhatFits(tester, db);

    await tester.tap(find.text('Small fixture'));
    await tester.pumpAndSettle();

    expect(find.text('Add fish or plants'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Change'), findsOneWidget);
    expect(find.text('Small fixture'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('a reading outside a stocked species range shows the alert', (
    tester,
  ) async {
    await addStock(db, 'fussy');
    await logReading(db, Parameter.ph, 8.2);
    await openTank(tester, db);

    expect(find.text('Outside what your stock can take'), findsOneWidget);
    expect(find.text('Fussy fixture'), findsWidgets);

    await tearDownApp(tester, db);
  });

  testWidgets('outside ideal but tolerated is a caution, not the banner', (
    tester,
  ) async {
    await addStock(db, 'fussy');
    await logReading(db, Parameter.ph, 7.0);
    await openTank(tester, db);

    expect(find.text('Outside what your stock can take'), findsNothing);
    await scrollTo(tester, find.text('×2'));
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Fussy fixture'),
        matching: find.byIcon(Icons.warning_amber_rounded),
      ),
      findsOneWidget,
    );

    await tearDownApp(tester, db);
  });

  testWidgets('prompts for the water tests that are missing', (tester) async {
    await logReading(db, Parameter.ph, 6.8);
    await openTank(tester, db);

    await scrollTo(tester, find.text('Test GH and KH to update fit checks'));
    expect(find.text('Test GH and KH to update fit checks'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('no prompt once pH, GH and KH are all recent', (tester) async {
    await logReading(db, Parameter.ph, 6.8);
    await logReading(db, Parameter.gh, 6);
    await logReading(db, Parameter.kh, 3);
    await openTank(tester, db);

    await scrollTo(tester, find.text('What fits this tank'));
    expect(find.textContaining('to update fit checks'), findsNothing);

    await tearDownApp(tester, db);
  });
}
