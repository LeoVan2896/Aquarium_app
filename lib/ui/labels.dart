import 'package:flutter/material.dart' show DateUtils;

import '../domain/cycle_engine.dart';
import '../domain/enums.dart';
import '../domain/species.dart';
import '../domain/units.dart';

extension CycleStageLabel on CycleStage {
  String get label => switch (this) {
    CycleStage.notStarted => 'Not started',
    CycleStage.ammoniaPhase => 'Ammonia phase',
    CycleStage.nitritePhase => 'Nitrite phase',
    CycleStage.doseTest => 'Dose testing',
    CycleStage.cycled => 'Cycled',
    CycleStage.readyToStock => 'Ready to stock',
  };
}

extension CycleMethodLabel on CycleMethod {
  String get label => switch (this) {
    CycleMethod.fishless => 'Fishless',
    CycleMethod.fishIn => 'Fish-in',
  };
}

extension TierLabel on Tier {
  String get label => switch (this) {
    Tier.beginner => 'Beginner',
    Tier.easyIntermediate => 'Easy intermediate',
    Tier.intermediate => 'Intermediate',
  };
}

extension AnimalKindLabel on AnimalKind {
  String get label => switch (this) {
    AnimalKind.fish => 'Fish',
    AnimalKind.shrimp => 'Shrimp',
    AnimalKind.snail => 'Snail',
  };
}

extension TemperamentLabel on Temperament {
  String get label => switch (this) {
    Temperament.peaceful => 'Peaceful',
    Temperament.semiAggressive => 'Semi-aggressive',
    Temperament.aggressive => 'Aggressive',
  };
}

extension SwimLevelLabel on SwimLevel {
  String get label => switch (this) {
    SwimLevel.top => 'Top',
    SwimLevel.middle => 'Middle',
    SwimLevel.bottom => 'Bottom',
    SwimLevel.all => 'All levels',
  };
}

extension LightLevelLabel on LightLevel {
  String get label => switch (this) {
    LightLevel.low => 'Low',
    LightLevel.medium => 'Medium',
    LightLevel.high => 'High',
  };
}

extension Co2NeedLabel on Co2Need {
  String get label => switch (this) {
    Co2Need.notNeeded => 'Not needed',
    Co2Need.helps => 'Helps',
    Co2Need.required => 'Required',
  };
}

extension GrowthRateLabel on GrowthRate {
  String get label => switch (this) {
    GrowthRate.verySlow => 'Very slow',
    GrowthRate.slow => 'Slow',
    GrowthRate.medium => 'Medium',
    GrowthRate.fast => 'Fast',
    GrowthRate.veryFast => 'Very fast',
  };
}

extension PlacementLabel on Placement {
  String get label => switch (this) {
    Placement.foreground => 'Foreground',
    Placement.midground => 'Midground',
    Placement.background => 'Background',
    Placement.floating => 'Floating',
  };
}

extension AnimalFlagLabel on AnimalFlag {
  String get label => switch (this) {
    AnimalFlag.finNipper => 'Nips fins',
    AnimalFlag.longFinned => 'Long fins',
    AnimalFlag.eatsPlants => 'Eats plants',
    AnimalFlag.digs => 'Digs',
    AnimalFlag.eatsShrimp => 'Eats shrimp',
    AnimalFlag.eatsSmallFish => 'Eats small fish',
    AnimalFlag.needsMatureTank => 'Needs an established tank',
    AnimalFlag.needsLiveFood => 'Needs live or frozen food',
    AnimalFlag.needsSand => 'Needs soft sand',
    AnimalFlag.stockQualityWarning => 'Store stock often in poor health',
  };
}

extension IntermediateReasonLabel on IntermediateReason {
  String get label => switch (this) {
    IntermediateReason.matureTank => 'Needs a mature, stable tank',
    IntermediateReason.liveFood => 'Needs live or frozen food',
    IntermediateReason.softWater => 'Needs soft water',
    IntermediateReason.territorial => 'Territorial males',
    IntermediateReason.equipment => 'Needs special equipment',
    IntermediateReason.poorCompetitor => 'Easily outcompeted for food',
  };
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

String formatTime(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${d.hour < 12 ? 'AM' : 'PM'}';
}

String formatDateTime(DateTime d) => '${formatDate(d)} · ${formatTime(d)}';

String unitSuffix(String unit) => switch (unit) {
  'F' => '°F',
  'pH' => '',
  _ => unit,
};

String formatValue(double value, String unit) => switch (unit) {
  'F' => '${formatNumber(value)}°F',
  'pH' => formatNumber(value),
  _ => '${formatNumber(value)} $unit',
};

String describeEvent({
  String? product,
  double? amount,
  String? amountUnit,
  double? percentChanged,
}) => [
  if (percentChanged != null) '${formatNumber(percentChanged)}% changed',
  ?product,
  if (amount != null) [formatNumber(amount), ?amountUnit].join(' '),
].join(' · ');

extension EventTypeLabel on EventType {
  String get label => switch (this) {
    EventType.waterChange => 'Water change',
    EventType.dose => 'Dose',
    EventType.ammoniaDose => 'Ammonia dose',
    EventType.other => 'Other',
  };
}

extension WaterSourceLabel on WaterSource {
  String get label => switch (this) {
    WaterSource.tap => 'Tap water',
    WaterSource.softened => 'Softened water',
    WaterSource.neighbor => "Neighbor's water",
    WaterSource.filtered => 'Filtered water',
    WaterSource.other => 'Other water',
  };
}

extension ParameterLabel on Parameter {
  String get label => switch (this) {
    Parameter.ammonia => 'Ammonia',
    Parameter.nitrite => 'Nitrite',
    Parameter.nitrate => 'Nitrate',
    Parameter.ph => 'pH',
    Parameter.gh => 'GH',
    Parameter.kh => 'KH',
    Parameter.chlorine => 'Chlorine',
    Parameter.temperature => 'Temp',
  };
}

String formatDateRange(DateTime a, DateTime b) {
  final start = '${_months[a.month - 1]} ${a.day}';
  final end = '${_months[b.month - 1]} ${b.day}, ${b.year}';
  if (DateUtils.isSameDay(a, b)) return formatDate(a);
  return a.year == b.year ? '$start – $end' : '${formatDate(a)} – $end';
}

String formatShortDateTime(DateTime d) =>
    '${_months[d.month - 1]} ${d.day} · ${formatTime(d)}';
