import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/fit_checks.dart';
import 'package:aquarium_app/domain/recommendations.dart';
import 'package:aquarium_app/domain/species.dart';
import 'package:aquarium_app/domain/tank_conditions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'species_fixtures.dart';

const setup = TankSetup(volumeGal: 20, lengthIn: 24, widthIn: 12);
final now = DateTime.utc(2026, 11, 1);

TankConditions measured({double? temp, double? ph, double? gh, double? kh}) {
  Condition? c(double? v) =>
      v == null ? null : Condition(v, ConditionSource.reading, now);
  return TankConditions(tempF: c(temp), ph: c(ph), gh: c(gh), kh: c(kh));
}

List<Recommendation> run(
  List<AnimalSpecies> animals, {
  TankConditions conditions = const TankConditions(),
  List<AnimalSpecies> stocked = const [],
}) => recommend(
  catalog: SpeciesCatalog(animals: animals),
  type: SpeciesType.animal,
  setup: setup,
  conditions: conditions,
  maturity: const Maturity(),
  now: now,
  stockedAnimals: stocked,
  stockedPlants: const [],
);

void main() {
  group('recommendations', () {
    test('rank by fails, then cautions, then unknowns, then name', () {
      final fits = fish(
        id: 'fits',
        commonName: 'Zebra fits',
        tempF: [range(70, 78)],
        ph: [range(6, 7.5)],
        minTank: [const TankSize(gallons: 10, source: 'a')],
      );
      final unknownPh = fish(
        id: 'unknown',
        commonName: 'Alpha unknown',
        tempF: [range(70, 78)],
        minTank: [const TankSize(gallons: 10, source: 'a')],
      );
      final tooBig = fish(
        id: 'big',
        commonName: 'Beta big',
        tempF: [range(70, 78)],
        ph: [range(6, 7.5)],
        minTank: [const TankSize(gallons: 55, source: 'a')],
      );

      final ranked = run([
        tooBig,
        unknownPh,
        fits,
      ], conditions: measured(temp: 74, ph: 6.8));

      expect(ranked.map((r) => r.commonName), [
        'Zebra fits',
        'Alpha unknown',
        'Beta big',
      ]);
      expect(ranked.first.fails, 0);
      expect(ranked.last.fails, 1);
    });

    test('species already in the tank are left out', () {
      final tetra = fish(id: 'tetra');
      expect(run([tetra], stocked: [tetra]), isEmpty);
    });

    test('a schooler is judged at its minimum group size', () {
      final schooler = fish(minGroupSize: 8);
      final groupCheck = run([schooler]).single.checks
          .singleWhere((c) => c.kind == CheckKind.groupSize);
      expect(groupCheck.status, CheckStatus.pass);
    });

    test('unknowns say what to log to settle them', () {
      final r = run([
        fish(tempF: [range(70, 78)], ph: [range(6, 7)], gh: [range(4, 8)]),
      ]).single;

      expect(r.hints, [
        'Log a temperature',
        'Log a pH reading',
        'Log a GH reading',
      ]);
    });
  });

  group('species alerts', () {
    final tetra = fish(
      commonName: 'Fixture tetra',
      ph: [range(6.5, 7, tolerated: const Span(6, 7.5))],
      tempF: [range(72, 76)],
    );

    List<SpeciesAlert> alerts(TankConditions c) => speciesAlerts(
      animals: [tetra],
      plants: const [],
      setup: setup,
      conditions: c,
    );

    test('a reading outside the tolerated range is a fail alert', () {
      final a = alerts(measured(ph: 8.2)).single;
      expect(a.speciesName, 'Fixture tetra');
      expect(a.check.kind, CheckKind.ph);
      expect(a.check.status, CheckStatus.fail);
    });

    test('outside ideal but tolerated is a caution', () {
      expect(
        alerts(measured(ph: 7.3)).single.check.status,
        CheckStatus.caution,
      );
    });

    test('in range or unmeasured raises nothing', () {
      expect(alerts(measured(ph: 6.8)), isEmpty);
      expect(alerts(const TankConditions()), isEmpty);
    });

    test('a target temperature is not a reading and never alerts', () {
      expect(
        alerts(
          const TankConditions(
            tempF: Condition(85, ConditionSource.targetTemp),
          ),
        ),
        isEmpty,
      );
      expect(
        alerts(measured(temp: 85)).single.check.kind,
        CheckKind.temperature,
      );
    });
  });

  test('stale water tests lists what is missing', () {
    expect(staleWaterTests(measured(ph: 7)), ['GH', 'KH']);
    expect(staleWaterTests(measured(ph: 7, gh: 6, kh: 3)), isEmpty);
  });
}
