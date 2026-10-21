import 'compatibility.dart';
import 'config.dart';
import 'enums.dart';
import 'fit_checks.dart';
import 'species.dart';
import 'tank_conditions.dart';

class Recommendation {
  Recommendation(this.species, this.checks, this.hints);

  // AnimalSpecies or PlantSpecies.
  final Object species;
  final List<Check> checks;

  // What the user could log or enter to turn an unknown into a verdict.
  final List<String> hints;

  late final int fails = _count(CheckStatus.fail);
  late final int cautions = _count(CheckStatus.caution);
  late final int unknowns = _count(CheckStatus.unknown);

  bool get passesAll => fails == 0 && cautions == 0 && unknowns == 0;

  String get commonName => switch (species) {
    AnimalSpecies a => a.commonName,
    PlantSpecies p => p.commonName,
    _ => '',
  };

  int _count(CheckStatus s) => checks.where((c) => c.status == s).length;
}

// An unknown only gets a hint when the tank side is missing; a gap in the
// sources can't be fixed by logging anything.
List<String> _hints(
  Object species,
  List<Check> checks,
  TankSetup setup,
  TankConditions conditions,
) {
  bool sourced(CheckKind kind) => switch ((species, kind)) {
    (AnimalSpecies a, CheckKind.temperature) => a.tempF.isNotEmpty,
    (AnimalSpecies a, CheckKind.ph) => a.ph.isNotEmpty,
    (AnimalSpecies a, CheckKind.gh) => a.gh.isNotEmpty,
    (AnimalSpecies a, CheckKind.kh) => a.kh.isNotEmpty,
    (AnimalSpecies a, CheckKind.tankSize) => a.minTank.isNotEmpty,
    (PlantSpecies p, CheckKind.temperature) => p.tempF.isNotEmpty,
    (PlantSpecies p, CheckKind.ph) => p.ph.isNotEmpty,
    (PlantSpecies p, CheckKind.kh) => p.kh.isNotEmpty,
    (PlantSpecies p, CheckKind.light) => p.light.isNotEmpty,
    _ => false,
  };

  String? hint(CheckKind kind) => !sourced(kind)
      ? null
      : switch (kind) {
          CheckKind.temperature when conditions.tempF == null =>
            'Log a temperature',
          CheckKind.ph when conditions.ph == null => 'Log a pH reading',
          CheckKind.gh when conditions.gh == null => 'Log a GH reading',
          CheckKind.kh when conditions.kh == null => 'Log a KH reading',
          CheckKind.tankSize
              when setup.lengthIn == null || setup.widthIn == null =>
            "Enter your tank's length and width",
          CheckKind.light when setup.lightLevel == null =>
            "Set your tank's light strength",
          _ => null,
        };
  return {
    for (final c in checks)
      if (c.status == CheckStatus.unknown) ?hint(c.kind),
  }.toList();
}

// Species already in the tank are left out; this answers "what could I add?".
List<Recommendation> recommend({
  required SpeciesCatalog catalog,
  required SpeciesType type,
  required TankSetup setup,
  required TankConditions conditions,
  required Maturity maturity,
  required DateTime now,
  required List<AnimalSpecies> stockedAnimals,
  required List<PlantSpecies> stockedPlants,
  DomainConfig config = const DomainConfig(),
}) {
  final stockedIds = {
    for (final a in stockedAnimals) a.id,
    for (final p in stockedPlants) p.id,
  };
  final List<(Object, List<Check>)> evaluated = switch (type) {
    SpeciesType.animal => [
      for (final a in catalog.animals)
        if (!stockedIds.contains(a.id))
          (
            a,
            [
              ...animalFit(
                a,
                setup: setup,
                conditions: conditions,
                maturity: maturity,
                now: now,
                plannedCount: a.minGroupSize?.value ?? 1,
                config: config,
              ),
              ...animalCompatibility(
                a,
                animals: stockedAnimals,
                plants: stockedPlants,
                config: config,
              ),
            ],
          ),
    ],
    SpeciesType.plant => [
      for (final p in catalog.plants)
        if (!stockedIds.contains(p.id))
          (
            p,
            [
              ...plantFit(
                p,
                setup: setup,
                conditions: conditions,
                config: config,
              ),
              ...plantCompatibility(p, animals: stockedAnimals),
            ],
          ),
    ],
  };
  final results = [
    for (final (species, checks) in evaluated)
      Recommendation(
        species,
        checks,
        _hints(species, checks, setup, conditions),
      ),
  ];
  return results..sort(
    (a, b) => [
      a.fails.compareTo(b.fails),
      a.cautions.compareTo(b.cautions),
      a.unknowns.compareTo(b.unknowns),
      a.commonName.toLowerCase().compareTo(b.commonName.toLowerCase()),
    ].firstWhere((c) => c != 0, orElse: () => 0),
  );
}

class SpeciesAlert {
  const SpeciesAlert(this.speciesName, this.check);

  final String speciesName;
  final Check check;
}

const _waterKinds = {
  CheckKind.temperature,
  CheckKind.ph,
  CheckKind.gh,
  CheckKind.kh,
};

// Only measured values raise alerts: a target or room temperature is not a reading.
List<SpeciesAlert> speciesAlerts({
  required List<AnimalSpecies> animals,
  required List<PlantSpecies> plants,
  required TankSetup setup,
  required TankConditions conditions,
  DomainConfig config = const DomainConfig(),
}) {
  final measured = TankConditions(
    tempF: conditions.tempF?.source == ConditionSource.reading
        ? conditions.tempF
        : null,
    ph: conditions.ph,
    gh: conditions.gh,
    kh: conditions.kh,
  );
  List<SpeciesAlert> from(String name, List<Check> checks) => [
    for (final c in checks)
      if (_waterKinds.contains(c.kind) &&
          (c.status == CheckStatus.fail || c.status == CheckStatus.caution))
        SpeciesAlert(name, c),
  ];
  return [
    for (final a in animals)
      ...from(
        a.commonName,
        animalFit(
          a,
          setup: setup,
          conditions: measured,
          maturity: const Maturity(),
          now: DateTime.utc(0),
          config: config,
        ),
      ),
    for (final p in plants)
      ...from(
        p.commonName,
        plantFit(p, setup: setup, conditions: measured, config: config),
      ),
  ];
}

// Which of pH, GH and KH have no reading recent enough to count.
List<String> staleWaterTests(TankConditions conditions) => [
  if (conditions.ph == null) 'pH',
  if (conditions.gh == null) 'GH',
  if (conditions.kh == null) 'KH',
];
