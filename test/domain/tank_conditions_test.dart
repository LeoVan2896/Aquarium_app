import 'package:aquarium_app/domain/cycle_engine.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/models.dart';
import 'package:aquarium_app/domain/tank_conditions.dart';
import 'package:aquarium_app/domain/units.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

const setup = TankSetup(volumeGal: 20, targetTempF: 76, roomTempF: 72);

// Ammonia, then nitrite, then two passed dose tests, then low nitrate on `readyDay`.
({List<LoggedReading> readings, List<LoggedEvent> events}) cycledBy(
  int readyDay,
) => (
  readings: [
    ...pair(2, 0, day(1)),
    ...pair(0.5, 1, day(readyDay - 6)),
    ...pair(0, 0, day(readyDay - 5)),
    ...pair(0, 0, day(readyDay - 3)),
    ...pair(0, 0, day(readyDay - 1)),
    reading(Parameter.nitrate, 10, day(readyDay)),
  ],
  events: [ammoniaDose(day(readyDay - 4)), ammoniaDose(day(readyDay - 2))],
);

void main() {
  group('conditions', () {
    test('temperature prefers a reading, then the target, then the room', () {
      final now = day(10);

      expect(
        tankConditions(
          setup: setup,
          readings: [reading(Parameter.temperature, 74, day(2), unit: 'F')],
          now: now,
        ).tempF!.value,
        74,
      );
      final target = tankConditions(
        setup: setup,
        readings: [],
        now: now,
      ).tempF!;
      expect(target.value, 76);
      expect(target.source, ConditionSource.targetTemp);
      expect(
        tankConditions(
          setup: const TankSetup(volumeGal: 20, roomTempF: 72),
          readings: [],
          now: now,
        ).tempF!.source,
        ConditionSource.roomTemp,
      );
    });

    test('a pH reading older than 30 days counts as missing', () {
      final old = reading(Parameter.ph, 6.8, day(0));

      expect(
        tankConditions(setup: setup, readings: [old], now: day(30)).ph!.value,
        6.8,
      );
      expect(
        tankConditions(setup: setup, readings: [old], now: day(31)).ph,
        isNull,
      );
    });

    test('GH and KH come out in degrees whatever unit was logged', () {
      final c = tankConditions(
        setup: setup,
        readings: [
          reading(Parameter.gh, ppmPerDegree * 4, day(1)),
          reading(Parameter.kh, 3, day(1), unit: 'dKH'),
        ],
        now: day(2),
      );

      expect(c.gh!.value, closeTo(4, 1e-9));
      expect(c.kh!.value, 3);
    });

    test('a corrected reading is replaced by its correction', () {
      final wrong = reading(Parameter.ph, 8.2, day(1));
      final fixed = reading(Parameter.ph, 6.2, day(1), correctsId: wrong.id);

      expect(
        tankConditions(
          setup: setup,
          readings: [wrong, fixed],
          now: day(2),
        ).ph!.value,
        6.2,
      );
    });
  });

  test('only fishless tanks that are not ready to stock gate fish', () {
    expect(fishGated(CycleMethod.fishless, CycleStage.nitritePhase), isTrue);
    expect(fishGated(CycleMethod.fishless, CycleStage.cycled), isTrue);
    expect(fishGated(CycleMethod.fishless, CycleStage.readyToStock), isFalse);
    expect(fishGated(CycleMethod.fishIn, CycleStage.ammoniaPhase), isFalse);
  });

  group('maturity', () {
    test('a tank that cycled in 28 days is established 28 days later', () {
      final log = cycledBy(28);
      final m = tankMaturity(
        tank: tank(),
        readings: log.readings,
        events: log.events,
      );

      expect(m.readyAt, day(28));
      expect(m.establishedAt, day(56));
      expect(m.isEstablished(day(55)), isFalse);
      expect(m.isEstablished(day(56)), isTrue);
    });

    test('a tank that took 56 days waits 56 more', () {
      final log = cycledBy(56);
      final m = tankMaturity(
        tank: tank(),
        readings: log.readings,
        events: log.events,
      );

      expect(m.isEstablished(day(84)), isFalse);
      expect(m.establishedAt, day(112));
    });

    test('a tank that never reached ready to stock is unknown', () {
      final m = tankMaturity(
        tank: tank(),
        readings: pair(2, 0, day(3)),
        events: const [],
      );

      expect(m.readyAt, isNull);
      expect(m.isEstablished(day(400)), isFalse);
    });

    test('a tank with no cycle start date is unknown', () {
      final log = cycledBy(28);
      final m = tankMaturity(
        tank: const TankProfile(
          hasSoil: false,
          cycleMethod: CycleMethod.fishless,
        ),
        readings: log.readings,
        events: log.events,
      );

      expect(m.establishedAt, isNull);
    });
  });
}
