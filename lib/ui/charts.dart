import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';

const _seriesColor = Color(0xFF3987E5);
const _defaultParameters = {
  Parameter.ammonia,
  Parameter.nitrite,
  Parameter.nitrate,
};

const markerLabels = {
  EventType.waterChange: 'WC',
  EventType.dose: 'Dose',
  EventType.ammoniaDose: 'NH₃',
};

// One chart per parameter: ammonia (0–8 ppm), nitrate (0–160) and pH (6–8) cannot share a y-axis.
class ParameterCharts extends StatefulWidget {
  const ParameterCharts({
    super.key,
    required this.readings,
    required this.events,
    required this.now,
  });

  final List<LoggedReading> readings;
  final List<LoggedEvent> events;
  final DateTime now;

  @override
  State<ParameterCharts> createState() => _ParameterChartsState();
}

class _ParameterChartsState extends State<ParameterCharts> {
  Set<Parameter>? _selected;

  @override
  Widget build(BuildContext context) {
    final available = Parameter.values
        .where((p) => widget.readings.any((r) => r.parameter == p))
        .toList();
    if (available.isEmpty) return const SizedBox.shrink();

    final selected =
        _selected ??
        {
          ...available.where(_defaultParameters.contains),
          if (!available.any(_defaultParameters.contains)) available.first,
        };
    final markers = widget.events
        .where((e) => markerLabels.containsKey(e.type))
        .toList();
    final first = [
      widget.readings.first.takenAt,
      ?markers.firstOrNull?.occurredAt,
    ].reduce((a, b) => a.isBefore(b) ? a : b);
    final start = DateTime(first.year, first.month, first.day);
    final end = widget.now.isAfter(start) ? widget.now : start;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpace.s2,
          runSpacing: AppSpace.s2,
          children: [
            for (final p in available)
              FilterChip(
                label: Text(p.label),
                selected: selected.contains(p),
                onSelected: (on) =>
                    setState(() => _selected = {...selected}..toggle(p, on)),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.s3),
        for (final p in available)
          if (selected.contains(p)) ...[
            _ParameterChart(
              parameter: p,
              readings: widget.readings.where((r) => r.parameter == p).toList(),
              markers: markers,
              start: start,
              end: end,
            ),
            const SizedBox(height: AppSpace.s3),
          ],
        if (markers.isNotEmpty)
          Text(
            [
              for (final MapEntry(:key, :value) in markerLabels.entries)
                if (markers.any((m) => m.type == key)) '$value = ${key.label}',
            ].join('  ·  '),
            style: const TextStyle(
              fontSize: AppType.xs,
              color: AppColors.muted,
            ),
          ),
      ],
    );
  }
}

extension on Set<Parameter> {
  void toggle(Parameter p, bool on) => on ? add(p) : remove(p);
}

class _ParameterChart extends StatelessWidget {
  const _ParameterChart({
    required this.parameter,
    required this.readings,
    required this.markers,
    required this.start,
    required this.end,
  });

  final Parameter parameter;
  final List<LoggedReading> readings;
  final List<LoggedEvent> markers;
  final DateTime start;
  final DateTime end;

  bool get _hardness => parameter == Parameter.gh || parameter == Parameter.kh;

  double _x(DateTime t) => t.difference(start).inMinutes / 1440;

  double _y(LoggedReading r) => _hardness ? r.ppm : r.value;

  @override
  Widget build(BuildContext context) {
    final unit = _hardness ? 'ppm' : readings.last.unit;
    final values = readings.map(_y).toList();
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final minY = parameter == Parameter.ph
        ? (minValue - 0.5).floorToDouble()
        : 0.0;
    final maxY = maxValue <= minY
        ? minY + 1
        : maxValue + (maxValue - minY) * 0.15;
    final spanDays = math.max(_x(end), 1.0);
    final title = unitSuffix(unit).isEmpty
        ? parameter.label
        : '${parameter.label} (${unitSuffix(unit)})';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s3,
        AppSpace.s3,
        AppSpace.s4,
        AppSpace.s2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpace.s1),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppType.sm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s3),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: spanDays,
                minY: minY,
                maxY: maxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.border, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) =>
                          _offInterval(value, meta)
                          ? const SizedBox.shrink()
                          : SideTitleWidget(
                              meta: meta,
                              child: Text(
                                formatNumber(
                                  double.parse(value.toStringAsFixed(2)),
                                ),
                                style: const TextStyle(
                                  fontSize: AppType.xs,
                                  color: AppColors.muted2,
                                ),
                              ),
                            ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: math.max(1, (spanDays / 4).ceilToDouble()),
                      getTitlesWidget: (value, meta) =>
                          _offInterval(value, meta)
                          ? const SizedBox.shrink()
                          : SideTitleWidget(
                              meta: meta,
                              child: Text(
                                _shortDate(addDays(start, value.round())),
                                style: const TextStyle(
                                  fontSize: AppType.xs,
                                  color: AppColors.muted2,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    for (final m in markers)
                      VerticalLine(
                        x: _x(m.occurredAt),
                        color: AppColors.muted2,
                        strokeWidth: 1,
                        dashArray: const [3, 3],
                        label: VerticalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(left: 2),
                          style: const TextStyle(
                            fontSize: AppType.xs - 1,
                            color: AppColors.muted,
                          ),
                          labelResolver: (_) => markerLabels[m.type]!,
                        ),
                      ),
                  ],
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surface2,
                    getTooltipItems: (spots) => [
                      for (final s in spots)
                        LineTooltipItem(
                          '${formatValue(_y(readings[s.spotIndex]), unit)}\n${formatShortDateTime(readings[s.spotIndex].takenAt)}',
                          const TextStyle(
                            fontSize: AppType.sm,
                            color: AppColors.text,
                          ),
                        ),
                    ],
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (final r in readings) FlSpot(_x(r.takenAt), _y(r)),
                    ],
                    color: _seriesColor,
                    barWidth: 2,
                    dotData: FlDotData(
                      getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                        radius: 4,
                        color: _seriesColor,
                        strokeWidth: 2,
                        strokeColor: AppColors.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // fl_chart always labels the axis ends; skip the max when it is off the tick grid.
  static bool _offInterval(double value, TitleMeta meta) {
    if (value != meta.max) return false;
    final steps = (value - meta.min) / meta.appliedInterval;
    return (steps - steps.round()).abs() > 1e-6;
  }

  static String _shortDate(DateTime d) =>
      formatShortDateTime(d).split(' · ').first;
}
