import 'package:flutter/material.dart' show DateUtils;

import '../domain/cycle_engine.dart';
import '../domain/enums.dart';
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
