import 'config.dart';
import 'species.dart';
import 'tank_conditions.dart';
import 'units.dart';

enum CheckStatus { pass, caution, fail, unknown }

enum CheckKind {
  temperature,
  ph,
  gh,
  kh,
  tankSize,
  groupSize,
  maturity,
  substrate,
  light,
  co2,
  rootFeeder,
  temperatureOverlap,
  temperament,
  predation,
  eatsShrimp,
  finNipping,
  shrimpWater,
  plantDamage,
}

class Check {
  const Check(this.kind, this.status, this.reason);

  final CheckKind kind;
  final CheckStatus status;
  final String reason;
}

const _cmPerInch = 2.54;

List<Check> animalFit(
  AnimalSpecies species, {
  required TankSetup setup,
  required TankConditions conditions,
  required Maturity maturity,
  required DateTime now,
  int plannedCount = 1,
  int currentCount = 0,
  DomainConfig config = const DomainConfig(),
}) {
  final s = species.sources;
  return [
    _rangeCheck(
      CheckKind.temperature,
      'Temperature',
      '°F',
      conditions.tempF,
      species.tempF,
      s,
      config,
    ),
    _rangeCheck(CheckKind.ph, 'pH', '', conditions.ph, species.ph, s, config),
    _rangeCheck(
      CheckKind.gh,
      'GH',
      ' dGH',
      conditions.gh,
      species.gh,
      s,
      config,
    ),
    _rangeCheck(
      CheckKind.kh,
      'KH',
      ' dKH',
      conditions.kh,
      species.kh,
      s,
      config,
    ),
    _tankSizeCheck(species.minTank, setup, s),
    ?_groupCheck(species, plannedCount + currentCount),
    ?_maturityCheck(species, maturity, now),
    if (species.flags[AnimalFlag.needsSand]?.value == true)
      setup.sandSubstrate
          ? const Check(CheckKind.substrate, CheckStatus.pass, 'Sand bottom.')
          : Check(
              CheckKind.substrate,
              CheckStatus.caution,
              '${species.commonName} needs soft sand (${sourceName(s, species.flags[AnimalFlag.needsSand]!.source)}).',
            ),
  ];
}

List<Check> plantFit(
  PlantSpecies plant, {
  required TankSetup setup,
  required TankConditions conditions,
  DomainConfig config = const DomainConfig(),
}) {
  final s = plant.sources;
  return [
    _rangeCheck(
      CheckKind.temperature,
      'Temperature',
      '°F',
      conditions.tempF,
      plant.tempF,
      s,
      config,
    ),
    _rangeCheck(CheckKind.ph, 'pH', '', conditions.ph, plant.ph, s, config),
    _rangeCheck(CheckKind.kh, 'KH', ' dKH', conditions.kh, plant.kh, s, config),
    _lightCheck(plant, setup),
    _co2Check(plant, setup),
    if (plant.rootFeeder?.value == true)
      setup.hasSoil || setup.usesRootTabs
          ? const Check(
              CheckKind.rootFeeder,
              CheckStatus.pass,
              'Feeds through its roots; your substrate or root tabs cover it.',
            )
          : const Check(
              CheckKind.rootFeeder,
              CheckStatus.caution,
              'Feeds through its roots. Add root tabs, since the tank has no soil.',
            ),
  ];
}

Check _rangeCheck(
  CheckKind kind,
  String label,
  String unit,
  Condition? condition,
  List<RangeReport> reports,
  Map<String, String> sources,
  DomainConfig config,
) {
  if (reports.isEmpty) {
    return Check(kind, CheckStatus.unknown, 'No source gives a $label range.');
  }
  if (condition == null) {
    return Check(
      kind,
      CheckStatus.unknown,
      kind == CheckKind.temperature
          ? 'No temperature reading or target temperature yet.'
          : 'No $label reading in the last ${config.conditionsMaxAgeDays.value} days.',
    );
  }
  final value = condition.value;
  final shown = '$label ${_number(value)}$unit';
  final verdicts = [
    for (final r in reports)
      (
        status: _rangeStatus(value, r, config.rangeMargin),
        text: _describeRange(r, unit, sources),
      ),
  ];
  return Check(
    kind,
    _combine(verdicts.map((v) => v.status)),
    '$shown vs ${verdicts.map((v) => v.text).join('; ')}.',
  );
}

CheckStatus _rangeStatus(double value, RangeReport r, double margin) {
  final optimal = r.optimal;
  final tolerated = r.tolerated;
  if (_inside(value, optimal ?? tolerated!, 0)) return CheckStatus.pass;
  if (optimal != null && tolerated != null && _inside(value, tolerated, 0)) {
    return CheckStatus.caution;
  }
  if (_inside(value, tolerated ?? optimal!, margin)) return CheckStatus.caution;
  return CheckStatus.fail;
}

bool _inside(double value, Span span, double margin) =>
    value >= span.min - margin && value <= (span.max ?? value) + margin;

// When sources disagree on the verdict, neither is trusted over the other.
CheckStatus _combine(Iterable<CheckStatus> statuses) {
  final distinct = statuses.toSet();
  return distinct.length == 1 ? distinct.single : CheckStatus.caution;
}

String _describeRange(RangeReport r, String unit, Map<String, String> sources) {
  final parts = [
    if (r.optimal != null) 'ideal ${formatSpan(r.optimal!)}$unit',
    if (r.tolerated != null) 'tolerates ${formatSpan(r.tolerated!)}$unit',
  ];
  return '${parts.join(', ')} (${sourceName(sources, r.source)})';
}

Check _tankSizeCheck(
  List<TankSize> sizes,
  TankSetup setup,
  Map<String, String> sources,
) {
  if (sizes.isEmpty) {
    return const Check(
      CheckKind.tankSize,
      CheckStatus.unknown,
      'No source gives a minimum tank size.',
    );
  }
  final verdicts = <({CheckStatus status, String text})>[];
  for (final size in sizes) {
    final from = sourceName(sources, size.source);
    if (size.lengthCm != null || size.widthCm != null) {
      final needs = [
        if (size.lengthCm != null) _number(size.lengthCm!),
        if (size.widthCm != null) _number(size.widthCm!),
      ].join(' × ');
      final length = setup.lengthIn;
      final width = setup.widthIn;
      if ((size.lengthCm != null && length == null) ||
          (size.widthCm != null && width == null)) {
        verdicts.add((
          status: CheckStatus.unknown,
          text:
              'needs a $needs cm base ($from); enter your tank\'s length and width',
        ));
        continue;
      }
      final fits =
          (size.lengthCm == null || length! * _cmPerInch >= size.lengthCm!) &&
          (size.widthCm == null || width! * _cmPerInch >= size.widthCm!);
      verdicts.add((
        status: fits ? CheckStatus.pass : CheckStatus.fail,
        text: 'needs a $needs cm base ($from)',
      ));
    } else {
      final gallons = size.gallons!;
      verdicts.add((
        status: setup.volumeGal >= gallons
            ? CheckStatus.pass
            : CheckStatus.fail,
        text: 'needs ${_number(gallons)} gal ($from)',
      ));
    }
  }
  final statuses = verdicts.map((v) => v.status).toSet();
  final status = statuses.contains(CheckStatus.unknown)
      ? CheckStatus.unknown
      : _combine(statuses);
  return Check(
    CheckKind.tankSize,
    status,
    'Tank ${_tankDescription(setup)}: ${verdicts.map((v) => v.text).join('; ')}.',
  );
}

String _tankDescription(TankSetup setup) {
  final dims = setup.lengthIn != null && setup.widthIn != null
      ? ', ${_number(setup.lengthIn!)} × ${_number(setup.widthIn!)} in'
      : '';
  return '${_number(setup.volumeGal)} gal$dims';
}

Check? _groupCheck(AnimalSpecies species, int total) {
  final min = species.minGroupSize;
  if (min == null) return null;
  final from = sourceName(species.sources, min.source);
  return total >= min.value
      ? Check(
          CheckKind.groupSize,
          CheckStatus.pass,
          'Group of $total meets the minimum of ${min.value} ($from).',
        )
      : Check(
          CheckKind.groupSize,
          CheckStatus.caution,
          'Keep at least ${min.value} together ($from); you\'d have $total.',
        );
}

Check? _maturityCheck(AnimalSpecies species, Maturity maturity, DateTime now) {
  final flag = species.flags[AnimalFlag.needsMatureTank];
  if (flag?.value != true) return null;
  final from = sourceName(species.sources, flag!.source);
  final establishedAt = maturity.establishedAt;
  if (establishedAt == null) {
    return Check(
      CheckKind.maturity,
      CheckStatus.unknown,
      'Needs an established tank ($from). Can\'t tell until the tank has finished cycling.',
    );
  }
  return maturity.isEstablished(now)
      ? Check(
          CheckKind.maturity,
          CheckStatus.pass,
          'Needs an established tank ($from); yours is.',
        )
      : Check(
          CheckKind.maturity,
          CheckStatus.caution,
          'Needs an established tank ($from). Yours will be on ${_date(establishedAt)}.',
        );
}

Check _lightCheck(PlantSpecies plant, TankSetup setup) {
  if (plant.light.isEmpty) {
    return const Check(
      CheckKind.light,
      CheckStatus.unknown,
      'No source gives a light need.',
    );
  }
  final ratings = plant.light
      .map((r) => '${r.value.name} (${sourceName(plant.sources, r.source)})')
      .join(', ');
  final tank = setup.lightLevel;
  if (tank == null) {
    return Check(
      CheckKind.light,
      CheckStatus.unknown,
      'Needs $ratings light. Set your tank\'s light level.',
    );
  }
  final levels = plant.light.map((r) => r.value.index);
  final lowest = levels.reduce((a, b) => a < b ? a : b);
  final highest = levels.reduce((a, b) => a > b ? a : b);
  final status = tank.index >= highest
      ? CheckStatus.pass
      : tank.index >= lowest
      ? CheckStatus.caution
      : CheckStatus.fail;
  return Check(
    CheckKind.light,
    status,
    'Your light is ${tank.name}; sources say $ratings.',
  );
}

Check _co2Check(PlantSpecies plant, TankSetup setup) {
  if (plant.co2.isEmpty) {
    return const Check(
      CheckKind.co2,
      CheckStatus.unknown,
      'No source gives a CO₂ need.',
    );
  }
  final verdicts = [
    for (final r in plant.co2)
      setup.hasCo2
          ? CheckStatus.pass
          : switch (r.value) {
              Co2Need.notNeeded => CheckStatus.pass,
              Co2Need.helps => CheckStatus.caution,
              Co2Need.required => CheckStatus.fail,
            },
  ];
  final ratings = plant.co2
      .map((r) => '${r.value.name} (${sourceName(plant.sources, r.source)})')
      .join(', ');
  return Check(
    CheckKind.co2,
    _combine(verdicts),
    '${setup.hasCo2 ? 'You add CO₂' : 'No CO₂'}; sources say $ratings.',
  );
}

String _number(double value) =>
    formatNumber(double.parse(value.toStringAsFixed(1)));

String _date(DateTime t) =>
    '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
