// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TanksTable extends Tanks with TableInfo<$TanksTable, Tank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeGalMeta = const VerificationMeta(
    'volumeGal',
  );
  @override
  late final GeneratedColumn<double> volumeGal = GeneratedColumn<double>(
    'volume_gal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _substrateTypeMeta = const VerificationMeta(
    'substrateType',
  );
  @override
  late final GeneratedColumn<String> substrateType = GeneratedColumn<String>(
    'substrate_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasSoilMeta = const VerificationMeta(
    'hasSoil',
  );
  @override
  late final GeneratedColumn<bool> hasSoil = GeneratedColumn<bool>(
    'has_soil',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_soil" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<WaterSource, String> waterSource =
      GeneratedColumn<String>(
        'water_source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WaterSource>($TanksTable.$converterwaterSource);
  static const VerificationMeta _heaterWattsMeta = const VerificationMeta(
    'heaterWatts',
  );
  @override
  late final GeneratedColumn<double> heaterWatts = GeneratedColumn<double>(
    'heater_watts',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lightWattsMeta = const VerificationMeta(
    'lightWatts',
  );
  @override
  late final GeneratedColumn<double> lightWatts = GeneratedColumn<double>(
    'light_watts',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lightHoursPerDayMeta = const VerificationMeta(
    'lightHoursPerDay',
  );
  @override
  late final GeneratedColumn<double> lightHoursPerDay = GeneratedColumn<double>(
    'light_hours_per_day',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomTempFMeta = const VerificationMeta(
    'roomTempF',
  );
  @override
  late final GeneratedColumn<double> roomTempF = GeneratedColumn<double>(
    'room_temp_f',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetTempFMeta = const VerificationMeta(
    'targetTempF',
  );
  @override
  late final GeneratedColumn<double> targetTempF = GeneratedColumn<double>(
    'target_temp_f',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleStartedAtMeta = const VerificationMeta(
    'cycleStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cycleStartedAt =
      GeneratedColumn<DateTime>(
        'cycle_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<CycleMethod, String> cycleMethod =
      GeneratedColumn<String>(
        'cycle_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CycleMethod>($TanksTable.$convertercycleMethod);
  static const VerificationMeta _stockedAtMeta = const VerificationMeta(
    'stockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> stockedAt = GeneratedColumn<DateTime>(
    'stocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LightLevel?, String> lightLevel =
      GeneratedColumn<String>(
        'light_level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LightLevel?>($TanksTable.$converterlightLeveln);
  static const VerificationMeta _hasCo2Meta = const VerificationMeta('hasCo2');
  @override
  late final GeneratedColumn<bool> hasCo2 = GeneratedColumn<bool>(
    'has_co2',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_co2" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _footprintLengthInMeta = const VerificationMeta(
    'footprintLengthIn',
  );
  @override
  late final GeneratedColumn<double> footprintLengthIn =
      GeneratedColumn<double>(
        'footprint_length_in',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _footprintWidthInMeta = const VerificationMeta(
    'footprintWidthIn',
  );
  @override
  late final GeneratedColumn<double> footprintWidthIn = GeneratedColumn<double>(
    'footprint_width_in',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    volumeGal,
    substrateType,
    hasSoil,
    waterSource,
    heaterWatts,
    lightWatts,
    lightHoursPerDay,
    roomTempF,
    targetTempF,
    cycleStartedAt,
    cycleMethod,
    stockedAt,
    archived,
    createdAt,
    lightLevel,
    hasCo2,
    footprintLengthIn,
    footprintWidthIn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tanks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tank> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('volume_gal')) {
      context.handle(
        _volumeGalMeta,
        volumeGal.isAcceptableOrUnknown(data['volume_gal']!, _volumeGalMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeGalMeta);
    }
    if (data.containsKey('substrate_type')) {
      context.handle(
        _substrateTypeMeta,
        substrateType.isAcceptableOrUnknown(
          data['substrate_type']!,
          _substrateTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_substrateTypeMeta);
    }
    if (data.containsKey('has_soil')) {
      context.handle(
        _hasSoilMeta,
        hasSoil.isAcceptableOrUnknown(data['has_soil']!, _hasSoilMeta),
      );
    } else if (isInserting) {
      context.missing(_hasSoilMeta);
    }
    if (data.containsKey('heater_watts')) {
      context.handle(
        _heaterWattsMeta,
        heaterWatts.isAcceptableOrUnknown(
          data['heater_watts']!,
          _heaterWattsMeta,
        ),
      );
    }
    if (data.containsKey('light_watts')) {
      context.handle(
        _lightWattsMeta,
        lightWatts.isAcceptableOrUnknown(data['light_watts']!, _lightWattsMeta),
      );
    }
    if (data.containsKey('light_hours_per_day')) {
      context.handle(
        _lightHoursPerDayMeta,
        lightHoursPerDay.isAcceptableOrUnknown(
          data['light_hours_per_day']!,
          _lightHoursPerDayMeta,
        ),
      );
    }
    if (data.containsKey('room_temp_f')) {
      context.handle(
        _roomTempFMeta,
        roomTempF.isAcceptableOrUnknown(data['room_temp_f']!, _roomTempFMeta),
      );
    }
    if (data.containsKey('target_temp_f')) {
      context.handle(
        _targetTempFMeta,
        targetTempF.isAcceptableOrUnknown(
          data['target_temp_f']!,
          _targetTempFMeta,
        ),
      );
    }
    if (data.containsKey('cycle_started_at')) {
      context.handle(
        _cycleStartedAtMeta,
        cycleStartedAt.isAcceptableOrUnknown(
          data['cycle_started_at']!,
          _cycleStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('stocked_at')) {
      context.handle(
        _stockedAtMeta,
        stockedAt.isAcceptableOrUnknown(data['stocked_at']!, _stockedAtMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('has_co2')) {
      context.handle(
        _hasCo2Meta,
        hasCo2.isAcceptableOrUnknown(data['has_co2']!, _hasCo2Meta),
      );
    }
    if (data.containsKey('footprint_length_in')) {
      context.handle(
        _footprintLengthInMeta,
        footprintLengthIn.isAcceptableOrUnknown(
          data['footprint_length_in']!,
          _footprintLengthInMeta,
        ),
      );
    }
    if (data.containsKey('footprint_width_in')) {
      context.handle(
        _footprintWidthInMeta,
        footprintWidthIn.isAcceptableOrUnknown(
          data['footprint_width_in']!,
          _footprintWidthInMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tank(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      volumeGal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume_gal'],
      )!,
      substrateType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}substrate_type'],
      )!,
      hasSoil: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_soil'],
      )!,
      waterSource: $TanksTable.$converterwaterSource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}water_source'],
        )!,
      ),
      heaterWatts: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heater_watts'],
      ),
      lightWatts: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}light_watts'],
      ),
      lightHoursPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}light_hours_per_day'],
      ),
      roomTempF: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}room_temp_f'],
      ),
      targetTempF: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_temp_f'],
      ),
      cycleStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cycle_started_at'],
      ),
      cycleMethod: $TanksTable.$convertercycleMethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cycle_method'],
        )!,
      ),
      stockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}stocked_at'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lightLevel: $TanksTable.$converterlightLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}light_level'],
        ),
      ),
      hasCo2: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_co2'],
      )!,
      footprintLengthIn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}footprint_length_in'],
      ),
      footprintWidthIn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}footprint_width_in'],
      ),
    );
  }

  @override
  $TanksTable createAlias(String alias) {
    return $TanksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WaterSource, String, String> $converterwaterSource =
      const EnumNameConverter<WaterSource>(WaterSource.values);
  static JsonTypeConverter2<CycleMethod, String, String> $convertercycleMethod =
      const EnumNameConverter<CycleMethod>(CycleMethod.values);
  static JsonTypeConverter2<LightLevel, String, String> $converterlightLevel =
      const EnumNameConverter<LightLevel>(LightLevel.values);
  static JsonTypeConverter2<LightLevel?, String?, String?>
  $converterlightLeveln = JsonTypeConverter2.asNullable($converterlightLevel);
}

class Tank extends DataClass implements Insertable<Tank> {
  final int id;
  final String name;
  final double volumeGal;
  final String substrateType;
  final bool hasSoil;
  final WaterSource waterSource;
  final double? heaterWatts;
  final double? lightWatts;
  final double? lightHoursPerDay;
  final double? roomTempF;
  final double? targetTempF;
  final DateTime? cycleStartedAt;
  final CycleMethod cycleMethod;
  final DateTime? stockedAt;
  final bool archived;
  final DateTime createdAt;
  final LightLevel? lightLevel;
  final bool hasCo2;
  final double? footprintLengthIn;
  final double? footprintWidthIn;
  const Tank({
    required this.id,
    required this.name,
    required this.volumeGal,
    required this.substrateType,
    required this.hasSoil,
    required this.waterSource,
    this.heaterWatts,
    this.lightWatts,
    this.lightHoursPerDay,
    this.roomTempF,
    this.targetTempF,
    this.cycleStartedAt,
    required this.cycleMethod,
    this.stockedAt,
    required this.archived,
    required this.createdAt,
    this.lightLevel,
    required this.hasCo2,
    this.footprintLengthIn,
    this.footprintWidthIn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['volume_gal'] = Variable<double>(volumeGal);
    map['substrate_type'] = Variable<String>(substrateType);
    map['has_soil'] = Variable<bool>(hasSoil);
    {
      map['water_source'] = Variable<String>(
        $TanksTable.$converterwaterSource.toSql(waterSource),
      );
    }
    if (!nullToAbsent || heaterWatts != null) {
      map['heater_watts'] = Variable<double>(heaterWatts);
    }
    if (!nullToAbsent || lightWatts != null) {
      map['light_watts'] = Variable<double>(lightWatts);
    }
    if (!nullToAbsent || lightHoursPerDay != null) {
      map['light_hours_per_day'] = Variable<double>(lightHoursPerDay);
    }
    if (!nullToAbsent || roomTempF != null) {
      map['room_temp_f'] = Variable<double>(roomTempF);
    }
    if (!nullToAbsent || targetTempF != null) {
      map['target_temp_f'] = Variable<double>(targetTempF);
    }
    if (!nullToAbsent || cycleStartedAt != null) {
      map['cycle_started_at'] = Variable<DateTime>(cycleStartedAt);
    }
    {
      map['cycle_method'] = Variable<String>(
        $TanksTable.$convertercycleMethod.toSql(cycleMethod),
      );
    }
    if (!nullToAbsent || stockedAt != null) {
      map['stocked_at'] = Variable<DateTime>(stockedAt);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lightLevel != null) {
      map['light_level'] = Variable<String>(
        $TanksTable.$converterlightLeveln.toSql(lightLevel),
      );
    }
    map['has_co2'] = Variable<bool>(hasCo2);
    if (!nullToAbsent || footprintLengthIn != null) {
      map['footprint_length_in'] = Variable<double>(footprintLengthIn);
    }
    if (!nullToAbsent || footprintWidthIn != null) {
      map['footprint_width_in'] = Variable<double>(footprintWidthIn);
    }
    return map;
  }

  TanksCompanion toCompanion(bool nullToAbsent) {
    return TanksCompanion(
      id: Value(id),
      name: Value(name),
      volumeGal: Value(volumeGal),
      substrateType: Value(substrateType),
      hasSoil: Value(hasSoil),
      waterSource: Value(waterSource),
      heaterWatts: heaterWatts == null && nullToAbsent
          ? const Value.absent()
          : Value(heaterWatts),
      lightWatts: lightWatts == null && nullToAbsent
          ? const Value.absent()
          : Value(lightWatts),
      lightHoursPerDay: lightHoursPerDay == null && nullToAbsent
          ? const Value.absent()
          : Value(lightHoursPerDay),
      roomTempF: roomTempF == null && nullToAbsent
          ? const Value.absent()
          : Value(roomTempF),
      targetTempF: targetTempF == null && nullToAbsent
          ? const Value.absent()
          : Value(targetTempF),
      cycleStartedAt: cycleStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleStartedAt),
      cycleMethod: Value(cycleMethod),
      stockedAt: stockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(stockedAt),
      archived: Value(archived),
      createdAt: Value(createdAt),
      lightLevel: lightLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(lightLevel),
      hasCo2: Value(hasCo2),
      footprintLengthIn: footprintLengthIn == null && nullToAbsent
          ? const Value.absent()
          : Value(footprintLengthIn),
      footprintWidthIn: footprintWidthIn == null && nullToAbsent
          ? const Value.absent()
          : Value(footprintWidthIn),
    );
  }

  factory Tank.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tank(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      volumeGal: serializer.fromJson<double>(json['volumeGal']),
      substrateType: serializer.fromJson<String>(json['substrateType']),
      hasSoil: serializer.fromJson<bool>(json['hasSoil']),
      waterSource: $TanksTable.$converterwaterSource.fromJson(
        serializer.fromJson<String>(json['waterSource']),
      ),
      heaterWatts: serializer.fromJson<double?>(json['heaterWatts']),
      lightWatts: serializer.fromJson<double?>(json['lightWatts']),
      lightHoursPerDay: serializer.fromJson<double?>(json['lightHoursPerDay']),
      roomTempF: serializer.fromJson<double?>(json['roomTempF']),
      targetTempF: serializer.fromJson<double?>(json['targetTempF']),
      cycleStartedAt: serializer.fromJson<DateTime?>(json['cycleStartedAt']),
      cycleMethod: $TanksTable.$convertercycleMethod.fromJson(
        serializer.fromJson<String>(json['cycleMethod']),
      ),
      stockedAt: serializer.fromJson<DateTime?>(json['stockedAt']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lightLevel: $TanksTable.$converterlightLeveln.fromJson(
        serializer.fromJson<String?>(json['lightLevel']),
      ),
      hasCo2: serializer.fromJson<bool>(json['hasCo2']),
      footprintLengthIn: serializer.fromJson<double?>(
        json['footprintLengthIn'],
      ),
      footprintWidthIn: serializer.fromJson<double?>(json['footprintWidthIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'volumeGal': serializer.toJson<double>(volumeGal),
      'substrateType': serializer.toJson<String>(substrateType),
      'hasSoil': serializer.toJson<bool>(hasSoil),
      'waterSource': serializer.toJson<String>(
        $TanksTable.$converterwaterSource.toJson(waterSource),
      ),
      'heaterWatts': serializer.toJson<double?>(heaterWatts),
      'lightWatts': serializer.toJson<double?>(lightWatts),
      'lightHoursPerDay': serializer.toJson<double?>(lightHoursPerDay),
      'roomTempF': serializer.toJson<double?>(roomTempF),
      'targetTempF': serializer.toJson<double?>(targetTempF),
      'cycleStartedAt': serializer.toJson<DateTime?>(cycleStartedAt),
      'cycleMethod': serializer.toJson<String>(
        $TanksTable.$convertercycleMethod.toJson(cycleMethod),
      ),
      'stockedAt': serializer.toJson<DateTime?>(stockedAt),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lightLevel': serializer.toJson<String?>(
        $TanksTable.$converterlightLeveln.toJson(lightLevel),
      ),
      'hasCo2': serializer.toJson<bool>(hasCo2),
      'footprintLengthIn': serializer.toJson<double?>(footprintLengthIn),
      'footprintWidthIn': serializer.toJson<double?>(footprintWidthIn),
    };
  }

  Tank copyWith({
    int? id,
    String? name,
    double? volumeGal,
    String? substrateType,
    bool? hasSoil,
    WaterSource? waterSource,
    Value<double?> heaterWatts = const Value.absent(),
    Value<double?> lightWatts = const Value.absent(),
    Value<double?> lightHoursPerDay = const Value.absent(),
    Value<double?> roomTempF = const Value.absent(),
    Value<double?> targetTempF = const Value.absent(),
    Value<DateTime?> cycleStartedAt = const Value.absent(),
    CycleMethod? cycleMethod,
    Value<DateTime?> stockedAt = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    Value<LightLevel?> lightLevel = const Value.absent(),
    bool? hasCo2,
    Value<double?> footprintLengthIn = const Value.absent(),
    Value<double?> footprintWidthIn = const Value.absent(),
  }) => Tank(
    id: id ?? this.id,
    name: name ?? this.name,
    volumeGal: volumeGal ?? this.volumeGal,
    substrateType: substrateType ?? this.substrateType,
    hasSoil: hasSoil ?? this.hasSoil,
    waterSource: waterSource ?? this.waterSource,
    heaterWatts: heaterWatts.present ? heaterWatts.value : this.heaterWatts,
    lightWatts: lightWatts.present ? lightWatts.value : this.lightWatts,
    lightHoursPerDay: lightHoursPerDay.present
        ? lightHoursPerDay.value
        : this.lightHoursPerDay,
    roomTempF: roomTempF.present ? roomTempF.value : this.roomTempF,
    targetTempF: targetTempF.present ? targetTempF.value : this.targetTempF,
    cycleStartedAt: cycleStartedAt.present
        ? cycleStartedAt.value
        : this.cycleStartedAt,
    cycleMethod: cycleMethod ?? this.cycleMethod,
    stockedAt: stockedAt.present ? stockedAt.value : this.stockedAt,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    lightLevel: lightLevel.present ? lightLevel.value : this.lightLevel,
    hasCo2: hasCo2 ?? this.hasCo2,
    footprintLengthIn: footprintLengthIn.present
        ? footprintLengthIn.value
        : this.footprintLengthIn,
    footprintWidthIn: footprintWidthIn.present
        ? footprintWidthIn.value
        : this.footprintWidthIn,
  );
  Tank copyWithCompanion(TanksCompanion data) {
    return Tank(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      volumeGal: data.volumeGal.present ? data.volumeGal.value : this.volumeGal,
      substrateType: data.substrateType.present
          ? data.substrateType.value
          : this.substrateType,
      hasSoil: data.hasSoil.present ? data.hasSoil.value : this.hasSoil,
      waterSource: data.waterSource.present
          ? data.waterSource.value
          : this.waterSource,
      heaterWatts: data.heaterWatts.present
          ? data.heaterWatts.value
          : this.heaterWatts,
      lightWatts: data.lightWatts.present
          ? data.lightWatts.value
          : this.lightWatts,
      lightHoursPerDay: data.lightHoursPerDay.present
          ? data.lightHoursPerDay.value
          : this.lightHoursPerDay,
      roomTempF: data.roomTempF.present ? data.roomTempF.value : this.roomTempF,
      targetTempF: data.targetTempF.present
          ? data.targetTempF.value
          : this.targetTempF,
      cycleStartedAt: data.cycleStartedAt.present
          ? data.cycleStartedAt.value
          : this.cycleStartedAt,
      cycleMethod: data.cycleMethod.present
          ? data.cycleMethod.value
          : this.cycleMethod,
      stockedAt: data.stockedAt.present ? data.stockedAt.value : this.stockedAt,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lightLevel: data.lightLevel.present
          ? data.lightLevel.value
          : this.lightLevel,
      hasCo2: data.hasCo2.present ? data.hasCo2.value : this.hasCo2,
      footprintLengthIn: data.footprintLengthIn.present
          ? data.footprintLengthIn.value
          : this.footprintLengthIn,
      footprintWidthIn: data.footprintWidthIn.present
          ? data.footprintWidthIn.value
          : this.footprintWidthIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tank(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('volumeGal: $volumeGal, ')
          ..write('substrateType: $substrateType, ')
          ..write('hasSoil: $hasSoil, ')
          ..write('waterSource: $waterSource, ')
          ..write('heaterWatts: $heaterWatts, ')
          ..write('lightWatts: $lightWatts, ')
          ..write('lightHoursPerDay: $lightHoursPerDay, ')
          ..write('roomTempF: $roomTempF, ')
          ..write('targetTempF: $targetTempF, ')
          ..write('cycleStartedAt: $cycleStartedAt, ')
          ..write('cycleMethod: $cycleMethod, ')
          ..write('stockedAt: $stockedAt, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('lightLevel: $lightLevel, ')
          ..write('hasCo2: $hasCo2, ')
          ..write('footprintLengthIn: $footprintLengthIn, ')
          ..write('footprintWidthIn: $footprintWidthIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    volumeGal,
    substrateType,
    hasSoil,
    waterSource,
    heaterWatts,
    lightWatts,
    lightHoursPerDay,
    roomTempF,
    targetTempF,
    cycleStartedAt,
    cycleMethod,
    stockedAt,
    archived,
    createdAt,
    lightLevel,
    hasCo2,
    footprintLengthIn,
    footprintWidthIn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tank &&
          other.id == this.id &&
          other.name == this.name &&
          other.volumeGal == this.volumeGal &&
          other.substrateType == this.substrateType &&
          other.hasSoil == this.hasSoil &&
          other.waterSource == this.waterSource &&
          other.heaterWatts == this.heaterWatts &&
          other.lightWatts == this.lightWatts &&
          other.lightHoursPerDay == this.lightHoursPerDay &&
          other.roomTempF == this.roomTempF &&
          other.targetTempF == this.targetTempF &&
          other.cycleStartedAt == this.cycleStartedAt &&
          other.cycleMethod == this.cycleMethod &&
          other.stockedAt == this.stockedAt &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.lightLevel == this.lightLevel &&
          other.hasCo2 == this.hasCo2 &&
          other.footprintLengthIn == this.footprintLengthIn &&
          other.footprintWidthIn == this.footprintWidthIn);
}

class TanksCompanion extends UpdateCompanion<Tank> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> volumeGal;
  final Value<String> substrateType;
  final Value<bool> hasSoil;
  final Value<WaterSource> waterSource;
  final Value<double?> heaterWatts;
  final Value<double?> lightWatts;
  final Value<double?> lightHoursPerDay;
  final Value<double?> roomTempF;
  final Value<double?> targetTempF;
  final Value<DateTime?> cycleStartedAt;
  final Value<CycleMethod> cycleMethod;
  final Value<DateTime?> stockedAt;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<LightLevel?> lightLevel;
  final Value<bool> hasCo2;
  final Value<double?> footprintLengthIn;
  final Value<double?> footprintWidthIn;
  const TanksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.volumeGal = const Value.absent(),
    this.substrateType = const Value.absent(),
    this.hasSoil = const Value.absent(),
    this.waterSource = const Value.absent(),
    this.heaterWatts = const Value.absent(),
    this.lightWatts = const Value.absent(),
    this.lightHoursPerDay = const Value.absent(),
    this.roomTempF = const Value.absent(),
    this.targetTempF = const Value.absent(),
    this.cycleStartedAt = const Value.absent(),
    this.cycleMethod = const Value.absent(),
    this.stockedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lightLevel = const Value.absent(),
    this.hasCo2 = const Value.absent(),
    this.footprintLengthIn = const Value.absent(),
    this.footprintWidthIn = const Value.absent(),
  });
  TanksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double volumeGal,
    required String substrateType,
    required bool hasSoil,
    required WaterSource waterSource,
    this.heaterWatts = const Value.absent(),
    this.lightWatts = const Value.absent(),
    this.lightHoursPerDay = const Value.absent(),
    this.roomTempF = const Value.absent(),
    this.targetTempF = const Value.absent(),
    this.cycleStartedAt = const Value.absent(),
    required CycleMethod cycleMethod,
    this.stockedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lightLevel = const Value.absent(),
    this.hasCo2 = const Value.absent(),
    this.footprintLengthIn = const Value.absent(),
    this.footprintWidthIn = const Value.absent(),
  }) : name = Value(name),
       volumeGal = Value(volumeGal),
       substrateType = Value(substrateType),
       hasSoil = Value(hasSoil),
       waterSource = Value(waterSource),
       cycleMethod = Value(cycleMethod);
  static Insertable<Tank> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? volumeGal,
    Expression<String>? substrateType,
    Expression<bool>? hasSoil,
    Expression<String>? waterSource,
    Expression<double>? heaterWatts,
    Expression<double>? lightWatts,
    Expression<double>? lightHoursPerDay,
    Expression<double>? roomTempF,
    Expression<double>? targetTempF,
    Expression<DateTime>? cycleStartedAt,
    Expression<String>? cycleMethod,
    Expression<DateTime>? stockedAt,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<String>? lightLevel,
    Expression<bool>? hasCo2,
    Expression<double>? footprintLengthIn,
    Expression<double>? footprintWidthIn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (volumeGal != null) 'volume_gal': volumeGal,
      if (substrateType != null) 'substrate_type': substrateType,
      if (hasSoil != null) 'has_soil': hasSoil,
      if (waterSource != null) 'water_source': waterSource,
      if (heaterWatts != null) 'heater_watts': heaterWatts,
      if (lightWatts != null) 'light_watts': lightWatts,
      if (lightHoursPerDay != null) 'light_hours_per_day': lightHoursPerDay,
      if (roomTempF != null) 'room_temp_f': roomTempF,
      if (targetTempF != null) 'target_temp_f': targetTempF,
      if (cycleStartedAt != null) 'cycle_started_at': cycleStartedAt,
      if (cycleMethod != null) 'cycle_method': cycleMethod,
      if (stockedAt != null) 'stocked_at': stockedAt,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (lightLevel != null) 'light_level': lightLevel,
      if (hasCo2 != null) 'has_co2': hasCo2,
      if (footprintLengthIn != null) 'footprint_length_in': footprintLengthIn,
      if (footprintWidthIn != null) 'footprint_width_in': footprintWidthIn,
    });
  }

  TanksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? volumeGal,
    Value<String>? substrateType,
    Value<bool>? hasSoil,
    Value<WaterSource>? waterSource,
    Value<double?>? heaterWatts,
    Value<double?>? lightWatts,
    Value<double?>? lightHoursPerDay,
    Value<double?>? roomTempF,
    Value<double?>? targetTempF,
    Value<DateTime?>? cycleStartedAt,
    Value<CycleMethod>? cycleMethod,
    Value<DateTime?>? stockedAt,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<LightLevel?>? lightLevel,
    Value<bool>? hasCo2,
    Value<double?>? footprintLengthIn,
    Value<double?>? footprintWidthIn,
  }) {
    return TanksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      volumeGal: volumeGal ?? this.volumeGal,
      substrateType: substrateType ?? this.substrateType,
      hasSoil: hasSoil ?? this.hasSoil,
      waterSource: waterSource ?? this.waterSource,
      heaterWatts: heaterWatts ?? this.heaterWatts,
      lightWatts: lightWatts ?? this.lightWatts,
      lightHoursPerDay: lightHoursPerDay ?? this.lightHoursPerDay,
      roomTempF: roomTempF ?? this.roomTempF,
      targetTempF: targetTempF ?? this.targetTempF,
      cycleStartedAt: cycleStartedAt ?? this.cycleStartedAt,
      cycleMethod: cycleMethod ?? this.cycleMethod,
      stockedAt: stockedAt ?? this.stockedAt,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      lightLevel: lightLevel ?? this.lightLevel,
      hasCo2: hasCo2 ?? this.hasCo2,
      footprintLengthIn: footprintLengthIn ?? this.footprintLengthIn,
      footprintWidthIn: footprintWidthIn ?? this.footprintWidthIn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (volumeGal.present) {
      map['volume_gal'] = Variable<double>(volumeGal.value);
    }
    if (substrateType.present) {
      map['substrate_type'] = Variable<String>(substrateType.value);
    }
    if (hasSoil.present) {
      map['has_soil'] = Variable<bool>(hasSoil.value);
    }
    if (waterSource.present) {
      map['water_source'] = Variable<String>(
        $TanksTable.$converterwaterSource.toSql(waterSource.value),
      );
    }
    if (heaterWatts.present) {
      map['heater_watts'] = Variable<double>(heaterWatts.value);
    }
    if (lightWatts.present) {
      map['light_watts'] = Variable<double>(lightWatts.value);
    }
    if (lightHoursPerDay.present) {
      map['light_hours_per_day'] = Variable<double>(lightHoursPerDay.value);
    }
    if (roomTempF.present) {
      map['room_temp_f'] = Variable<double>(roomTempF.value);
    }
    if (targetTempF.present) {
      map['target_temp_f'] = Variable<double>(targetTempF.value);
    }
    if (cycleStartedAt.present) {
      map['cycle_started_at'] = Variable<DateTime>(cycleStartedAt.value);
    }
    if (cycleMethod.present) {
      map['cycle_method'] = Variable<String>(
        $TanksTable.$convertercycleMethod.toSql(cycleMethod.value),
      );
    }
    if (stockedAt.present) {
      map['stocked_at'] = Variable<DateTime>(stockedAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lightLevel.present) {
      map['light_level'] = Variable<String>(
        $TanksTable.$converterlightLeveln.toSql(lightLevel.value),
      );
    }
    if (hasCo2.present) {
      map['has_co2'] = Variable<bool>(hasCo2.value);
    }
    if (footprintLengthIn.present) {
      map['footprint_length_in'] = Variable<double>(footprintLengthIn.value);
    }
    if (footprintWidthIn.present) {
      map['footprint_width_in'] = Variable<double>(footprintWidthIn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TanksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('volumeGal: $volumeGal, ')
          ..write('substrateType: $substrateType, ')
          ..write('hasSoil: $hasSoil, ')
          ..write('waterSource: $waterSource, ')
          ..write('heaterWatts: $heaterWatts, ')
          ..write('lightWatts: $lightWatts, ')
          ..write('lightHoursPerDay: $lightHoursPerDay, ')
          ..write('roomTempF: $roomTempF, ')
          ..write('targetTempF: $targetTempF, ')
          ..write('cycleStartedAt: $cycleStartedAt, ')
          ..write('cycleMethod: $cycleMethod, ')
          ..write('stockedAt: $stockedAt, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('lightLevel: $lightLevel, ')
          ..write('hasCo2: $hasCo2, ')
          ..write('footprintLengthIn: $footprintLengthIn, ')
          ..write('footprintWidthIn: $footprintWidthIn')
          ..write(')'))
        .toString();
  }
}

class $TestKitsTable extends TestKits with TableInfo<$TestKitsTable, TestKit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestKitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, brand, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_kits';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestKit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestKit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestKit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TestKitsTable createAlias(String alias) {
    return $TestKitsTable(attachedDatabase, alias);
  }
}

class TestKit extends DataClass implements Insertable<TestKit> {
  final int id;
  final String name;
  final String? brand;
  final DateTime createdAt;
  const TestKit({
    required this.id,
    required this.name,
    this.brand,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TestKitsCompanion toCompanion(bool nullToAbsent) {
    return TestKitsCompanion(
      id: Value(id),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      createdAt: Value(createdAt),
    );
  }

  factory TestKit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestKit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TestKit copyWith({
    int? id,
    String? name,
    Value<String?> brand = const Value.absent(),
    DateTime? createdAt,
  }) => TestKit(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    createdAt: createdAt ?? this.createdAt,
  );
  TestKit copyWithCompanion(TestKitsCompanion data) {
    return TestKit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestKit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, brand, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestKit &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.createdAt == this.createdAt);
}

class TestKitsCompanion extends UpdateCompanion<TestKit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<DateTime> createdAt;
  const TestKitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TestKitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TestKit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TestKitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? brand,
    Value<DateTime>? createdAt,
  }) {
    return TestKitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestKitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KitParametersTable extends KitParameters
    with TableInfo<$KitParametersTable, KitParameter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KitParametersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kitIdMeta = const VerificationMeta('kitId');
  @override
  late final GeneratedColumn<int> kitId = GeneratedColumn<int>(
    'kit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES test_kits (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Parameter, String> parameter =
      GeneratedColumn<String>(
        'parameter',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Parameter>($KitParametersTable.$converterparameter);
  @override
  late final GeneratedColumnWithTypeConverter<InputMode, String> inputMode =
      GeneratedColumn<String>(
        'input_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InputMode>($KitParametersTable.$converterinputMode);
  @override
  late final GeneratedColumnWithTypeConverter<List<double>?, String> stepsJson =
      GeneratedColumn<String>(
        'steps_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<double>?>($KitParametersTable.$converterstepsJsonn);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kitId,
    parameter,
    inputMode,
    stepsJson,
    unit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kit_parameters';
  @override
  VerificationContext validateIntegrity(
    Insertable<KitParameter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kit_id')) {
      context.handle(
        _kitIdMeta,
        kitId.isAcceptableOrUnknown(data['kit_id']!, _kitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kitIdMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kitId, parameter},
  ];
  @override
  KitParameter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KitParameter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kit_id'],
      )!,
      parameter: $KitParametersTable.$converterparameter.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}parameter'],
        )!,
      ),
      inputMode: $KitParametersTable.$converterinputMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}input_mode'],
        )!,
      ),
      stepsJson: $KitParametersTable.$converterstepsJsonn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}steps_json'],
        ),
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
    );
  }

  @override
  $KitParametersTable createAlias(String alias) {
    return $KitParametersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Parameter, String, String> $converterparameter =
      const EnumNameConverter<Parameter>(Parameter.values);
  static JsonTypeConverter2<InputMode, String, String> $converterinputMode =
      const EnumNameConverter<InputMode>(InputMode.values);
  static TypeConverter<List<double>, String> $converterstepsJson =
      const StepsConverter();
  static TypeConverter<List<double>?, String?> $converterstepsJsonn =
      NullAwareTypeConverter.wrap($converterstepsJson);
}

class KitParameter extends DataClass implements Insertable<KitParameter> {
  final int id;
  final int kitId;
  final Parameter parameter;
  final InputMode inputMode;
  final List<double>? stepsJson;
  final String unit;
  const KitParameter({
    required this.id,
    required this.kitId,
    required this.parameter,
    required this.inputMode,
    this.stepsJson,
    required this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kit_id'] = Variable<int>(kitId);
    {
      map['parameter'] = Variable<String>(
        $KitParametersTable.$converterparameter.toSql(parameter),
      );
    }
    {
      map['input_mode'] = Variable<String>(
        $KitParametersTable.$converterinputMode.toSql(inputMode),
      );
    }
    if (!nullToAbsent || stepsJson != null) {
      map['steps_json'] = Variable<String>(
        $KitParametersTable.$converterstepsJsonn.toSql(stepsJson),
      );
    }
    map['unit'] = Variable<String>(unit);
    return map;
  }

  KitParametersCompanion toCompanion(bool nullToAbsent) {
    return KitParametersCompanion(
      id: Value(id),
      kitId: Value(kitId),
      parameter: Value(parameter),
      inputMode: Value(inputMode),
      stepsJson: stepsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(stepsJson),
      unit: Value(unit),
    );
  }

  factory KitParameter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KitParameter(
      id: serializer.fromJson<int>(json['id']),
      kitId: serializer.fromJson<int>(json['kitId']),
      parameter: $KitParametersTable.$converterparameter.fromJson(
        serializer.fromJson<String>(json['parameter']),
      ),
      inputMode: $KitParametersTable.$converterinputMode.fromJson(
        serializer.fromJson<String>(json['inputMode']),
      ),
      stepsJson: serializer.fromJson<List<double>?>(json['stepsJson']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kitId': serializer.toJson<int>(kitId),
      'parameter': serializer.toJson<String>(
        $KitParametersTable.$converterparameter.toJson(parameter),
      ),
      'inputMode': serializer.toJson<String>(
        $KitParametersTable.$converterinputMode.toJson(inputMode),
      ),
      'stepsJson': serializer.toJson<List<double>?>(stepsJson),
      'unit': serializer.toJson<String>(unit),
    };
  }

  KitParameter copyWith({
    int? id,
    int? kitId,
    Parameter? parameter,
    InputMode? inputMode,
    Value<List<double>?> stepsJson = const Value.absent(),
    String? unit,
  }) => KitParameter(
    id: id ?? this.id,
    kitId: kitId ?? this.kitId,
    parameter: parameter ?? this.parameter,
    inputMode: inputMode ?? this.inputMode,
    stepsJson: stepsJson.present ? stepsJson.value : this.stepsJson,
    unit: unit ?? this.unit,
  );
  KitParameter copyWithCompanion(KitParametersCompanion data) {
    return KitParameter(
      id: data.id.present ? data.id.value : this.id,
      kitId: data.kitId.present ? data.kitId.value : this.kitId,
      parameter: data.parameter.present ? data.parameter.value : this.parameter,
      inputMode: data.inputMode.present ? data.inputMode.value : this.inputMode,
      stepsJson: data.stepsJson.present ? data.stepsJson.value : this.stepsJson,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KitParameter(')
          ..write('id: $id, ')
          ..write('kitId: $kitId, ')
          ..write('parameter: $parameter, ')
          ..write('inputMode: $inputMode, ')
          ..write('stepsJson: $stepsJson, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kitId, parameter, inputMode, stepsJson, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KitParameter &&
          other.id == this.id &&
          other.kitId == this.kitId &&
          other.parameter == this.parameter &&
          other.inputMode == this.inputMode &&
          other.stepsJson == this.stepsJson &&
          other.unit == this.unit);
}

class KitParametersCompanion extends UpdateCompanion<KitParameter> {
  final Value<int> id;
  final Value<int> kitId;
  final Value<Parameter> parameter;
  final Value<InputMode> inputMode;
  final Value<List<double>?> stepsJson;
  final Value<String> unit;
  const KitParametersCompanion({
    this.id = const Value.absent(),
    this.kitId = const Value.absent(),
    this.parameter = const Value.absent(),
    this.inputMode = const Value.absent(),
    this.stepsJson = const Value.absent(),
    this.unit = const Value.absent(),
  });
  KitParametersCompanion.insert({
    this.id = const Value.absent(),
    required int kitId,
    required Parameter parameter,
    required InputMode inputMode,
    this.stepsJson = const Value.absent(),
    required String unit,
  }) : kitId = Value(kitId),
       parameter = Value(parameter),
       inputMode = Value(inputMode),
       unit = Value(unit);
  static Insertable<KitParameter> custom({
    Expression<int>? id,
    Expression<int>? kitId,
    Expression<String>? parameter,
    Expression<String>? inputMode,
    Expression<String>? stepsJson,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kitId != null) 'kit_id': kitId,
      if (parameter != null) 'parameter': parameter,
      if (inputMode != null) 'input_mode': inputMode,
      if (stepsJson != null) 'steps_json': stepsJson,
      if (unit != null) 'unit': unit,
    });
  }

  KitParametersCompanion copyWith({
    Value<int>? id,
    Value<int>? kitId,
    Value<Parameter>? parameter,
    Value<InputMode>? inputMode,
    Value<List<double>?>? stepsJson,
    Value<String>? unit,
  }) {
    return KitParametersCompanion(
      id: id ?? this.id,
      kitId: kitId ?? this.kitId,
      parameter: parameter ?? this.parameter,
      inputMode: inputMode ?? this.inputMode,
      stepsJson: stepsJson ?? this.stepsJson,
      unit: unit ?? this.unit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kitId.present) {
      map['kit_id'] = Variable<int>(kitId.value);
    }
    if (parameter.present) {
      map['parameter'] = Variable<String>(
        $KitParametersTable.$converterparameter.toSql(parameter.value),
      );
    }
    if (inputMode.present) {
      map['input_mode'] = Variable<String>(
        $KitParametersTable.$converterinputMode.toSql(inputMode.value),
      );
    }
    if (stepsJson.present) {
      map['steps_json'] = Variable<String>(
        $KitParametersTable.$converterstepsJsonn.toSql(stepsJson.value),
      );
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KitParametersCompanion(')
          ..write('id: $id, ')
          ..write('kitId: $kitId, ')
          ..write('parameter: $parameter, ')
          ..write('inputMode: $inputMode, ')
          ..write('stepsJson: $stepsJson, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

class $ReadingsTable extends Readings with TableInfo<$ReadingsTable, Reading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tankIdMeta = const VerificationMeta('tankId');
  @override
  late final GeneratedColumn<int> tankId = GeneratedColumn<int>(
    'tank_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tanks (id)',
    ),
  );
  static const VerificationMeta _kitIdMeta = const VerificationMeta('kitId');
  @override
  late final GeneratedColumn<int> kitId = GeneratedColumn<int>(
    'kit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES test_kits (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Parameter, String> parameter =
      GeneratedColumn<String>(
        'parameter',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Parameter>($ReadingsTable.$converterparameter);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enteredAtMeta = const VerificationMeta(
    'enteredAt',
  );
  @override
  late final GeneratedColumn<DateTime> enteredAt = GeneratedColumn<DateTime>(
    'entered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _correctsIdMeta = const VerificationMeta(
    'correctsId',
  );
  @override
  late final GeneratedColumn<int> correctsId = GeneratedColumn<int>(
    'corrects_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES readings (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tankId,
    kitId,
    parameter,
    value,
    unit,
    takenAt,
    enteredAt,
    correctsId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tank_id')) {
      context.handle(
        _tankIdMeta,
        tankId.isAcceptableOrUnknown(data['tank_id']!, _tankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tankIdMeta);
    }
    if (data.containsKey('kit_id')) {
      context.handle(
        _kitIdMeta,
        kitId.isAcceptableOrUnknown(data['kit_id']!, _kitIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('entered_at')) {
      context.handle(
        _enteredAtMeta,
        enteredAt.isAcceptableOrUnknown(data['entered_at']!, _enteredAtMeta),
      );
    }
    if (data.containsKey('corrects_id')) {
      context.handle(
        _correctsIdMeta,
        correctsId.isAcceptableOrUnknown(data['corrects_id']!, _correctsIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tank_id'],
      )!,
      kitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kit_id'],
      ),
      parameter: $ReadingsTable.$converterparameter.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}parameter'],
        )!,
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      enteredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entered_at'],
      )!,
      correctsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corrects_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ReadingsTable createAlias(String alias) {
    return $ReadingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Parameter, String, String> $converterparameter =
      const EnumNameConverter<Parameter>(Parameter.values);
}

class Reading extends DataClass implements Insertable<Reading> {
  final int id;
  final int tankId;
  final int? kitId;
  final Parameter parameter;
  final double value;
  final String unit;
  final DateTime takenAt;
  final DateTime enteredAt;
  final int? correctsId;
  final String? note;
  const Reading({
    required this.id,
    required this.tankId,
    this.kitId,
    required this.parameter,
    required this.value,
    required this.unit,
    required this.takenAt,
    required this.enteredAt,
    this.correctsId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tank_id'] = Variable<int>(tankId);
    if (!nullToAbsent || kitId != null) {
      map['kit_id'] = Variable<int>(kitId);
    }
    {
      map['parameter'] = Variable<String>(
        $ReadingsTable.$converterparameter.toSql(parameter),
      );
    }
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['entered_at'] = Variable<DateTime>(enteredAt);
    if (!nullToAbsent || correctsId != null) {
      map['corrects_id'] = Variable<int>(correctsId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      tankId: Value(tankId),
      kitId: kitId == null && nullToAbsent
          ? const Value.absent()
          : Value(kitId),
      parameter: Value(parameter),
      value: Value(value),
      unit: Value(unit),
      takenAt: Value(takenAt),
      enteredAt: Value(enteredAt),
      correctsId: correctsId == null && nullToAbsent
          ? const Value.absent()
          : Value(correctsId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Reading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reading(
      id: serializer.fromJson<int>(json['id']),
      tankId: serializer.fromJson<int>(json['tankId']),
      kitId: serializer.fromJson<int?>(json['kitId']),
      parameter: $ReadingsTable.$converterparameter.fromJson(
        serializer.fromJson<String>(json['parameter']),
      ),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      enteredAt: serializer.fromJson<DateTime>(json['enteredAt']),
      correctsId: serializer.fromJson<int?>(json['correctsId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tankId': serializer.toJson<int>(tankId),
      'kitId': serializer.toJson<int?>(kitId),
      'parameter': serializer.toJson<String>(
        $ReadingsTable.$converterparameter.toJson(parameter),
      ),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'enteredAt': serializer.toJson<DateTime>(enteredAt),
      'correctsId': serializer.toJson<int?>(correctsId),
      'note': serializer.toJson<String?>(note),
    };
  }

  Reading copyWith({
    int? id,
    int? tankId,
    Value<int?> kitId = const Value.absent(),
    Parameter? parameter,
    double? value,
    String? unit,
    DateTime? takenAt,
    DateTime? enteredAt,
    Value<int?> correctsId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Reading(
    id: id ?? this.id,
    tankId: tankId ?? this.tankId,
    kitId: kitId.present ? kitId.value : this.kitId,
    parameter: parameter ?? this.parameter,
    value: value ?? this.value,
    unit: unit ?? this.unit,
    takenAt: takenAt ?? this.takenAt,
    enteredAt: enteredAt ?? this.enteredAt,
    correctsId: correctsId.present ? correctsId.value : this.correctsId,
    note: note.present ? note.value : this.note,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      tankId: data.tankId.present ? data.tankId.value : this.tankId,
      kitId: data.kitId.present ? data.kitId.value : this.kitId,
      parameter: data.parameter.present ? data.parameter.value : this.parameter,
      value: data.value.present ? data.value.value : this.value,
      unit: data.unit.present ? data.unit.value : this.unit,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      enteredAt: data.enteredAt.present ? data.enteredAt.value : this.enteredAt,
      correctsId: data.correctsId.present
          ? data.correctsId.value
          : this.correctsId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('kitId: $kitId, ')
          ..write('parameter: $parameter, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('takenAt: $takenAt, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('correctsId: $correctsId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tankId,
    kitId,
    parameter,
    value,
    unit,
    takenAt,
    enteredAt,
    correctsId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.tankId == this.tankId &&
          other.kitId == this.kitId &&
          other.parameter == this.parameter &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.takenAt == this.takenAt &&
          other.enteredAt == this.enteredAt &&
          other.correctsId == this.correctsId &&
          other.note == this.note);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<int> id;
  final Value<int> tankId;
  final Value<int?> kitId;
  final Value<Parameter> parameter;
  final Value<double> value;
  final Value<String> unit;
  final Value<DateTime> takenAt;
  final Value<DateTime> enteredAt;
  final Value<int?> correctsId;
  final Value<String?> note;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.tankId = const Value.absent(),
    this.kitId = const Value.absent(),
    this.parameter = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.enteredAt = const Value.absent(),
    this.correctsId = const Value.absent(),
    this.note = const Value.absent(),
  });
  ReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int tankId,
    this.kitId = const Value.absent(),
    required Parameter parameter,
    required double value,
    required String unit,
    required DateTime takenAt,
    this.enteredAt = const Value.absent(),
    this.correctsId = const Value.absent(),
    this.note = const Value.absent(),
  }) : tankId = Value(tankId),
       parameter = Value(parameter),
       value = Value(value),
       unit = Value(unit),
       takenAt = Value(takenAt);
  static Insertable<Reading> custom({
    Expression<int>? id,
    Expression<int>? tankId,
    Expression<int>? kitId,
    Expression<String>? parameter,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<DateTime>? takenAt,
    Expression<DateTime>? enteredAt,
    Expression<int>? correctsId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tankId != null) 'tank_id': tankId,
      if (kitId != null) 'kit_id': kitId,
      if (parameter != null) 'parameter': parameter,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (takenAt != null) 'taken_at': takenAt,
      if (enteredAt != null) 'entered_at': enteredAt,
      if (correctsId != null) 'corrects_id': correctsId,
      if (note != null) 'note': note,
    });
  }

  ReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? tankId,
    Value<int?>? kitId,
    Value<Parameter>? parameter,
    Value<double>? value,
    Value<String>? unit,
    Value<DateTime>? takenAt,
    Value<DateTime>? enteredAt,
    Value<int?>? correctsId,
    Value<String?>? note,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      tankId: tankId ?? this.tankId,
      kitId: kitId ?? this.kitId,
      parameter: parameter ?? this.parameter,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      takenAt: takenAt ?? this.takenAt,
      enteredAt: enteredAt ?? this.enteredAt,
      correctsId: correctsId ?? this.correctsId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tankId.present) {
      map['tank_id'] = Variable<int>(tankId.value);
    }
    if (kitId.present) {
      map['kit_id'] = Variable<int>(kitId.value);
    }
    if (parameter.present) {
      map['parameter'] = Variable<String>(
        $ReadingsTable.$converterparameter.toSql(parameter.value),
      );
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (enteredAt.present) {
      map['entered_at'] = Variable<DateTime>(enteredAt.value);
    }
    if (correctsId.present) {
      map['corrects_id'] = Variable<int>(correctsId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('kitId: $kitId, ')
          ..write('parameter: $parameter, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('takenAt: $takenAt, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('correctsId: $correctsId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tankIdMeta = const VerificationMeta('tankId');
  @override
  late final GeneratedColumn<int> tankId = GeneratedColumn<int>(
    'tank_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tanks (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EventType>($EventsTable.$convertertype);
  static const VerificationMeta _productMeta = const VerificationMeta(
    'product',
  );
  @override
  late final GeneratedColumn<String> product = GeneratedColumn<String>(
    'product',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountUnitMeta = const VerificationMeta(
    'amountUnit',
  );
  @override
  late final GeneratedColumn<String> amountUnit = GeneratedColumn<String>(
    'amount_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _percentChangedMeta = const VerificationMeta(
    'percentChanged',
  );
  @override
  late final GeneratedColumn<double> percentChanged = GeneratedColumn<double>(
    'percent_changed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enteredAtMeta = const VerificationMeta(
    'enteredAt',
  );
  @override
  late final GeneratedColumn<DateTime> enteredAt = GeneratedColumn<DateTime>(
    'entered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _correctsIdMeta = const VerificationMeta(
    'correctsId',
  );
  @override
  late final GeneratedColumn<int> correctsId = GeneratedColumn<int>(
    'corrects_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tankId,
    type,
    product,
    amount,
    amountUnit,
    percentChanged,
    occurredAt,
    enteredAt,
    correctsId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tank_id')) {
      context.handle(
        _tankIdMeta,
        tankId.isAcceptableOrUnknown(data['tank_id']!, _tankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tankIdMeta);
    }
    if (data.containsKey('product')) {
      context.handle(
        _productMeta,
        product.isAcceptableOrUnknown(data['product']!, _productMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('amount_unit')) {
      context.handle(
        _amountUnitMeta,
        amountUnit.isAcceptableOrUnknown(data['amount_unit']!, _amountUnitMeta),
      );
    }
    if (data.containsKey('percent_changed')) {
      context.handle(
        _percentChangedMeta,
        percentChanged.isAcceptableOrUnknown(
          data['percent_changed']!,
          _percentChangedMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('entered_at')) {
      context.handle(
        _enteredAtMeta,
        enteredAt.isAcceptableOrUnknown(data['entered_at']!, _enteredAtMeta),
      );
    }
    if (data.containsKey('corrects_id')) {
      context.handle(
        _correctsIdMeta,
        correctsId.isAcceptableOrUnknown(data['corrects_id']!, _correctsIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tank_id'],
      )!,
      type: $EventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      product: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      amountUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_unit'],
      ),
      percentChanged: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percent_changed'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      enteredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entered_at'],
      )!,
      correctsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corrects_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EventType, String, String> $convertertype =
      const EnumNameConverter<EventType>(EventType.values);
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final int tankId;
  final EventType type;
  final String? product;
  final double? amount;
  final String? amountUnit;
  final double? percentChanged;
  final DateTime occurredAt;
  final DateTime enteredAt;
  final int? correctsId;
  final String? note;
  const Event({
    required this.id,
    required this.tankId,
    required this.type,
    this.product,
    this.amount,
    this.amountUnit,
    this.percentChanged,
    required this.occurredAt,
    required this.enteredAt,
    this.correctsId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tank_id'] = Variable<int>(tankId);
    {
      map['type'] = Variable<String>($EventsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || product != null) {
      map['product'] = Variable<String>(product);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || amountUnit != null) {
      map['amount_unit'] = Variable<String>(amountUnit);
    }
    if (!nullToAbsent || percentChanged != null) {
      map['percent_changed'] = Variable<double>(percentChanged);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['entered_at'] = Variable<DateTime>(enteredAt);
    if (!nullToAbsent || correctsId != null) {
      map['corrects_id'] = Variable<int>(correctsId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      tankId: Value(tankId),
      type: Value(type),
      product: product == null && nullToAbsent
          ? const Value.absent()
          : Value(product),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      amountUnit: amountUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(amountUnit),
      percentChanged: percentChanged == null && nullToAbsent
          ? const Value.absent()
          : Value(percentChanged),
      occurredAt: Value(occurredAt),
      enteredAt: Value(enteredAt),
      correctsId: correctsId == null && nullToAbsent
          ? const Value.absent()
          : Value(correctsId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      tankId: serializer.fromJson<int>(json['tankId']),
      type: $EventsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      product: serializer.fromJson<String?>(json['product']),
      amount: serializer.fromJson<double?>(json['amount']),
      amountUnit: serializer.fromJson<String?>(json['amountUnit']),
      percentChanged: serializer.fromJson<double?>(json['percentChanged']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      enteredAt: serializer.fromJson<DateTime>(json['enteredAt']),
      correctsId: serializer.fromJson<int?>(json['correctsId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tankId': serializer.toJson<int>(tankId),
      'type': serializer.toJson<String>(
        $EventsTable.$convertertype.toJson(type),
      ),
      'product': serializer.toJson<String?>(product),
      'amount': serializer.toJson<double?>(amount),
      'amountUnit': serializer.toJson<String?>(amountUnit),
      'percentChanged': serializer.toJson<double?>(percentChanged),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'enteredAt': serializer.toJson<DateTime>(enteredAt),
      'correctsId': serializer.toJson<int?>(correctsId),
      'note': serializer.toJson<String?>(note),
    };
  }

  Event copyWith({
    int? id,
    int? tankId,
    EventType? type,
    Value<String?> product = const Value.absent(),
    Value<double?> amount = const Value.absent(),
    Value<String?> amountUnit = const Value.absent(),
    Value<double?> percentChanged = const Value.absent(),
    DateTime? occurredAt,
    DateTime? enteredAt,
    Value<int?> correctsId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Event(
    id: id ?? this.id,
    tankId: tankId ?? this.tankId,
    type: type ?? this.type,
    product: product.present ? product.value : this.product,
    amount: amount.present ? amount.value : this.amount,
    amountUnit: amountUnit.present ? amountUnit.value : this.amountUnit,
    percentChanged: percentChanged.present
        ? percentChanged.value
        : this.percentChanged,
    occurredAt: occurredAt ?? this.occurredAt,
    enteredAt: enteredAt ?? this.enteredAt,
    correctsId: correctsId.present ? correctsId.value : this.correctsId,
    note: note.present ? note.value : this.note,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      tankId: data.tankId.present ? data.tankId.value : this.tankId,
      type: data.type.present ? data.type.value : this.type,
      product: data.product.present ? data.product.value : this.product,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountUnit: data.amountUnit.present
          ? data.amountUnit.value
          : this.amountUnit,
      percentChanged: data.percentChanged.present
          ? data.percentChanged.value
          : this.percentChanged,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      enteredAt: data.enteredAt.present ? data.enteredAt.value : this.enteredAt,
      correctsId: data.correctsId.present
          ? data.correctsId.value
          : this.correctsId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('type: $type, ')
          ..write('product: $product, ')
          ..write('amount: $amount, ')
          ..write('amountUnit: $amountUnit, ')
          ..write('percentChanged: $percentChanged, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('correctsId: $correctsId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tankId,
    type,
    product,
    amount,
    amountUnit,
    percentChanged,
    occurredAt,
    enteredAt,
    correctsId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.tankId == this.tankId &&
          other.type == this.type &&
          other.product == this.product &&
          other.amount == this.amount &&
          other.amountUnit == this.amountUnit &&
          other.percentChanged == this.percentChanged &&
          other.occurredAt == this.occurredAt &&
          other.enteredAt == this.enteredAt &&
          other.correctsId == this.correctsId &&
          other.note == this.note);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<int> tankId;
  final Value<EventType> type;
  final Value<String?> product;
  final Value<double?> amount;
  final Value<String?> amountUnit;
  final Value<double?> percentChanged;
  final Value<DateTime> occurredAt;
  final Value<DateTime> enteredAt;
  final Value<int?> correctsId;
  final Value<String?> note;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.tankId = const Value.absent(),
    this.type = const Value.absent(),
    this.product = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountUnit = const Value.absent(),
    this.percentChanged = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.enteredAt = const Value.absent(),
    this.correctsId = const Value.absent(),
    this.note = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required int tankId,
    required EventType type,
    this.product = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountUnit = const Value.absent(),
    this.percentChanged = const Value.absent(),
    required DateTime occurredAt,
    this.enteredAt = const Value.absent(),
    this.correctsId = const Value.absent(),
    this.note = const Value.absent(),
  }) : tankId = Value(tankId),
       type = Value(type),
       occurredAt = Value(occurredAt);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<int>? tankId,
    Expression<String>? type,
    Expression<String>? product,
    Expression<double>? amount,
    Expression<String>? amountUnit,
    Expression<double>? percentChanged,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? enteredAt,
    Expression<int>? correctsId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tankId != null) 'tank_id': tankId,
      if (type != null) 'type': type,
      if (product != null) 'product': product,
      if (amount != null) 'amount': amount,
      if (amountUnit != null) 'amount_unit': amountUnit,
      if (percentChanged != null) 'percent_changed': percentChanged,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (enteredAt != null) 'entered_at': enteredAt,
      if (correctsId != null) 'corrects_id': correctsId,
      if (note != null) 'note': note,
    });
  }

  EventsCompanion copyWith({
    Value<int>? id,
    Value<int>? tankId,
    Value<EventType>? type,
    Value<String?>? product,
    Value<double?>? amount,
    Value<String?>? amountUnit,
    Value<double?>? percentChanged,
    Value<DateTime>? occurredAt,
    Value<DateTime>? enteredAt,
    Value<int?>? correctsId,
    Value<String?>? note,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      tankId: tankId ?? this.tankId,
      type: type ?? this.type,
      product: product ?? this.product,
      amount: amount ?? this.amount,
      amountUnit: amountUnit ?? this.amountUnit,
      percentChanged: percentChanged ?? this.percentChanged,
      occurredAt: occurredAt ?? this.occurredAt,
      enteredAt: enteredAt ?? this.enteredAt,
      correctsId: correctsId ?? this.correctsId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tankId.present) {
      map['tank_id'] = Variable<int>(tankId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $EventsTable.$convertertype.toSql(type.value),
      );
    }
    if (product.present) {
      map['product'] = Variable<String>(product.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (amountUnit.present) {
      map['amount_unit'] = Variable<String>(amountUnit.value);
    }
    if (percentChanged.present) {
      map['percent_changed'] = Variable<double>(percentChanged.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (enteredAt.present) {
      map['entered_at'] = Variable<DateTime>(enteredAt.value);
    }
    if (correctsId.present) {
      map['corrects_id'] = Variable<int>(correctsId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('type: $type, ')
          ..write('product: $product, ')
          ..write('amount: $amount, ')
          ..write('amountUnit: $amountUnit, ')
          ..write('percentChanged: $percentChanged, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('correctsId: $correctsId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tankIdMeta = const VerificationMeta('tankId');
  @override
  late final GeneratedColumn<int> tankId = GeneratedColumn<int>(
    'tank_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tanks (id)',
    ),
  );
  static const VerificationMeta _everyNDaysMeta = const VerificationMeta(
    'everyNDays',
  );
  @override
  late final GeneratedColumn<int> everyNDays = GeneratedColumn<int>(
    'every_n_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeOfDayMeta = const VerificationMeta(
    'timeOfDay',
  );
  @override
  late final GeneratedColumn<String> timeOfDay = GeneratedColumn<String>(
    'time_of_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastFiredAtMeta = const VerificationMeta(
    'lastFiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFiredAt = GeneratedColumn<DateTime>(
    'last_fired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tankId,
    everyNDays,
    timeOfDay,
    enabled,
    lastFiredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tank_id')) {
      context.handle(
        _tankIdMeta,
        tankId.isAcceptableOrUnknown(data['tank_id']!, _tankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tankIdMeta);
    }
    if (data.containsKey('every_n_days')) {
      context.handle(
        _everyNDaysMeta,
        everyNDays.isAcceptableOrUnknown(
          data['every_n_days']!,
          _everyNDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_everyNDaysMeta);
    }
    if (data.containsKey('time_of_day')) {
      context.handle(
        _timeOfDayMeta,
        timeOfDay.isAcceptableOrUnknown(data['time_of_day']!, _timeOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_timeOfDayMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('last_fired_at')) {
      context.handle(
        _lastFiredAtMeta,
        lastFiredAt.isAcceptableOrUnknown(
          data['last_fired_at']!,
          _lastFiredAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tank_id'],
      )!,
      everyNDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}every_n_days'],
      )!,
      timeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_day'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      lastFiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fired_at'],
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int tankId;
  final int everyNDays;
  final String timeOfDay;
  final bool enabled;
  final DateTime? lastFiredAt;
  const Reminder({
    required this.id,
    required this.tankId,
    required this.everyNDays,
    required this.timeOfDay,
    required this.enabled,
    this.lastFiredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tank_id'] = Variable<int>(tankId);
    map['every_n_days'] = Variable<int>(everyNDays);
    map['time_of_day'] = Variable<String>(timeOfDay);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || lastFiredAt != null) {
      map['last_fired_at'] = Variable<DateTime>(lastFiredAt);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      tankId: Value(tankId),
      everyNDays: Value(everyNDays),
      timeOfDay: Value(timeOfDay),
      enabled: Value(enabled),
      lastFiredAt: lastFiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFiredAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      tankId: serializer.fromJson<int>(json['tankId']),
      everyNDays: serializer.fromJson<int>(json['everyNDays']),
      timeOfDay: serializer.fromJson<String>(json['timeOfDay']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      lastFiredAt: serializer.fromJson<DateTime?>(json['lastFiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tankId': serializer.toJson<int>(tankId),
      'everyNDays': serializer.toJson<int>(everyNDays),
      'timeOfDay': serializer.toJson<String>(timeOfDay),
      'enabled': serializer.toJson<bool>(enabled),
      'lastFiredAt': serializer.toJson<DateTime?>(lastFiredAt),
    };
  }

  Reminder copyWith({
    int? id,
    int? tankId,
    int? everyNDays,
    String? timeOfDay,
    bool? enabled,
    Value<DateTime?> lastFiredAt = const Value.absent(),
  }) => Reminder(
    id: id ?? this.id,
    tankId: tankId ?? this.tankId,
    everyNDays: everyNDays ?? this.everyNDays,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    enabled: enabled ?? this.enabled,
    lastFiredAt: lastFiredAt.present ? lastFiredAt.value : this.lastFiredAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      tankId: data.tankId.present ? data.tankId.value : this.tankId,
      everyNDays: data.everyNDays.present
          ? data.everyNDays.value
          : this.everyNDays,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      lastFiredAt: data.lastFiredAt.present
          ? data.lastFiredAt.value
          : this.lastFiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('everyNDays: $everyNDays, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('enabled: $enabled, ')
          ..write('lastFiredAt: $lastFiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tankId, everyNDays, timeOfDay, enabled, lastFiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.tankId == this.tankId &&
          other.everyNDays == this.everyNDays &&
          other.timeOfDay == this.timeOfDay &&
          other.enabled == this.enabled &&
          other.lastFiredAt == this.lastFiredAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> tankId;
  final Value<int> everyNDays;
  final Value<String> timeOfDay;
  final Value<bool> enabled;
  final Value<DateTime?> lastFiredAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.tankId = const Value.absent(),
    this.everyNDays = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastFiredAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int tankId,
    required int everyNDays,
    required String timeOfDay,
    this.enabled = const Value.absent(),
    this.lastFiredAt = const Value.absent(),
  }) : tankId = Value(tankId),
       everyNDays = Value(everyNDays),
       timeOfDay = Value(timeOfDay);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? tankId,
    Expression<int>? everyNDays,
    Expression<String>? timeOfDay,
    Expression<bool>? enabled,
    Expression<DateTime>? lastFiredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tankId != null) 'tank_id': tankId,
      if (everyNDays != null) 'every_n_days': everyNDays,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (enabled != null) 'enabled': enabled,
      if (lastFiredAt != null) 'last_fired_at': lastFiredAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? tankId,
    Value<int>? everyNDays,
    Value<String>? timeOfDay,
    Value<bool>? enabled,
    Value<DateTime?>? lastFiredAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      tankId: tankId ?? this.tankId,
      everyNDays: everyNDays ?? this.everyNDays,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      enabled: enabled ?? this.enabled,
      lastFiredAt: lastFiredAt ?? this.lastFiredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tankId.present) {
      map['tank_id'] = Variable<int>(tankId.value);
    }
    if (everyNDays.present) {
      map['every_n_days'] = Variable<int>(everyNDays.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<String>(timeOfDay.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (lastFiredAt.present) {
      map['last_fired_at'] = Variable<DateTime>(lastFiredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('everyNDays: $everyNDays, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('enabled: $enabled, ')
          ..write('lastFiredAt: $lastFiredAt')
          ..write(')'))
        .toString();
  }
}

class $StockEntriesTable extends StockEntries
    with TableInfo<$StockEntriesTable, StockEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tankIdMeta = const VerificationMeta('tankId');
  @override
  late final GeneratedColumn<int> tankId = GeneratedColumn<int>(
    'tank_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tanks (id)',
    ),
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SpeciesType, String> speciesType =
      GeneratedColumn<String>(
        'species_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpeciesType>($StockEntriesTable.$converterspeciesType);
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<int> change = GeneratedColumn<int>(
    'change',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enteredAtMeta = const VerificationMeta(
    'enteredAt',
  );
  @override
  late final GeneratedColumn<DateTime> enteredAt = GeneratedColumn<DateTime>(
    'entered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _correctsIdMeta = const VerificationMeta(
    'correctsId',
  );
  @override
  late final GeneratedColumn<int> correctsId = GeneratedColumn<int>(
    'corrects_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stock_entries (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tankId,
    speciesId,
    speciesType,
    change,
    occurredAt,
    enteredAt,
    correctsId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tank_id')) {
      context.handle(
        _tankIdMeta,
        tankId.isAcceptableOrUnknown(data['tank_id']!, _tankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tankIdMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('change')) {
      context.handle(
        _changeMeta,
        change.isAcceptableOrUnknown(data['change']!, _changeMeta),
      );
    } else if (isInserting) {
      context.missing(_changeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('entered_at')) {
      context.handle(
        _enteredAtMeta,
        enteredAt.isAcceptableOrUnknown(data['entered_at']!, _enteredAtMeta),
      );
    }
    if (data.containsKey('corrects_id')) {
      context.handle(
        _correctsIdMeta,
        correctsId.isAcceptableOrUnknown(data['corrects_id']!, _correctsIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tankId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tank_id'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      )!,
      speciesType: $StockEntriesTable.$converterspeciesType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}species_type'],
        )!,
      ),
      change: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}change'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      enteredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entered_at'],
      )!,
      correctsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corrects_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $StockEntriesTable createAlias(String alias) {
    return $StockEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SpeciesType, String, String> $converterspeciesType =
      const EnumNameConverter<SpeciesType>(SpeciesType.values);
}

class StockEntry extends DataClass implements Insertable<StockEntry> {
  final int id;
  final int tankId;
  final String speciesId;
  final SpeciesType speciesType;
  final int change;
  final DateTime occurredAt;
  final DateTime enteredAt;
  final int? correctsId;
  final String? note;
  const StockEntry({
    required this.id,
    required this.tankId,
    required this.speciesId,
    required this.speciesType,
    required this.change,
    required this.occurredAt,
    required this.enteredAt,
    this.correctsId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tank_id'] = Variable<int>(tankId);
    map['species_id'] = Variable<String>(speciesId);
    {
      map['species_type'] = Variable<String>(
        $StockEntriesTable.$converterspeciesType.toSql(speciesType),
      );
    }
    map['change'] = Variable<int>(change);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['entered_at'] = Variable<DateTime>(enteredAt);
    if (!nullToAbsent || correctsId != null) {
      map['corrects_id'] = Variable<int>(correctsId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  StockEntriesCompanion toCompanion(bool nullToAbsent) {
    return StockEntriesCompanion(
      id: Value(id),
      tankId: Value(tankId),
      speciesId: Value(speciesId),
      speciesType: Value(speciesType),
      change: Value(change),
      occurredAt: Value(occurredAt),
      enteredAt: Value(enteredAt),
      correctsId: correctsId == null && nullToAbsent
          ? const Value.absent()
          : Value(correctsId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory StockEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockEntry(
      id: serializer.fromJson<int>(json['id']),
      tankId: serializer.fromJson<int>(json['tankId']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      speciesType: $StockEntriesTable.$converterspeciesType.fromJson(
        serializer.fromJson<String>(json['speciesType']),
      ),
      change: serializer.fromJson<int>(json['change']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      enteredAt: serializer.fromJson<DateTime>(json['enteredAt']),
      correctsId: serializer.fromJson<int?>(json['correctsId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tankId': serializer.toJson<int>(tankId),
      'speciesId': serializer.toJson<String>(speciesId),
      'speciesType': serializer.toJson<String>(
        $StockEntriesTable.$converterspeciesType.toJson(speciesType),
      ),
      'change': serializer.toJson<int>(change),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'enteredAt': serializer.toJson<DateTime>(enteredAt),
      'correctsId': serializer.toJson<int?>(correctsId),
      'note': serializer.toJson<String?>(note),
    };
  }

  StockEntry copyWith({
    int? id,
    int? tankId,
    String? speciesId,
    SpeciesType? speciesType,
    int? change,
    DateTime? occurredAt,
    DateTime? enteredAt,
    Value<int?> correctsId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => StockEntry(
    id: id ?? this.id,
    tankId: tankId ?? this.tankId,
    speciesId: speciesId ?? this.speciesId,
    speciesType: speciesType ?? this.speciesType,
    change: change ?? this.change,
    occurredAt: occurredAt ?? this.occurredAt,
    enteredAt: enteredAt ?? this.enteredAt,
    correctsId: correctsId.present ? correctsId.value : this.correctsId,
    note: note.present ? note.value : this.note,
  );
  StockEntry copyWithCompanion(StockEntriesCompanion data) {
    return StockEntry(
      id: data.id.present ? data.id.value : this.id,
      tankId: data.tankId.present ? data.tankId.value : this.tankId,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      speciesType: data.speciesType.present
          ? data.speciesType.value
          : this.speciesType,
      change: data.change.present ? data.change.value : this.change,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      enteredAt: data.enteredAt.present ? data.enteredAt.value : this.enteredAt,
      correctsId: data.correctsId.present
          ? data.correctsId.value
          : this.correctsId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockEntry(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('speciesId: $speciesId, ')
          ..write('speciesType: $speciesType, ')
          ..write('change: $change, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('correctsId: $correctsId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tankId,
    speciesId,
    speciesType,
    change,
    occurredAt,
    enteredAt,
    correctsId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockEntry &&
          other.id == this.id &&
          other.tankId == this.tankId &&
          other.speciesId == this.speciesId &&
          other.speciesType == this.speciesType &&
          other.change == this.change &&
          other.occurredAt == this.occurredAt &&
          other.enteredAt == this.enteredAt &&
          other.correctsId == this.correctsId &&
          other.note == this.note);
}

class StockEntriesCompanion extends UpdateCompanion<StockEntry> {
  final Value<int> id;
  final Value<int> tankId;
  final Value<String> speciesId;
  final Value<SpeciesType> speciesType;
  final Value<int> change;
  final Value<DateTime> occurredAt;
  final Value<DateTime> enteredAt;
  final Value<int?> correctsId;
  final Value<String?> note;
  const StockEntriesCompanion({
    this.id = const Value.absent(),
    this.tankId = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.speciesType = const Value.absent(),
    this.change = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.enteredAt = const Value.absent(),
    this.correctsId = const Value.absent(),
    this.note = const Value.absent(),
  });
  StockEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int tankId,
    required String speciesId,
    required SpeciesType speciesType,
    required int change,
    required DateTime occurredAt,
    this.enteredAt = const Value.absent(),
    this.correctsId = const Value.absent(),
    this.note = const Value.absent(),
  }) : tankId = Value(tankId),
       speciesId = Value(speciesId),
       speciesType = Value(speciesType),
       change = Value(change),
       occurredAt = Value(occurredAt);
  static Insertable<StockEntry> custom({
    Expression<int>? id,
    Expression<int>? tankId,
    Expression<String>? speciesId,
    Expression<String>? speciesType,
    Expression<int>? change,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? enteredAt,
    Expression<int>? correctsId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tankId != null) 'tank_id': tankId,
      if (speciesId != null) 'species_id': speciesId,
      if (speciesType != null) 'species_type': speciesType,
      if (change != null) 'change': change,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (enteredAt != null) 'entered_at': enteredAt,
      if (correctsId != null) 'corrects_id': correctsId,
      if (note != null) 'note': note,
    });
  }

  StockEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? tankId,
    Value<String>? speciesId,
    Value<SpeciesType>? speciesType,
    Value<int>? change,
    Value<DateTime>? occurredAt,
    Value<DateTime>? enteredAt,
    Value<int?>? correctsId,
    Value<String?>? note,
  }) {
    return StockEntriesCompanion(
      id: id ?? this.id,
      tankId: tankId ?? this.tankId,
      speciesId: speciesId ?? this.speciesId,
      speciesType: speciesType ?? this.speciesType,
      change: change ?? this.change,
      occurredAt: occurredAt ?? this.occurredAt,
      enteredAt: enteredAt ?? this.enteredAt,
      correctsId: correctsId ?? this.correctsId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tankId.present) {
      map['tank_id'] = Variable<int>(tankId.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (speciesType.present) {
      map['species_type'] = Variable<String>(
        $StockEntriesTable.$converterspeciesType.toSql(speciesType.value),
      );
    }
    if (change.present) {
      map['change'] = Variable<int>(change.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (enteredAt.present) {
      map['entered_at'] = Variable<DateTime>(enteredAt.value);
    }
    if (correctsId.present) {
      map['corrects_id'] = Variable<int>(correctsId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockEntriesCompanion(')
          ..write('id: $id, ')
          ..write('tankId: $tankId, ')
          ..write('speciesId: $speciesId, ')
          ..write('speciesType: $speciesType, ')
          ..write('change: $change, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('correctsId: $correctsId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TanksTable tanks = $TanksTable(this);
  late final $TestKitsTable testKits = $TestKitsTable(this);
  late final $KitParametersTable kitParameters = $KitParametersTable(this);
  late final $ReadingsTable readings = $ReadingsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $StockEntriesTable stockEntries = $StockEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tanks,
    testKits,
    kitParameters,
    readings,
    events,
    reminders,
    stockEntries,
  ];
}

typedef $$TanksTableCreateCompanionBuilder = TanksCompanion Function({
  Value<int> id,
  required String name,
  required double volumeGal,
  required String substrateType,
  required bool hasSoil,
  required WaterSource waterSource,
  Value<double?> heaterWatts,
  Value<double?> lightWatts,
  Value<double?> lightHoursPerDay,
  Value<double?> roomTempF,
  Value<double?> targetTempF,
  Value<DateTime?> cycleStartedAt,
  required CycleMethod cycleMethod,
  Value<DateTime?> stockedAt,
  Value<bool> archived,
  Value<DateTime> createdAt,
  Value<LightLevel?> lightLevel,
  Value<bool> hasCo2,
  Value<double?> footprintLengthIn,
  Value<double?> footprintWidthIn,
});
typedef $$TanksTableUpdateCompanionBuilder = TanksCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> volumeGal,
  Value<String> substrateType,
  Value<bool> hasSoil,
  Value<WaterSource> waterSource,
  Value<double?> heaterWatts,
  Value<double?> lightWatts,
  Value<double?> lightHoursPerDay,
  Value<double?> roomTempF,
  Value<double?> targetTempF,
  Value<DateTime?> cycleStartedAt,
  Value<CycleMethod> cycleMethod,
  Value<DateTime?> stockedAt,
  Value<bool> archived,
  Value<DateTime> createdAt,
  Value<LightLevel?> lightLevel,
  Value<bool> hasCo2,
  Value<double?> footprintLengthIn,
  Value<double?> footprintWidthIn,
});

final class $$TanksTableReferences
    extends BaseReferences<_$AppDatabase, $TanksTable, Tank> {
  $$TanksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: 'tanks__id__readings__tank_id',
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.tankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'tanks__id__events__tank_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.tankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'tanks__id__reminders__tank_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.tankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockEntriesTable, List<StockEntry>>
  _stockEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockEntries,
    aliasName: 'tanks__id__stock_entries__tank_id',
  );

  $$StockEntriesTableProcessedTableManager get stockEntriesRefs {
    final manager = $$StockEntriesTableTableManager(
      $_db,
      $_db.stockEntries,
    ).filter((f) => f.tankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TanksTableFilterComposer extends Composer<_$AppDatabase, $TanksTable> {
  $$TanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumeGal => $composableBuilder(
    column: $table.volumeGal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get substrateType => $composableBuilder(
    column: $table.substrateType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSoil => $composableBuilder(
    column: $table.hasSoil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WaterSource, WaterSource, String>
  get waterSource => $composableBuilder(
    column: $table.waterSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get heaterWatts => $composableBuilder(
    column: $table.heaterWatts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lightWatts => $composableBuilder(
    column: $table.lightWatts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lightHoursPerDay => $composableBuilder(
    column: $table.lightHoursPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get roomTempF => $composableBuilder(
    column: $table.roomTempF,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetTempF => $composableBuilder(
    column: $table.targetTempF,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cycleStartedAt => $composableBuilder(
    column: $table.cycleStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CycleMethod, CycleMethod, String>
  get cycleMethod => $composableBuilder(
    column: $table.cycleMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get stockedAt => $composableBuilder(
    column: $table.stockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LightLevel?, LightLevel, String>
  get lightLevel => $composableBuilder(
    column: $table.lightLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get hasCo2 => $composableBuilder(
    column: $table.hasCo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get footprintLengthIn => $composableBuilder(
    column: $table.footprintLengthIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get footprintWidthIn => $composableBuilder(
    column: $table.footprintWidthIn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockEntriesRefs(
    Expression<bool> Function($$StockEntriesTableFilterComposer f) f,
  ) {
    final $$StockEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockEntries,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockEntriesTableFilterComposer(
            $db: $db,
            $table: $db.stockEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TanksTableOrderingComposer
    extends Composer<_$AppDatabase, $TanksTable> {
  $$TanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumeGal => $composableBuilder(
    column: $table.volumeGal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get substrateType => $composableBuilder(
    column: $table.substrateType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSoil => $composableBuilder(
    column: $table.hasSoil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterSource => $composableBuilder(
    column: $table.waterSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heaterWatts => $composableBuilder(
    column: $table.heaterWatts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lightWatts => $composableBuilder(
    column: $table.lightWatts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lightHoursPerDay => $composableBuilder(
    column: $table.lightHoursPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get roomTempF => $composableBuilder(
    column: $table.roomTempF,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetTempF => $composableBuilder(
    column: $table.targetTempF,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cycleStartedAt => $composableBuilder(
    column: $table.cycleStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleMethod => $composableBuilder(
    column: $table.cycleMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get stockedAt => $composableBuilder(
    column: $table.stockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lightLevel => $composableBuilder(
    column: $table.lightLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCo2 => $composableBuilder(
    column: $table.hasCo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get footprintLengthIn => $composableBuilder(
    column: $table.footprintLengthIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get footprintWidthIn => $composableBuilder(
    column: $table.footprintWidthIn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TanksTable> {
  $$TanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get volumeGal =>
      $composableBuilder(column: $table.volumeGal, builder: (column) => column);

  GeneratedColumn<String> get substrateType => $composableBuilder(
    column: $table.substrateType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSoil =>
      $composableBuilder(column: $table.hasSoil, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WaterSource, String> get waterSource =>
      $composableBuilder(
        column: $table.waterSource,
        builder: (column) => column,
      );

  GeneratedColumn<double> get heaterWatts => $composableBuilder(
    column: $table.heaterWatts,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lightWatts => $composableBuilder(
    column: $table.lightWatts,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lightHoursPerDay => $composableBuilder(
    column: $table.lightHoursPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get roomTempF =>
      $composableBuilder(column: $table.roomTempF, builder: (column) => column);

  GeneratedColumn<double> get targetTempF => $composableBuilder(
    column: $table.targetTempF,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cycleStartedAt => $composableBuilder(
    column: $table.cycleStartedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CycleMethod, String> get cycleMethod =>
      $composableBuilder(
        column: $table.cycleMethod,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get stockedAt =>
      $composableBuilder(column: $table.stockedAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LightLevel?, String> get lightLevel =>
      $composableBuilder(
        column: $table.lightLevel,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get hasCo2 =>
      $composableBuilder(column: $table.hasCo2, builder: (column) => column);

  GeneratedColumn<double> get footprintLengthIn => $composableBuilder(
    column: $table.footprintLengthIn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get footprintWidthIn => $composableBuilder(
    column: $table.footprintWidthIn,
    builder: (column) => column,
  );

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockEntriesRefs<T extends Object>(
    Expression<T> Function($$StockEntriesTableAnnotationComposer a) f,
  ) {
    final $$StockEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockEntries,
      getReferencedColumn: (t) => t.tankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TanksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TanksTable,
          Tank,
          $$TanksTableFilterComposer,
          $$TanksTableOrderingComposer,
          $$TanksTableAnnotationComposer,
          $$TanksTableCreateCompanionBuilder,
          $$TanksTableUpdateCompanionBuilder,
          (Tank, $$TanksTableReferences),
          Tank,
          PrefetchHooks Function({
            bool readingsRefs,
            bool eventsRefs,
            bool remindersRefs,
            bool stockEntriesRefs,
          })
        > {
  $$TanksTableTableManager(_$AppDatabase db, $TanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> volumeGal = const Value.absent(),
                Value<String> substrateType = const Value.absent(),
                Value<bool> hasSoil = const Value.absent(),
                Value<WaterSource> waterSource = const Value.absent(),
                Value<double?> heaterWatts = const Value.absent(),
                Value<double?> lightWatts = const Value.absent(),
                Value<double?> lightHoursPerDay = const Value.absent(),
                Value<double?> roomTempF = const Value.absent(),
                Value<double?> targetTempF = const Value.absent(),
                Value<DateTime?> cycleStartedAt = const Value.absent(),
                Value<CycleMethod> cycleMethod = const Value.absent(),
                Value<DateTime?> stockedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<LightLevel?> lightLevel = const Value.absent(),
                Value<bool> hasCo2 = const Value.absent(),
                Value<double?> footprintLengthIn = const Value.absent(),
                Value<double?> footprintWidthIn = const Value.absent(),
              }) => TanksCompanion(
                id: id,
                name: name,
                volumeGal: volumeGal,
                substrateType: substrateType,
                hasSoil: hasSoil,
                waterSource: waterSource,
                heaterWatts: heaterWatts,
                lightWatts: lightWatts,
                lightHoursPerDay: lightHoursPerDay,
                roomTempF: roomTempF,
                targetTempF: targetTempF,
                cycleStartedAt: cycleStartedAt,
                cycleMethod: cycleMethod,
                stockedAt: stockedAt,
                archived: archived,
                createdAt: createdAt,
                lightLevel: lightLevel,
                hasCo2: hasCo2,
                footprintLengthIn: footprintLengthIn,
                footprintWidthIn: footprintWidthIn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double volumeGal,
                required String substrateType,
                required bool hasSoil,
                required WaterSource waterSource,
                Value<double?> heaterWatts = const Value.absent(),
                Value<double?> lightWatts = const Value.absent(),
                Value<double?> lightHoursPerDay = const Value.absent(),
                Value<double?> roomTempF = const Value.absent(),
                Value<double?> targetTempF = const Value.absent(),
                Value<DateTime?> cycleStartedAt = const Value.absent(),
                required CycleMethod cycleMethod,
                Value<DateTime?> stockedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<LightLevel?> lightLevel = const Value.absent(),
                Value<bool> hasCo2 = const Value.absent(),
                Value<double?> footprintLengthIn = const Value.absent(),
                Value<double?> footprintWidthIn = const Value.absent(),
              }) => TanksCompanion.insert(
                id: id,
                name: name,
                volumeGal: volumeGal,
                substrateType: substrateType,
                hasSoil: hasSoil,
                waterSource: waterSource,
                heaterWatts: heaterWatts,
                lightWatts: lightWatts,
                lightHoursPerDay: lightHoursPerDay,
                roomTempF: roomTempF,
                targetTempF: targetTempF,
                cycleStartedAt: cycleStartedAt,
                cycleMethod: cycleMethod,
                stockedAt: stockedAt,
                archived: archived,
                createdAt: createdAt,
                lightLevel: lightLevel,
                hasCo2: hasCo2,
                footprintLengthIn: footprintLengthIn,
                footprintWidthIn: footprintWidthIn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TanksTable, Tank>(table),
                  $$TanksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                readingsRefs = false,
                eventsRefs = false,
                remindersRefs = false,
                stockEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingsRefs) db.readings,
                    if (eventsRefs) db.events,
                    if (remindersRefs) db.reminders,
                    if (stockEntriesRefs) db.stockEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingsRefs)
                        await $_getPrefetchedData<Tank, $TanksTable, Reading>(
                          currentTable: table,
                          referencedTable: $$TanksTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TanksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tankId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventsRefs)
                        await $_getPrefetchedData<Tank, $TanksTable, Event>(
                          currentTable: table,
                          referencedTable: $$TanksTableReferences
                              ._eventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TanksTableReferences(db, table, p0).eventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tankId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<Tank, $TanksTable, Reminder>(
                          currentTable: table,
                          referencedTable: $$TanksTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TanksTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tankId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockEntriesRefs)
                        await $_getPrefetchedData<
                          Tank,
                          $TanksTable,
                          StockEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TanksTableReferences
                              ._stockEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TanksTableReferences(
                                db,
                                table,
                                p0,
                              ).stockEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tankId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TanksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TanksTable,
      Tank,
      $$TanksTableFilterComposer,
      $$TanksTableOrderingComposer,
      $$TanksTableAnnotationComposer,
      $$TanksTableCreateCompanionBuilder,
      $$TanksTableUpdateCompanionBuilder,
      (Tank, $$TanksTableReferences),
      Tank,
      PrefetchHooks Function({
        bool readingsRefs,
        bool eventsRefs,
        bool remindersRefs,
        bool stockEntriesRefs,
      })
    >;
typedef $$TestKitsTableCreateCompanionBuilder = TestKitsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> brand,
  Value<DateTime> createdAt,
});
typedef $$TestKitsTableUpdateCompanionBuilder = TestKitsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> brand,
  Value<DateTime> createdAt,
});

final class $$TestKitsTableReferences
    extends BaseReferences<_$AppDatabase, $TestKitsTable, TestKit> {
  $$TestKitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KitParametersTable, List<KitParameter>>
  _kitParametersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.kitParameters,
    aliasName: 'test_kits__id__kit_parameters__kit_id',
  );

  $$KitParametersTableProcessedTableManager get kitParametersRefs {
    final manager = $$KitParametersTableTableManager(
      $_db,
      $_db.kitParameters,
    ).filter((f) => f.kitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kitParametersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingsTable, List<Reading>> _readingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.readings,
    aliasName: 'test_kits__id__readings__kit_id',
  );

  $$ReadingsTableProcessedTableManager get readingsRefs {
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.kitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TestKitsTableFilterComposer
    extends Composer<_$AppDatabase, $TestKitsTable> {
  $$TestKitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> kitParametersRefs(
    Expression<bool> Function($$KitParametersTableFilterComposer f) f,
  ) {
    final $$KitParametersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitParameters,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitParametersTableFilterComposer(
            $db: $db,
            $table: $db.kitParameters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingsRefs(
    Expression<bool> Function($$ReadingsTableFilterComposer f) f,
  ) {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TestKitsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestKitsTable> {
  $$TestKitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TestKitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestKitsTable> {
  $$TestKitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> kitParametersRefs<T extends Object>(
    Expression<T> Function($$KitParametersTableAnnotationComposer a) f,
  ) {
    final $$KitParametersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kitParameters,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KitParametersTableAnnotationComposer(
            $db: $db,
            $table: $db.kitParameters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingsRefs<T extends Object>(
    Expression<T> Function($$ReadingsTableAnnotationComposer a) f,
  ) {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.kitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TestKitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestKitsTable,
          TestKit,
          $$TestKitsTableFilterComposer,
          $$TestKitsTableOrderingComposer,
          $$TestKitsTableAnnotationComposer,
          $$TestKitsTableCreateCompanionBuilder,
          $$TestKitsTableUpdateCompanionBuilder,
          (TestKit, $$TestKitsTableReferences),
          TestKit,
          PrefetchHooks Function({bool kitParametersRefs, bool readingsRefs})
        > {
  $$TestKitsTableTableManager(_$AppDatabase db, $TestKitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestKitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestKitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestKitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TestKitsCompanion(
                id: id,
                name: name,
                brand: brand,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TestKitsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TestKitsTable, TestKit>(table),
                  $$TestKitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({kitParametersRefs = false, readingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (kitParametersRefs) db.kitParameters,
                    if (readingsRefs) db.readings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (kitParametersRefs)
                        await $_getPrefetchedData<
                          TestKit,
                          $TestKitsTable,
                          KitParameter
                        >(
                          currentTable: table,
                          referencedTable: $$TestKitsTableReferences
                              ._kitParametersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TestKitsTableReferences(
                                db,
                                table,
                                p0,
                              ).kitParametersRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.kitId == item.id),
                          typedResults: items,
                        ),
                      if (readingsRefs)
                        await $_getPrefetchedData<
                          TestKit,
                          $TestKitsTable,
                          Reading
                        >(
                          currentTable: table,
                          referencedTable: $$TestKitsTableReferences
                              ._readingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TestKitsTableReferences(
                                db,
                                table,
                                p0,
                              ).readingsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.kitId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TestKitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestKitsTable,
      TestKit,
      $$TestKitsTableFilterComposer,
      $$TestKitsTableOrderingComposer,
      $$TestKitsTableAnnotationComposer,
      $$TestKitsTableCreateCompanionBuilder,
      $$TestKitsTableUpdateCompanionBuilder,
      (TestKit, $$TestKitsTableReferences),
      TestKit,
      PrefetchHooks Function({bool kitParametersRefs, bool readingsRefs})
    >;
typedef $$KitParametersTableCreateCompanionBuilder =
    KitParametersCompanion Function({
      Value<int> id,
      required int kitId,
      required Parameter parameter,
      required InputMode inputMode,
      Value<List<double>?> stepsJson,
      required String unit,
    });
typedef $$KitParametersTableUpdateCompanionBuilder =
    KitParametersCompanion Function({
      Value<int> id,
      Value<int> kitId,
      Value<Parameter> parameter,
      Value<InputMode> inputMode,
      Value<List<double>?> stepsJson,
      Value<String> unit,
    });

final class $$KitParametersTableReferences
    extends BaseReferences<_$AppDatabase, $KitParametersTable, KitParameter> {
  $$KitParametersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TestKitsTable _kitIdTable(_$AppDatabase db) =>
      db.testKits.createAlias('kit_parameters__kit_id__test_kits__id');

  $$TestKitsTableProcessedTableManager get kitId {
    final $_column = $_itemColumn<int>('kit_id')!;

    final manager = $$TestKitsTableTableManager(
      $_db,
      $_db.testKits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KitParametersTableFilterComposer
    extends Composer<_$AppDatabase, $KitParametersTable> {
  $$KitParametersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Parameter, Parameter, String> get parameter =>
      $composableBuilder(
        column: $table.parameter,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<InputMode, InputMode, String> get inputMode =>
      $composableBuilder(
        column: $table.inputMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<double>?, List<double>, String>
  get stepsJson => $composableBuilder(
    column: $table.stepsJson,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  $$TestKitsTableFilterComposer get kitId {
    final $$TestKitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.testKits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestKitsTableFilterComposer(
            $db: $db,
            $table: $db.testKits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitParametersTableOrderingComposer
    extends Composer<_$AppDatabase, $KitParametersTable> {
  $$KitParametersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parameter => $composableBuilder(
    column: $table.parameter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputMode => $composableBuilder(
    column: $table.inputMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepsJson => $composableBuilder(
    column: $table.stepsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  $$TestKitsTableOrderingComposer get kitId {
    final $$TestKitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.testKits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestKitsTableOrderingComposer(
            $db: $db,
            $table: $db.testKits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitParametersTableAnnotationComposer
    extends Composer<_$AppDatabase, $KitParametersTable> {
  $$KitParametersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Parameter, String> get parameter =>
      $composableBuilder(column: $table.parameter, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InputMode, String> get inputMode =>
      $composableBuilder(column: $table.inputMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<double>?, String> get stepsJson =>
      $composableBuilder(column: $table.stepsJson, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$TestKitsTableAnnotationComposer get kitId {
    final $$TestKitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.testKits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestKitsTableAnnotationComposer(
            $db: $db,
            $table: $db.testKits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KitParametersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KitParametersTable,
          KitParameter,
          $$KitParametersTableFilterComposer,
          $$KitParametersTableOrderingComposer,
          $$KitParametersTableAnnotationComposer,
          $$KitParametersTableCreateCompanionBuilder,
          $$KitParametersTableUpdateCompanionBuilder,
          (KitParameter, $$KitParametersTableReferences),
          KitParameter,
          PrefetchHooks Function({bool kitId})
        > {
  $$KitParametersTableTableManager(_$AppDatabase db, $KitParametersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KitParametersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KitParametersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KitParametersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> kitId = const Value.absent(),
                Value<Parameter> parameter = const Value.absent(),
                Value<InputMode> inputMode = const Value.absent(),
                Value<List<double>?> stepsJson = const Value.absent(),
                Value<String> unit = const Value.absent(),
              }) => KitParametersCompanion(
                id: id,
                kitId: kitId,
                parameter: parameter,
                inputMode: inputMode,
                stepsJson: stepsJson,
                unit: unit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int kitId,
                required Parameter parameter,
                required InputMode inputMode,
                Value<List<double>?> stepsJson = const Value.absent(),
                required String unit,
              }) => KitParametersCompanion.insert(
                id: id,
                kitId: kitId,
                parameter: parameter,
                inputMode: inputMode,
                stepsJson: stepsJson,
                unit: unit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KitParametersTable, KitParameter>(table),
                  $$KitParametersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({kitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (kitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.kitId,
                        referencedTable: $$KitParametersTableReferences
                            ._kitIdTable(db),
                        referencedColumn: $$KitParametersTableReferences
                            ._kitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KitParametersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KitParametersTable,
      KitParameter,
      $$KitParametersTableFilterComposer,
      $$KitParametersTableOrderingComposer,
      $$KitParametersTableAnnotationComposer,
      $$KitParametersTableCreateCompanionBuilder,
      $$KitParametersTableUpdateCompanionBuilder,
      (KitParameter, $$KitParametersTableReferences),
      KitParameter,
      PrefetchHooks Function({bool kitId})
    >;
typedef $$ReadingsTableCreateCompanionBuilder = ReadingsCompanion Function({
  Value<int> id,
  required int tankId,
  Value<int?> kitId,
  required Parameter parameter,
  required double value,
  required String unit,
  required DateTime takenAt,
  Value<DateTime> enteredAt,
  Value<int?> correctsId,
  Value<String?> note,
});
typedef $$ReadingsTableUpdateCompanionBuilder = ReadingsCompanion Function({
  Value<int> id,
  Value<int> tankId,
  Value<int?> kitId,
  Value<Parameter> parameter,
  Value<double> value,
  Value<String> unit,
  Value<DateTime> takenAt,
  Value<DateTime> enteredAt,
  Value<int?> correctsId,
  Value<String?> note,
});

final class $$ReadingsTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingsTable, Reading> {
  $$ReadingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TanksTable _tankIdTable(_$AppDatabase db) =>
      db.tanks.createAlias('readings__tank_id__tanks__id');

  $$TanksTableProcessedTableManager get tankId {
    final $_column = $_itemColumn<int>('tank_id')!;

    final manager = $$TanksTableTableManager(
      $_db,
      $_db.tanks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TestKitsTable _kitIdTable(_$AppDatabase db) =>
      db.testKits.createAlias('readings__kit_id__test_kits__id');

  $$TestKitsTableProcessedTableManager? get kitId {
    final $_column = $_itemColumn<int>('kit_id');
    if ($_column == null) return null;
    final manager = $$TestKitsTableTableManager(
      $_db,
      $_db.testKits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReadingsTable _correctsIdTable(_$AppDatabase db) =>
      db.readings.createAlias('readings__corrects_id__readings__id');

  $$ReadingsTableProcessedTableManager? get correctsId {
    final $_column = $_itemColumn<int>('corrects_id');
    if ($_column == null) return null;
    final manager = $$ReadingsTableTableManager(
      $_db,
      $_db.readings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_correctsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Parameter, Parameter, String> get parameter =>
      $composableBuilder(
        column: $table.parameter,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$TanksTableFilterComposer get tankId {
    final $$TanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableFilterComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TestKitsTableFilterComposer get kitId {
    final $$TestKitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.testKits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestKitsTableFilterComposer(
            $db: $db,
            $table: $db.testKits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingsTableFilterComposer get correctsId {
    final $$ReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableFilterComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parameter => $composableBuilder(
    column: $table.parameter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$TanksTableOrderingComposer get tankId {
    final $$TanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableOrderingComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TestKitsTableOrderingComposer get kitId {
    final $$TestKitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.testKits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestKitsTableOrderingComposer(
            $db: $db,
            $table: $db.testKits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingsTableOrderingComposer get correctsId {
    final $$ReadingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableOrderingComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Parameter, String> get parameter =>
      $composableBuilder(column: $table.parameter, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get enteredAt =>
      $composableBuilder(column: $table.enteredAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$TanksTableAnnotationComposer get tankId {
    final $$TanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableAnnotationComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TestKitsTableAnnotationComposer get kitId {
    final $$TestKitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kitId,
      referencedTable: $db.testKits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TestKitsTableAnnotationComposer(
            $db: $db,
            $table: $db.testKits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingsTableAnnotationComposer get correctsId {
    final $$ReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.readings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.readings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingsTable,
          Reading,
          $$ReadingsTableFilterComposer,
          $$ReadingsTableOrderingComposer,
          $$ReadingsTableAnnotationComposer,
          $$ReadingsTableCreateCompanionBuilder,
          $$ReadingsTableUpdateCompanionBuilder,
          (Reading, $$ReadingsTableReferences),
          Reading,
          PrefetchHooks Function({bool tankId, bool kitId, bool correctsId})
        > {
  $$ReadingsTableTableManager(_$AppDatabase db, $ReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tankId = const Value.absent(),
                Value<int?> kitId = const Value.absent(),
                Value<Parameter> parameter = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<DateTime> enteredAt = const Value.absent(),
                Value<int?> correctsId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                tankId: tankId,
                kitId: kitId,
                parameter: parameter,
                value: value,
                unit: unit,
                takenAt: takenAt,
                enteredAt: enteredAt,
                correctsId: correctsId,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tankId,
                Value<int?> kitId = const Value.absent(),
                required Parameter parameter,
                required double value,
                required String unit,
                required DateTime takenAt,
                Value<DateTime> enteredAt = const Value.absent(),
                Value<int?> correctsId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => ReadingsCompanion.insert(
                id: id,
                tankId: tankId,
                kitId: kitId,
                parameter: parameter,
                value: value,
                unit: unit,
                takenAt: takenAt,
                enteredAt: enteredAt,
                correctsId: correctsId,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingsTable, Reading>(table),
                  $$ReadingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tankId = false, kitId = false, correctsId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tankId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tankId,
                            referencedTable: $$ReadingsTableReferences
                                ._tankIdTable(db),
                            referencedColumn: $$ReadingsTableReferences
                                ._tankIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (kitId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.kitId,
                            referencedTable: $$ReadingsTableReferences
                                ._kitIdTable(db),
                            referencedColumn: $$ReadingsTableReferences
                                ._kitIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (correctsId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.correctsId,
                            referencedTable: $$ReadingsTableReferences
                                ._correctsIdTable(db),
                            referencedColumn: $$ReadingsTableReferences
                                ._correctsIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingsTable,
      Reading,
      $$ReadingsTableFilterComposer,
      $$ReadingsTableOrderingComposer,
      $$ReadingsTableAnnotationComposer,
      $$ReadingsTableCreateCompanionBuilder,
      $$ReadingsTableUpdateCompanionBuilder,
      (Reading, $$ReadingsTableReferences),
      Reading,
      PrefetchHooks Function({bool tankId, bool kitId, bool correctsId})
    >;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required int tankId,
  required EventType type,
  Value<String?> product,
  Value<double?> amount,
  Value<String?> amountUnit,
  Value<double?> percentChanged,
  required DateTime occurredAt,
  Value<DateTime> enteredAt,
  Value<int?> correctsId,
  Value<String?> note,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<int> tankId,
  Value<EventType> type,
  Value<String?> product,
  Value<double?> amount,
  Value<String?> amountUnit,
  Value<double?> percentChanged,
  Value<DateTime> occurredAt,
  Value<DateTime> enteredAt,
  Value<int?> correctsId,
  Value<String?> note,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TanksTable _tankIdTable(_$AppDatabase db) =>
      db.tanks.createAlias('events__tank_id__tanks__id');

  $$TanksTableProcessedTableManager get tankId {
    final $_column = $_itemColumn<int>('tank_id')!;

    final manager = $$TanksTableTableManager(
      $_db,
      $_db.tanks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EventsTable _correctsIdTable(_$AppDatabase db) =>
      db.events.createAlias('events__corrects_id__events__id');

  $$EventsTableProcessedTableManager? get correctsId {
    final $_column = $_itemColumn<int>('corrects_id');
    if ($_column == null) return null;
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_correctsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EventType, EventType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentChanged => $composableBuilder(
    column: $table.percentChanged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$TanksTableFilterComposer get tankId {
    final $$TanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableFilterComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EventsTableFilterComposer get correctsId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentChanged => $composableBuilder(
    column: $table.percentChanged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$TanksTableOrderingComposer get tankId {
    final $$TanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableOrderingComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EventsTableOrderingComposer get correctsId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EventType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get percentChanged => $composableBuilder(
    column: $table.percentChanged,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get enteredAt =>
      $composableBuilder(column: $table.enteredAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$TanksTableAnnotationComposer get tankId {
    final $$TanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableAnnotationComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EventsTableAnnotationComposer get correctsId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({bool tankId, bool correctsId})
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tankId = const Value.absent(),
                Value<EventType> type = const Value.absent(),
                Value<String?> product = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> amountUnit = const Value.absent(),
                Value<double?> percentChanged = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> enteredAt = const Value.absent(),
                Value<int?> correctsId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                tankId: tankId,
                type: type,
                product: product,
                amount: amount,
                amountUnit: amountUnit,
                percentChanged: percentChanged,
                occurredAt: occurredAt,
                enteredAt: enteredAt,
                correctsId: correctsId,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tankId,
                required EventType type,
                Value<String?> product = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> amountUnit = const Value.absent(),
                Value<double?> percentChanged = const Value.absent(),
                required DateTime occurredAt,
                Value<DateTime> enteredAt = const Value.absent(),
                Value<int?> correctsId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                tankId: tankId,
                type: type,
                product: product,
                amount: amount,
                amountUnit: amountUnit,
                percentChanged: percentChanged,
                occurredAt: occurredAt,
                enteredAt: enteredAt,
                correctsId: correctsId,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventsTable, Event>(table),
                  $$EventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tankId = false, correctsId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tankId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tankId,
                        referencedTable: $$EventsTableReferences._tankIdTable(
                          db,
                        ),
                        referencedColumn: $$EventsTableReferences
                            ._tankIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (correctsId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.correctsId,
                        referencedTable: $$EventsTableReferences
                            ._correctsIdTable(db),
                        referencedColumn: $$EventsTableReferences
                            ._correctsIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({bool tankId, bool correctsId})
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  required int tankId,
  required int everyNDays,
  required String timeOfDay,
  Value<bool> enabled,
  Value<DateTime?> lastFiredAt,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int> tankId,
  Value<int> everyNDays,
  Value<String> timeOfDay,
  Value<bool> enabled,
  Value<DateTime?> lastFiredAt,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TanksTable _tankIdTable(_$AppDatabase db) =>
      db.tanks.createAlias('reminders__tank_id__tanks__id');

  $$TanksTableProcessedTableManager get tankId {
    final $_column = $_itemColumn<int>('tank_id')!;

    final manager = $$TanksTableTableManager(
      $_db,
      $_db.tanks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get everyNDays => $composableBuilder(
    column: $table.everyNDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFiredAt => $composableBuilder(
    column: $table.lastFiredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TanksTableFilterComposer get tankId {
    final $$TanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableFilterComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get everyNDays => $composableBuilder(
    column: $table.everyNDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFiredAt => $composableBuilder(
    column: $table.lastFiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TanksTableOrderingComposer get tankId {
    final $$TanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableOrderingComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get everyNDays => $composableBuilder(
    column: $table.everyNDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFiredAt => $composableBuilder(
    column: $table.lastFiredAt,
    builder: (column) => column,
  );

  $$TanksTableAnnotationComposer get tankId {
    final $$TanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableAnnotationComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool tankId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tankId = const Value.absent(),
                Value<int> everyNDays = const Value.absent(),
                Value<String> timeOfDay = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime?> lastFiredAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                tankId: tankId,
                everyNDays: everyNDays,
                timeOfDay: timeOfDay,
                enabled: enabled,
                lastFiredAt: lastFiredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tankId,
                required int everyNDays,
                required String timeOfDay,
                Value<bool> enabled = const Value.absent(),
                Value<DateTime?> lastFiredAt = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                tankId: tankId,
                everyNDays: everyNDays,
                timeOfDay: timeOfDay,
                enabled: enabled,
                lastFiredAt: lastFiredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tankId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tankId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tankId,
                        referencedTable: $$RemindersTableReferences
                            ._tankIdTable(db),
                        referencedColumn: $$RemindersTableReferences
                            ._tankIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool tankId})
    >;
typedef $$StockEntriesTableCreateCompanionBuilder =
    StockEntriesCompanion Function({
      Value<int> id,
      required int tankId,
      required String speciesId,
      required SpeciesType speciesType,
      required int change,
      required DateTime occurredAt,
      Value<DateTime> enteredAt,
      Value<int?> correctsId,
      Value<String?> note,
    });
typedef $$StockEntriesTableUpdateCompanionBuilder =
    StockEntriesCompanion Function({
      Value<int> id,
      Value<int> tankId,
      Value<String> speciesId,
      Value<SpeciesType> speciesType,
      Value<int> change,
      Value<DateTime> occurredAt,
      Value<DateTime> enteredAt,
      Value<int?> correctsId,
      Value<String?> note,
    });

final class $$StockEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $StockEntriesTable, StockEntry> {
  $$StockEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TanksTable _tankIdTable(_$AppDatabase db) =>
      db.tanks.createAlias('stock_entries__tank_id__tanks__id');

  $$TanksTableProcessedTableManager get tankId {
    final $_column = $_itemColumn<int>('tank_id')!;

    final manager = $$TanksTableTableManager(
      $_db,
      $_db.tanks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StockEntriesTable _correctsIdTable(_$AppDatabase db) => db
      .stockEntries
      .createAlias('stock_entries__corrects_id__stock_entries__id');

  $$StockEntriesTableProcessedTableManager? get correctsId {
    final $_column = $_itemColumn<int>('corrects_id');
    if ($_column == null) return null;
    final manager = $$StockEntriesTableTableManager(
      $_db,
      $_db.stockEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_correctsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $StockEntriesTable> {
  $$StockEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SpeciesType, SpeciesType, String>
  get speciesType => $composableBuilder(
    column: $table.speciesType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$TanksTableFilterComposer get tankId {
    final $$TanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableFilterComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StockEntriesTableFilterComposer get correctsId {
    final $$StockEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.stockEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockEntriesTableFilterComposer(
            $db: $db,
            $table: $db.stockEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockEntriesTable> {
  $$StockEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciesType => $composableBuilder(
    column: $table.speciesType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$TanksTableOrderingComposer get tankId {
    final $$TanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableOrderingComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StockEntriesTableOrderingComposer get correctsId {
    final $$StockEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.stockEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.stockEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockEntriesTable> {
  $$StockEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpeciesType, String> get speciesType =>
      $composableBuilder(
        column: $table.speciesType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get enteredAt =>
      $composableBuilder(column: $table.enteredAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$TanksTableAnnotationComposer get tankId {
    final $$TanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tankId,
      referencedTable: $db.tanks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TanksTableAnnotationComposer(
            $db: $db,
            $table: $db.tanks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StockEntriesTableAnnotationComposer get correctsId {
    final $$StockEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.correctsId,
      referencedTable: $db.stockEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockEntriesTable,
          StockEntry,
          $$StockEntriesTableFilterComposer,
          $$StockEntriesTableOrderingComposer,
          $$StockEntriesTableAnnotationComposer,
          $$StockEntriesTableCreateCompanionBuilder,
          $$StockEntriesTableUpdateCompanionBuilder,
          (StockEntry, $$StockEntriesTableReferences),
          StockEntry,
          PrefetchHooks Function({bool tankId, bool correctsId})
        > {
  $$StockEntriesTableTableManager(_$AppDatabase db, $StockEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tankId = const Value.absent(),
                Value<String> speciesId = const Value.absent(),
                Value<SpeciesType> speciesType = const Value.absent(),
                Value<int> change = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> enteredAt = const Value.absent(),
                Value<int?> correctsId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => StockEntriesCompanion(
                id: id,
                tankId: tankId,
                speciesId: speciesId,
                speciesType: speciesType,
                change: change,
                occurredAt: occurredAt,
                enteredAt: enteredAt,
                correctsId: correctsId,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tankId,
                required String speciesId,
                required SpeciesType speciesType,
                required int change,
                required DateTime occurredAt,
                Value<DateTime> enteredAt = const Value.absent(),
                Value<int?> correctsId = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => StockEntriesCompanion.insert(
                id: id,
                tankId: tankId,
                speciesId: speciesId,
                speciesType: speciesType,
                change: change,
                occurredAt: occurredAt,
                enteredAt: enteredAt,
                correctsId: correctsId,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockEntriesTable, StockEntry>(table),
                  $$StockEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tankId = false, correctsId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tankId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tankId,
                        referencedTable: $$StockEntriesTableReferences
                            ._tankIdTable(db),
                        referencedColumn: $$StockEntriesTableReferences
                            ._tankIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (correctsId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.correctsId,
                        referencedTable: $$StockEntriesTableReferences
                            ._correctsIdTable(db),
                        referencedColumn: $$StockEntriesTableReferences
                            ._correctsIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockEntriesTable,
      StockEntry,
      $$StockEntriesTableFilterComposer,
      $$StockEntriesTableOrderingComposer,
      $$StockEntriesTableAnnotationComposer,
      $$StockEntriesTableCreateCompanionBuilder,
      $$StockEntriesTableUpdateCompanionBuilder,
      (StockEntry, $$StockEntriesTableReferences),
      StockEntry,
      PrefetchHooks Function({bool tankId, bool correctsId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TanksTableTableManager get tanks =>
      $$TanksTableTableManager(_db, _db.tanks);
  $$TestKitsTableTableManager get testKits =>
      $$TestKitsTableTableManager(_db, _db.testKits);
  $$KitParametersTableTableManager get kitParameters =>
      $$KitParametersTableTableManager(_db, _db.kitParameters);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$StockEntriesTableTableManager get stockEntries =>
      $$StockEntriesTableTableManager(_db, _db.stockEntries);
}
