import 'config.dart';
import 'fit_checks.dart';
import 'species.dart';
import 'units.dart';

// Returns only problems: an empty list means no known conflict with the stock.
List<Check> animalCompatibility(
  AnimalSpecies candidate, {
  required Iterable<AnimalSpecies> animals,
  required Iterable<PlantSpecies> plants,
  DomainConfig config = const DomainConfig(),
}) {
  final checks = <Check>[];
  for (final other in animals) {
    if (other.id == candidate.id) continue;
    checks.addAll([
      ?_temperatureOverlap(candidate, other),
      ?_temperament(candidate, other),
      ?_predation(candidate, other, config),
      ?_predation(other, candidate, config),
      ?_eatsShrimp(candidate, other),
      ?_eatsShrimp(other, candidate),
      ?_finNipping(candidate, other),
      ?_finNipping(other, candidate),
      ?_shrimpWater(candidate, other),
    ]);
  }
  final plantNames = [for (final p in plants) p.commonName];
  if (plantNames.isNotEmpty) checks.addAll(_plantDamage(candidate, plantNames));
  return checks;
}

List<Check> plantCompatibility(
  PlantSpecies candidate, {
  required Iterable<AnimalSpecies> animals,
}) => [
  for (final a in animals) ..._plantDamage(a, [candidate.commonName]),
];

Check? _temperatureOverlap(AnimalSpecies a, AnimalSpecies b) {
  final spanA = _preferredTemp(a);
  final spanB = _preferredTemp(b);
  if (spanA == null || spanB == null) return null;
  final overlaps = spanA.min <= spanB.max! && spanB.min <= spanA.max!;
  if (overlaps) return null;
  return Check(
    CheckKind.temperatureOverlap,
    CheckStatus.fail,
    '${a.commonName} wants ${_range(spanA)}°F and ${b.commonName} wants ${_range(spanB)}°F; there\'s no temperature that suits both.',
  );
}

// The first report is the highest-priority source; its ideal range if given.
Span? _preferredTemp(AnimalSpecies s) =>
    s.tempF.isEmpty ? null : s.tempF.first.optimal ?? s.tempF.first.tolerated;

Check? _temperament(AnimalSpecies a, AnimalSpecies b) {
  final ta = a.temperament?.value;
  final tb = b.temperament?.value;
  if (ta == null || tb == null) return null;
  final pair = {ta, tb};
  if (!pair.contains(Temperament.peaceful) || pair.length == 1) return null;
  final rougher = ta == Temperament.peaceful ? b : a;
  final gentle = ta == Temperament.peaceful ? a : b;
  return pair.contains(Temperament.aggressive)
      ? Check(
          CheckKind.temperament,
          CheckStatus.fail,
          '${rougher.commonName} is aggressive; ${gentle.commonName} is peaceful.',
        )
      : Check(
          CheckKind.temperament,
          CheckStatus.caution,
          '${rougher.commonName} is semi-aggressive; ${gentle.commonName} is peaceful.',
        );
}

Check? _predation(
  AnimalSpecies predator,
  AnimalSpecies prey,
  DomainConfig config,
) {
  if (predator.flags[AnimalFlag.eatsSmallFish]?.value != true) return null;
  final predatorSize = _adultSize(predator);
  final preySize = _adultSize(prey);
  if (predatorSize == null || preySize == null || preySize >= predatorSize) {
    return null;
  }
  final ratio = config.predationSizeRatio.value;
  if (ratio != null && preySize <= ratio * predatorSize) {
    return Check(
      CheckKind.predation,
      CheckStatus.fail,
      '${predator.commonName} eats small fish, and ${prey.commonName} is small enough to be eaten.',
    );
  }
  return Check(
    CheckKind.predation,
    CheckStatus.caution,
    '${predator.commonName} eats small fish, and ${prey.commonName} is smaller than it.',
  );
}

double? _adultSize(AnimalSpecies s) {
  if (s.adultSizeIn.isEmpty) return null;
  final span = s.adultSizeIn.first.value;
  return span.max ?? span.min;
}

Check? _eatsShrimp(AnimalSpecies eater, AnimalSpecies shrimp) {
  if (eater.flags[AnimalFlag.eatsShrimp]?.value != true ||
      shrimp.kind != AnimalKind.shrimp) {
    return null;
  }
  return Check(
    CheckKind.eatsShrimp,
    CheckStatus.caution,
    '${eater.commonName} is known to eat small shrimp like ${shrimp.commonName}.',
  );
}

Check? _finNipping(AnimalSpecies nipper, AnimalSpecies target) {
  if (nipper.flags[AnimalFlag.finNipper]?.value != true ||
      target.flags[AnimalFlag.longFinned]?.value != true) {
    return null;
  }
  return Check(
    CheckKind.finNipping,
    CheckStatus.fail,
    '${nipper.commonName} nips fins, and ${target.commonName} has long fins.',
  );
}

// Soft-water Caridina (crystal reds) can't share the harder water Neocaridina
// need. Amano shrimp are Caridina too but aren't soft-water, so the rule keys
// on the softWater reason, not the genus alone.
Check? _shrimpWater(AnimalSpecies a, AnimalSpecies b) {
  bool softCaridina(AnimalSpecies s) =>
      _genus(s) == 'caridina' &&
      s.intermediateReasons.contains(IntermediateReason.softWater);
  bool neocaridina(AnimalSpecies s) => _genus(s) == 'neocaridina';

  final (soft, hard) = softCaridina(a) && neocaridina(b)
      ? (a, b)
      : softCaridina(b) && neocaridina(a)
      ? (b, a)
      : (null, null);
  if (soft == null || hard == null) return null;
  return Check(
    CheckKind.shrimpWater,
    CheckStatus.fail,
    '${soft.commonName} needs soft water that ${hard.commonName} can\'t live in.',
  );
}

String _genus(AnimalSpecies s) =>
    s.scientificName.trim().split(' ').first.toLowerCase();

List<Check> _plantDamage(AnimalSpecies animal, List<String> plantNames) {
  final names = plantNames.join(', ');
  return [
    if (animal.flags[AnimalFlag.eatsPlants]?.value == true)
      Check(
        CheckKind.plantDamage,
        CheckStatus.caution,
        '${animal.commonName} eats plants: $names.',
      ),
    if (animal.flags[AnimalFlag.digs]?.value == true)
      Check(
        CheckKind.plantDamage,
        CheckStatus.caution,
        '${animal.commonName} digs and may uproot $names.',
      ),
  ];
}

String _range(Span span) =>
    '${formatNumber(span.min)}–${formatNumber(span.max!)}';
