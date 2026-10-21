import 'package:aquarium_app/domain/compatibility.dart';
import 'package:aquarium_app/domain/config.dart';
import 'package:aquarium_app/domain/fit_checks.dart';
import 'package:aquarium_app/domain/species.dart';
import 'package:flutter_test/flutter_test.dart';

import 'species_fixtures.dart';

List<Check> against(
  AnimalSpecies candidate,
  List<AnimalSpecies> animals, {
  List<PlantSpecies> plants = const [],
  DomainConfig config = const DomainConfig(),
}) => animalCompatibility(
  candidate,
  animals: animals,
  plants: plants,
  config: config,
);

void main() {
  test('species with no shared temperature fail', () {
    final warm = fish(
      id: 'warm',
      commonName: 'Warm fish',
      tempF: [range(81, 86)],
    );
    final cool = fish(
      id: 'cool',
      commonName: 'Cool fish',
      tempF: [range(68, 75)],
    );

    final checks = against(warm, [cool]);
    expect(checks.single.kind, CheckKind.temperatureOverlap);
    expect(checks.single.status, CheckStatus.fail);
    expect(
      checks.single.reason,
      "Warm fish wants 81–86°F and Cool fish wants 68–75°F; there's no temperature that suits both.",
    );
  });

  test('overlapping temperatures raise nothing', () {
    expect(
      against(fish(id: 'a', tempF: [range(72, 80)]), [
        fish(id: 'b', tempF: [range(70, 74)]),
      ]),
      isEmpty,
    );
  });

  test('aggressive with peaceful fails; semi-aggressive is a caution', () {
    final calm = fish(id: 'calm', temperament: Temperament.peaceful);

    expect(
      against(fish(id: 'mean', temperament: Temperament.aggressive), [
        calm,
      ]).single.status,
      CheckStatus.fail,
    );
    expect(
      against(calm, [
        fish(id: 'edgy', temperament: Temperament.semiAggressive),
      ]).single.status,
      CheckStatus.caution,
    );
  });

  test(
    'a fish-eater with a smaller tankmate is a caution until a ratio is set',
    () {
      final hunter = fish(
        id: 'hunter',
        sizeIn: 4,
        flags: {AnimalFlag.eatsSmallFish: true},
      );
      final tiny = fish(id: 'tiny', sizeIn: 1);

      expect(against(tiny, [hunter]).single.status, CheckStatus.caution);
      expect(
        against(
          tiny,
          [hunter],
          config: const DomainConfig(predationSizeRatio: Sourced(0.5, 'test')),
        ).single.status,
        CheckStatus.fail,
      );
      expect(against(fish(id: 'big', sizeIn: 5), [hunter]), isEmpty);
    },
  );

  test('shrimp-eaters get a caution with shrimp', () {
    final shrimp = fish(id: 'shrimp', kind: AnimalKind.shrimp);
    final eater = fish(id: 'eater', flags: {AnimalFlag.eatsShrimp: true});

    expect(against(shrimp, [eater]).single.kind, CheckKind.eatsShrimp);
  });

  test('a fin nipper with long-finned fish fails both ways', () {
    final nipper = fish(id: 'nipper', flags: {AnimalFlag.finNipper: true});
    final flowing = fish(id: 'flowing', flags: {AnimalFlag.longFinned: true});

    expect(against(nipper, [flowing]).single.status, CheckStatus.fail);
    expect(against(flowing, [nipper]).single.status, CheckStatus.fail);
  });

  group('shrimp water', () {
    final neo = fish(
      id: 'neo',
      scientificName: 'Neocaridina fixturae',
      kind: AnimalKind.shrimp,
    );

    test('soft-water Caridina with Neocaridina fails', () {
      final soft = fish(
        id: 'soft',
        scientificName: 'Caridina fixturae',
        kind: AnimalKind.shrimp,
        reasons: [IntermediateReason.softWater],
      );

      expect(against(soft, [neo]).single.kind, CheckKind.shrimpWater);
      expect(against(neo, [soft]).single.status, CheckStatus.fail);
    });

    test('a Caridina without soft-water needs is fine with Neocaridina', () {
      final hardy = fish(
        id: 'hardy',
        scientificName: 'Caridina robusta',
        kind: AnimalKind.shrimp,
      );

      expect(against(hardy, [neo]), isEmpty);
    });
  });

  test('plant eaters and diggers are cautions when plants are stocked', () {
    final grazer = fish(
      id: 'grazer',
      commonName: 'Grazer',
      flags: {AnimalFlag.eatsPlants: true, AnimalFlag.digs: true},
    );
    final fern = plant(commonName: 'Fixture fern');

    expect(against(grazer, [], plants: [fern]).map((c) => c.reason), [
      'Grazer eats plants: Fixture fern.',
      'Grazer digs and may uproot Fixture fern.',
    ]);
    expect(against(grazer, []), isEmpty);
    expect(plantCompatibility(fern, animals: [grazer]), hasLength(2));
  });

  test('more of the same species is never a conflict with itself', () {
    final mean = fish(id: 'mean', temperament: Temperament.aggressive);
    expect(against(mean, [mean]), isEmpty);
  });
}
