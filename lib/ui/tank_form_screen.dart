import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

class TankFormScreen extends ConsumerStatefulWidget {
  const TankFormScreen({super.key, this.tank});

  final Tank? tank;

  @override
  ConsumerState<TankFormScreen> createState() => _TankFormScreenState();
}

class _TankFormScreenState extends ConsumerState<TankFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.tank?.name);
  late final _volume = _numberController(widget.tank?.volumeGal);
  late final _substrate = TextEditingController(
    text: widget.tank?.substrateType,
  );
  late final _roomTemp = _numberController(widget.tank?.roomTempF);
  late final _targetTemp = _numberController(widget.tank?.targetTempF);
  late final _heater = _numberController(widget.tank?.heaterWatts);
  late final _light = _numberController(widget.tank?.lightWatts);
  late final _lightHours = _numberController(widget.tank?.lightHoursPerDay);

  late bool _hasSoil = widget.tank?.hasSoil ?? false;
  late WaterSource _waterSource = widget.tank?.waterSource ?? WaterSource.tap;
  late CycleMethod _cycleMethod =
      widget.tank?.cycleMethod ?? CycleMethod.fishless;
  late DateTime? _cycleStartedAt = widget.tank?.cycleStartedAt;
  late DateTime? _stockedAt = widget.tank?.stockedAt;
  bool _saving = false;

  bool get _isNew => widget.tank == null;

  late final List<Object?> _initial;

  @override
  void initState() {
    super.initState();
    _initial = _snapshot();
  }

  bool _hasChanges() => !listEquals(_snapshot(), _initial);

  List<Object?> _snapshot() => [
    for (final c in [
      _name,
      _volume,
      _substrate,
      _roomTemp,
      _targetTemp,
      _heater,
      _light,
      _lightHours,
    ])
      c.text,
    _hasSoil,
    _waterSource,
    _cycleMethod,
    _cycleStartedAt,
    _stockedAt,
  ];

  static TextEditingController _numberController(double? value) =>
      TextEditingController(text: value == null ? '' : formatNumber(value));

  @override
  void dispose() {
    for (final c in [
      _name,
      _volume,
      _substrate,
      _roomTemp,
      _targetTemp,
      _heater,
      _light,
      _lightHours,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parse(TextEditingController c) =>
      c.text.trim().isEmpty ? null : double.tryParse(c.text.trim());

  String? _optionalNumber(String? text) =>
      (text ?? '').trim().isEmpty || double.tryParse(text!.trim()) != null
      ? null
      : 'Enter a number.';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final db = ref.read(databaseProvider);
    final companion = TanksCompanion(
      name: Value(_name.text.trim()),
      volumeGal: Value(_parse(_volume)!),
      substrateType: Value(_substrate.text.trim()),
      hasSoil: Value(_hasSoil),
      waterSource: Value(_waterSource),
      roomTempF: Value(_parse(_roomTemp)),
      targetTempF: Value(_parse(_targetTemp)),
      heaterWatts: Value(_parse(_heater)),
      lightWatts: Value(_parse(_light)),
      lightHoursPerDay: Value(_parse(_lightHours)),
      cycleMethod: Value(_cycleMethod),
      cycleStartedAt: Value(_cycleStartedAt),
      stockedAt: Value(_stockedAt),
    );

    final tank = widget.tank;
    if (tank == null) {
      await db.addTank(companion);
    } else {
      await db.updateTank(tank.id, companion);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _archive() async {
    final tank = widget.tank!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Archive ${tank.name}?'),
        content: const Text(
          "It'll be hidden from your tanks list. Its readings and events are kept, and you can restore it anytime.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep tank'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.fail),
            child: const Text('Archive tank'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(databaseProvider).setTankArchived(tank.id, archived: true);
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _restore() async {
    await ref
        .read(databaseProvider)
        .setTankArchived(widget.tank!.id, archived: false);
    if (mounted) Navigator.of(context).pop();
  }

  Future<DateTime?> _pickDate(DateTime? initial) => showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final archived = widget.tank?.archived ?? false;

    return DiscardChangesGuard(
      hasChanges: _hasChanges,
      child: Scaffold(
        appBar: AppBar(title: Text(_isNew ? 'New tank' : 'Edit tank')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpace.s4),
            children: [
              const SectionHeader('Tank'),
              GroupedSection(
                children: [
                  _Field(
                    child: TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'e.g. 20 gal planted',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? 'Enter a tank name.'
                          : null,
                    ),
                  ),
                  _Field(
                    child: TextFormField(
                      controller: _volume,
                      decoration: const InputDecoration(
                        labelText: 'Volume',
                        suffixText: 'gal',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        final value = double.tryParse((v ?? '').trim());
                        return value == null || value <= 0
                            ? 'Enter the volume in gallons.'
                            : null;
                      },
                    ),
                  ),
                  _Field(
                    child: TextFormField(
                      controller: _substrate,
                      decoration: const InputDecoration(
                        labelText: 'Substrate',
                        hintText: 'e.g. aquasoil, sand, gravel',
                      ),
                    ),
                  ),
                  SwitchListTile(
                    value: _hasSoil,
                    onChanged: (v) => setState(() => _hasSoil = v),
                    title: const Text('Soil substrate'),
                    subtitle: const Text(
                      'Soil can leach ammonia for weeks, so the cycle takes longer.',
                      style: TextStyle(
                        fontSize: AppType.sm,
                        color: AppColors.muted,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.s4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.s5),
              const SectionHeader('Water'),
              GroupedSection(
                children: [
                  _Field(
                    child: DropdownButtonFormField<WaterSource>(
                      initialValue: _waterSource,
                      dropdownColor: AppColors.surface2,
                      decoration: const InputDecoration(
                        labelText: 'Water source',
                      ),
                      items: [
                        for (final source in WaterSource.values)
                          DropdownMenuItem(
                            value: source,
                            child: Text(source.label),
                          ),
                      ],
                      onChanged: (v) => setState(() => _waterSource = v!),
                    ),
                  ),
                  _Field(
                    child: Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            controller: _roomTemp,
                            label: 'Room temp',
                            suffix: '°F',
                            validator: _optionalNumber,
                          ),
                        ),
                        const SizedBox(width: AppSpace.s3),
                        Expanded(
                          child: _NumberField(
                            controller: _targetTemp,
                            label: 'Target temp',
                            suffix: '°F',
                            validator: _optionalNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.s5),
              const SectionHeader('Cycle'),
              GroupedSection(
                children: [
                  _Field(
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<CycleMethod>(
                        segments: [
                          for (final method in CycleMethod.values)
                            ButtonSegment(
                              value: method,
                              label: Text(method.label),
                            ),
                        ],
                        selected: {_cycleMethod},
                        onSelectionChanged: (s) =>
                            setState(() => _cycleMethod = s.single),
                      ),
                    ),
                  ),
                  _DateRow(
                    label: 'Cycle started',
                    value: _cycleStartedAt,
                    onPick: () async {
                      final picked = await _pickDate(_cycleStartedAt);
                      if (picked != null) {
                        setState(() => _cycleStartedAt = picked);
                      }
                    },
                    onClear: () => setState(() => _cycleStartedAt = null),
                  ),
                  _DateRow(
                    label: 'Fish added',
                    value: _stockedAt,
                    onPick: () async {
                      final picked = await _pickDate(_stockedAt);
                      if (picked != null) setState(() => _stockedAt = picked);
                    },
                    onClear: () => setState(() => _stockedAt = null),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.s5),
              const SectionHeader('Equipment'),
              GroupedSection(
                children: [
                  _Field(
                    child: Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            controller: _heater,
                            label: 'Heater',
                            suffix: 'W',
                            validator: _optionalNumber,
                          ),
                        ),
                        const SizedBox(width: AppSpace.s3),
                        Expanded(
                          child: _NumberField(
                            controller: _light,
                            label: 'Light',
                            suffix: 'W',
                            validator: _optionalNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Field(
                    child: _NumberField(
                      controller: _lightHours,
                      label: 'Light on per day',
                      suffix: 'h',
                      validator: _optionalNumber,
                    ),
                  ),
                ],
              ),
              if (!_isNew) ...[
                const SizedBox(height: AppSpace.s5),
                GroupedSection(
                  children: [
                    ListTile(
                      onTap: archived ? _restore : _archive,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.s4,
                      ),
                      leading: Icon(
                        archived
                            ? Icons.unarchive_outlined
                            : Icons.archive_outlined,
                        color: archived ? AppColors.text : AppColors.fail,
                      ),
                      title: Text(
                        archived ? 'Restore tank' : 'Archive tank',
                        style: TextStyle(
                          color: archived ? AppColors.text : AppColors.fail,
                        ),
                      ),
                    ),
                  ],
                ),
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
              child: Text(_isNew ? 'Add tank' : 'Save changes'),
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.child});

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

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.suffix,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String suffix;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label, suffixText: suffix),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    validator: validator,
  );
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final date = value;
    return ListTile(
      onTap: onPick,
      contentPadding: const EdgeInsets.only(
        left: AppSpace.s4,
        right: AppSpace.s2,
      ),
      leading: const Icon(Icons.event_outlined, color: AppColors.muted),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            date == null ? 'Not set' : formatDate(date),
            style: TextStyle(
              color: date == null ? AppColors.muted2 : AppColors.text,
            ),
          ),
          if (date != null)
            IconButton(
              onPressed: onClear,
              tooltip: 'Clear $label',
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AppColors.muted,
            )
          else
            const Padding(
              padding: EdgeInsets.all(AppSpace.s3),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.muted2,
              ),
            ),
        ],
      ),
    );
  }
}
