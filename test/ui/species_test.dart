import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/species.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

// Made-up species for tests only. Values are arbitrary, not real care ranges.
const _sources = {
  'a': 'https://www.example.test/a',
  'b': 'https://other.test/b',
};

const _catalog = SpeciesCatalog(
  animals: [
    AnimalSpecies(
      id: 'fixture-tetra',
      commonName: 'Fixture tetra',
      scientificName: 'Fixturus testii',
      kind: AnimalKind.fish,
      tier: Tier.beginner,
      sources: _sources,
      tempF: [
        RangeReport(
          optimal: Span(72, 76),
          tolerated: Span(68, 80),
          source: 'a',
        ),
        RangeReport(tolerated: Span(70, 82), source: 'b'),
      ],
      adultSizeIn: [Rated(Span(1, 1.5), 'a')],
      minTank: [TankSize(lengthCm: 60, widthCm: 30, source: 'a')],
      flags: {AnimalFlag.needsMatureTank: Rated(true, 'a')},
    ),
    AnimalSpecies(
      id: 'fixture-shrimp',
      commonName: 'Fixture shrimp',
      scientificName: 'Caridina fixturae',
      kind: AnimalKind.shrimp,
      tier: Tier.intermediate,
      sources: _sources,
      intermediateReasons: [IntermediateReason.softWater],
    ),
  ],
  plants: [
    PlantSpecies(
      id: 'fixture-fern',
      commonName: 'Fixture fern',
      scientificName: 'Testaria plantae',
      tier: Tier.beginner,
      sources: _sources,
      light: [Rated(LightLevel.low, 'a'), Rated(LightLevel.medium, 'b')],
      heightAfter2MonthsCm: Rated(Span(20), 'a'),
    ),
  ],
  avoid: [
    AvoidEntry(
      scientificName: 'Avoidus giganticus',
      commonNames: ['Fixture giant'],
      kind: AvoidKind.animal,
      reason: 'Outgrows home tanks.',
      sourceUrl: 'https://example.test/avoid',
    ),
  ],
);

Future<void> openBrowser(
  WidgetTester tester,
  AppDatabase db, {
  SpeciesCatalog catalog = _catalog,
}) async {
  await pumpApp(tester, db, catalog: catalog);
  await tester.tap(find.text('Browse species'));
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  testWidgets('lists fish with a summary and the avoid list', (tester) async {
    await openBrowser(tester, db);

    expect(find.text('Fixture tetra'), findsOneWidget);
    expect(find.text('Fish · 72–76°F · 1–1.5 in'), findsOneWidget);
    expect(find.text('Fixture shrimp'), findsOneWidget);
    expect(find.text('Avoid'), findsOneWidget);
    expect(find.text('Fixture giant'), findsOneWidget);
    expect(find.text('Fixture fern'), findsNothing);

    await tearDownApp(tester, db);
  });

  testWidgets('switches to plants', (tester) async {
    await openBrowser(tester, db);

    await tester.tap(find.text('Plants'));
    await tester.pumpAndSettle();

    expect(find.text('Fixture fern'), findsOneWidget);
    expect(find.text('Low light'), findsOneWidget);
    expect(find.text('Fixture tetra'), findsNothing);
    expect(find.text('Fixture giant'), findsNothing);

    await tearDownApp(tester, db);
  });

  testWidgets('search matches scientific names', (tester) async {
    await openBrowser(tester, db);

    await tester.enterText(find.byType(TextField), 'caridina');
    await tester.pumpAndSettle();

    expect(find.text('Fixture shrimp'), findsOneWidget);
    expect(find.text('Fixture tetra'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(
      find.text('Nothing matches. Try another name or tier.'),
      findsOneWidget,
    );

    await tearDownApp(tester, db);
  });

  testWidgets('tier filter hides other tiers and the avoid list', (
    tester,
  ) async {
    await openBrowser(tester, db);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Intermediate'));
    await tester.pumpAndSettle();

    expect(find.text('Fixture shrimp'), findsOneWidget);
    expect(find.text('Fixture tetra'), findsNothing);
    expect(find.text('Fixture giant'), findsNothing);

    await tearDownApp(tester, db);
  });

  testWidgets('fish detail shows each source and what no source states', (
    tester,
  ) async {
    await openBrowser(tester, db);

    await tester.tap(find.text('Fixture tetra'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Ideal 72–76°F, tolerates 68–80°F (example.test)\n'
        'tolerates 70–82°F (other.test)',
      ),
      findsOneWidget,
    );
    expect(find.text('60 × 30 cm base (example.test)'), findsOneWidget);
    expect(find.text('Not stated by sources'), findsWidgets);

    await scrollTo(tester, find.text('Needs an established tank'));
    expect(find.text('Yes (example.test)'), findsOneWidget);
    await scrollTo(tester, find.text('Sources'));
    expect(find.text('https://other.test/b'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('plant detail shows light per source and open-ended height', (
    tester,
  ) async {
    await openBrowser(tester, db);
    await tester.tap(find.text('Plants'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fixture fern'));
    await tester.pumpAndSettle();

    expect(
      find.text('Low (example.test)\nMedium (other.test)'),
      findsOneWidget,
    );
    await scrollTo(tester, find.text('20+ cm (example.test)'));
    expect(find.text('20+ cm (example.test)'), findsOneWidget);

    await tearDownApp(tester, db);
  });

  testWidgets('an empty catalog says so', (tester) async {
    await openBrowser(tester, db, catalog: const SpeciesCatalog());

    expect(find.text('No fish in the catalog yet.'), findsOneWidget);
    expect(find.text('Avoid'), findsNothing);

    await tearDownApp(tester, db);
  });
}
