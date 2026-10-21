import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../domain/enums.dart';
import '../domain/species.dart' show LightLevel;

import 'database.steps.dart';

part 'database.g.dart';

class Tanks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get volumeGal => real()();
  TextColumn get substrateType => text()();
  BoolColumn get hasSoil => boolean()();
  TextColumn get waterSource => textEnum<WaterSource>()();
  RealColumn get heaterWatts => real().nullable()();
  RealColumn get lightWatts => real().nullable()();
  RealColumn get lightHoursPerDay => real().nullable()();
  RealColumn get roomTempF => real().nullable()();
  RealColumn get targetTempF => real().nullable()();
  DateTimeColumn get cycleStartedAt => dateTime().nullable()();
  TextColumn get cycleMethod => textEnum<CycleMethod>()();
  DateTimeColumn get stockedAt => dateTime().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get lightLevel => textEnum<LightLevel>().nullable()();
  BoolColumn get hasCo2 => boolean().withDefault(const Constant(false))();
  RealColumn get footprintLengthIn => real().nullable()();
  RealColumn get footprintWidthIn => real().nullable()();
}

class TestKits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class KitParameters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kitId => integer().references(TestKits, #id)();
  TextColumn get parameter => textEnum<Parameter>()();
  TextColumn get inputMode => textEnum<InputMode>()();
  TextColumn get stepsJson => text().map(const StepsConverter()).nullable()();
  TextColumn get unit => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {kitId, parameter},
  ];
}

class Readings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tankId => integer().references(Tanks, #id)();
  IntColumn get kitId => integer().nullable().references(TestKits, #id)();
  TextColumn get parameter => textEnum<Parameter>()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  DateTimeColumn get takenAt => dateTime()();
  DateTimeColumn get enteredAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get correctsId => integer().nullable().references(Readings, #id)();
  TextColumn get note => text().nullable()();
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tankId => integer().references(Tanks, #id)();
  TextColumn get type => textEnum<EventType>()();
  TextColumn get product => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get amountUnit => text().nullable()();
  RealColumn get percentChanged => real().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get enteredAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get correctsId => integer().nullable().references(Events, #id)();
  TextColumn get note => text().nullable()();
}

class StockEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tankId => integer().references(Tanks, #id)();
  TextColumn get speciesId => text()();
  TextColumn get speciesType => textEnum<SpeciesType>()();
  IntColumn get change => integer()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get enteredAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get correctsId =>
      integer().nullable().references(StockEntries, #id)();
  TextColumn get note => text().nullable()();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tankId => integer().references(Tanks, #id)();
  IntColumn get everyNDays => integer()();
  TextColumn get timeOfDay => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastFiredAt => dateTime().nullable()();
}

class StepsConverter extends TypeConverter<List<double>, String> {
  const StepsConverter();

  @override
  List<double> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).map((e) => (e as num).toDouble()).toList();

  @override
  String toSql(List<double> value) => jsonEncode(value);
}

@DriftDatabase(
  tables: [
    Tanks,
    TestKits,
    KitParameters,
    Readings,
    Events,
    Reminders,
    StockEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'aquarium'));

  @override
  int get schemaVersion => 2;

  Future<int> addTank(TanksCompanion tank) => into(tanks).insert(tank);

  Future<void> updateTank(int id, TanksCompanion tank) =>
      (update(tanks)..where((t) => t.id.equals(id))).write(tank);

  Future<void> setTankArchived(int id, {required bool archived}) =>
      updateTank(id, TanksCompanion(archived: Value(archived)));

  Future<void> addReadings(List<ReadingsCompanion> rows) =>
      batch((b) => b.insertAll(readings, rows));

  Future<int> correctReading(
    Reading original, {
    required double value,
    required DateTime takenAt,
    String? note,
  }) => into(readings).insert(
    ReadingsCompanion.insert(
      tankId: original.tankId,
      kitId: Value(original.kitId),
      parameter: original.parameter,
      value: value,
      unit: original.unit,
      takenAt: takenAt,
      correctsId: Value(original.id),
      note: Value(note),
    ),
  );

  Future<void> saveReminder({
    required int tankId,
    required int everyNDays,
    required String timeOfDay,
    required bool enabled,
  }) => transaction(() async {
    final row = RemindersCompanion(
      tankId: Value(tankId),
      everyNDays: Value(everyNDays),
      timeOfDay: Value(timeOfDay),
      enabled: Value(enabled),
    );
    final existing = await (select(
      reminders,
    )..where((r) => r.tankId.equals(tankId))).getSingleOrNull();
    if (existing == null) {
      await into(reminders).insert(row);
    } else {
      await (update(
        reminders,
      )..where((r) => r.id.equals(existing.id))).write(row);
    }
  });

  Future<int> addEvent(EventsCompanion event) => into(events).insert(event);

  Future<int> addStockEntry(StockEntriesCompanion entry) =>
      into(stockEntries).insert(entry);

  Future<int> correctStockEntry(
    StockEntry original, {
    required int change,
    required DateTime occurredAt,
    String? note,
  }) => into(stockEntries).insert(
    StockEntriesCompanion.insert(
      tankId: original.tankId,
      speciesId: original.speciesId,
      speciesType: original.speciesType,
      change: change,
      occurredAt: occurredAt,
      correctsId: Value(original.id),
      note: Value(note),
    ),
  );

  Future<int> correctEvent(Event original, EventsCompanion correction) =>
      into(events).insert(
        correction.copyWith(
          tankId: Value(original.tankId),
          correctsId: Value(original.id),
        ),
      );

  // Parameters are replaced wholesale; nothing references their ids, so a rewrite is simpler than a diff.
  Future<int> saveKit({
    int? kitId,
    required String name,
    String? brand,
    required List<KitParametersCompanion> parameters,
  }) => transaction(() async {
    final kit = TestKitsCompanion(name: Value(name), brand: Value(brand));
    final id = kitId ?? await into(testKits).insert(kit);
    if (kitId != null) {
      await (update(testKits)..where((k) => k.id.equals(kitId))).write(kit);
      await (delete(kitParameters)..where((p) => p.kitId.equals(kitId))).go();
    }
    for (final p in parameters) {
      await into(kitParameters).insert(p.copyWith(kitId: Value(id)));
    }
    return id;
  });

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createAppendOnlyGuards(['readings', 'events', 'stock_entries']);
      await _seed();
    },
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.addColumn(schema.tanks, schema.tanks.lightLevel);
        await m.addColumn(schema.tanks, schema.tanks.hasCo2);
        await m.addColumn(schema.tanks, schema.tanks.footprintLengthIn);
        await m.addColumn(schema.tanks, schema.tanks.footprintWidthIn);
        await m.createTable(schema.stockEntries);
        await _createAppendOnlyGuards(['stock_entries']);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // Enforced in SQLite, not just in Dart, so no future query can silently rewrite the log.
  Future<void> _createAppendOnlyGuards(List<String> tables) async {
    for (final table in tables) {
      for (final op in ['UPDATE', 'DELETE']) {
        await customStatement('''
          CREATE TRIGGER ${table}_no_${op.toLowerCase()}
          BEFORE $op ON $table
          BEGIN
            SELECT RAISE(ABORT, '$table is append-only');
          END
        ''');
      }
    }
  }

  Future<void> _seed() => transaction(() async {
    await into(tanks).insert(
      TanksCompanion.insert(
        name: '20 gal planted',
        volumeGal: 20,
        substrateType: 'soil',
        hasSoil: true,
        waterSource: WaterSource.filtered,
        roomTempF: const Value(74),
        cycleMethod: CycleMethod.fishless,
      ),
    );

    final ammoniaKit = await into(testKits)
        .insert(TestKitsCompanion.insert(name: 'Ammonia strip'));
    await into(kitParameters).insert(
      KitParametersCompanion.insert(
        kitId: ammoniaKit,
        parameter: Parameter.ammonia,
        inputMode: InputMode.steps,
        unit: 'ppm',
      ),
    );

    final stripKit = await into(testKits)
        .insert(TestKitsCompanion.insert(name: '8-in-1 strip'));
    for (final (parameter, unit) in [
      (Parameter.nitrate, 'ppm'),
      (Parameter.nitrite, 'ppm'),
      (Parameter.gh, 'ppm'),
      (Parameter.kh, 'ppm'),
      (Parameter.ph, 'pH'),
      (Parameter.chlorine, 'ppm'),
    ]) {
      await into(kitParameters).insert(
        KitParametersCompanion.insert(
          kitId: stripKit,
          parameter: parameter,
          inputMode: InputMode.steps,
          unit: unit,
        ),
      );
    }
  });
}
