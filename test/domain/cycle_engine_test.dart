import 'package:aquarium_app/domain/cycle_engine.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

CycleStatus evaluate(
  TankProfile t,
  List<LoggedReading> readings, {
  List<LoggedEvent> events = const [],
  required DateTime now,
}) => evaluateCycle(tank: t, readings: readings, events: events, now: now);

// Nitrite seen on day 10, both zero by day 20.
List<LoggedReading> throughNitritePhase() => [
  ...pair(2, 0, day(5)),
  ...pair(0.5, 1, day(10)),
  ...pair(0, 0, day(20)),
];

({List<LoggedReading> readings, List<LoggedEvent> events}) doseTest(
  int doseDay, {
  double ammonia = 0,
  double nitrite = 0,
}) => (
  readings: pair(ammonia, nitrite, day(doseDay, 24)),
  events: [ammoniaDose(day(doseDay))],
);

void main() {
  test('no cycle start date is notStarted', () {
    final status = evaluate(
      const TankProfile(hasSoil: false, cycleMethod: CycleMethod.fishless),
      [],
      now: day(1),
    );
    expect(status.stage, CycleStage.notStarted);
  });

  group('ammoniaPhase', () {
    test('ammonia above 0 and nitrite never seen', () {
      final status = evaluate(tank(), pair(2, 0, day(3)), now: day(4));
      expect(status.stage, CycleStage.ammoniaPhase);
      expect(status.reason, contains('Ammonia is 2 ppm'));
    });

    test('ammonia at 0 before nitrite appears prompts a fishless dose', () {
      final status = evaluate(tank(), pair(0, 0, day(1)), now: day(2));
      expect(status.stage, CycleStage.ammoniaPhase);
      expect(status.nextStep, contains('Dose ammonia to 2 ppm'));
    });

    test('readings before the cycle start are ignored', () {
      final status = evaluate(
        tank(),
        pair(1, 1, start.subtract(const Duration(days: 2))),
        now: day(1),
      );
      expect(status.stage, CycleStage.ammoniaPhase);
      expect(status.reason, contains('No ammonia reading'));
    });

    test('a corrected nitrite reading no longer counts as seen', () {
      final wrong = reading(Parameter.nitrite, 1, day(3));
      final status = evaluate(tank(), [
        reading(Parameter.ammonia, 2, day(3)),
        wrong,
        reading(Parameter.nitrite, 0, day(3), correctsId: wrong.id),
      ], now: day(4));
      expect(status.stage, CycleStage.ammoniaPhase);
    });
  });

  test('nitritePhase once nitrite has been seen and is still above 0', () {
    final status = evaluate(tank(), [
      ...pair(2, 0, day(5)),
      ...pair(0, 2, day(12)),
    ], now: day(13));
    expect(status.stage, CycleStage.nitritePhase);
  });

  test('doseTest when both read 0 after nitrite was seen', () {
    final status = evaluate(tank(), throughNitritePhase(), now: day(20, 1));
    expect(status.stage, CycleStage.doseTest);
    expect(status.nextStep, 'Dose ammonia to 2 ppm, test again in 24 h.');
  });

  test('ammonia spike right after a dose does not drop back a stage', () {
    final status = evaluate(
      tank(),
      [...throughNitritePhase(), ...pair(2, 0, day(21, 2))],
      events: [ammoniaDose(day(21))],
      now: day(21, 3),
    );
    expect(status.stage, CycleStage.doseTest);
    expect(status.nextStep, contains('18–30 h after your last dose'));
  });

  test('a reading outside the 18–30 h window is not a dose test', () {
    final status = evaluate(
      tank(),
      [...throughNitritePhase(), ...pair(0, 0, day(22, 12))],
      events: [ammoniaDose(day(21))],
      now: day(23),
    );
    expect(status.passStreak, 0);
    expect(status.doseTests.single.result, DoseTestResult.missed);
  });

  test('two passing dose tests make the tank cycled', () {
    final a = doseTest(21);
    final b = doseTest(23);
    final status = evaluate(
      tank(),
      [...throughNitritePhase(), ...a.readings, ...b.readings],
      events: [...a.events, ...b.events],
      now: day(25),
    );
    expect(status.stage, CycleStage.cycled);
    expect(status.passStreak, 2);
    expect(status.nextStep, contains('Test nitrate'));
  });

  test('one failing test resets the streak', () {
    final pass1 = doseTest(21);
    final fail = doseTest(23, ammonia: 0.25);
    final pass2 = doseTest(26);
    final status = evaluate(
      tank(),
      [
        ...throughNitritePhase(),
        ...pass1.readings,
        ...fail.readings,
        ...pair(0, 0, day(25)),
        ...pass2.readings,
      ],
      events: [...pass1.events, ...fail.events, ...pass2.events],
      now: day(28),
    );
    expect(status.stage, CycleStage.doseTest);
    expect(status.passStreak, 1);
    expect(status.doseTests.map((t) => t.result), [
      DoseTestResult.pass,
      DoseTestResult.fail,
      DoseTestResult.pass,
    ]);
  });

  group('soil tank', () {
    ({List<LoggedReading> readings, List<LoggedEvent> events}) twoPasses() {
      final a = doseTest(21);
      final b = doseTest(23);
      return (
        readings: [...throughNitritePhase(), ...a.readings, ...b.readings],
        events: [...a.events, ...b.events],
      );
    }

    test('under 28 days never shows cycled', () {
      final log = twoPasses();
      for (final now in [day(25), day(27, 23)]) {
        final status = evaluate(
          tank(hasSoil: true),
          log.readings,
          events: log.events,
          now: now,
        );
        expect(status.stage, CycleStage.doseTest);
        expect(status.reason, soilLeachMessage);
      }
    });

    test('from day 28 the same log is cycled', () {
      final log = twoPasses();
      final status = evaluate(
        tank(hasSoil: true),
        log.readings,
        events: log.events,
        now: day(28),
      );
      expect(status.stage, CycleStage.cycled);
    });
  });

  test('readyToStock once cycled and nitrate is under 20 ppm', () {
    final a = doseTest(21);
    final b = doseTest(23);
    final readings = [
      ...throughNitritePhase(),
      ...a.readings,
      ...b.readings,
      reading(Parameter.nitrate, 40, day(24, 1)),
    ];
    final events = [...a.events, ...b.events];

    expect(
      evaluate(tank(), readings, events: events, now: day(25)).stage,
      CycleStage.cycled,
    );
    expect(
      evaluate(
        tank(),
        [...readings, reading(Parameter.nitrate, 10, day(25))],
        events: events,
        now: day(25, 1),
      ).stage,
      CycleStage.readyToStock,
    );
  });

  group('fishIn', () {
    test('warns on ammonia and nitrite above 0 and says feed lightly', () {
      final status = evaluate(tank(method: CycleMethod.fishIn), [
        ...pair(0.5, 0, day(2)),
        ...pair(0.25, 0.5, day(6)),
      ], now: day(7));
      expect(status.warnings, [
        'Ammonia is 0.25 ppm with fish in the tank.',
        'Nitrite is 0.5 ppm with fish in the tank.',
        'Feed lightly for the first 14 days.',
      ]);
    });

    test('skips doseTest and is cycled when both read 0', () {
      final status = evaluate(
        tank(method: CycleMethod.fishIn),
        throughNitritePhase(),
        now: day(20, 1),
      );
      expect(status.stage, CycleStage.cycled);
      expect(status.warnings, isEmpty);
    });

    test('soil under 28 days holds instead of cycled', () {
      final status = evaluate(
        tank(method: CycleMethod.fishIn, hasSoil: true),
        throughNitritePhase(),
        now: day(20, 1),
      );
      expect(status.stage, CycleStage.nitritePhase);
      expect(status.reason, soilLeachMessage);
    });
  });
}
