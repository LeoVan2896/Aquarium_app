import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  testWidgets('lists the seeded tank with a Not started chip', (tester) async {
    await pumpApp(tester, db);

    expect(find.text('20 gal planted'), findsOneWidget);
    expect(find.text('20 gal · Soil · Filtered water'), findsOneWidget);
    expect(find.text('Not started'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('stage chip comes from the cycle engine', (tester) async {
    final tank = await db.select(db.tanks).getSingle();
    await db.updateTank(
      tank.id,
      TanksCompanion(cycleStartedAt: Value(DateTime(2026, 10, 18))),
    );
    await db
        .into(db.readings)
        .insert(
          ReadingsCompanion.insert(
            tankId: tank.id,
            parameter: Parameter.ammonia,
            value: 2,
            unit: 'ppm',
            takenAt: DateTime(2026, 10, 19),
          ),
        );

    await pumpApp(tester, db);

    expect(find.text('Ammonia phase'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('adds a tank from the form', (tester) async {
    await pumpApp(tester, db);

    await tester.tap(find.text('Add tank'));
    await tester.pumpAndSettle();
    expect(find.text('New tank'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      '10 gal shrimp',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Volume'), '10');
    await tester.tap(find.text('Add tank').last);
    await tester.pumpAndSettle();

    expect(find.text('10 gal shrimp'), findsOneWidget);
    final saved = await (db.select(
      db.tanks,
    )..where((t) => t.name.equals('10 gal shrimp'))).getSingle();
    expect(saved.volumeGal, 10);
    expect(saved.waterSource, WaterSource.tap);
    expect(saved.cycleMethod, CycleMethod.fishless);
    await tearDownApp(tester, db);
  });

  testWidgets('requires a name and a positive volume', (tester) async {
    await pumpApp(tester, db);

    await tester.tap(find.text('Add tank'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add tank').last);
    await tester.pumpAndSettle();

    expect(find.text('Enter a tank name.'), findsOneWidget);
    expect(find.text('Enter the volume in gallons.'), findsOneWidget);
    expect(await db.select(db.tanks).get(), hasLength(1));
    await tearDownApp(tester, db);
  });

  testWidgets('archives a tank after confirming, then restores it', (
    tester,
  ) async {
    await pumpApp(tester, db);

    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit tank'));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Archive tank'));
    await tester.tap(find.text('Archive tank'));
    await tester.pumpAndSettle();

    expect(find.text('Archive 20 gal planted?'), findsOneWidget);
    await tester.tap(find.text('Archive tank').last);
    await tester.pumpAndSettle();

    expect(find.text('No tanks yet'), findsOneWidget);
    expect(find.text('Show archived (1)'), findsOneWidget);
    expect((await db.select(db.tanks).getSingle()).archived, isTrue);

    await tester.tap(find.text('Show archived (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Restore tank'));
    await tester.tap(find.text('Restore tank'));
    await tester.pumpAndSettle();

    expect(find.text('No tanks yet'), findsNothing);
    expect((await db.select(db.tanks).getSingle()).archived, isFalse);
    await tearDownApp(tester, db);
  });
}
