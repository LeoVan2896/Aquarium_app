import 'package:flutter/material.dart';

import '../domain/chart_reader.dart';
import '../domain/enums.dart';
import '../domain/steps.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

class ScanResult {
  const ScanResult(this.parameter, this.steps, {this.unit});

  final Parameter parameter;
  final List<double> steps;
  final String? unit;
}

class _Entry {
  _Entry(this.parameter, List<double> steps, {this.unit})
    : detected = parameter,
      text = TextEditingController(text: steps.map(formatNumber).join(', '));

  Parameter? parameter;
  final Parameter? detected;
  final String? unit;
  final TextEditingController text;
  String? error;
}

const _chartParameters = [
  Parameter.ammonia,
  Parameter.nitrite,
  Parameter.nitrate,
  Parameter.ph,
  Parameter.gh,
  Parameter.kh,
  Parameter.chlorine,
];

class ChartReviewScreen extends StatefulWidget {
  const ChartReviewScreen({super.key, required this.reading});

  final ChartReading reading;

  @override
  State<ChartReviewScreen> createState() => _ChartReviewScreenState();
}

class _ChartReviewScreenState extends State<ChartReviewScreen> {
  late final List<_Entry> _entries = [
    for (final MapEntry(:key, :value) in widget.reading.matched.entries)
      _Entry(key, value.steps, unit: value.unit),
    for (final steps in widget.reading.unmatched) _Entry(null, steps),
  ];

  @override
  void dispose() {
    for (final e in _entries) {
      e.text.dispose();
    }
    super.dispose();
  }

  void _apply() {
    final results = <ScanResult>[];
    final seen = <Parameter>{};
    var valid = true;
    for (final e in _entries) {
      e.error = null;
      final parameter = e.parameter;
      if (parameter == null) continue;
      final steps = parseSteps(e.text.text);
      if (steps == null || steps.length < 2) {
        e.error = 'Use at least two numbers, e.g. 0, 0.5, 1';
        valid = false;
      } else if (!seen.add(parameter)) {
        e.error = '${parameter.label} is already used above.';
        valid = false;
      } else {
        results.add(
          ScanResult(
            parameter,
            mergeSteps(const [], steps),
            unit: parameter == e.detected ? e.unit : null,
          ),
        );
      }
    }
    setState(() {});
    if (valid) Navigator.of(context).pop(results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check the chart')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s4),
        children: [
          Text(
            _entries.isEmpty
                ? "Couldn't find any rows of numbers. Try again with the chart filling the frame, flat and without glare."
                : 'Compare each row with your bottle and fix anything that was misread. Rows set to Ignore are skipped.',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpace.s4),
          for (final e in _entries) ...[
            GroupedSection(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpace.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<Parameter?>(
                        initialValue: e.parameter,
                        dropdownColor: AppColors.surface2,
                        decoration: const InputDecoration(
                          labelText: 'Parameter',
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Ignore this row'),
                          ),
                          for (final p in _chartParameters)
                            DropdownMenuItem(value: p, child: Text(p.label)),
                        ],
                        onChanged: (p) => setState(() => e.parameter = p),
                      ),
                      const SizedBox(height: AppSpace.s3),
                      TextField(
                        controller: e.text,
                        enabled: e.parameter != null,
                        decoration: InputDecoration(
                          labelText: e.unit == null
                              ? 'Steps'
                              : 'Steps (${e.unit})',
                          errorText: e.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.s3),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.s4,
            AppSpace.s2,
            AppSpace.s4,
            AppSpace.s3,
          ),
          child: FilledButton(
            onPressed: _entries.isEmpty
                ? () => Navigator.of(context).pop()
                : _apply,
            child: Text(_entries.isEmpty ? 'Back to kit' : 'Use these steps'),
          ),
        ),
      ),
    );
  }
}
