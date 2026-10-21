import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import '../domain/recommendations.dart';
import '../domain/species.dart';
import 'add_stock_screen.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

class WhatFitsScreen extends ConsumerStatefulWidget {
  const WhatFitsScreen({super.key, required this.tank});

  final Tank tank;

  @override
  ConsumerState<WhatFitsScreen> createState() => _WhatFitsScreenState();
}

class _WhatFitsScreenState extends ConsumerState<WhatFitsScreen> {
  SpeciesType _type = SpeciesType.animal;
  Tier? _tier;
  String? _position;
  bool _hideFlagged = false;

  // Swim level for fish, placement for plants; null when no source states it.
  List<String> _positions(Object species) => switch (species) {
    AnimalSpecies a => [?a.swimLevel?.value.label],
    PlantSpecies p => [for (final x in p.placement?.value ?? const []) x.label],
    _ => const [],
  };

  Tier _tierOf(Object species) => switch (species) {
    AnimalSpecies a => a.tier,
    PlantSpecies p => p.tier,
    _ => Tier.beginner,
  };

  @override
  Widget build(BuildContext context) {
    final stock = ref.watch(stockContextProvider(widget.tank)).value;
    if (stock == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final all = recommend(
      catalog: stock.catalog,
      type: _type,
      setup: stock.setup,
      conditions: stock.conditions,
      maturity: stock.maturity,
      now: stock.now,
      stockedAnimals: stock.animals,
      stockedPlants: stock.plants,
      config: ref.watch(domainConfigProvider),
    );
    final positions = {for (final r in all) ..._positions(r.species)}.toList()
      ..sort();
    final shown = [
      for (final r in all)
        if ((_tier == null || _tierOf(r.species) == _tier) &&
            (_position == null || _positions(r.species).contains(_position)) &&
            (!_hideFlagged || (r.fails == 0 && r.cautions == 0)))
          r,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('What fits')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s4),
        children: [
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
              _position = null;
            }),
          ),
          const SizedBox(height: AppSpace.s3),
          Wrap(
            spacing: AppSpace.s2,
            runSpacing: AppSpace.s2,
            children: [
              ChoiceChip(
                label: const Text('All tiers'),
                selected: _tier == null,
                onSelected: (_) => setState(() => _tier = null),
              ),
              for (final tier in Tier.values)
                ChoiceChip(
                  label: Text(tier.label),
                  selected: _tier == tier,
                  onSelected: (_) => setState(() => _tier = tier),
                ),
              for (final p in positions)
                FilterChip(
                  label: Text(p),
                  selected: _position == p,
                  onSelected: (on) => setState(() => _position = on ? p : null),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s2),
          GroupedSection(
            children: [
              SwitchListTile(
                value: _hideFlagged,
                onChanged: (v) => setState(() => _hideFlagged = v),
                title: const Text('Hide problems and cautions'),
                subtitle: const Text(
                  'Species with unknowns stay, since sources often leave values out.',
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
          const SizedBox(height: AppSpace.s4),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpace.s1),
              child: Text(
                all.isEmpty
                    ? 'No species in the catalog yet.'
                    : 'Nothing matches these filters.',
                style: const TextStyle(
                  fontSize: AppType.sm,
                  color: AppColors.muted,
                ),
              ),
            )
          else
            GroupedSection(
              children: [
                for (final r in shown)
                  _RecommendationRow(
                    r,
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => AddStockScreen(
                          tank: widget.tank,
                          initialType: _type,
                          initialSpeciesId: switch (r.species) {
                            AnimalSpecies a => a.id,
                            PlantSpecies p => p.id,
                            _ => null,
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppSpace.s2),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpace.s1),
            child: Text(
              'Ranked by problems, then cautions, then unknowns. Schooling fish are judged at their minimum group size.',
              style: TextStyle(fontSize: AppType.sm, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow(this.r, {required this.onTap});

  final Recommendation r;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = r.fails > 0
        ? (Icons.cancel_rounded, AppColors.fail)
        : r.cautions > 0
        ? (Icons.warning_amber_rounded, AppColors.warn)
        : r.unknowns > 0
        ? (Icons.help_outline_rounded, AppColors.muted)
        : (Icons.check_circle_rounded, AppColors.pass);
    final verdict = r.passesAll
        ? 'Passes every check'
        : [
            if (r.fails > 0)
              '${r.fails} ${r.fails == 1 ? 'problem' : 'problems'}',
            if (r.cautions > 0)
              '${r.cautions} ${r.cautions == 1 ? 'caution' : 'cautions'}',
            if (r.unknowns > 0) '${r.unknowns} unknown',
          ].join(' · ');
    const muted = TextStyle(fontSize: AppType.sm, color: AppColors.muted);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: AppSpace.s4,
        right: AppSpace.s2,
        top: AppSpace.s1,
        bottom: AppSpace.s1,
      ),
      leading: Icon(icon, color: color),
      title: Text(r.commonName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(verdict, style: muted),
          if (r.hints.isNotEmpty)
            Text(
              'To settle: ${r.hints.join(' · ')}',
              style: muted.copyWith(color: AppColors.muted2),
            ),
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.muted2,
      ),
    );
  }
}
