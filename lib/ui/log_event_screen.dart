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

const productQuickPicks = ['Prime', 'SafeStart', 'Root tabs', 'Ammonia'];
const amountUnits = ['ml', 'drops', 'tabs', 'ppm'];

class LogEventScreen extends ConsumerStatefulWidget {
  const LogEventScreen({super.key, required this.tankId, this.correcting});

  final int tankId;
  final Event? correcting;

  @override
  ConsumerState<LogEventScreen> createState() => _LogEventScreenState();
}

class _LogEventScreenState extends ConsumerState<LogEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late EventType _type = widget.correcting?.type ?? EventType.waterChange;
  late final _product = TextEditingController(text: widget.correcting?.product);
  late final _amount = TextEditingController(
    text: _numberText(widget.correcting?.amount),
  );
  late String _amountUnit = widget.correcting?.amountUnit ?? amountUnits.first;
  late final _percent = TextEditingController(
    text: _numberText(widget.correcting?.percentChanged),
  );
  late DateTime _occurredAt =
      widget.correcting?.occurredAt ?? ref.read(clockProvider)();
  late final _note = TextEditingController(text: widget.correcting?.note);
  late final List<Object?> _initial;
  bool _saving = false;

  bool get _isCorrection => widget.correcting != null;

  static String _numberText(double? v) => v == null ? '' : formatNumber(v);

  @override
  void initState() {
    super.initState();
    _initial = _snapshot();
  }

  List<Object?> _snapshot() => [
    _type,
    _product.text,
    _amount.text,
    _amountUnit,
    _percent.text,
    _occurredAt,
    _note.text,
  ];

  bool _hasChanges() => !listEquals(_snapshot(), _initial);

  @override
  void dispose() {
    for (final c in [_product, _amount, _percent, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectType(EventType type) => setState(() {
    _type = type;
    if (type == EventType.ammoniaDose && _product.text.trim().isEmpty) {
      _product.text = 'Ammonia';
    }
  });

  String? _text(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  double? _number(TextEditingController c) => double.tryParse(c.text.trim());

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final amount = _number(_amount);
    final event = EventsCompanion(
      tankId: Value(widget.tankId),
      type: Value(_type),
      product: Value(_text(_product)),
      amount: Value(amount),
      amountUnit: Value(amount == null ? null : _amountUnit),
      percentChanged: Value(
        _type == EventType.waterChange ? _number(_percent) : null,
      ),
      occurredAt: Value(_occurredAt),
      note: Value(_text(_note)),
    );

    final db = ref.read(databaseProvider);
    final original = widget.correcting;
    if (original == null) {
      await db.addEvent(event);
    } else {
      await db.correctEvent(original, event);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final original = widget.correcting;

    return DiscardChangesGuard(
      hasChanges: _hasChanges,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isCorrection ? 'Correct event' : 'Log event'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpace.s4),
            children: [
              if (original != null) ...[
                Text(
                  'Logged as ${original.type.label} on ${formatDateTime(original.occurredAt)}. The original stays in the log; the correction replaces it everywhere else.',
                  style: const TextStyle(
                    fontSize: AppType.sm,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
              ],
              const SectionHeader('Type'),
              Wrap(
                spacing: AppSpace.s2,
                runSpacing: AppSpace.s2,
                children: [
                  for (final type in EventType.values)
                    ChoiceChip(
                      label: Text(type.label),
                      selected: _type == type,
                      onSelected: (_) => _selectType(type),
                    ),
                ],
              ),
              const SizedBox(height: AppSpace.s5),
              const SectionHeader('Details'),
              GroupedSection(
                children: [
                  if (_type == EventType.waterChange)
                    _Padded(
                      child: TextFormField(
                        controller: _percent,
                        decoration: const InputDecoration(
                          labelText: 'Water changed',
                          suffixText: '%',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return null;
                          final value = double.tryParse(v!.trim());
                          return value == null || value <= 0 || value > 100
                              ? 'Enter a percent from 1 to 100.'
                              : null;
                        },
                      ),
                    ),
                  _Padded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _product,
                          decoration: const InputDecoration(
                            labelText: 'Product (optional)',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpace.s2),
                        Wrap(
                          spacing: AppSpace.s2,
                          runSpacing: AppSpace.s2,
                          children: [
                            for (final pick in productQuickPicks)
                              ChoiceChip(
                                label: Text(pick),
                                selected: _product.text.trim() == pick,
                                onSelected: (on) => setState(
                                  () => _product.text = on ? pick : '',
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _Padded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _amount,
                          decoration: InputDecoration(
                            labelText: 'Amount (optional)',
                            suffixText: _amountUnit,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            if ((v ?? '').trim().isEmpty) return null;
                            final value = double.tryParse(v!.trim());
                            return value == null || value < 0
                                ? 'Enter a number.'
                                : null;
                          },
                        ),
                        const SizedBox(height: AppSpace.s2),
                        Wrap(
                          spacing: AppSpace.s2,
                          children: [
                            for (final unit in amountUnits)
                              ChoiceChip(
                                label: Text(unit),
                                selected: _amountUnit == unit,
                                onSelected: (_) =>
                                    setState(() => _amountUnit = unit),
                              ),
                          ],
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
                    label: 'When',
                    value: _occurredAt,
                    onChanged: (t) => setState(() => _occurredAt = t),
                  ),
                  _Padded(
                    child: TextFormField(
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
              child: Text(_isCorrection ? 'Save correction' : 'Save event'),
            ),
          ),
        ),
      ),
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
