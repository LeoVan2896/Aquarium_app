import 'package:aquarium_app/domain/fit_checks.dart';
import 'package:aquarium_app/domain/species.dart';
import 'package:aquarium_app/domain/tank_conditions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'species_fixtures.dart';

final now = DateTime.utc(2026, 11, 1);

TankConditions withPh(double? ph) => TankConditions(
  ph: ph == null ? null : Condition(ph, ConditionSource.reading, now),
);

Check checkFor(
  CheckKind kind,
  AnimalSpecies species, {
  TankSetup setup = const TankSetup(volumeGal: 20),
  TankConditions conditions = const TankConditions(),
  Maturity maturity = const Maturity(),
  int plannedCount = 1,
  int currentCount = 0,
}) => animalFit(
  species,
  setup: setup,
  conditions: conditions,
  maturity: maturity,
  now: now,
  plannedCount: plannedCount,
  currentCount: currentCount,
).singleWhere((c) => c.kind == kind);

Check plantCheck(
  CheckKind kind,
  PlantSpecies p, {
  TankSetup setup = const TankSetup(volumeGal: 20),
}) => plantFit(
  p,
  setup: setup,
  conditions: const TankConditions(),
).singleWhere((c) => c.kind == kind);

void main() {
  group('water ranges', () {
    final species = fish(
      ph: [range(6.5, 7.0, tolerated: const Span(6.0, 7.5))],
    );

    test('inside the ideal range passes', () {
      final c = checkFor(CheckKind.ph, species, conditions: withPh(6.8));
      expect(c.status, CheckStatus.pass);
      expect(
        c.reason,
        'pH 6.8 vs ideal 6.5–7, tolerates 6–7.5 (example.test).',
      );
    });

    test('tolerated but outside ideal is a caution', () {
      expect(
        checkFor(CheckKind.ph, species, conditions: withPh(6.2)).status,
        CheckStatus.caution,
      );
    });

    test('outside both fails', () {
      expect(
        checkFor(CheckKind.ph, species, conditions: withPh(5.5)).status,
        CheckStatus.fail,
      );
    });

    test('a tolerated-only range passes anywhere inside it', () {
      final tolerantOnly = fish(
        ph: [const RangeReport(tolerated: Span(6, 8), source: 'a')],
      );
      expect(
        checkFor(CheckKind.ph, tolerantOnly, conditions: withPh(6.1)).status,
        CheckStatus.pass,
      );
    });

    test('no reading is unknown, never a pass', () {
      final c = checkFor(CheckKind.ph, species);
      expect(c.status, CheckStatus.unknown);
      expect(c.reason, 'No pH reading in the last 30 days.');
    });

    test('no sourced range is unknown', () {
      expect(
        checkFor(CheckKind.gh, species, conditions: withPh(7)).status,
        CheckStatus.unknown,
      );
    });

    test('sources that disagree on the verdict give a caution', () {
      final disputed = fish(
        tempF: [
          range(81, 86),
          range(77, 84, source: 'b'),
        ],
      );
      final c = checkFor(
        CheckKind.temperature,
        disputed,
        conditions: const TankConditions(
          tempF: Condition(78, ConditionSource.targetTemp),
        ),
      );
      expect(c.status, CheckStatus.caution);
      expect(c.reason, contains('ideal 81–86°F (example.test)'));
    });

    test('sources that agree keep their verdict', () {
      final agreed = fish(
        tempF: [
          range(81, 86),
          range(77, 84, source: 'b'),
        ],
      );
      expect(
        checkFor(
          CheckKind.temperature,
          agreed,
          conditions: const TankConditions(
            tempF: Condition(74, ConditionSource.reading),
          ),
        ).status,
        CheckStatus.fail,
      );
    });
  });

  group('tank size', () {
    final longBase = fish(
      minTank: [const TankSize(lengthCm: 100, widthCm: 30, source: 'a')],
    );

    test('a 100 × 30 cm base fails on a 24 × 12 in tank', () {
      expect(
        checkFor(
          CheckKind.tankSize,
          longBase,
          setup: const TankSetup(volumeGal: 20, lengthIn: 24, widthIn: 12),
        ).status,
        CheckStatus.fail,
      );
    });

    test('a base that fits passes', () {
      expect(
        checkFor(
          CheckKind.tankSize,
          longBase,
          setup: const TankSetup(volumeGal: 40, lengthIn: 48, widthIn: 13),
        ).status,
        CheckStatus.pass,
      );
    });

    test('a footprint with no tank dimensions entered is unknown', () {
      final c = checkFor(CheckKind.tankSize, longBase);
      expect(c.status, CheckStatus.unknown);
      expect(c.reason, contains("enter your tank's length and width"));
    });

    test('a gallons-only minimum compares volume', () {
      final big = fish(minTank: [const TankSize(gallons: 30, source: 'a')]);
      expect(checkFor(CheckKind.tankSize, big).status, CheckStatus.fail);
    });
  });

  group('group, maturity and substrate', () {
    test('counts current stock toward the minimum group', () {
      final schooler = fish(minGroupSize: 8);

      expect(
        checkFor(CheckKind.groupSize, schooler, plannedCount: 4).status,
        CheckStatus.caution,
      );
      expect(
        checkFor(
          CheckKind.groupSize,
          schooler,
          plannedCount: 4,
          currentCount: 4,
        ).status,
        CheckStatus.pass,
      );
    });

    test('species without a sourced group size get no group check', () {
      expect(
        animalFit(
          fish(),
          setup: const TankSetup(volumeGal: 20),
          conditions: const TankConditions(),
          maturity: const Maturity(),
          now: now,
        ).where((c) => c.kind == CheckKind.groupSize),
        isEmpty,
      );
    });

    test('needs-mature-tank species wait for the established date', () {
      final sensitive = fish(flags: {AnimalFlag.needsMatureTank: true});
      final m = Maturity(
        readyAt: DateTime.utc(2026, 10, 1),
        establishedAt: DateTime.utc(2026, 11, 15),
      );

      final waiting = checkFor(CheckKind.maturity, sensitive, maturity: m);
      expect(waiting.status, CheckStatus.caution);
      expect(waiting.reason, contains('2026-11-15'));
      expect(
        checkFor(CheckKind.maturity, sensitive).status,
        CheckStatus.unknown,
      );
    });

    test('sand-needing species get a caution on other substrates', () {
      final digger = fish(flags: {AnimalFlag.needsSand: true});

      expect(checkFor(CheckKind.substrate, digger).status, CheckStatus.caution);
      expect(
        checkFor(
          CheckKind.substrate,
          digger,
          setup: const TankSetup(volumeGal: 20, sandSubstrate: true),
        ).status,
        CheckStatus.pass,
      );
    });
  });

  group('plants', () {
    test('light passes at the highest rating and cautions in between', () {
      final p = plant(light: [LightLevel.low, LightLevel.medium]);

      expect(
        plantCheck(
          CheckKind.light,
          p,
          setup: const TankSetup(volumeGal: 20, lightLevel: LightLevel.medium),
        ).status,
        CheckStatus.pass,
      );
      expect(
        plantCheck(
          CheckKind.light,
          p,
          setup: const TankSetup(volumeGal: 20, lightLevel: LightLevel.low),
        ).status,
        CheckStatus.caution,
      );
      expect(plantCheck(CheckKind.light, p).status, CheckStatus.unknown);
    });

    test('light below every rating fails', () {
      expect(
        plantCheck(
          CheckKind.light,
          plant(light: [LightLevel.high]),
          setup: const TankSetup(volumeGal: 20, lightLevel: LightLevel.low),
        ).status,
        CheckStatus.fail,
      );
    });

    test('CO₂ required fails without it, helps is a caution', () {
      expect(
        plantCheck(CheckKind.co2, plant(co2: [Co2Need.required])).status,
        CheckStatus.fail,
      );
      expect(
        plantCheck(CheckKind.co2, plant(co2: [Co2Need.helps])).status,
        CheckStatus.caution,
      );
      expect(
        plantCheck(
          CheckKind.co2,
          plant(co2: [Co2Need.required]),
          setup: const TankSetup(volumeGal: 20, hasCo2: true),
        ).status,
        CheckStatus.pass,
      );
    });

    test('root feeders need soil or root tabs', () {
      final p = plant(rootFeeder: true);

      expect(plantCheck(CheckKind.rootFeeder, p).status, CheckStatus.caution);
      expect(
        plantCheck(
          CheckKind.rootFeeder,
          p,
          setup: const TankSetup(volumeGal: 20, hasSoil: true),
        ).status,
        CheckStatus.pass,
      );
    });
  });
}
