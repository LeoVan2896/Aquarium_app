import 'dart:convert';
import 'dart:io';

import 'package:aquarium_app/domain/species.dart';
import 'package:aquarium_app/domain/species_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

// Made-up test data, never shipped. Values are arbitrary, not real care ranges.
Map<String, Object?> fixtureAnimal() => {
  'id': 'fixture-tetra',
  'commonName': 'Fixture tetra',
  'scientificName': 'Fixturus testii',
  'kind': 'fish',
  'tier': 'beginner',
  'sources': {
    'a': 'https://example.test/fixture-tetra',
    'b': 'https://example.test/other',
  },
  'tempF': [
    {
      'optimal': [72, 76],
      'tolerated': [68, 80],
      'source': 'a',
    },
    {
      'tolerated': [70, 82],
      'source': 'b',
    },
  ],
  'ph': [
    {
      'tolerated': [6, 7.5],
      'source': 'a',
    },
  ],
  'adultSizeIn': [
    {
      'value': [1, 1.5],
      'source': 'a',
    },
  ],
  'minTank': [
    {'lengthCm': 60, 'widthCm': 30, 'source': 'a'},
    {'gallons': 10, 'source': 'b'},
  ],
  'minGroupSize': {'value': 8, 'source': 'a'},
  'temperament': {'value': 'peaceful', 'source': 'a'},
  'flags': {
    'needsMatureTank': {'value': true, 'source': 'a'},
    'eatsShrimp': {'value': false, 'source': 'b'},
  },
  'intermediateReasons': ['softWater'],
};

Map<String, Object?> fixturePlant() => {
  'id': 'fixture-fern',
  'commonName': 'Fixture fern',
  'scientificName': 'Testaria plantae',
  'tier': 'beginner',
  'sources': {'t': 'https://example.test/fixture-fern'},
  'light': [
    {'value': 'low', 'source': 't'},
    {'value': 'medium', 'source': 't'},
  ],
  'co2': [
    {'value': 'notNeeded', 'source': 't'},
  ],
  'placement': {
    'value': ['midground', 'background'],
    'source': 't',
  },
  'epiphyte': {'value': true, 'source': 't'},
  'heightAfter2MonthsCm': {
    'value': [20],
    'source': 't',
  },
};

Map<String, Object?> fixtureAvoid() => {
  'scientificName': 'Avoidus giganticus',
  'commonNames': ['Fixture giant'],
  'kind': 'animal',
  'reason': 'Outgrows home tanks.',
  'sourceUrl': 'https://example.test/avoid',
};

SpeciesCatalog parse({
  List<Object?>? animals,
  List<Object?>? plants,
  List<Object?>? avoid,
}) => parseCatalog(
  animals: animals ?? [fixtureAnimal()],
  plants: plants ?? [fixturePlant()],
  avoid: avoid ?? [fixtureAvoid()],
);

List<String> issuesFor({
  List<Object?>? animals,
  List<Object?>? plants,
  List<Object?>? avoid,
}) => validateCatalog(parse(animals: animals, plants: plants, avoid: avoid));

Matcher formatError(String path) => throwsA(
  isA<FormatException>().having((e) => e.message, 'message', startsWith(path)),
);

void main() {
  group('parsing', () {
    test('reads a full animal entry and keeps both sources\' ranges', () {
      final a = parse().animals.single;

      expect(a.kind, AnimalKind.fish);
      expect(a.tempF, hasLength(2));
      expect(a.tempF[0].optimal!.min, 72);
      expect(a.tempF[0].tolerated!.max, 80);
      expect(a.tempF[1].optimal, isNull);
      expect(a.tempF[1].source, 'b');
      expect(a.minTank[0].lengthCm, 60);
      expect(a.minTank[1].gallons, 10);
      expect(a.minGroupSize!.value, 8);
      expect(a.temperament!.value, Temperament.peaceful);
      expect(a.flags[AnimalFlag.needsMatureTank]!.value, isTrue);
      expect(a.flags[AnimalFlag.eatsShrimp]!.value, isFalse);
      expect(a.intermediateReasons, [IntermediateReason.softWater]);
    });

    test('fields no source stated stay empty or null, never defaulted', () {
      final a = parse().animals.single;

      expect(a.gh, isEmpty);
      expect(a.kh, isEmpty);
      expect(a.swimLevel, isNull);
      expect(a.flags.containsKey(AnimalFlag.finNipper), isFalse);
    });

    test('reads a plant entry with an open-ended height', () {
      final p = parse().plants.single;

      expect(p.light.map((r) => r.value), [LightLevel.low, LightLevel.medium]);
      expect(p.co2.single.value, Co2Need.notNeeded);
      expect(p.placement!.value, [Placement.midground, Placement.background]);
      expect(p.epiphyte!.value, isTrue);
      expect(p.heightAfter2MonthsCm!.value.min, 20);
      expect(p.heightAfter2MonthsCm!.value.max, isNull);
    });

    test('reads an avoid entry', () {
      final e = parse().avoid.single;

      expect(e.kind, AvoidKind.animal);
      expect(e.commonNames, ['Fixture giant']);
    });

    test('a misspelled field fails with its path', () {
      expect(
        () => parse(animals: [fixtureAnimal()..['tempf'] = []]),
        formatError('animals[0].tempf'),
      );
    });

    test('an unknown enum value fails and lists the allowed ones', () {
      expect(
        () => parse(animals: [fixtureAnimal()..['kind'] = 'crab']),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'animals[0].kind: expected one of fish, shrimp, snail',
          ),
        ),
      );
    });

    test('wrong types fail with the path to the bad value', () {
      expect(
        () => parse(
          animals: [
            fixtureAnimal()
              ..['minGroupSize'] = {'value': 'eight', 'source': 'a'},
          ],
        ),
        formatError('animals[0].minGroupSize.value'),
      );
      expect(
        () => parse(
          animals: [
            fixtureAnimal()
              ..['ph'] = [
                {
                  'tolerated': [1, 2, 3],
                  'source': 'a',
                },
              ],
          ],
        ),
        formatError('animals[0].ph[0].tolerated'),
      );
    });
  });

  group('validation', () {
    test('the fixture catalog has no issues', () {
      expect(issuesFor(), isEmpty);
    });

    test('an entry with no sources is rejected', () {
      expect(
        issuesFor(
          plants: [
            fixturePlant()
              ..['sources'] = <String, String>{}
              ..remove('light')
              ..remove('co2')
              ..remove('placement')
              ..remove('epiphyte')
              ..remove('heightAfter2MonthsCm'),
          ],
        ),
        ['plants/fixture-fern: has no sources'],
      );
    });

    test('a value citing a source the entry does not list is rejected', () {
      expect(
        issuesFor(
          animals: [
            fixtureAnimal()
              ..['temperament'] = {'value': 'peaceful', 'source': 'z'},
          ],
        ),
        ['animals/fixture-tetra.temperament: unknown source "z"'],
      );
    });

    test('a source that is not a URL is rejected', () {
      expect(
        issuesFor(
          animals: [
            fixtureAnimal()
              ..['sources'] = {
                'a': 'Seriously Fish',
                'b': 'https://example.test/b',
              },
          ],
        ),
        ['animals/fixture-tetra.sources.a: not a URL'],
      );
    });

    test('min above max is rejected', () {
      expect(
        issuesFor(
          animals: [
            fixtureAnimal()
              ..['ph'] = [
                {
                  'tolerated': [7.5, 6],
                  'source': 'a',
                },
              ],
          ],
        ),
        ['animals/fixture-tetra.ph[0].tolerated: min is above max'],
      );
    });

    test('a water range must be closed and have optimal or tolerated', () {
      expect(
        issuesFor(
          animals: [
            fixtureAnimal()
              ..['ph'] = [
                {
                  'tolerated': [6],
                  'source': 'a',
                },
                {'source': 'a'},
              ],
          ],
        ),
        [
          'animals/fixture-tetra.ph[0].tolerated: needs both min and max',
          'animals/fixture-tetra.ph[1]: needs optimal or tolerated',
        ],
      );
    });

    test('an optimal range wider than tolerated is rejected', () {
      expect(
        issuesFor(
          animals: [
            fixtureAnimal()
              ..['tempF'] = [
                {
                  'optimal': [66, 76],
                  'tolerated': [68, 80],
                  'source': 'a',
                },
              ],
          ],
        ),
        ['animals/fixture-tetra.tempF[0]: optimal is outside tolerated'],
      );
    });

    test('a tank size with no gallons or dimensions is rejected', () {
      expect(
        issuesFor(
          animals: [
            fixtureAnimal()
              ..['minTank'] = [
                {'source': 'a'},
              ],
          ],
        ),
        ['animals/fixture-tetra.minTank[0]: needs gallons or dimensions'],
      );
    });

    test('duplicate ids and scientific names are rejected across kinds', () {
      final twin = fixturePlant()
        ..['id'] = 'fixture-tetra'
        ..['scientificName'] = 'FIXTURUS TESTII';

      expect(issuesFor(plants: [twin]), [
        'plants/fixture-tetra: duplicate id "fixture-tetra"',
        'plants/fixture-tetra: duplicate scientificName "FIXTURUS TESTII"',
      ]);
    });

    test('a species cannot be both recommended and on the avoid list', () {
      expect(
        issuesFor(
          avoid: [fixtureAvoid()..['scientificName'] = 'Fixturus testii'],
        ),
        [
          'avoid[0]: "Fixturus testii" is also in the catalog as a recommendation',
        ],
      );
    });

    test('an avoid entry needs a reason and a source URL', () {
      expect(
        issuesFor(
          avoid: [
            fixtureAvoid()
              ..['reason'] = ' '
              ..['sourceUrl'] = '',
          ],
        ),
        ['avoid[0]: reason is empty', 'avoid[0]: sourceUrl is not a URL'],
      );
    });
  });

  group('loading', () {
    test('an invalid catalog throws with every issue listed', () async {
      final files = {
        animalsAsset: jsonEncode([
          fixtureAnimal()..['sources'] = {'a': 'nope', 'b': 'nope'},
        ]),
        plantsAsset: '[]',
        avoidAsset: '[]',
      };

      await expectLater(
        loadSpeciesCatalog((path) async => files[path]!),
        throwsA(
          isA<CatalogException>().having((e) => e.issues, 'issues', [
            'animals/fixture-tetra.sources.a: not a URL',
            'animals/fixture-tetra.sources.b: not a URL',
          ]),
        ),
      );
    });

    test('the shipped catalog assets load and validate', () async {
      final catalog = await loadSpeciesCatalog(
        (path) => File(path).readAsString(),
      );

      expect(catalog, isA<SpeciesCatalog>());
    });
  });
}
