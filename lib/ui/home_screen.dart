import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import '../domain/units.dart';
import '../notifications/reminder_notifier.dart';
import 'kit_setup_screen.dart';
import 'labels.dart';
import 'species_browser_screen.dart';
import 'tank_form_screen.dart';
import 'tank_screen.dart';
import 'theme.dart';
import 'widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showArchived = false;

  // Home stays mounted for the app's lifetime, so it owns keeping scheduled reminders in sync.
  @override
  void initState() {
    super.initState();
    ref.listenManual<List<PlannedReminder>?>(reminderPlanProvider, (
      previous,
      next,
    ) {
      if (next != null && !listEquals(previous, next)) {
        ref.read(reminderNotifierProvider).replaceAll(next);
      }
    }, fireImmediately: true);
  }

  void _openForm([Tank? tank]) =>
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (_) => TankFormScreen(tank: tank)));

  void _openKit([TestKit? kit, List<KitParameter> parameters = const []]) =>
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => KitSetupScreen(kit: kit, parameters: parameters),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final tanks = ref.watch(tanksProvider);
    final kits = ref.watch(testKitsProvider);
    final params = ref.watch(kitParametersProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.8, -1.1),
              radius: 1.2,
              colors: [Color(0x1A2997FF), AppColors.bg],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.s4,
                AppSpace.s5,
                AppSpace.s4,
                AppSpace.s5,
              ),
              children: [
                const Text(
                  'Aquarium',
                  style: TextStyle(
                    fontSize: AppType.largeTitle,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: AppSpace.s5),
                SectionHeader(
                  'Tanks',
                  trailing: FilledButton.icon(
                    onPressed: _openForm,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add tank'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.s3,
                      ),
                      textStyle: const TextStyle(
                        fontSize: AppType.sm + 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ..._asyncList(tanks, (rows) {
                  final active = rows.where((t) => !t.archived).toList();
                  final archived = rows.where((t) => t.archived).toList();
                  return [
                    if (active.isEmpty)
                      const _EmptyTanks()
                    else
                      for (final tank in active)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpace.s3),
                          child: _TankCard(
                            tank,
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => TankScreen(tankId: tank.id),
                              ),
                            ),
                          ),
                        ),
                    if (archived.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _showArchived = !_showArchived),
                          icon: Icon(
                            _showArchived
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            size: 18,
                          ),
                          label: Text(
                            _showArchived
                                ? 'Hide archived'
                                : 'Show archived (${archived.length})',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.muted,
                          ),
                        ),
                      ),
                      if (_showArchived)
                        for (final tank in archived)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpace.s3),
                            child: Opacity(
                              opacity: 0.55,
                              child: _TankCard(
                                tank,
                                onTap: () => _openForm(tank),
                              ),
                            ),
                          ),
                    ],
                  ];
                }),
                const SizedBox(height: AppSpace.s4),
                const SectionHeader('Fish & plants'),
                GroupedSection(
                  children: [
                    ListTile(
                      onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => const SpeciesBrowserScreen(),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: AppSpace.s4,
                        right: AppSpace.s2,
                      ),
                      leading: const Icon(
                        Icons.set_meal_outlined,
                        color: AppColors.muted,
                      ),
                      title: const Text('Browse species'),
                      subtitle: const Text(
                        'Care ranges from cited sources',
                        style: TextStyle(
                          fontSize: AppType.sm,
                          color: AppColors.muted,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.muted2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.s4),
                SectionHeader(
                  'Test kits',
                  trailing: TextButton.icon(
                    onPressed: _openKit,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add kit'),
                  ),
                ),
                ..._asyncList(
                  kits,
                  (rows) => [
                    _KitGroup(
                      kits: rows,
                      params: params.value ?? const [],
                      onOpen: _openKit,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.s2),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpace.s1),
                  child: Text(
                    "Before your first reading, enter the steps printed on each bottle's color chart.",
                    style: TextStyle(
                      fontSize: AppType.sm,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _asyncList<T>(
    AsyncValue<T> value,
    List<Widget> Function(T) data,
  ) => value.when(
    data: data,
    loading: () => const [
      Padding(
        padding: EdgeInsets.all(AppSpace.s4),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    ],
    error: (e, _) => [
      const Text(
        "Couldn't load your data. Restart the app to try again.",
        style: TextStyle(color: AppColors.fail, fontSize: AppType.sm),
      ),
    ],
  );
}

class _EmptyTanks extends StatelessWidget {
  const _EmptyTanks();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.s5),
      decoration: BoxDecoration(
        color: AppColors.recessed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.water_drop_outlined, color: AppColors.muted, size: 32),
          SizedBox(height: AppSpace.s2),
          Text(
            'No tanks yet',
            style: TextStyle(
              fontSize: AppType.lg,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: AppSpace.s1),
          Text(
            'Add a tank to start tracking its cycle.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppType.sm, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _TankCard extends ConsumerWidget {
  const _TankCard(this.tank, {required this.onTap});

  final Tank tank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(cycleStatusProvider(tank));
    final details = [
      '${formatNumber(tank.volumeGal)} gal',
      if (tank.hasSoil)
        'Soil'
      else if (tank.substrateType.isNotEmpty)
        tank.substrateType,
      tank.waterSource.label,
    ].join(' · ');

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s4),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tank.name,
                      style: const TextStyle(
                        fontSize: AppType.lg,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s1),
                    Text(
                      details,
                      style: const TextStyle(
                        fontSize: AppType.sm,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpace.s2),
                    if (status.value case final s?) StageChip(s.stage),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted2),
            ],
          ),
        ),
      ),
    );
  }
}

class _KitGroup extends StatelessWidget {
  const _KitGroup({
    required this.kits,
    required this.params,
    required this.onOpen,
  });

  final List<TestKit> kits;
  final List<KitParameter> params;
  final void Function(TestKit, List<KitParameter>) onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (i, kit) in kits.indexed) ...[
            if (i > 0) const Divider(indent: AppSpace.s4 + 32 + AppSpace.s3),
            _KitRow(
              kit,
              params.where((p) => p.kitId == kit.id).toList(),
              onOpen: onOpen,
            ),
          ],
        ],
      ),
    );
  }
}

class _KitRow extends StatelessWidget {
  const _KitRow(this.kit, this.params, {required this.onOpen});

  final TestKit kit;
  final List<KitParameter> params;
  final void Function(TestKit, List<KitParameter>) onOpen;

  @override
  Widget build(BuildContext context) {
    final needsSteps = params.any(
      (p) => p.inputMode == InputMode.steps && (p.stepsJson?.isEmpty ?? true),
    );

    return InkWell(
      onTap: () => onOpen(kit, params),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.s4),
        child: Row(
          children: [
            const Icon(
              Icons.science_outlined,
              color: AppColors.muted,
              size: 32,
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kit.name,
                    style: const TextStyle(
                      fontSize: AppType.md,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    params.map((p) => p.parameter.label).join(' · '),
                    style: const TextStyle(
                      fontSize: AppType.sm,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (needsSteps)
              const Pill(
                icon: Icons.warning_amber_rounded,
                text: 'Steps needed',
                color: AppColors.warn,
              ),
            const SizedBox(width: AppSpace.s1),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted2),
          ],
        ),
      ),
    );
  }
}
