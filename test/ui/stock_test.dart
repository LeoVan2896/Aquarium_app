import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/species.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

// Made-up species for tests only. Values are arbitrary, not real care ranges.
const _sources = {'a': 'https://example.test/a'};

const _catalog = SpeciesCatalog(
  animals: [
    AnimalSpecies(
      id: 'fixture-tetra',
      commonName: 'Fixture tetra',
      scientificName: 'Fixturus testii',
      kind: AnimalKind.fish,
      tier: Tier.beginner,
      sources: _sources,
      minTank: [TankSize(gallons: 10, source: 'a')],
      minGroupSize: Rated(6, 'a'),
    ),
  ],
  plants: [
    PlantSpecies(
      id: 'fixture-fern',
      commonName: 'Fixture fern',
      scientificName: 'Testaria plantae',
      tier: Tier.beginner,
      sources: _sources,
      co2: [Rated(Co2Need.notNeeded, 'a')],
    ),
  ],
);

Future<void> openTank(WidgetTester tester, AppDatabase db) async {
  await pumpApp(tester, db, catalog: _catalog);
  await tester.tap(find.text('20 gal planted'));
  await tester.pumpAndSettle();
  await scrollTo(tester, find.text('Stock'));
}

Future<void> openAdd(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();
}

Future<int> seedStock(AppDatabase db, int change) async {
  final tank = await db.select(db.tanks).getSingle();
  return db.addStockEntry(
    StockEntriesCompanion.insert(
      tankId: tank.id,
      speciesId: 'fixture-tetra',
      speciesType: SpeciesType.animal,
      change: change,
      occurredAt: DateTime(2026, 10, 20),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  testWidgets('an uncycled tank says plants can go in but fish should wait', (
    tester,
  ) async {
    await openTank(tester, db);

    expect(
      find.text(
        'No fish or plants yet. Plants can go in now; wait for the cycle to finish before adding fish.',
      ),
      findsOneWidget,
    );

    await tearDownApp(tester, db);
  });

  testWidgets('adding fish to an uncycled tank shows the gate and checks', (
    tester,
  ) async {
    await openTank(tester, db);
    await openAdd(tester);

    await tester.tap(find.text('Fixture tetra'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining("Your tank hasn't finished cycling"),
      findsOneWidget,
    );
    expect(find.text('Group size'), findsOneWidget);
    expect(
      find.text("Keep at least 6 together (example.test); you'd have 1."),
      findsOneWidget,
    );

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byTooltip('More'));
    }
    await tester.pumpAndSettle();
    expect(
      find.text('Group of 6 meets the minimum of 6 (example.test).'),
      findsOneWidget,
    );

    await tester.tap(find.text('Add anyway'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.stockEntries).get();
    expect(rows.single.change, 6);
    expect(rows.single.speciesType, SpeciesType.animal);
    await scrollTo(tester, find.text('×6'));
    expect(find.text('×6'), findsOneWidget);
    await scrollTo(tester, find.text('Added Fixture tetra'));
    expect(find.text('Added Fixture tetra'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('plants are never gated', (tester) async {
    await openTank(tester, db);
    await openAdd(tester);

    await tester.tap(find.text('Plants'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fixture fern'));
    await tester.pumpAndSettle();

    expect(find.textContaining("hasn't finished cycling"), findsNothing);
    await tester.tap(find.text('Add to tank'));
    await tester.pumpAndSettle();

    expect(
      (await db.select(db.stockEntries).getSingle()).speciesType,
      SpeciesType.plant,
    );

    await tearDownApp(tester, db);
  });

  testWidgets('removing stock logs a negative entry', (tester) async {
    await seedStock(db, 3);
    await openTank(tester, db);

    await tester.tap(find.byTooltip('Remove Fixture tetra'));
    await tester.pumpAndSettle();
    expect(find.text('3 in the tank now.'), findsOneWidget);

    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove from tank'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.stockEntries).get();
    expect(rows.map((r) => r.change), [3, -2]);
    expect(find.text('×1'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('correcting a stock entry adds a row and updates the count', (
    tester,
  ) async {
    final id = await seedStock(db, 8);
    await openTank(tester, db);

    await scrollTo(tester, find.text('Added Fixture tetra'));
    await tester.tap(find.text('Added Fixture tetra'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Fewer'));
    await tester.tap(find.byTooltip('Fewer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save correction'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.stockEntries).get();
    expect(rows, hasLength(2));
    expect(rows.last.correctsId, id);
    expect(rows.last.change, 6);
    await scrollTo(tester, find.text('×6'));
    expect(find.text('×6'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('the tank form saves light, CO₂ and footprint', (tester) async {
    await pumpApp(tester, db, catalog: _catalog);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit tank'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Length'), '24');
    await tester.enterText(find.widgetWithText(TextFormField, 'Width'), '12');
    await scrollTo(tester, find.text('CO₂ injection'));
    await scrollToEnd(tester);
    await tester.tap(find.text('CO₂ injection'));
    await tester.tap(find.text('Not sure'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Medium').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final tank = await db.select(db.tanks).getSingle();
    expect(tank.footprintLengthIn, 24);
    expect(tank.footprintWidthIn, 12);
    expect(tank.hasCo2, isTrue);
    expect(tank.lightLevel, LightLevel.medium);

    await tearDownApp(tester, db);
  });
}
