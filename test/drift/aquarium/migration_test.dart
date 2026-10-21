// dart format width=80
import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('v1 to v2 keeps existing tanks and readings untouched', () async {
    const tank = v1.TanksData(
      id: 1,
      name: '20 gal planted',
      volumeGal: 20,
      substrateType: 'soil',
      hasSoil: 1,
      waterSource: 'filtered',
      roomTempF: 74,
      cycleStartedAt: 1792281600,
      cycleMethod: 'fishless',
      archived: 0,
      createdAt: 1792281600,
    );
    const reading = v1.ReadingsData(
      id: 1,
      tankId: 1,
      parameter: 'ammonia',
      value: 2,
      unit: 'ppm',
      takenAt: 1792368000,
      enteredAt: 1792368000,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(oldDb.tanks, tank);
        batch.insert(oldDb.readings, reading);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.tanks).get(), [
          const v2.TanksData(
            id: 1,
            name: '20 gal planted',
            volumeGal: 20,
            substrateType: 'soil',
            hasSoil: 1,
            waterSource: 'filtered',
            roomTempF: 74,
            cycleStartedAt: 1792281600,
            cycleMethod: 'fishless',
            archived: 0,
            createdAt: 1792281600,
            hasCo2: 0,
          ),
        ]);
        expect(await newDb.select(newDb.readings).get(), [
          const v2.ReadingsData(
            id: 1,
            tankId: 1,
            parameter: 'ammonia',
            value: 2,
            unit: 'ppm',
            takenAt: 1792368000,
            enteredAt: 1792368000,
          ),
        ]);
        expect(await newDb.select(newDb.stockEntries).get(), isEmpty);
      },
    );
  });

  test('stock entries are append-only after upgrading', () async {
    final schema = await verifier.schemaAt(1);
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 2);

    final tankId = await db.addTank(
      TanksCompanion.insert(
        name: 'Test tank',
        volumeGal: 10,
        substrateType: 'sand',
        hasSoil: false,
        waterSource: WaterSource.tap,
        cycleMethod: CycleMethod.fishless,
      ),
    );
    await db.addStockEntry(
      StockEntriesCompanion.insert(
        tankId: tankId,
        speciesId: 'fixture-fish',
        speciesType: SpeciesType.animal,
        change: 6,
        occurredAt: DateTime(2026, 11, 1),
      ),
    );

    await expectLater(
      db.customStatement('UPDATE stock_entries SET change = 5'),
      throwsA(anything),
    );
    await expectLater(
      db.customStatement('DELETE FROM stock_entries'),
      throwsA(anything),
    );
    await db.close();
  });
}
