import 'units.dart';

enum Tier { beginner, easyIntermediate, intermediate }

enum AnimalKind { fish, shrimp, snail }

enum Temperament { peaceful, semiAggressive, aggressive }

enum SwimLevel { top, middle, bottom, all }

enum LightLevel { low, medium, high }

enum Co2Need { notNeeded, helps, required }

enum GrowthRate { verySlow, slow, medium, fast, veryFast }

enum Placement { foreground, midground, background, floating }

enum AnimalFlag {
  finNipper,
  longFinned,
  eatsPlants,
  digs,
  eatsShrimp,
  eatsSmallFish,
  needsMatureTank,
  needsLiveFood,
  needsSand,
  stockQualityWarning,
}

enum IntermediateReason {
  matureTank,
  liveFood,
  softWater,
  territorial,
  equipment,
  poorCompetitor,
}

enum AvoidKind { animal, plant }

// A null max means open-ended, e.g. Tropica's "20+ cm" heights.
class Span {
  const Span(this.min, [this.max]);

  final double min;
  final double? max;
}

String formatSpan(Span span) {
  String n(double v) => formatNumber(double.parse(v.toStringAsFixed(1)));
  return span.max == null
      ? '${n(span.min)}+'
      : '${n(span.min)}–${n(span.max!)}';
}

// `source` is a key into the owning entry's `sources` map.
class Rated<T> {
  const Rated(this.value, this.source);

  final T value;
  final String source;
}

class RangeReport {
  const RangeReport({this.optimal, this.tolerated, required this.source});

  final Span? optimal;
  final Span? tolerated;
  final String source;
}

class TankSize {
  const TankSize({
    this.gallons,
    this.lengthCm,
    this.widthCm,
    required this.source,
  });

  final double? gallons;
  final double? lengthCm;
  final double? widthCm;
  final String source;
}

// Range lists hold one report per source, so disagreements are kept, not merged.
// An empty list means no source stated the value. GH and KH are in degrees (dGH, dKH).
class AnimalSpecies {
  const AnimalSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.kind,
    required this.tier,
    required this.sources,
    this.tempF = const [],
    this.ph = const [],
    this.gh = const [],
    this.kh = const [],
    this.adultSizeIn = const [],
    this.minTank = const [],
    this.minGroupSize,
    this.temperament,
    this.swimLevel,
    this.flags = const {},
    this.intermediateReasons = const [],
    this.notes,
  });

  final String id;
  final String commonName;
  final String scientificName;
  final AnimalKind kind;
  final Tier tier;
  final Map<String, String> sources;
  final List<RangeReport> tempF;
  final List<RangeReport> ph;
  final List<RangeReport> gh;
  final List<RangeReport> kh;
  final List<Rated<Span>> adultSizeIn;
  final List<TankSize> minTank;
  final Rated<int>? minGroupSize;
  final Rated<Temperament>? temperament;
  final Rated<SwimLevel>? swimLevel;
  final Map<AnimalFlag, Rated<bool>> flags;
  final List<IntermediateReason> intermediateReasons;
  final String? notes;
}

class PlantSpecies {
  const PlantSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.tier,
    required this.sources,
    this.tempF = const [],
    this.ph = const [],
    this.kh = const [],
    this.light = const [],
    this.co2 = const [],
    this.growthRate = const [],
    this.placement,
    this.epiphyte,
    this.rootFeeder,
    this.heightAfter2MonthsCm,
    this.careHeightCm,
    this.maxHeightCm,
    this.notes,
  });

  final String id;
  final String commonName;
  final String scientificName;
  final Tier tier;
  final Map<String, String> sources;
  final List<RangeReport> tempF;
  final List<RangeReport> ph;
  final List<RangeReport> kh;
  final List<Rated<LightLevel>> light;
  final List<Rated<Co2Need>> co2;
  final List<Rated<GrowthRate>> growthRate;
  final Rated<List<Placement>>? placement;
  final Rated<bool>? epiphyte;
  final Rated<bool>? rootFeeder;
  final Rated<Span>? heightAfter2MonthsCm;
  final Rated<Span>? careHeightCm;
  final Rated<Span>? maxHeightCm;
  final String? notes;
}

class AvoidEntry {
  const AvoidEntry({
    required this.scientificName,
    required this.commonNames,
    required this.kind,
    required this.reason,
    required this.sourceUrl,
  });

  final String scientificName;
  final List<String> commonNames;
  final AvoidKind kind;
  final String reason;
  final String sourceUrl;
}

class SpeciesCatalog {
  const SpeciesCatalog({
    this.animals = const [],
    this.plants = const [],
    this.avoid = const [],
  });

  final List<AnimalSpecies> animals;
  final List<PlantSpecies> plants;
  final List<AvoidEntry> avoid;
}

// The site's host reads better than a bare key like "sf" in a reason.
String sourceName(Map<String, String> sources, String key) {
  final host = Uri.tryParse(sources[key] ?? '')?.host ?? '';
  final name = host.startsWith('www.') ? host.substring(4) : host;
  return name.isEmpty ? key : name;
}
