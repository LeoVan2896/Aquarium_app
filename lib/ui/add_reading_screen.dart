import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import 'kit_setup_screen.dart';
import 'labels.dart';
import 'theme.dart';
import 'value_input.dart';
import 'widgets.dart';

class AddReadingScreen extends ConsumerStatefulWidget {
  const AddReadingScreen({super.key, required this.tankId});

  final int tankId;

  @override
  ConsumerState<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends ConsumerState<AddReadingScreen> {
  int? _kitId;
  final Map<Parameter, double> _values = {};
  late DateTime _takenAt = ref.read(clockProvider)();
  final _note = TextEditingController();
  bool _showMissingValue = false;
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _selectKit(int id) => setState(() {
    _kitId = id;
    _values.clear();
    _showMissingValue = false;
  });

  void _openKitSetup(TestKit kit, List<KitParameter> params) =>
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => KitSetupScreen(kit: kit, parameters: params),
        ),
      );

  Future<void> _save(TestKit kit, List<KitParameter> params) async {
    if (_values.isEmpty) {
      setState(() => _showMissingValue = true);
      return;
    }
    setState(() => _saving = true);
    final note = _note.text.trim();
    await ref.read(databaseProvider).addReadings([
      for (final p in params)
        if (_values[p.parameter] case final value?)
          ReadingsCompanion.insert(
            tankId: widget.tankId,
            kitId: Value(kit.id),
            parameter: p.parameter,
            value: value,
            unit: p.unit,
            takenAt: _takenAt,
            note: Value(note.isEmpty ? null : note),
          ),
    ]);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final kits = ref.watch(testKitsProvider).value ?? const <TestKit>[];
    final allParams =
        ref.watch(kitParametersProvider).value ?? const <KitParameter>[];

    if (kits.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add reading')),
        body: const Center(
          child: Text(
            'Add a test kit first.',
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      );
    }

    final kit = kits.firstWhere(
      (k) => k.id == _kitId,
      orElse: () => kits.first,
    );
    final params = allParams.where((p) => p.kitId == kit.id).toList()
      ..sort((a, b) => a.parameter.index.compareTo(b.parameter.index));
    final missingSteps = params.any(
      (p) => p.inputMode == InputMode.steps && (p.stepsJson?.isEmpty ?? true),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add reading')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s4),
        children: [
          const SectionHeader('Kit'),
          Wrap(
            spacing: AppSpace.s2,
            runSpacing: AppSpace.s2,
            children: [
              for (final k in kits)
                ChoiceChip(
                  label: Text(k.name),
                  selected: k.id == kit.id,
                  onSelected: (_) => _selectKit(k.id),
                ),
            ],
          ),
          if (missingSteps) ...[
            const SizedBox(height: AppSpace.s3),
            _StepsMissingBanner(onSetUp: () => _openKitSetup(kit, params)),
          ],
          const SizedBox(height: AppSpace.s5),
          SectionHeader(
            'Results',
            trailing: _showMissingValue
                ? const Text(
                    'Enter at least one value.',
                    style: TextStyle(
                      fontSize: AppType.sm,
                      color: AppColors.fail,
                    ),
                  )
                : null,
          ),
          GroupedSection(
            children: [
              for (final p in params)
                Padding(
                  padding: const EdgeInsets.all(AppSpace.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unitSuffix(p.unit).isEmpty
                            ? p.parameter.label
                            : '${p.parameter.label} (${unitSuffix(p.unit)})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpace.s2),
                      if (p.inputMode == InputMode.steps &&
                          (p.stepsJson?.isEmpty ?? true))
                        const Text(
                          'No steps yet.',
                          style: TextStyle(
                            fontSize: AppType.sm,
                            color: AppColors.muted,
                          ),
                        )
                      else
                        ValueInput(
                          key: ValueKey((kit.id, p.parameter)),
                          mode: p.inputMode,
                          steps: p.stepsJson ?? const [],
                          unit: p.unit,
                          label: p.parameter.label,
                          onChanged: (v) => setState(() {
                            if (v == null) {
                              _values.remove(p.parameter);
                            } else {
                              _values[p.parameter] = v;
                              _showMissingValue = false;
                            }
                          }),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s5),
          GroupedSection(
            children: [
              DateTimeRow(
                label: 'Taken',
                value: _takenAt,
                onChanged: (t) => setState(() => _takenAt = t),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpace.s4),
                child: TextField(
                  controller: _note,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                  ),
                ),
              ),
            ],
          ),
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
            onPressed: _saving ? null : () => _save(kit, params),
            child: const Text('Save reading'),
          ),
        ),
      ),
    );
  }
}

class _StepsMissingBanner extends StatelessWidget {
  const _StepsMissingBanner({required this.onSetUp});

  final VoidCallback onSetUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s4,
        AppSpace.s3,
        AppSpace.s2,
        AppSpace.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.recessed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warn.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warn),
          const SizedBox(width: AppSpace.s3),
          const Expanded(
            child: Text(
              "Some parameters have no steps. Enter them from your bottle's color chart.",
              style: TextStyle(fontSize: AppType.sm),
            ),
          ),
          TextButton(onPressed: onSetUp, child: const Text('Set up steps')),
        ],
      ),
    );
  }
}
