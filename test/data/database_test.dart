import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seeds one soil tank and two kits with empty steps', () async {
    final tanks = await db.select(db.tanks).get();
    expect(tanks.single.name, '20 gal planted');
    expect(tanks.single.hasSoil, isTrue);
    expect(tanks.single.waterSource, WaterSource.filtered);
    expect(tanks.single.roomTempF, 74);

    final kits = await db.select(db.testKits).get();
    expect(kits.map((k) => k.name), ['Ammonia strip', '8-in-1 strip']);

    final params = await db.select(db.kitParameters).get();
    expect(params.every((p) => p.stepsJson == null), isTrue);
  });

  test('steps round-trip as a list of doubles', () async {
    final param = await db.select(db.kitParameters).get().then((p) => p.first);
    await (db.update(
      db.kitParameters,
    )..where((p) => p.id.equals(param.id))).write(
      const KitParametersCompanion(stepsJson: Value([0, 0.25, 0.5, 1, 3, 6])),
    );

    final updated = await (db.select(
      db.kitParameters,
    )..where((p) => p.id.equals(param.id))).getSingle();
    expect(updated.stepsJson, [0, 0.25, 0.5, 1, 3, 6]);
  });

  test('correctReading copies the original and points back at it', () async {
    final tank = await db.select(db.tanks).getSingle();
    await db.addReadings([
      ReadingsCompanion.insert(
        tankId: tank.id,
        parameter: Parameter.nitrite,
        value: 2,
        unit: 'ppm',
        takenAt: DateTime(2026, 10, 19),
      ),
    ]);
    final original = await db.select(db.readings).getSingle();

    await db.correctReading(
      original,
      value: 1,
      takenAt: DateTime(2026, 10, 19, 8),
      note: 'misread the strip',
    );

    final fix = await (db.select(
      db.readings,
    )..where((r) => r.correctsId.equals(original.id))).getSingle();
    expect(fix.tankId, original.tankId);
    expect(fix.parameter, Parameter.nitrite);
    expect(fix.unit, 'ppm');
    expect(fix.value, 1);
    expect(fix.note, 'misread the strip');
    expect(
      (await (db.select(
        db.readings,
      )..where((r) => r.id.equals(original.id))).getSingle()).value,
      2,
    );
  });

  test('saveKit creates a kit, then replaces its parameters on edit', () async {
    final id = await db.saveKit(
      name: 'API Master',
      brand: 'API',
      parameters: const [
        KitParametersCompanion(
          parameter: Value(Parameter.ammonia),
          inputMode: Value(InputMode.steps),
          unit: Value('ppm'),
          stepsJson: Value([0, 0.25, 0.5]),
        ),
        KitParametersCompanion(
          parameter: Value(Parameter.ph),
          inputMode: Value(InputMode.free),
          unit: Value('pH'),
        ),
      ],
    );

    await db.saveKit(
      kitId: id,
      name: 'API Master Kit',
      parameters: const [
        KitParametersCompanion(
          parameter: Value(Parameter.ph),
          inputMode: Value(InputMode.free),
          unit: Value('pH'),
        ),
      ],
    );

    final kit = await (db.select(
      db.testKits,
    )..where((k) => k.id.equals(id))).getSingle();
    expect(kit.name, 'API Master Kit');
    expect(kit.brand, isNull);
    final params = await (db.select(
      db.kitParameters,
    )..where((p) => p.kitId.equals(id))).get();
    expect(params.map((p) => p.parameter), [Parameter.ph]);
  });

  group('append-only', () {
    late int readingId;
    late int eventId;

    setUp(() async {
      final tank = await db.select(db.tanks).getSingle();
      readingId = await db
          .into(db.readings)
          .insert(
            ReadingsCompanion.insert(
              tankId: tank.id,
              parameter: Parameter.ammonia,
              value: 1,
              unit: 'ppm',
              takenAt: DateTime(2026, 10, 18),
            ),
          );
      eventId = await db
          .into(db.events)
          .insert(
            EventsCompanion.insert(
              tankId: tank.id,
              type: EventType.waterChange,
              occurredAt: DateTime(2026, 10, 18),
            ),
          );
    });

    test('readings reject update and delete', () async {
      expect(
        () => (db.update(db.readings)..where((r) => r.id.equals(readingId)))
            .write(const ReadingsCompanion(value: Value(2))),
        throwsA(isA<SqliteException>()),
      );
      expect(
        () =>
            (db.delete(db.readings)..where((r) => r.id.equals(readingId))).go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test('events reject update and delete', () async {
      expect(
        () => (db.update(db.events)..where((e) => e.id.equals(eventId))).write(
          const EventsCompanion(note: Value('x')),
        ),
        throwsA(isA<SqliteException>()),
      );
      expect(
        () => (db.delete(db.events)..where((e) => e.id.equals(eventId))).go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test('a correction is a new row pointing at the original', () async {
      final tank = await db.select(db.tanks).getSingle();
      await db
          .into(db.readings)
          .insert(
            ReadingsCompanion.insert(
              tankId: tank.id,
              parameter: Parameter.ammonia,
              value: 0.5,
              unit: 'ppm',
              takenAt: DateTime(2026, 10, 18),
              correctsId: Value(readingId),
            ),
          );
      final rows = await db.select(db.readings).get();
      expect(rows, hasLength(2));
      expect(rows.last.correctsId, readingId);
    });
  });

  group('stock entries', () {
    late Tank tank;
    late StockEntry added;

    setUp(() async {
      tank = await db.select(db.tanks).getSingle();
      await db.addStockEntry(
        StockEntriesCompanion.insert(
          tankId: tank.id,
          speciesId: 'fixture-fish',
          speciesType: SpeciesType.animal,
          change: 6,
          occurredAt: DateTime(2026, 11, 1),
        ),
      );
      added = await db.select(db.stockEntries).getSingle();
    });

    test('new tank fields default to unknown light and no CO₂', () {
      expect(tank.lightLevel, isNull);
      expect(tank.hasCo2, isFalse);
      expect(tank.footprintLengthIn, isNull);
      expect(tank.footprintWidthIn, isNull);
    });

    test('reject update and delete', () async {
      expect(
        () => (db.update(db.stockEntries)..where((s) => s.id.equals(added.id)))
            .write(const StockEntriesCompanion(change: Value(5))),
        throwsA(isA<SqliteException>()),
      );
      expect(
        () => (db.delete(
          db.stockEntries,
        )..where((s) => s.id.equals(added.id))).go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test(
      'correctStockEntry copies the original and points back at it',
      () async {
        await db.correctStockEntry(
          added,
          change: 5,
          occurredAt: DateTime(2026, 11, 1),
          note: 'miscounted',
        );

        final rows = await db.select(db.stockEntries).get();
        expect(rows, hasLength(2));
        expect(rows.last.correctsId, added.id);
        expect(rows.last.speciesId, 'fixture-fish');
        expect(rows.last.change, 5);
      },
    );
  });
}
