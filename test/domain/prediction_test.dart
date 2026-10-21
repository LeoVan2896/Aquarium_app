import 'package:aquarium_app/domain/cycle_engine.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/models.dart';
import 'package:aquarium_app/domain/prediction.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

CyclePrediction? predict(
  TankProfile t,
  List<LoggedReading> readings, {
  required DateTime now,
}) {
  final status = evaluateCycle(
    tank: t,
    readings: readings,
    events: const [],
    now: now,
  );
  return predictFinish(tank: t, status: status, readings: readings, now: now);
}

void main() {
  test('no prediction before the cycle starts', () {
    const t = TankProfile(hasSoil: false, cycleMethod: CycleMethod.fishless);
    expect(predict(t, [], now: day(1)), isNull);
  });

  test('fewer than 5 readings gives the typical 4–8 week range', () {
    final p = predict(tank(), pair(2, 0, day(2)), now: day(3))!;
    expect(p.confidence, Confidence.low);
    expect(p.earliest, day(28));
    expect(p.latest, day(56));
    expect(p.basis, contains('Fewer than 5 readings'));
  });

  test('day math keeps the calendar date across a DST change', () {
    final localStart = DateTime(2026, 10, 18);
    final t = TankProfile(
      hasSoil: true,
      cycleMethod: CycleMethod.fishless,
      cycleStartedAt: localStart,
    );
    final p = predict(t, [
      reading(Parameter.ammonia, 2, DateTime(2026, 10, 19)),
    ], now: DateTime(2026, 10, 21))!;
    expect(p.earliest, DateTime(2026, 11, 29));
    expect(p.latest, DateTime(2026, 12, 13));
  });

  test('soil tanks use the 6–8 week range', () {
    final p = predict(tank(hasSoil: true), pair(2, 0, day(2)), now: day(3))!;
    expect(p.earliest, day(42));
    expect(p.latest, day(56));
  });

  test('falling ammonia projects to 0 and adds the remaining stages', () {
    final readings = [
      for (var d = 3; d <= 7; d++)
        reading(Parameter.ammonia, (8 - d).toDouble(), day(d)),
    ];
    final p = predict(tank(), readings, now: day(7))!;

    // Ammonia hits 0 on day 8; nitrite stage 7–21 d + dose tests 2–7 d.
    expect(p.confidence, Confidence.medium);
    expect(p.earliest, day(17));
    expect(p.latest, day(36));
    expect(p.basis, contains('Ammonia falling about 1 ppm/day'));
  });

  test('a slow trend is clamped to the typical range plus 2 weeks', () {
    final readings = [
      for (var d = 3; d <= 7; d++)
        reading(Parameter.ammonia, 8 - d * 0.01, day(d)),
    ];
    final p = predict(tank(), readings, now: day(7))!;
    expect(p.latest, day(70));
    expect(p.earliest, day(70));
  });

  test('ammonia that is not falling falls back to the typical range', () {
    final readings = [
      for (var d = 3; d <= 7; d++) reading(Parameter.ammonia, 2, day(d)),
    ];
    final p = predict(tank(), readings, now: day(7))!;
    expect(p.confidence, Confidence.low);
    expect(p.basis, contains("isn't falling"));
  });

  test('soil tanks never predict before day 28', () {
    final readings = [
      ...pair(2, 0, day(1)),
      ...pair(0.5, 2, day(3)),
      ...pair(0, 0, day(5)),
    ];
    final p = predict(tank(hasSoil: true), readings, now: day(5, 1))!;
    expect(p.earliest, day(28));
  });
}
