import 'package:flutter/material.dart';

import '../domain/species.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

const notStated = 'Not stated by sources';

class AnimalDetailScreen extends StatelessWidget {
  const AnimalDetailScreen({super.key, required this.species});

  final AnimalSpecies species;

  @override
  Widget build(BuildContext context) {
    final a = species;
    final s = a.sources;
    final knownFlags = [
      for (final flag in AnimalFlag.values)
        if (a.flags[flag] case final r?) (flag, r),
    ];
    final unknownFlags = [
      for (final flag in AnimalFlag.values)
        if (!a.flags.containsKey(flag)) flag.label.toLowerCase(),
    ];

    return _DetailScaffold(
      commonName: a.commonName,
      scientificName: a.scientificName,
      pills: [a.tier.label, a.kind.label],
      sections: [
        _Section('Water', [
          _Field('Temperature', _ranges(a.tempF, '°F', s)),
          _Field('pH', _ranges(a.ph, '', s)),
          _Field('GH', _ranges(a.gh, ' dGH', s)),
          _Field('KH', _ranges(a.kh, ' dKH', s)),
        ]),
        _Section('Size and space', [
          _Field('Adult size', [
            for (final r in a.adultSizeIn)
              '${formatSpan(r.value)} in (${sourceName(s, r.source)})',
          ]),
          _Field('Minimum tank', [for (final t in a.minTank) _tankSize(t, s)]),
          _Field('Group', [
            if (a.minGroupSize case final r?)
              'At least ${r.value} (${sourceName(s, r.source)})',
          ]),
        ]),
        _Section(
          'Behavior',
          [
            _Field('Temperament', [
              if (a.temperament case final r?)
                '${r.value.label} (${sourceName(s, r.source)})',
            ]),
            _Field('Swim level', [
              if (a.swimLevel case final r?)
                '${r.value.label} (${sourceName(s, r.source)})',
            ]),
            for (final (flag, r) in knownFlags)
              _Field(flag.label, [
                '${r.value ? 'Yes' : 'No'} (${sourceName(s, r.source)})',
              ]),
          ],
          footer: unknownFlags.isEmpty
              ? null
              : 'Not stated by sources: ${unknownFlags.join(', ')}.',
        ),
        if (a.intermediateReasons.isNotEmpty)
          _Section('Why intermediate', [
            for (final r in a.intermediateReasons) _Field(r.label, const []),
          ], plain: true),
      ],
      notes: a.notes,
      sources: s,
    );
  }
}

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key, required this.plant});

  final PlantSpecies plant;

  @override
  Widget build(BuildContext context) {
    final p = plant;
    final s = p.sources;

    List<String> rated<T>(List<Rated<T>> ratings, String Function(T) label) => [
      for (final r in ratings) '${label(r.value)} (${sourceName(s, r.source)})',
    ];
    List<String> one<T>(Rated<T>? r, String Function(T) label) => r == null
        ? const []
        : ['${label(r.value)} (${sourceName(s, r.source)})'];
    String yesNo(bool v) => v ? 'Yes' : 'No';
    String cm(Span span) => '${formatSpan(span)} cm';

    return _DetailScaffold(
      commonName: p.commonName,
      scientificName: p.scientificName,
      pills: [p.tier.label, 'Plant'],
      sections: [
        _Section('Water', [
          _Field('Temperature', _ranges(p.tempF, '°F', s)),
          _Field('pH', _ranges(p.ph, '', s)),
          _Field('KH', _ranges(p.kh, ' dKH', s)),
        ]),
        _Section('Growing', [
          _Field('Light', rated(p.light, (v) => v.label)),
          _Field('CO₂', rated(p.co2, (v) => v.label)),
          _Field('Growth', rated(p.growthRate, (v) => v.label)),
          _Field(
            'Placement',
            one(p.placement, (v) => v.map((x) => x.label).join(', ')),
          ),
          _Field('Attach to wood or rock', one(p.epiphyte, yesNo)),
          _Field('Feeds through roots', one(p.rootFeeder, yesNo)),
        ]),
        // Sources mean different things by "height", so each kind is shown apart.
        _Section('Height', [
          _Field('After 2 months', one(p.heightAfter2MonthsCm, cm)),
          _Field('Care height', one(p.careHeightCm, cm)),
          _Field('Maximum', one(p.maxHeightCm, cm)),
        ]),
      ],
      notes: p.notes,
      sources: s,
    );
  }
}

List<String> _ranges(
  List<RangeReport> reports,
  String unit,
  Map<String, String> sources,
) => [
  for (final r in reports)
    '${[if (r.optimal != null) 'Ideal ${formatSpan(r.optimal!)}$unit', if (r.tolerated != null) 'tolerates ${formatSpan(r.tolerated!)}$unit'].join(', ')} (${sourceName(sources, r.source)})',
];

String _tankSize(TankSize t, Map<String, String> sources) {
  final base = [
    if (t.lengthCm != null) formatNumber(t.lengthCm!),
    if (t.widthCm != null) formatNumber(t.widthCm!),
  ].join(' × ');
  final parts = [
    if (base.isNotEmpty) '$base cm base',
    if (t.gallons != null) '${formatNumber(t.gallons!)} gal',
  ];
  return '${parts.join(', ')} (${sourceName(sources, t.source)})';
}

class _Section {
  const _Section(this.title, this.fields, {this.footer, this.plain = false});

  final String title;
  final List<_Field> fields;
  final String? footer;
  final bool plain;
}

class _Field {
  const _Field(this.label, this.lines);

  final String label;
  final List<String> lines;
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({
    required this.commonName,
    required this.scientificName,
    required this.pills,
    required this.sections,
    required this.notes,
    required this.sources,
  });

  final String commonName;
  final String scientificName;
  final List<String> pills;
  final List<_Section> sections;
  final String? notes;
  final Map<String, String> sources;

  @override
  Widget build(BuildContext context) {
    const muted = TextStyle(fontSize: AppType.sm, color: AppColors.muted);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.s4,
          0,
          AppSpace.s4,
          AppSpace.s5,
        ),
        children: [
          Text(
            commonName,
            style: const TextStyle(
              fontSize: AppType.xl + 4,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          Text(
            scientificName,
            style: const TextStyle(
              fontSize: AppType.md,
              fontStyle: FontStyle.italic,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: AppSpace.s3),
          Wrap(
            spacing: AppSpace.s2,
            children: [
              for (final p in pills) Pill(icon: Icons.label_outline, text: p),
            ],
          ),
          for (final section in sections) ...[
            const SizedBox(height: AppSpace.s5),
            SectionHeader(section.title),
            GroupedSection(
              children: [
                for (final f in section.fields)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.s4,
                    ),
                    title: Text(f.label),
                    subtitle: section.plain
                        ? null
                        : Text(
                            f.lines.isEmpty ? notStated : f.lines.join('\n'),
                            style: f.lines.isEmpty
                                ? muted.copyWith(color: AppColors.muted2)
                                : muted,
                          ),
                  ),
              ],
            ),
            if (section.footer != null) ...[
              const SizedBox(height: AppSpace.s2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s1),
                child: Text(section.footer!, style: muted),
              ),
            ],
          ],
          if (notes != null) ...[
            const SizedBox(height: AppSpace.s5),
            const SectionHeader('Notes'),
            Text(notes!),
          ],
          const SizedBox(height: AppSpace.s5),
          const SectionHeader('Sources'),
          GroupedSection(
            children: [
              for (final key in sources.keys)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s4,
                  ),
                  title: Text(sourceName(sources, key)),
                  subtitle: SelectableText(sources[key]!, style: muted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
