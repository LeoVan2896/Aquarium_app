import 'config.dart';
import 'enums.dart';
import 'models.dart';
import 'units.dart';

enum CycleStage {
  notStarted,
  ammoniaPhase,
  nitritePhase,
  doseTest,
  cycled,
  readyToStock,
}

enum DoseTestResult { pass, fail, pending, missed }

class DoseTest {
  const DoseTest(this.dose, this.result);

  final LoggedEvent dose;
  final DoseTestResult result;
}

class CycleStatus {
  const CycleStatus({
    required this.stage,
    required this.reason,
    required this.nextStep,
    this.warnings = const [],
    this.passStreak = 0,
    this.doseTests = const [],
  });

  final CycleStage stage;
  final String reason;
  final String nextStep;
  final List<String> warnings;
  final int passStreak;
  final List<DoseTest> doseTests;
}

const soilLeachMessage = 'Soil tanks often leach ammonia early — keep testing';

class CycleLog {
  CycleLog({
    required DateTime start,
    required Iterable<LoggedReading> readings,
    required Iterable<LoggedEvent> events,
    required this.config,
  }) : readings =
           effectiveOnly(readings)
               .where((r) => !r.takenAt.isBefore(start))
               .toList()
             ..sort((a, b) => a.takenAt.compareTo(b.takenAt)),
       doses =
           effectiveOnly(events)
               .where(
                 (e) =>
                     e.type == EventType.ammoniaDose &&
                     !e.occurredAt.isBefore(start),
               )
               .toList()
             ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

  final DomainConfig config;
  final List<LoggedReading> readings;
  final List<LoggedEvent> doses;

  Duration get _windowStart =>
      Duration(hours: config.doseWindowStartHours.value);
  Duration get _windowEnd => Duration(hours: config.doseWindowEndHours.value);

  // Ammonia is expected to be high right after a dose; those readings say nothing about the cycle.
  bool _inDoseSpike(DateTime t) => doses.any(
    (d) =>
        !t.isBefore(d.occurredAt) && t.isBefore(d.occurredAt.add(_windowStart)),
  );

  LoggedReading? latest(Parameter parameter) {
    for (final r in readings.reversed) {
      if (r.parameter == parameter && !_inDoseSpike(r.takenAt)) return r;
    }
    return null;
  }

  bool get nitriteSeen =>
      readings.any((r) => r.parameter == Parameter.nitrite && r.value > 0);

  List<DoseTest> doseTests(DateTime now) => [
    for (final d in doses) _evaluateDose(d, now),
  ];

  DoseTest _evaluateDose(LoggedEvent dose, DateTime now) {
    final from = dose.occurredAt.add(_windowStart);
    final to = dose.occurredAt.add(_windowEnd);

    LoggedReading? lastInWindow(Parameter parameter) {
      for (final r in readings.reversed) {
        if (r.parameter == parameter &&
            !r.takenAt.isBefore(from) &&
            !r.takenAt.isAfter(to)) {
          return r;
        }
      }
      return null;
    }

    final ammonia = lastInWindow(Parameter.ammonia);
    final nitrite = lastInWindow(Parameter.nitrite);

    final DoseTestResult result;
    if ((ammonia?.value ?? 0) > 0 || (nitrite?.value ?? 0) > 0) {
      result = DoseTestResult.fail;
    } else if (ammonia != null && nitrite != null) {
      result = DoseTestResult.pass;
    } else if (now.isBefore(to)) {
      result = DoseTestResult.pending;
    } else {
      result = DoseTestResult.missed;
    }
    return DoseTest(dose, result);
  }
}

int passStreak(List<DoseTest> tests) {
  var streak = 0;
  for (final t in tests.reversed) {
    if (t.result == DoseTestResult.fail) return streak;
    if (t.result == DoseTestResult.pass) streak++;
  }
  return streak;
}

CycleStatus evaluateCycle({
  required TankProfile tank,
  required Iterable<LoggedReading> readings,
  required Iterable<LoggedEvent> events,
  required DateTime now,
  DomainConfig config = const DomainConfig(),
}) {
  final start = tank.cycleStartedAt;
  if (start == null) {
    return const CycleStatus(
      stage: CycleStage.notStarted,
      reason: 'No cycle start date yet.',
      nextStep: 'Set the day you started cycling this tank.',
    );
  }

  final log = CycleLog(
    start: start,
    readings: readings,
    events: events,
    config: config,
  );
  final ammonia = log.latest(Parameter.ammonia);
  final nitrite = log.latest(Parameter.nitrite);
  final fishIn = tank.cycleMethod == CycleMethod.fishIn;
  final soilHold =
      tank.hasSoil && now.isBefore(addDays(start, config.soilMinDays.value));
  final warnings = fishIn
      ? _fishInWarnings(tank, start, ammonia, nitrite, now, config)
      : const <String>[];

  if (!log.nitriteSeen) {
    return CycleStatus(
      stage: CycleStage.ammoniaPhase,
      reason: switch (ammonia) {
        null => 'No ammonia reading since the cycle started.',
        LoggedReading(:final value) when value > 0 =>
          "Ammonia is ${formatNumber(value)} ppm. Nitrite hasn't shown up yet.",
        _ => "Ammonia reads 0 and nitrite hasn't shown up yet.",
      },
      nextStep: switch (ammonia) {
        null => 'Test ammonia and nitrite.',
        LoggedReading(:final value) when value <= 0 && !fishIn =>
          'Dose ammonia to ${formatNumber(config.doseTargetPpm)} ppm so the bacteria have food.',
        _ => 'Keep testing every day or two. Nitrite appears as the bacteria grow.',
      },
      warnings: warnings,
    );
  }

  final bothZero =
      ammonia != null &&
      nitrite != null &&
      ammonia.value <= 0 &&
      nitrite.value <= 0;

  if (!bothZero) {
    return CycleStatus(
      stage: CycleStage.nitritePhase,
      reason:
          'Nitrite has shown up. Latest ammonia ${_describe(ammonia)}, nitrite ${_describe(nitrite)}.',
      nextStep: fishIn
          ? 'Keep testing daily. The cycle is done when both read 0.'
          : 'Keep testing. When ammonia and nitrite both read 0, start dose tests.',
      warnings: warnings,
    );
  }

  if (fishIn) {
    if (soilHold) {
      return CycleStatus(
        stage: CycleStage.nitritePhase,
        reason: soilLeachMessage,
        nextStep: 'Keep testing ammonia and nitrite daily.',
        warnings: warnings,
      );
    }
    return CycleStatus(
      stage: CycleStage.cycled,
      reason: 'Ammonia and nitrite both read 0.',
      nextStep: 'Keep testing weekly to confirm it holds.',
      warnings: warnings,
    );
  }

  final tests = log.doseTests(now);
  final streak = passStreak(tests);
  final required = config.passesRequired.value;

  if (streak < required || soilHold) {
    final pending =
        tests.isNotEmpty && tests.last.result == DoseTestResult.pending;
    final held = streak >= required;
    return CycleStatus(
      stage: CycleStage.doseTest,
      reason: held
          ? soilLeachMessage
          : 'Ammonia and nitrite both read 0. Dose tests passed in a row: $streak of $required.',
      nextStep: pending
          ? 'Test ammonia and nitrite ${config.doseWindowStartHours.value}–${config.doseWindowEndHours.value} h after your last dose.'
          : held
          ? 'Keep testing until day ${config.soilMinDays.value}.'
          : 'Dose ammonia to ${formatNumber(config.doseTargetPpm)} ppm, test again in 24 h.',
      passStreak: streak,
      doseTests: tests,
    );
  }

  final nitrate = log.latest(Parameter.nitrate);
  final passed = 'Passed $streak dose tests in a row.';
  if (nitrate != null && nitrate.ppm < config.readyNitrateMaxPpm) {
    return CycleStatus(
      stage: CycleStage.readyToStock,
      reason: '$passed Nitrate is ${formatNumber(nitrate.ppm)} ppm.',
      nextStep: 'Ready to add fish.',
      passStreak: streak,
      doseTests: tests,
    );
  }
  return CycleStatus(
    stage: CycleStage.cycled,
    reason: passed,
    nextStep: nitrate == null
        ? 'Test nitrate. Under ${formatNumber(config.readyNitrateMaxPpm)} ppm means ready to stock.'
        : 'Nitrate is ${formatNumber(nitrate.ppm)} ppm. Do a large water change to get it under ${formatNumber(config.readyNitrateMaxPpm)} ppm.',
    passStreak: streak,
    doseTests: tests,
  );
}

String _describe(LoggedReading? r) =>
    r == null ? 'not tested' : '${formatNumber(r.value)} ppm';

List<String> _fishInWarnings(
  TankProfile tank,
  DateTime start,
  LoggedReading? ammonia,
  LoggedReading? nitrite,
  DateTime now,
  DomainConfig config,
) => [
  if (ammonia != null && ammonia.value > 0)
    'Ammonia is ${formatNumber(ammonia.value)} ppm with fish in the tank.',
  if (nitrite != null && nitrite.value > 0)
    'Nitrite is ${formatNumber(nitrite.value)} ppm with fish in the tank.',
  if (now.isBefore(
    addDays(tank.stockedAt ?? start, config.fishInFeedLightlyDays),
  ))
    'Feed lightly for the first ${config.fishInFeedLightlyDays} days.',
];
