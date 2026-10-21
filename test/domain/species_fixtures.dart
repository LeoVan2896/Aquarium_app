import 'package:aquarium_app/domain/species.dart';

// Made-up species for tests only. Values are arbitrary, not real care ranges.
const fixtureSources = {
  'a': 'https://www.example.test/a',
  'b': 'https://example.test/b',
};

RangeReport range(
  double min,
  double max, {
  Span? tolerated,
  String source = 'a',
}) =>
    RangeReport(optimal: Span(min, max), tolerated: tolerated, source: source);

AnimalSpecies fish({
  String id = 'fixture-fish',
  String commonName = 'Fixture fish',
  String scientificName = 'Fixturus piscis',
  AnimalKind kind = AnimalKind.fish,
  List<RangeReport> tempF = const [],
  List<RangeReport> ph = const [],
  List<RangeReport> gh = const [],
  List<TankSize> minTank = const [],
  int? minGroupSize,
  Temperament? temperament,
  double? sizeIn,
  Map<AnimalFlag, bool> flags = const {},
  List<IntermediateReason> reasons = const [],
}) => AnimalSpecies(
  id: id,
  commonName: commonName,
  scientificName: scientificName,
  kind: kind,
  tier: Tier.beginner,
  sources: fixtureSources,
  tempF: tempF,
  ph: ph,
  gh: gh,
  minTank: minTank,
  minGroupSize: minGroupSize == null ? null : Rated(minGroupSize, 'a'),
  temperament: temperament == null ? null : Rated(temperament, 'a'),
  adultSizeIn: sizeIn == null ? const [] : [Rated(Span(sizeIn), 'a')],
  flags: {for (final e in flags.entries) e.key: Rated(e.value, 'a')},
  intermediateReasons: reasons,
);

PlantSpecies plant({
  String id = 'fixture-plant',
  String commonName = 'Fixture plant',
  List<LightLevel> light = const [],
  List<Co2Need> co2 = const [],
  bool? rootFeeder,
}) => PlantSpecies(
  id: id,
  commonName: commonName,
  scientificName: 'Fixturus planta',
  tier: Tier.beginner,
  sources: fixtureSources,
  light: [for (final l in light) Rated(l, 'a')],
  co2: [for (final c in co2) Rated(c, 'a')],
  rootFeeder: rootFeeder == null ? null : Rated(rootFeeder, 'a'),
);
