import 'dart:convert';

import 'species.dart';

const animalsAsset = 'assets/species/animals.json';
const plantsAsset = 'assets/species/plants.json';
const avoidAsset = 'assets/species/avoid.json';

class CatalogException implements Exception {
  const CatalogException(this.issues);

  final List<String> issues;

  @override
  String toString() => 'Species catalog is invalid:\n${issues.join('\n')}';
}

Future<SpeciesCatalog> loadSpeciesCatalog(
  Future<String> Function(String path) read,
) async {
  final catalog = parseCatalog(
    animals: jsonDecode(await read(animalsAsset)),
    plants: jsonDecode(await read(plantsAsset)),
    avoid: jsonDecode(await read(avoidAsset)),
  );
  final issues = validateCatalog(catalog);
  if (issues.isNotEmpty) throw CatalogException(issues);
  return catalog;
}

SpeciesCatalog parseCatalog({
  required Object? animals,
  required Object? plants,
  required Object? avoid,
}) => SpeciesCatalog(
  animals: _list(animals, 'animals', _animal),
  plants: _list(plants, 'plants', _plant),
  avoid: _list(avoid, 'avoid', _avoidEntry),
);

List<String> validateCatalog(SpeciesCatalog catalog) {
  final issues = <String>[];
  final ids = <String>{};
  final names = <String>{};

  void common(
    String where,
    String id,
    String commonName,
    String scientificName,
    Map<String, String> sources,
  ) {
    if (id.trim().isEmpty) issues.add('$where: id is empty');
    if (!ids.add(id)) issues.add('$where: duplicate id "$id"');
    if (commonName.trim().isEmpty) issues.add('$where: commonName is empty');
    if (scientificName.trim().isEmpty) {
      issues.add('$where: scientificName is empty');
    } else if (!names.add(scientificName.trim().toLowerCase())) {
      issues.add('$where: duplicate scientificName "$scientificName"');
    }
    if (sources.isEmpty) issues.add('$where: has no sources');
    sources.forEach((key, url) {
      if (!_isUrl(url)) issues.add('$where.sources.$key: not a URL');
    });
  }

  void ref(String where, String source, Map<String, String> sources) {
    if (!sources.containsKey(source)) {
      issues.add('$where: unknown source "$source"');
    }
  }

  void span(String where, Span span, {required bool closed}) {
    final max = span.max;
    if (max == null) {
      if (closed) issues.add('$where: needs both min and max');
    } else if (span.min > max) {
      issues.add('$where: min is above max');
    }
  }

  void ranges(
    String where,
    List<RangeReport> reports,
    Map<String, String> sources,
  ) {
    for (var i = 0; i < reports.length; i++) {
      final r = reports[i];
      final at = '$where[$i]';
      ref(at, r.source, sources);
      final optimal = r.optimal;
      final tolerated = r.tolerated;
      if (optimal == null && tolerated == null) {
        issues.add('$at: needs optimal or tolerated');
      }
      if (optimal != null) span('$at.optimal', optimal, closed: true);
      if (tolerated != null) span('$at.tolerated', tolerated, closed: true);
      if (optimal != null &&
          tolerated != null &&
          optimal.max != null &&
          tolerated.max != null &&
          (optimal.min < tolerated.min || optimal.max! > tolerated.max!)) {
        issues.add('$at: optimal is outside tolerated');
      }
    }
  }

  void rated<T>(String where, Rated<T>? r, Map<String, String> sources) {
    if (r != null) ref(where, r.source, sources);
  }

  for (final a in catalog.animals) {
    final w = 'animals/${a.id}';
    final s = a.sources;
    common(w, a.id, a.commonName, a.scientificName, s);
    ranges('$w.tempF', a.tempF, s);
    ranges('$w.ph', a.ph, s);
    ranges('$w.gh', a.gh, s);
    ranges('$w.kh', a.kh, s);
    for (var i = 0; i < a.adultSizeIn.length; i++) {
      final size = a.adultSizeIn[i];
      ref('$w.adultSizeIn[$i]', size.source, s);
      span('$w.adultSizeIn[$i]', size.value, closed: false);
    }
    for (var i = 0; i < a.minTank.length; i++) {
      final t = a.minTank[i];
      ref('$w.minTank[$i]', t.source, s);
      if (t.gallons == null && t.lengthCm == null && t.widthCm == null) {
        issues.add('$w.minTank[$i]: needs gallons or dimensions');
      }
    }
    rated('$w.minGroupSize', a.minGroupSize, s);
    rated('$w.temperament', a.temperament, s);
    rated('$w.swimLevel', a.swimLevel, s);
    a.flags.forEach((flag, r) => rated('$w.flags.${flag.name}', r, s));
  }

  for (final p in catalog.plants) {
    final w = 'plants/${p.id}';
    final s = p.sources;
    common(w, p.id, p.commonName, p.scientificName, s);
    ranges('$w.tempF', p.tempF, s);
    ranges('$w.ph', p.ph, s);
    ranges('$w.kh', p.kh, s);
    for (final r in p.light) {
      rated('$w.light', r, s);
    }
    for (final r in p.co2) {
      rated('$w.co2', r, s);
    }
    for (final r in p.growthRate) {
      rated('$w.growthRate', r, s);
    }
    rated('$w.placement', p.placement, s);
    rated('$w.epiphyte', p.epiphyte, s);
    rated('$w.rootFeeder', p.rootFeeder, s);
    for (final (field, height) in [
      ('heightAfter2MonthsCm', p.heightAfter2MonthsCm),
      ('careHeightCm', p.careHeightCm),
      ('maxHeightCm', p.maxHeightCm),
    ]) {
      if (height == null) continue;
      ref('$w.$field', height.source, s);
      span('$w.$field', height.value, closed: false);
    }
  }

  for (var i = 0; i < catalog.avoid.length; i++) {
    final e = catalog.avoid[i];
    final w = 'avoid[$i]';
    if (e.scientificName.trim().isEmpty) {
      issues.add('$w: scientificName is empty');
    } else if (names.contains(e.scientificName.trim().toLowerCase())) {
      issues.add(
        '$w: "${e.scientificName}" is also in the catalog as a recommendation',
      );
    }
    if (e.reason.trim().isEmpty) issues.add('$w: reason is empty');
    if (!_isUrl(e.sourceUrl)) issues.add('$w: sourceUrl is not a URL');
  }

  return issues;
}

bool _isUrl(String value) {
  final uri = Uri.tryParse(value);
  return uri != null &&
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.host.isNotEmpty;
}

AnimalSpecies _animal(Object? json, String path) {
  final o = _object(json, path, const {
    'id',
    'commonName',
    'scientificName',
    'kind',
    'tier',
    'sources',
    'tempF',
    'ph',
    'gh',
    'kh',
    'adultSizeIn',
    'minTank',
    'minGroupSize',
    'temperament',
    'swimLevel',
    'flags',
    'intermediateReasons',
    'notes',
  });
  return AnimalSpecies(
    id: _string(o, 'id', path),
    commonName: _string(o, 'commonName', path),
    scientificName: _string(o, 'scientificName', path),
    kind: _enum(AnimalKind.values, o['kind'], '$path.kind'),
    tier: _enum(Tier.values, o['tier'], '$path.tier'),
    sources: _sources(o['sources'], '$path.sources'),
    tempF: _optionalList(o['tempF'], '$path.tempF', _range),
    ph: _optionalList(o['ph'], '$path.ph', _range),
    gh: _optionalList(o['gh'], '$path.gh', _range),
    kh: _optionalList(o['kh'], '$path.kh', _range),
    adultSizeIn: _optionalList(
      o['adultSizeIn'],
      '$path.adultSizeIn',
      (j, p) => _rated(j, p, _span),
    ),
    minTank: _optionalList(o['minTank'], '$path.minTank', _tankSize),
    minGroupSize: _optionalRated(o['minGroupSize'], '$path.minGroupSize', _int),
    temperament: _optionalRated(
      o['temperament'],
      '$path.temperament',
      (j, p) => _enum(Temperament.values, j, p),
    ),
    swimLevel: _optionalRated(
      o['swimLevel'],
      '$path.swimLevel',
      (j, p) => _enum(SwimLevel.values, j, p),
    ),
    flags: _flags(o['flags'], '$path.flags'),
    intermediateReasons: _optionalList(
      o['intermediateReasons'],
      '$path.intermediateReasons',
      (j, p) => _enum(IntermediateReason.values, j, p),
    ),
    notes: _optionalString(o, 'notes', path),
  );
}

PlantSpecies _plant(Object? json, String path) {
  final o = _object(json, path, const {
    'id',
    'commonName',
    'scientificName',
    'tier',
    'sources',
    'tempF',
    'ph',
    'kh',
    'light',
    'co2',
    'growthRate',
    'placement',
    'epiphyte',
    'rootFeeder',
    'heightAfter2MonthsCm',
    'careHeightCm',
    'maxHeightCm',
    'notes',
  });
  return PlantSpecies(
    id: _string(o, 'id', path),
    commonName: _string(o, 'commonName', path),
    scientificName: _string(o, 'scientificName', path),
    tier: _enum(Tier.values, o['tier'], '$path.tier'),
    sources: _sources(o['sources'], '$path.sources'),
    tempF: _optionalList(o['tempF'], '$path.tempF', _range),
    ph: _optionalList(o['ph'], '$path.ph', _range),
    kh: _optionalList(o['kh'], '$path.kh', _range),
    light: _optionalList(
      o['light'],
      '$path.light',
      (j, p) => _rated(j, p, (v, vp) => _enum(LightLevel.values, v, vp)),
    ),
    co2: _optionalList(
      o['co2'],
      '$path.co2',
      (j, p) => _rated(j, p, (v, vp) => _enum(Co2Need.values, v, vp)),
    ),
    growthRate: _optionalList(
      o['growthRate'],
      '$path.growthRate',
      (j, p) => _rated(j, p, (v, vp) => _enum(GrowthRate.values, v, vp)),
    ),
    placement: _optionalRated(
      o['placement'],
      '$path.placement',
      (j, p) => _list(j, p, (v, vp) => _enum(Placement.values, v, vp)),
    ),
    epiphyte: _optionalRated(o['epiphyte'], '$path.epiphyte', _bool),
    rootFeeder: _optionalRated(o['rootFeeder'], '$path.rootFeeder', _bool),
    heightAfter2MonthsCm: _optionalRated(
      o['heightAfter2MonthsCm'],
      '$path.heightAfter2MonthsCm',
      _span,
    ),
    careHeightCm: _optionalRated(
      o['careHeightCm'],
      '$path.careHeightCm',
      _span,
    ),
    maxHeightCm: _optionalRated(o['maxHeightCm'], '$path.maxHeightCm', _span),
    notes: _optionalString(o, 'notes', path),
  );
}

AvoidEntry _avoidEntry(Object? json, String path) {
  final o = _object(json, path, const {
    'scientificName',
    'commonNames',
    'kind',
    'reason',
    'sourceUrl',
  });
  return AvoidEntry(
    scientificName: _string(o, 'scientificName', path),
    commonNames: _list(
      o['commonNames'],
      '$path.commonNames',
      (j, p) => _text(j, p),
    ),
    kind: _enum(AvoidKind.values, o['kind'], '$path.kind'),
    reason: _string(o, 'reason', path),
    sourceUrl: _string(o, 'sourceUrl', path),
  );
}

RangeReport _range(Object? json, String path) {
  final o = _object(json, path, const {'optimal', 'tolerated', 'source'});
  return RangeReport(
    optimal: o['optimal'] == null ? null : _span(o['optimal'], '$path.optimal'),
    tolerated: o['tolerated'] == null
        ? null
        : _span(o['tolerated'], '$path.tolerated'),
    source: _string(o, 'source', path),
  );
}

TankSize _tankSize(Object? json, String path) {
  final o = _object(json, path, const {
    'gallons',
    'lengthCm',
    'widthCm',
    'source',
  });
  double? optional(String key) =>
      o[key] == null ? null : _number(o[key], '$path.$key');
  return TankSize(
    gallons: optional('gallons'),
    lengthCm: optional('lengthCm'),
    widthCm: optional('widthCm'),
    source: _string(o, 'source', path),
  );
}

Map<String, String> _sources(Object? json, String path) {
  final o = _object(json, path);
  return {for (final e in o.entries) e.key: _text(e.value, '$path.${e.key}')};
}

Map<AnimalFlag, Rated<bool>> _flags(Object? json, String path) {
  if (json == null) return const {};
  final o = _object(json, path);
  return {
    for (final e in o.entries)
      _enum(AnimalFlag.values, e.key, '$path.${e.key}'): _rated(
        e.value,
        '$path.${e.key}',
        _bool,
      ),
  };
}

Rated<T> _rated<T>(
  Object? json,
  String path,
  T Function(Object?, String) value,
) {
  final o = _object(json, path, const {'value', 'source'});
  return Rated(value(o['value'], '$path.value'), _string(o, 'source', path));
}

Rated<T>? _optionalRated<T>(
  Object? json,
  String path,
  T Function(Object?, String) value,
) => json == null ? null : _rated(json, path, value);

// "[70, 82]" is a closed span; "[20]" is open-ended (20 or more).
Span _span(Object? json, String path) {
  if (json is! List || json.isEmpty || json.length > 2) {
    _fail(path, 'expected [min] or [min, max]');
  }
  return Span(
    _number(json[0], '$path[0]'),
    json.length == 2 ? _number(json[1], '$path[1]') : null,
  );
}

List<T> _list<T>(Object? json, String path, T Function(Object?, String) item) {
  if (json is! List) _fail(path, 'expected a list');
  return [for (var i = 0; i < json.length; i++) item(json[i], '$path[$i]')];
}

List<T> _optionalList<T>(
  Object? json,
  String path,
  T Function(Object?, String) item,
) => json == null ? const [] : _list(json, path, item);

Map<String, Object?> _object(
  Object? json,
  String path, [
  Set<String>? allowedKeys,
]) {
  if (json is! Map<String, Object?>) _fail(path, 'expected an object');
  if (allowedKeys != null) {
    for (final key in json.keys) {
      if (!allowedKeys.contains(key)) _fail('$path.$key', 'unknown field');
    }
  }
  return json;
}

String _string(Map<String, Object?> o, String key, String path) =>
    _text(o[key], '$path.$key');

String? _optionalString(Map<String, Object?> o, String key, String path) =>
    o[key] == null ? null : _string(o, key, path);

String _text(Object? json, String path) {
  if (json is! String) _fail(path, 'expected text');
  return json;
}

double _number(Object? json, String path) {
  if (json is! num) _fail(path, 'expected a number');
  return json.toDouble();
}

int _int(Object? json, String path) {
  if (json is! int) _fail(path, 'expected a whole number');
  return json;
}

bool _bool(Object? json, String path) {
  if (json is! bool) _fail(path, 'expected true or false');
  return json;
}

T _enum<T extends Enum>(List<T> values, Object? json, String path) {
  for (final value in values) {
    if (value.name == json) return value;
  }
  _fail(path, 'expected one of ${values.map((v) => v.name).join(', ')}');
}

Never _fail(String path, String message) =>
    throw FormatException('$path: $message');
