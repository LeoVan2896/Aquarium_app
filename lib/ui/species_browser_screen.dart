import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../domain/species.dart';
import 'labels.dart';
import 'species_detail_screen.dart';
import 'theme.dart';
import 'widgets.dart';

enum _Tab { fish, plants }

class SpeciesBrowserScreen extends ConsumerStatefulWidget {
  const SpeciesBrowserScreen({super.key});

  @override
  ConsumerState<SpeciesBrowserScreen> createState() =>
      _SpeciesBrowserScreenState();
}

class _SpeciesBrowserScreenState extends ConsumerState<SpeciesBrowserScreen> {
  _Tab _tab = _Tab.fish;
  Tier? _tier;
  String _query = '';

  bool _matches(String common, String scientific, Tier? tier) {
    if (_tier != null && tier != _tier) return false;
    final q = _query.trim().toLowerCase();
    return q.isEmpty ||
        common.toLowerCase().contains(q) ||
        scientific.toLowerCase().contains(q);
  }

  void _open(Widget screen) =>
      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(speciesCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fish & plants')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s4),
        children: [
          SegmentedButton<_Tab>(
            segments: const [
              ButtonSegment(value: _Tab.fish, label: Text('Fish & inverts')),
              ButtonSegment(value: _Tab.plants, label: Text('Plants')),
            ],
            selected: {_tab},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _tab = s.single),
          ),
          const SizedBox(height: AppSpace.s3),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search by common or scientific name',
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpace.s3),
          Wrap(
            spacing: AppSpace.s2,
            runSpacing: AppSpace.s2,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _tier == null,
                onSelected: (_) => setState(() => _tier = null),
              ),
              for (final tier in Tier.values)
                ChoiceChip(
                  label: Text(tier.label),
                  selected: _tier == tier,
                  onSelected: (_) => setState(() => _tier = tier),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s4),
          ...catalog.when(
            data: _content,
            loading: () => const [
              Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ],
            error: (e, _) => const [
              Text(
                "Couldn't load the species list. Restart the app to try again.",
                style: TextStyle(color: AppColors.fail, fontSize: AppType.sm),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _content(SpeciesCatalog catalog) {
    final rows = switch (_tab) {
      _Tab.fish => [
        for (final a in catalog.animals)
          if (_matches(a.commonName, a.scientificName, a.tier))
            _SpeciesRow(
              commonName: a.commonName,
              scientificName: a.scientificName,
              summary: _animalSummary(a),
              onTap: () => _open(AnimalDetailScreen(species: a)),
            ),
      ],
      _Tab.plants => [
        for (final p in catalog.plants)
          if (_matches(p.commonName, p.scientificName, p.tier))
            _SpeciesRow(
              commonName: p.commonName,
              scientificName: p.scientificName,
              summary: _plantSummary(p),
              onTap: () => _open(PlantDetailScreen(plant: p)),
            ),
      ],
    };
    final kind = _tab == _Tab.fish ? AvoidKind.animal : AvoidKind.plant;
    final avoid = [
      for (final e in catalog.avoid)
        if (e.kind == kind &&
            _tier == null &&
            _matches(e.commonNames.join(' '), e.scientificName, null))
          e,
    ];
    final searching = _query.trim().isNotEmpty || _tier != null;

    return [
      if (rows.isEmpty)
        _EmptyState(
          searching
              ? 'Nothing matches. Try another name or tier.'
              : _tab == _Tab.fish
              ? 'No fish in the catalog yet.'
              : 'No plants in the catalog yet.',
        )
      else
        GroupedSection(children: rows),
      if (avoid.isNotEmpty) ...[
        const SizedBox(height: AppSpace.s5),
        SectionHeader(_tab == _Tab.fish ? 'Avoid' : 'Not truly aquatic'),
        GroupedSection(
          children: [
            for (final e in avoid)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.s4,
                  vertical: AppSpace.s1,
                ),
                leading: const Icon(Icons.block_rounded, color: AppColors.warn),
                title: Text(e.commonNames.join(', ')),
                subtitle: Text(
                  '${e.scientificName} · ${e.reason}',
                  style: const TextStyle(
                    fontSize: AppType.sm,
                    color: AppColors.muted,
                  ),
                ),
              ),
          ],
        ),
      ],
    ];
  }
}

String _animalSummary(AnimalSpecies a) {
  Span? first(List<RangeReport> r) =>
      r.isEmpty ? null : r.first.optimal ?? r.first.tolerated;
  final temp = first(a.tempF);
  final ph = first(a.ph);
  return [
    a.kind.label,
    if (temp != null) '${formatSpan(temp)}°F',
    if (ph != null) 'pH ${formatSpan(ph)}',
    if (a.adultSizeIn.isNotEmpty) '${formatSpan(a.adultSizeIn.first.value)} in',
  ].join(' · ');
}

String _plantSummary(PlantSpecies p) => [
  if (p.light.isNotEmpty) '${p.light.first.value.label} light',
  if (p.co2.isNotEmpty) 'CO₂ ${p.co2.first.value.label.toLowerCase()}',
  if (p.placement != null) p.placement!.value.first.label,
].join(' · ');

class _SpeciesRow extends StatelessWidget {
  const _SpeciesRow({
    required this.commonName,
    required this.scientificName,
    required this.summary,
    required this.onTap,
  });

  final String commonName;
  final String scientificName;
  final String summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: AppSpace.s4,
        right: AppSpace.s2,
        top: AppSpace.s1,
        bottom: AppSpace.s1,
      ),
      title: Text(commonName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scientificName,
            style: const TextStyle(
              fontSize: AppType.sm,
              fontStyle: FontStyle.italic,
              color: AppColors.muted,
            ),
          ),
          if (summary.isNotEmpty)
            Text(
              summary,
              style: const TextStyle(
                fontSize: AppType.sm,
                color: AppColors.muted,
              ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.s5),
      decoration: BoxDecoration(
        color: AppColors.recessed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.set_meal_outlined, color: AppColors.muted, size: 32),
          const SizedBox(height: AppSpace.s2),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppType.sm,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
