import 'package:flutter/material.dart';

import '../domain/enums.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';

class ValueInput extends StatefulWidget {
  const ValueInput({
    super.key,
    required this.mode,
    required this.steps,
    required this.unit,
    required this.onChanged,
    this.initial,
    this.label = 'Value',
  });

  final InputMode mode;
  final List<double> steps;
  final String unit;
  final double? initial;
  final String label;
  final ValueChanged<double?> onChanged;

  @override
  State<ValueInput> createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
  late double? _selected = widget.initial;
  late final _text = TextEditingController(
    text: widget.initial == null ? '' : formatNumber(widget.initial!),
  );
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _typed(String text) {
    final trimmed = text.trim();
    final value = double.tryParse(trimmed);
    setState(
      () => _error = trimmed.isEmpty || (value != null && value >= 0)
          ? null
          : 'Enter a number.',
    );
    widget.onChanged(_error == null ? value : null);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == InputMode.free) {
      return TextField(
        controller: _text,
        onChanged: _typed,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: widget.label,
          suffixText: unitSuffix(widget.unit),
          errorText: _error,
        ),
      );
    }

    return Wrap(
      spacing: AppSpace.s2,
      runSpacing: AppSpace.s2,
      children: [
        for (final step in widget.steps)
          ChoiceChip(
            label: Text(formatNumber(step)),
            selected: _selected == step,
            onSelected: (on) {
              setState(() => _selected = on ? step : null);
              widget.onChanged(_selected);
            },
          ),
      ],
    );
  }
}
