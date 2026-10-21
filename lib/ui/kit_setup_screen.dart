import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import '../domain/steps.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

class KitSetupScreen extends ConsumerStatefulWidget {
  const KitSetupScreen({super.key, this.kit, this.parameters = const []});

  final TestKit? kit;
  final List<KitParameter> parameters;

  @override
  ConsumerState<KitSetupScreen> createState() => _KitSetupScreenState();
}

class _ParamDraft {
  _ParamDraft({
    required this.parameter,
    required this.unit,
    required this.mode,
    required this.steps,
  });

  final Parameter parameter;
  String unit;
  InputMode mode;
  List<double> steps;
  final stepInput = TextEditingController();
  String? stepError;
}

class _KitSetupScreenState extends ConsumerState<KitSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.kit?.name);
  late final _brand = TextEditingController(text: widget.kit?.brand);
  late final List<_ParamDraft> _params = [
    for (final p in widget.parameters)
      _ParamDraft(
        parameter: p.parameter,
        unit: p.unit,
        mode: p.inputMode,
        steps: [...?p.stepsJson],
      ),
  ]..sort((a, b) => a.parameter.index.compareTo(b.parameter.index));
  bool _showMissingParams = false;
  bool _saving = false;

  bool get _isNew => widget.kit == null;

  late final List<Object?> _initial;

  @override
  void initState() {
    super.initState();
    _initial = _snapshot();
  }

  bool _hasChanges() => !listEquals(_snapshot(), _initial);

  List<Object?> _snapshot() => [
    _name.text,
    _brand.text,
    for (final p in _params)
      (p.parameter, p.unit, p.mode, p.steps.join(','), p.stepInput.text),
  ];

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    for (final p in _params) {
      p.stepInput.dispose();
    }
    super.dispose();
  }

  void _addSteps(_ParamDraft draft) {
    final parsed = parseSteps(draft.stepInput.text);
    setState(() {
      if (parsed == null) {
        draft.stepError = 'Use numbers separated by commas, e.g. 0, 0.5, 1';
        return;
      }
      draft.steps = mergeSteps(draft.steps, parsed);
      draft.stepError = null;
      draft.stepInput.clear();
    });
  }

  Future<void> _pickParameter() async {
    final used = {for (final p in _params) p.parameter};
    final available = Parameter.values.where((p) => !used.contains(p));
    final picked = await showModalBottomSheet<Parameter>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final p in available)
              ListTile(
                title: Text(p.label),
                trailing: Text(
                  unitOptions(p).join(' / '),
                  style: const TextStyle(color: AppColors.muted),
                ),
                onTap: () => Navigator.of(context).pop(p),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() {
      _params
        ..add(
          _ParamDraft(
            parameter: picked,
            unit: unitOptions(picked).first,
            mode: InputMode.steps,
            steps: [],
          ),
        )
        ..sort((a, b) => a.parameter.index.compareTo(b.parameter.index));
      _showMissingParams = false;
    });
  }

  Future<void> _save() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _showMissingParams = _params.isEmpty);
    if (!valid || _params.isEmpty) return;
    setState(() => _saving = true);

    final brand = _brand.text.trim();
    await ref
        .read(databaseProvider)
        .saveKit(
          kitId: widget.kit?.id,
          name: _name.text.trim(),
          brand: brand.isEmpty ? null : brand,
          parameters: [
            for (final p in _params)
              KitParametersCompanion(
                parameter: Value(p.parameter),
                inputMode: Value(p.mode),
                unit: Value(p.unit),
                stepsJson: Value(
                  p.mode == InputMode.steps && p.steps.isNotEmpty
                      ? p.steps
                      : null,
                ),
              ),
          ],
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final canAddMore = _params.length < Parameter.values.length;

    return DiscardChangesGuard(
      hasChanges: _hasChanges,
      child: Scaffold(
        appBar: AppBar(title: Text(_isNew ? 'New kit' : 'Edit kit')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpace.s4),
            children: [
              const SectionHeader('Kit'),
              GroupedSection(
                children: [
                  _Padded(
                    child: TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'e.g. 8-in-1 strip',
                      ),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Enter a kit name.' : null,
                    ),
                  ),
                  _Padded(
                    child: TextFormField(
                      controller: _brand,
                      decoration: const InputDecoration(
                        labelText: 'Brand (optional)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.s5),
              SectionHeader(
                'What it tests',
                trailing: canAddMore
                    ? TextButton.icon(
                        onPressed: _pickParameter,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add parameter'),
                      )
                    : null,
              ),
              if (_params.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpace.s1),
                  child: Text(
                    'Add each parameter this kit tests.',
                    style: TextStyle(
                      fontSize: AppType.sm,
                      color: _showMissingParams
                          ? AppColors.fail
                          : AppColors.muted,
                    ),
                  ),
                ),
              for (final draft in _params) ...[
                _ParamCard(
                  draft: draft,
                  onChanged: () => setState(() {}),
                  onAddSteps: () => _addSteps(draft),
                  onRemove: () => setState(() {
                    _params.remove(draft);
                    draft.stepInput.dispose();
                  }),
                ),
                const SizedBox(height: AppSpace.s3),
              ],
            ],
          ),
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
              onPressed: _saving ? null : _save,
              child: Text(_isNew ? 'Add kit' : 'Save kit'),
            ),
          ),
        ),
      ),
    );
  }
}

class _ParamCard extends StatelessWidget {
  const _ParamCard({
    required this.draft,
    required this.onChanged,
    required this.onAddSteps,
    required this.onRemove,
  });

  final _ParamDraft draft;
  final VoidCallback onChanged;
  final VoidCallback onAddSteps;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final units = unitOptions(draft.parameter);
    final label = draft.parameter.label;

    return GroupedSection(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpace.s4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppType.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (units.length > 1)
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: [
                    for (final u in units)
                      ButtonSegment(value: u, label: Text(u)),
                  ],
                  selected: {draft.unit},
                  onSelectionChanged: (s) {
                    draft.unit = s.single;
                    onChanged();
                  },
                )
              else
                Text(
                  units.single,
                  style: const TextStyle(color: AppColors.muted),
                ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'Remove $label',
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.muted,
              ),
            ],
          ),
        ),
        _Padded(
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<InputMode>(
              segments: const [
                ButtonSegment(
                  value: InputMode.steps,
                  label: Text('Color chart'),
                ),
                ButtonSegment(
                  value: InputMode.free,
                  label: Text('Type a number'),
                ),
              ],
              selected: {draft.mode},
              onSelectionChanged: (s) {
                draft.mode = s.single;
                onChanged();
              },
            ),
          ),
        ),
        if (draft.mode == InputMode.free)
          const _Padded(
            child: Text(
              "You'll type the value each time you log a reading.",
              style: TextStyle(fontSize: AppType.sm, color: AppColors.muted),
            ),
          )
        else
          _Padded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (draft.steps.isEmpty)
                  const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.warn,
                      ),
                      SizedBox(width: AppSpace.s1),
                      Expanded(
                        child: Text(
                          "Enter the values printed on your bottle's color chart.",
                          style: TextStyle(
                            fontSize: AppType.sm,
                            color: AppColors.warn,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Wrap(
                    spacing: AppSpace.s2,
                    runSpacing: AppSpace.s2,
                    children: [
                      for (final step in draft.steps)
                        InputChip(
                          label: Text(formatNumber(step)),
                          backgroundColor: AppColors.surface2,
                          side: const BorderSide(color: AppColors.border2),
                          shape: const StadiumBorder(),
                          deleteIconColor: AppColors.muted,
                          onDeleted: () {
                            draft.steps = [...draft.steps]..remove(step);
                            onChanged();
                          },
                        ),
                    ],
                  ),
                const SizedBox(height: AppSpace.s3),
                TextField(
                  controller: draft.stepInput,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onAddSteps(),
                  decoration: InputDecoration(
                    labelText: 'Add steps (${draft.unit})',
                    hintText: 'e.g. 0, 0.25, 0.5, 1',
                    errorText: draft.stepError,
                    suffixIcon: IconButton(
                      onPressed: onAddSteps,
                      tooltip: 'Add steps',
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Padded extends StatelessWidget {
  const _Padded({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.s4,
      vertical: AppSpace.s3,
    ),
    child: child,
  );
}
