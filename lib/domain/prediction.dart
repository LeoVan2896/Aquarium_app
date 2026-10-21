import 'config.dart';
import 'cycle_engine.dart';
import 'enums.dart';
import 'models.dart';
import 'units.dart';

enum Confidence { low, medium }

class CyclePrediction {
  const CyclePrediction({
    required this.earliest,
    required this.latest,
    required this.confidence,
    required this.basis,
  });

  final DateTime earliest;
  final DateTime latest;
  final Confidence confidence;
  final String basis;
}

CyclePrediction? predictFinish({
  required TankProfile tank,
  required CycleStatus status,
  required Iterable<LoggedReading> readings,
  required DateTime now,
  DomainConfig config = const DomainConfig(),
}) {
  final start = tank.cycleStartedAt;
  if (start == null ||
      status.stage == CycleStage.notStarted ||
      status.stage == CycleStage.cycled ||
      status.stage == CycleStage.readyToStock) {
    return null;
  }

  final log = CycleLog(
    start: start,
    readings: readings,
    events: const [],
    config: config,
  );
  final weeks = tank.hasSoil ? config.soilTypicalWeeks : config.typicalWeeks;
  final typicalEarliest = addDays(start, weeks.min * 7);
  final typicalLatest = addDays(start, weeks.max * 7);
  final soilFloor = tank.hasSoil
      ? addDays(start, config.soilMinDays.value)
      : null;

  CyclePrediction typical(String why) => CyclePrediction(
    earliest: typicalEarliest,
    latest: typicalLatest,
    confidence: Confidence.low,
    basis:
        'Typical range for ${tank.hasSoil ? 'a soil' : 'a'} tank: ${weeks.min}–${weeks.max} weeks from start. $why',
  );

  final cycleReadings = log.readings
      .where(
        (r) =>
            r.parameter == Parameter.ammonia ||
            r.parameter == Parameter.nitrite,
      )
      .length;
  if (cycleReadings < config.minReadingsForTrend) {
    return typical('Fewer than ${config.minReadingsForTrend} readings so far.');
  }

  if (status.stage == CycleStage.doseTest) {
    final remaining = (config.passesRequired.value - status.passStreak).clamp(
      0,
      config.passesRequired.value,
    );
    var earliest = addDays(now, remaining);
    if (soilFloor != null && earliest.isBefore(soilFloor)) earliest = soilFloor;
    var latest = addDays(now, config.doseTestDays.value.max);
    if (latest.isBefore(earliest)) latest = earliest;
    return CyclePrediction(
      earliest: earliest,
      latest: latest,
      confidence: Confidence.medium,
      basis:
          'Dose tests passed: ${status.passStreak} of ${config.passesRequired.value}.',
    );
  }

  final falling = status.stage == CycleStage.ammoniaPhase
      ? Parameter.ammonia
      : Parameter.nitrite;
  final windowStart = addDays(now, -(config.trendWindowDays));
  final points = log.readings
      .where((r) => r.parameter == falling && !r.takenAt.isBefore(windowStart))
      .toList();
  final fit = _fitLine(points);
  final name = falling == Parameter.ammonia ? 'Ammonia' : 'Nitrite';
  if (fit == null || fit.slopePerDay >= 0) {
    return typical(
      "$name isn't falling over the last ${config.trendWindowDays} days yet.",
    );
  }

  var zeroAt = fit.origin.add(
    Duration(minutes: (-fit.intercept / fit.slopePerDay * 1440).round()),
  );
  if (zeroAt.isBefore(now)) zeroAt = now;

  final after = falling == Parameter.ammonia
      ? (
          min:
              config.nitritePhaseDays.value.min + config.doseTestDays.value.min,
          max:
              config.nitritePhaseDays.value.max + config.doseTestDays.value.max,
        )
      : config.doseTestDays.value;

  final clampLow = addDays(typicalEarliest, -(config.predictionClampWeeks * 7));
  final clampHigh = addDays(typicalLatest, config.predictionClampWeeks * 7);
  var earliest = _clamp(addDays(zeroAt, after.min), clampLow, clampHigh);
  var latest = _clamp(addDays(zeroAt, after.max), clampLow, clampHigh);
  if (soilFloor != null && earliest.isBefore(soilFloor)) earliest = soilFloor;
  if (latest.isBefore(earliest)) latest = earliest;

  return CyclePrediction(
    earliest: earliest,
    latest: latest,
    confidence: Confidence.medium,
    basis:
        '$name falling about ${formatNumber(double.parse((-fit.slopePerDay).toStringAsFixed(2)))} ppm/day over the last ${config.trendWindowDays} days, plus typical time for the remaining stages.',
  );
}

DateTime _clamp(DateTime t, DateTime low, DateTime high) =>
    t.isBefore(low) ? low : (t.isAfter(high) ? high : t);

typedef _Fit = ({DateTime origin, double intercept, double slopePerDay});

_Fit? _fitLine(List<LoggedReading> points) {
  if (points.length < 2) return null;
  final origin = points.first.takenAt;
  final xs = [
    for (final p in points) p.takenAt.difference(origin).inMinutes / 1440,
  ];
  final ys = [for (final p in points) p.value];
  final n = points.length;
  final meanX = xs.reduce((a, b) => a + b) / n;
  final meanY = ys.reduce((a, b) => a + b) / n;
  var covariance = 0.0;
  var variance = 0.0;
  for (var i = 0; i < n; i++) {
    covariance += (xs[i] - meanX) * (ys[i] - meanY);
    variance += (xs[i] - meanX) * (xs[i] - meanX);
  }
  if (variance == 0) return null;
  final slope = covariance / variance;
  return (origin: origin, intercept: meanY - slope * meanX, slopePerDay: slope);
}
