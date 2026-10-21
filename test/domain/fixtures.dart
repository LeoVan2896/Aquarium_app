import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/models.dart';

final start = DateTime.utc(2026, 10, 1, 9);

DateTime day(int d, [int hours = 0]) =>
    start.add(Duration(days: d, hours: hours));

var _nextId = 0;

LoggedReading reading(
  Parameter parameter,
  double value,
  DateTime takenAt, {
  String unit = 'ppm',
  int? correctsId,
}) => LoggedReading(
  id: ++_nextId,
  parameter: parameter,
  value: value,
  unit: unit,
  takenAt: takenAt,
  correctsId: correctsId,
);

LoggedEvent ammoniaDose(DateTime at) =>
    LoggedEvent(id: ++_nextId, type: EventType.ammoniaDose, occurredAt: at);

List<LoggedReading> pair(double ammonia, double nitrite, DateTime at) => [
  reading(Parameter.ammonia, ammonia, at),
  reading(Parameter.nitrite, nitrite, at),
];

TankProfile tank({
  bool hasSoil = false,
  CycleMethod method = CycleMethod.fishless,
  DateTime? cycleStartedAt,
  DateTime? stockedAt,
}) => TankProfile(
  hasSoil: hasSoil,
  cycleMethod: method,
  cycleStartedAt: cycleStartedAt ?? start,
  stockedAt: stockedAt,
);
