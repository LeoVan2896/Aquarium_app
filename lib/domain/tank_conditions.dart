import 'config.dart';
import 'cycle_engine.dart';
import 'enums.dart';
import 'models.dart';
import 'species.dart';
import 'units.dart';

class TankSetup {
  const TankSetup({
    required this.volumeGal,
    this.lengthIn,
    this.widthIn,
    this.hasSoil = false,
    this.sandSubstrate = false,
    this.usesRootTabs = false,
    this.lightLevel,
    this.hasCo2 = false,
    this.targetTempF,
    this.roomTempF,
  });

  final double volumeGal;
  final double? lengthIn;
  final double? widthIn;
  final bool hasSoil;
  final bool sandSubstrate;
  final bool usesRootTabs;
  final LightLevel? lightLevel;
  final bool hasCo2;
  final double? targetTempF;
  final double? roomTempF;
}

enum ConditionSource { reading, targetTemp, roomTemp }

// Values are °F, pH, dGH or dKH.
class Condition {
  const Condition(this.value, this.source, [this.takenAt]);

  final double value;
  final ConditionSource source;
  final DateTime? takenAt;
}

class TankConditions {
  const TankConditions({this.tempF, this.ph, this.gh, this.kh});

  final Condition? tempF;
  final Condition? ph;
  final Condition? gh;
  final Condition? kh;
}

TankConditions tankConditions({
  required TankSetup setup,
  required Iterable<LoggedReading> readings,
  required DateTime now,
  DomainConfig config = const DomainConfig(),
}) {
  final effective = effectiveOnly(readings);
  final freshFrom = addDays(now, -config.conditionsMaxAgeDays.value);

  Condition? fresh(Parameter parameter, double Function(LoggedReading) value) {
    final r = _latest(effective, parameter);
    if (r == null || r.takenAt.isBefore(freshFrom)) return null;
    return Condition(value(r), ConditionSource.reading, r.takenAt);
  }

  final tempReading = _latest(effective, Parameter.temperature);
  return TankConditions(
    tempF: tempReading != null
        ? Condition(
            tempReading.value,
            ConditionSource.reading,
            tempReading.takenAt,
          )
        : setup.targetTempF != null
        ? Condition(setup.targetTempF!, ConditionSource.targetTemp)
        : setup.roomTempF != null
        ? Condition(setup.roomTempF!, ConditionSource.roomTemp)
        : null,
    ph: fresh(Parameter.ph, (r) => r.value),
    gh: fresh(Parameter.gh, (r) => r.ppm / ppmPerDegree),
    kh: fresh(Parameter.kh, (r) => r.ppm / ppmPerDegree),
  );
}

// Fish-in tanks are stocked from the start, so only fishless tanks wait.
bool fishGated(CycleMethod method, CycleStage stage) =>
    method == CycleMethod.fishless && stage != CycleStage.readyToStock;

class Maturity {
  const Maturity({this.readyAt, this.establishedAt});

  final DateTime? readyAt;
  final DateTime? establishedAt;

  bool isEstablished(DateTime now) =>
      establishedAt != null && !now.isBefore(establishedAt!);
}

// A tank is established once it has stayed cycled for maturityFactor × the time
// the cycle took, so a slow cycle means a longer wait.
Maturity tankMaturity({
  required TankProfile tank,
  required Iterable<LoggedReading> readings,
  required Iterable<LoggedEvent> events,
  DomainConfig config = const DomainConfig(),
}) {
  final start = tank.cycleStartedAt;
  if (start == null) return const Maturity();
  final readyAt = _firstReadyAt(tank, readings, events, config);
  if (readyAt == null) return const Maturity();
  final cycleDays = readyAt.difference(start).inDays;
  return Maturity(
    readyAt: readyAt,
    establishedAt: addDays(
      readyAt,
      (cycleDays * config.maturityFactor.value).ceil(),
    ),
  );
}

// Stage is derived, never stored, so replay the log to find when it first
// reached readyToStock.
DateTime? _firstReadyAt(
  TankProfile tank,
  Iterable<LoggedReading> readings,
  Iterable<LoggedEvent> events,
  DomainConfig config,
) {
  final allReadings = readings.toList();
  final allEvents = events.toList();
  final times = {
    for (final r in allReadings) r.takenAt,
    for (final e in allEvents) e.occurredAt,
  }.toList()..sort();
  for (final t in times) {
    final status = evaluateCycle(
      tank: tank,
      readings: allReadings.where((r) => !r.takenAt.isAfter(t)),
      events: allEvents.where((e) => !e.occurredAt.isAfter(t)),
      now: t,
      config: config,
    );
    if (status.stage == CycleStage.readyToStock) return t;
  }
  return null;
}

LoggedReading? _latest(List<LoggedReading> readings, Parameter parameter) {
  LoggedReading? latest;
  for (final r in readings) {
    if (r.parameter == parameter &&
        (latest == null || r.takenAt.isAfter(latest.takenAt))) {
      latest = r;
    }
  }
  return latest;
}
