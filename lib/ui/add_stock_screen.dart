import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/compatibility.dart';
import '../domain/enums.dart';
import '../domain/fit_checks.dart';
import '../domain/species.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

class AddStockScreen extends ConsumerStatefulWidget {
  const AddStockScreen({
    super.key,
    required this.tank,
    this.removing,
    this.initialType = SpeciesType.animal,
    this.initialSpeciesId,
  });

  final Tank tank;
  final StockedSpecies? removing;
  final SpeciesType initialType;
  final String? initialSpeciesId;

  @override
  ConsumerState<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends ConsumerState<AddStockScreen> {
  late SpeciesType _type = widget.initialType;
  String _query = '';
  late String? _speciesId = widget.initialSpeciesId;
  int _count = 1;
  late DateTime _at = ref.read(clockProvider)();
  final _note = TextEditingController();
  bool _saving = false;

  bool get _removing => widget.removing != null;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final removing = widget.removing;
    final type = removing?.type ?? _type;
    final speciesId = removing?.speciesId ?? _speciesId;
    if (speciesId == null) return;
    setState(() => _saving = true);
    final note = _note.text.trim();
    await ref
        .read(databaseProvider)
        .addStockEntry(
          StockEntriesCompanion.insert(
            tankId: widget.tank.id,
            speciesId: speciesId,
            speciesType: type,
            change: _removing ? -_count : _count,
            occurredAt: _at,
            note: Value(note.isEmpty ? null : note),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final stockContext = ref.watch(stockContextProvider(widget.tank)).value;
    if (stockContext == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final removing = widget.removing;

    final List<Widget> body;
    final String action;
    if (removing != null) {
      action = 'Remove from tank';
      body = [
        Text(
          'Remove ${removing.name}',
          style: const TextStyle(
            fontSize: AppType.xl,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpace.s1),
        Text(
          '${removing.count} in the tank now.',
          style: const TextStyle(fontSize: AppType.sm, color: AppColors.muted),
        ),
        const SizedBox(height: AppSpace.s4),
        ..._details('How many', max: removing.count),
      ];
    } else {
      final selected = _selected(stockContext);
      final checks = selected == null
          ? const <Check>[]
          : _checksFor(selected, stockContext);
      final gated = selected is AnimalSpecies && stockContext.fishGated;
      final hasFail = checks.any((c) => c.status == CheckStatus.fail);
      action = gated || hasFail ? 'Add anyway' : 'Add to tank';
      body = [
        SegmentedButton<SpeciesType>(
          segments: const [
            ButtonSegment(
              value: SpeciesType.animal,
              label: Text('Fish & inverts'),
            ),
            ButtonSegment(value: SpeciesType.plant, label: Text('Plants')),
          ],
          selected: {_type},
          showSelectedIcon: false,
          onSelectionChanged: (s) => setState(() {
            _type = s.single;
            _speciesId = null;
          }),
        ),
        const SizedBox(height: AppSpace.s4),
        if (selected == null)
          ..._picker(stockContext)
        else ...[
          GroupedSection(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(
                  left: AppSpace.s4,
                  right: AppSpace.s2,
                ),
                title: Text(_name(selected)),
                subtitle: Text(
                  _scientific(selected),
                  style: const TextStyle(
                    fontSize: AppType.sm,
                    fontStyle: FontStyle.italic,
                    color: AppColors.muted,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => setState(() => _speciesId = null),
                  child: const Text('Change'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s4),
          if (gated) ...[
            _GateBanner(widget.tank),
            const SizedBox(height: AppSpace.s4),
          ],
          ..._details(
            _type == SpeciesType.plant
                ? 'How many pots or bunches'
                : 'How many',
          ),
          const SizedBox(height: AppSpace.s5),
          SectionHeader(_summary(checks)),
          GroupedSection(children: [for (final c in checks) CheckRow(c)]),
        ],
      ];
    }

    return DiscardChangesGuard(
      hasChanges: () =>
          _speciesId != widget.initialSpeciesId ||
          _count != 1 ||
          _note.text.trim().isNotEmpty,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_removing ? 'Remove stock' : 'Add fish or plants'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpace.s4),
          children: body,
        ),
        bottomNavigationBar: _removing || _speciesId != null
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.s4,
                    AppSpace.s2,
                    AppSpace.s4,
                    AppSpace.s3,
                  ),
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(action),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Object? _selected(StockContext c) => switch (_type) {
    SpeciesType.animal =>
      c.catalog.animals.where((a) => a.id == _speciesId).firstOrNull,
    SpeciesType.plant =>
      c.catalog.plants.where((p) => p.id == _speciesId).firstOrNull,
  };

  List<Check> _checksFor(Object species, StockContext c) => switch (species) {
    AnimalSpecies a => [
      ...animalFit(
        a,
        setup: c.setup,
        conditions: c.conditions,
        maturity: c.maturity,
        now: c.now,
        plannedCount: _count,
        currentCount: c.countOf(SpeciesType.animal, a.id),
      ),
      ...animalCompatibility(a, animals: c.animals, plants: c.plants),
    ],
    PlantSpecies p => [
      ...plantFit(p, setup: c.setup, conditions: c.conditions),
      ...plantCompatibility(p, animals: c.animals),
    ],
    _ => const [],
  };

  List<Widget> _picker(StockContext c) {
    final q = _query.trim().toLowerCase();
    bool matches(String common, String scientific) =>
        q.isEmpty ||
        common.toLowerCase().contains(q) ||
        scientific.toLowerCase().contains(q);
    final options = switch (_type) {
      SpeciesType.animal => [
        for (final a in c.catalog.animals)
          if (matches(a.commonName, a.scientificName))
            (a.id, a.commonName, a.scientificName),
      ],
      SpeciesType.plant => [
        for (final p in c.catalog.plants)
          if (matches(p.commonName, p.scientificName))
            (p.id, p.commonName, p.scientificName),
      ],
    };
    return [
      TextField(
        decoration: const InputDecoration(
          hintText: 'Search by common or scientific name',
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted),
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
      const SizedBox(height: AppSpace.s3),
      if (options.isEmpty)
        Padding(
          padding: const EdgeInsets.all(AppSpace.s1),
          child: Text(
            q.isNotEmpty
                ? 'Nothing matches. Try another name.'
                : 'No species in the catalog yet.',
            style: const TextStyle(
              fontSize: AppType.sm,
              color: AppColors.muted,
            ),
          ),
        )
      else
        GroupedSection(
          children: [
            for (final (id, common, scientific) in options)
              ListTile(
                onTap: () => setState(() {
                  _speciesId = id;
                  _count = 1;
                }),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.s4,
                ),
                title: Text(common),
                subtitle: Text(
                  scientific,
                  style: const TextStyle(
                    fontSize: AppType.sm,
                    fontStyle: FontStyle.italic,
                    color: AppColors.muted,
                  ),
                ),
              ),
          ],
        ),
    ];
  }

  List<Widget> _details(String countLabel, {int max = 99}) => [
    GroupedSection(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(
            left: AppSpace.s4,
            right: AppSpace.s2,
          ),
          title: Text(countLabel),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Fewer',
                onPressed: _count > 1 ? () => setState(() => _count--) : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '$_count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppType.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'More',
                onPressed: _count < max ? () => setState(() => _count++) : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
        DateTimeRow(
          label: _removing ? 'Removed' : 'Added',
          value: _at,
          onChanged: (t) => setState(() => _at = t),
        ),
      ],
    ),
    const SizedBox(height: AppSpace.s3),
    TextField(
      controller: _note,
      decoration: const InputDecoration(labelText: 'Note (optional)'),
    ),
  ];
}

String _name(Object species) => switch (species) {
  AnimalSpecies a => a.commonName,
  PlantSpecies p => p.commonName,
  _ => '',
};

String _scientific(Object species) => switch (species) {
  AnimalSpecies a => a.scientificName,
  PlantSpecies p => p.scientificName,
  _ => '',
};

String _summary(List<Check> checks) {
  int count(CheckStatus s) => checks.where((c) => c.status == s).length;
  final fails = count(CheckStatus.fail);
  final cautions = count(CheckStatus.caution);
  final unknowns = count(CheckStatus.unknown);
  final parts = [
    if (fails > 0) '$fails ${fails == 1 ? 'problem' : 'problems'}',
    if (cautions > 0) '$cautions ${cautions == 1 ? 'caution' : 'cautions'}',
    if (unknowns > 0) '$unknowns unknown',
  ];
  return parts.isEmpty
      ? 'Fits your tank'
      : 'How it fits · ${parts.join(' · ')}';
}

class CheckRow extends StatelessWidget {
  const CheckRow(this.check, {super.key});

  final Check check;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (check.status) {
      CheckStatus.pass => (Icons.check_circle_rounded, AppColors.pass),
      CheckStatus.caution => (Icons.warning_amber_rounded, AppColors.warn),
      CheckStatus.fail => (Icons.cancel_rounded, AppColors.fail),
      CheckStatus.unknown => (Icons.help_outline_rounded, AppColors.muted),
    };
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      leading: Icon(icon, color: color),
      title: Text(check.kind.label),
      subtitle: Text(
        check.reason,
        style: const TextStyle(fontSize: AppType.sm, color: AppColors.muted),
      ),
    );
  }
}

class _GateBanner extends ConsumerWidget {
  const _GateBanner(this.tank);

  final Tank tank;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prediction = ref.watch(tankDashboardProvider(tank)).value?.prediction;
    return Container(
      padding: const EdgeInsets.all(AppSpace.s4),
      decoration: BoxDecoration(
        color: AppColors.recessed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warn.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.hourglass_bottom_rounded, color: AppColors.warn),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Text(
              [
                "Your tank hasn't finished cycling, so fish added now would sit in ammonia or nitrite.",
                if (prediction != null)
                  'Expected ready ${formatDateRange(prediction.earliest, prediction.latest)}.',
              ].join(' '),
            ),
          ),
        ],
      ),
    );
  }
}
