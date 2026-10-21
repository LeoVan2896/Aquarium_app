import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import '../domain/fit_checks.dart';
import '../domain/recommendations.dart';
import '../domain/species.dart';
import 'add_reading_screen.dart';
import 'add_stock_screen.dart';
import 'charts.dart';
import 'dashboard.dart';
import 'labels.dart';
import 'log_event_screen.dart';
import 'reminder_screen.dart';
import 'species_detail_screen.dart';
import 'tank_form_screen.dart';
import 'what_fits_screen.dart';
import 'theme.dart';
import 'value_input.dart';
import 'widgets.dart';

class TankScreen extends ConsumerWidget {
  const TankScreen({super.key, required this.tankId});

  final int tankId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tanks = ref.watch(tanksProvider).value ?? const <Tank>[];
    final tank = tanks.where((t) => t.id == tankId).firstOrNull;
    if (tank == null) return const Scaffold();

    final dashboard = ref.watch(tankDashboardProvider(tank)).value;
    final readings = ref.watch(tankReadingsProvider(tankId)).value ?? const [];
    final events = ref.watch(tankEventsProvider(tankId)).value ?? const [];
    final stockEntries =
        ref.watch(tankStockEntriesProvider(tankId)).value ?? const [];
    final stock = ref.watch(stockContextProvider(tank)).value;
    final names = {
      for (final a in stock?.catalog.animals ?? const <AnimalSpecies>[])
        (SpeciesType.animal, a.id): a.commonName,
      for (final p in stock?.catalog.plants ?? const <PlantSpecies>[])
        (SpeciesType.plant, p.id): p.commonName,
    };
    final entries = _historyEntries(readings, events, stockEntries);

    return Scaffold(
      appBar: AppBar(
        title: Text(tank.name),
        actions: [
          IconButton(
            tooltip: 'Reminders',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => ReminderScreen(
                  tank: tank,
                  existing: (ref.read(remindersProvider).value ?? const [])
                      .where((r) => r.tankId == tank.id)
                      .firstOrNull,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Edit tank',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(builder: (_) => TankFormScreen(tank: tank)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s4),
        children: [
          if (stock?.alerts.where((a) => a.check.status == CheckStatus.fail)
              case final fails? when fails.isNotEmpty) ...[
            SpeciesAlertBanner(fails.toList()),
            const SizedBox(height: AppSpace.s3),
          ],
          if (dashboard != null) ...[
            if (dashboard.softened case final warning?) ...[
              SoftenedBanner(warning),
              const SizedBox(height: AppSpace.s3),
            ],
            CycleCard(
              status: dashboard.status,
              prediction: dashboard.prediction,
            ),
            const SizedBox(height: AppSpace.s5),
            if (dashboard.latest.isNotEmpty) ...[
              const SectionHeader('Latest'),
              LatestValues(dashboard.latest),
              const SizedBox(height: AppSpace.s5),
              const SectionHeader('Trends'),
              ParameterCharts(
                readings: dashboard.readings,
                events: dashboard.events,
                now: ref.watch(clockProvider)(),
              ),
              const SizedBox(height: AppSpace.s5),
            ],
          ],
          if (stock != null) ...[
            _StockSection(tank: tank, stock: stock),
            const SizedBox(height: AppSpace.s5),
          ],
          const SectionHeader('History'),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpace.s1),
              child: Text(
                'Nothing logged yet. Add a reading after your next test, or log a water change or dose.',
                style: TextStyle(fontSize: AppType.sm, color: AppColors.muted),
              ),
            ),
          for (final day in _groupByDay(entries)) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.s1,
                AppSpace.s2,
                0,
                AppSpace.s2,
              ),
              child: Text(
                formatDate(day.first.at),
                style: const TextStyle(
                  fontSize: AppType.xs + 1,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted2,
                ),
              ),
            ),
            GroupedSection(
              children: [
                for (final entry in day)
                  switch (entry) {
                    _ReadingEntry() => _ReadingRow(
                      entry,
                      onTap: () => _correct(context, entry.reading),
                    ),
                    _StockItem() => _StockRow(
                      entry,
                      name:
                          names[(
                            entry.entry.speciesType,
                            entry.entry.speciesId,
                          )] ??
                          entry.entry.speciesId,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.surface,
                        showDragHandle: true,
                        builder: (_) => _StockCorrectionSheet(entry.entry),
                      ),
                    ),
                    _EventEntry() => _EventRow(
                      entry,
                      onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => LogEventScreen(
                            tankId: tankId,
                            correcting: entry.event,
                          ),
                        ),
                      ),
                    ),
                  },
              ],
            ),
            const SizedBox(height: AppSpace.s3),
          ],
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
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => LogEventScreen(tankId: tankId),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.surface2,
                    foregroundColor: AppColors.text,
                    side: const BorderSide(color: AppColors.border2),
                  ),
                  icon: const Icon(Icons.water_drop_outlined),
                  label: const Text('Log event'),
                ),
              ),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => AddReadingScreen(tankId: tankId),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add reading'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _correct(BuildContext context, Reading reading) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    builder: (_) => _CorrectionSheet(reading),
  );
}

sealed class _Entry {
  DateTime get at;
}

class _ReadingEntry extends _Entry {
  _ReadingEntry(this.reading, this.replaced);

  final Reading reading;
  final Reading? replaced;

  @override
  DateTime get at => reading.takenAt;
}

class _EventEntry extends _Entry {
  _EventEntry(this.event, this.replaced);

  final Event event;
  final Event? replaced;

  @override
  DateTime get at => event.occurredAt;
}

class _StockItem extends _Entry {
  _StockItem(this.entry, this.replaced);

  final StockEntry entry;
  final StockEntry? replaced;

  @override
  DateTime get at => entry.occurredAt;
}

List<_Entry> _historyEntries(
  List<Reading> readings,
  List<Event> events,
  List<StockEntry> stock,
) {
  final readingsById = {for (final r in readings) r.id: r};
  final eventsById = {for (final e in events) e.id: e};
  final stockById = {for (final s in stock) s.id: s};
  final supersededStock = {
    for (final s in stock)
      if (s.correctsId != null) s.correctsId,
  };
  final supersededReadings = {
    for (final r in readings)
      if (r.correctsId != null) r.correctsId,
  };
  final supersededEvents = {
    for (final e in events)
      if (e.correctsId != null) e.correctsId,
  };
  return [
    for (final r in readings)
      if (!supersededReadings.contains(r.id))
        _ReadingEntry(r, readingsById[r.correctsId]),
    for (final e in events)
      if (!supersededEvents.contains(e.id))
        _EventEntry(e, eventsById[e.correctsId]),
    for (final s in stock)
      if (!supersededStock.contains(s.id))
        _StockItem(s, stockById[s.correctsId]),
  ]..sort((a, b) => b.at.compareTo(a.at));
}

List<List<_Entry>> _groupByDay(List<_Entry> entries) {
  final days = <List<_Entry>>[];
  for (final e in entries) {
    final last = days.lastOrNull;
    if (last != null && DateUtils.isSameDay(last.first.at, e.at)) {
      last.add(e);
    } else {
      days.add([e]);
    }
  }
  return days;
}

class _ReadingRow extends StatelessWidget {
  const _ReadingRow(this.entry, {required this.onTap});

  final _ReadingEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = entry.reading;
    final replaced = entry.replaced;
    final details = [
      formatTime(r.takenAt),
      if (replaced != null)
        'Corrected · was ${formatValue(replaced.value, replaced.unit)}',
      ?r.note,
    ].join(' · ');

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      leading: const Icon(Icons.science_outlined, color: AppColors.muted),
      title: Text(r.parameter.label),
      subtitle: Text(
        details,
        style: const TextStyle(fontSize: AppType.sm, color: AppColors.muted),
      ),
      trailing: Text(
        formatValue(r.value, r.unit),
        style: const TextStyle(
          fontSize: AppType.md,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow(this.entry, {required this.onTap});

  final _EventEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final e = entry.event;
    final replaced = entry.replaced;
    final what = describeEvent(
      product: e.product,
      amount: e.amount,
      amountUnit: e.amountUnit,
      percentChanged: e.percentChanged,
    );
    final details = [
      formatTime(e.occurredAt),
      if (what.isNotEmpty) what,
      if (replaced != null) 'Corrected',
      ?e.note,
    ].join(' · ');

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      leading: Icon(switch (e.type) {
        EventType.waterChange => Icons.water_drop_outlined,
        EventType.dose || EventType.ammoniaDose => Icons.colorize_outlined,
        EventType.other => Icons.notes_rounded,
      }, color: AppColors.muted),
      title: Text(e.type.label),
      subtitle: Text(
        details,
        style: const TextStyle(fontSize: AppType.sm, color: AppColors.muted),
      ),
    );
  }
}

class _CorrectionSheet extends ConsumerStatefulWidget {
  const _CorrectionSheet(this.original);

  final Reading original;

  @override
  ConsumerState<_CorrectionSheet> createState() => _CorrectionSheetState();
}

class _CorrectionSheetState extends ConsumerState<_CorrectionSheet> {
  late double? _value = widget.original.value;
  late DateTime _takenAt = widget.original.takenAt;
  late final _note = TextEditingController(text: widget.original.note);
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _value;
    if (value == null) return;
    setState(() => _saving = true);
    final note = _note.text.trim();
    await ref
        .read(databaseProvider)
        .correctReading(
          widget.original,
          value: value,
          takenAt: _takenAt,
          note: note.isEmpty ? null : note,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.original;
    final kitParam = (ref.watch(kitParametersProvider).value ?? const [])
        .where((p) => p.kitId == r.kitId && p.parameter == r.parameter)
        .firstOrNull;
    final steps = kitParam?.stepsJson ?? const <double>[];
    final useSteps =
        kitParam?.inputMode == InputMode.steps &&
        steps.isNotEmpty &&
        kitParam?.unit == r.unit;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.s4,
        0,
        AppSpace.s4,
        AppSpace.s4 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Correct ${r.parameter.label} reading',
              style: const TextStyle(
                fontSize: AppType.xl,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpace.s1),
            Text(
              'Logged as ${formatValue(r.value, r.unit)} on ${formatDateTime(r.takenAt)}. The original stays in the log; the correction replaces it everywhere else.',
              style: const TextStyle(
                fontSize: AppType.sm,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            ValueInput(
              mode: useSteps ? InputMode.steps : InputMode.free,
              steps: steps,
              unit: r.unit,
              initial: r.value,
              label: 'Corrected value',
              onChanged: (v) => setState(() => _value = v),
            ),
            const SizedBox(height: AppSpace.s3),
            GroupedSection(
              children: [
                DateTimeRow(
                  label: 'Taken',
                  value: _takenAt,
                  onChanged: (t) => setState(() => _takenAt = t),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.s3),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
            const SizedBox(height: AppSpace.s4),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving || _value == null ? null : _save,
                child: const Text('Save correction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockSection extends StatelessWidget {
  const _StockSection({required this.tank, required this.stock});

  final Tank tank;
  final StockContext stock;

  void _push(BuildContext context, Widget screen) =>
      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen));

  CheckStatus? _worstAlert(String name) {
    final statuses = {
      for (final a in stock.alerts)
        if (a.speciesName == name) a.check.status,
    };
    return statuses.contains(CheckStatus.fail)
        ? CheckStatus.fail
        : statuses.contains(CheckStatus.caution)
        ? CheckStatus.caution
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final stale = staleWaterTests(stock.conditions);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          'Stock',
          trailing: TextButton.icon(
            onPressed: () => _push(context, AddStockScreen(tank: tank)),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add'),
          ),
        ),
        if (stock.stock.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpace.s1),
            child: Text(
              stock.fishGated
                  ? 'No fish or plants yet. Plants can go in now; wait for the cycle to finish before adding fish.'
                  : 'No fish or plants yet.',
              style: const TextStyle(
                fontSize: AppType.sm,
                color: AppColors.muted,
              ),
            ),
          )
        else
          GroupedSection(
            children: [
              for (final s in stock.stock)
                ListTile(
                  onTap: switch ((s.animal, s.plant)) {
                    (final a?, _) => () => _push(
                      context,
                      AnimalDetailScreen(species: a),
                    ),
                    (_, final p?) => () => _push(
                      context,
                      PlantDetailScreen(plant: p),
                    ),
                    _ => null,
                  },
                  contentPadding: const EdgeInsets.only(
                    left: AppSpace.s4,
                    right: AppSpace.s1,
                  ),
                  leading: switch (_worstAlert(s.name)) {
                    CheckStatus.fail => const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.fail,
                    ),
                    CheckStatus.caution => const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warn,
                    ),
                    _ => Icon(
                      s.type == SpeciesType.plant
                          ? Icons.grass_rounded
                          : Icons.set_meal_outlined,
                      color: AppColors.muted,
                    ),
                  },
                  title: Text(s.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '×${s.count}',
                        style: const TextStyle(
                          fontSize: AppType.md,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove ${s.name}',
                        onPressed: () => _push(
                          context,
                          AddStockScreen(tank: tank, removing: s),
                        ),
                        icon: const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        const SizedBox(height: AppSpace.s3),
        GroupedSection(
          children: [
            ListTile(
              onTap: () => _push(context, WhatFitsScreen(tank: tank)),
              contentPadding: const EdgeInsets.only(
                left: AppSpace.s4,
                right: AppSpace.s2,
              ),
              leading: const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.muted,
              ),
              title: const Text('What fits this tank'),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted2,
              ),
            ),
            if (stale.isNotEmpty)
              ListTile(
                onTap: () => _push(context, AddReadingScreen(tankId: tank.id)),
                contentPadding: const EdgeInsets.only(
                  left: AppSpace.s4,
                  right: AppSpace.s2,
                ),
                leading: const Icon(
                  Icons.science_outlined,
                  color: AppColors.warn,
                ),
                title: Text('Test ${_list(stale)} to update fit checks'),
                subtitle: Text(
                  'No reading in the last ${stock.conditionsMaxAgeDays} days.',
                  style: const TextStyle(
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
      ],
    );
  }
}

String _list(List<String> items) => items.length <= 1
    ? items.join()
    : '${items.sublist(0, items.length - 1).join(', ')} and ${items.last}';

class _StockRow extends StatelessWidget {
  const _StockRow(this.item, {required this.name, required this.onTap});

  final _StockItem item;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final e = item.entry;
    final replaced = item.replaced;
    final details = [
      formatTime(e.occurredAt),
      if (replaced != null) 'Corrected · was ${replaced.change.abs()}',
      ?e.note,
    ].join(' · ');

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      leading: Icon(
        e.change < 0 ? Icons.logout_rounded : Icons.login_rounded,
        color: AppColors.muted,
      ),
      title: Text('${e.change < 0 ? 'Removed' : 'Added'} $name'),
      subtitle: Text(
        details,
        style: const TextStyle(fontSize: AppType.sm, color: AppColors.muted),
      ),
      trailing: Text(
        '${e.change.abs()}',
        style: const TextStyle(
          fontSize: AppType.md,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StockCorrectionSheet extends ConsumerStatefulWidget {
  const _StockCorrectionSheet(this.original);

  final StockEntry original;

  @override
  ConsumerState<_StockCorrectionSheet> createState() =>
      _StockCorrectionSheetState();
}

class _StockCorrectionSheetState extends ConsumerState<_StockCorrectionSheet> {
  late int _count = widget.original.change.abs();
  late DateTime _at = widget.original.occurredAt;
  late final _note = TextEditingController(text: widget.original.note);
  bool _saving = false;

  bool get _removal => widget.original.change < 0;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final note = _note.text.trim();
    await ref
        .read(databaseProvider)
        .correctStockEntry(
          widget.original,
          change: _removal ? -_count : _count,
          occurredAt: _at,
          note: note.isEmpty ? null : note,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final verb = _removal ? 'removed' : 'added';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.s4,
        0,
        AppSpace.s4,
        AppSpace.s4 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Correct stock entry',
              style: TextStyle(
                fontSize: AppType.xl,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpace.s1),
            Text(
              'Logged ${widget.original.change.abs()} $verb on ${formatDateTime(widget.original.occurredAt)}. Set 0 if it never happened. The original stays in the log.',
              style: const TextStyle(
                fontSize: AppType.sm,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            GroupedSection(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: AppSpace.s4,
                    right: AppSpace.s2,
                  ),
                  title: Text('How many $verb'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Fewer',
                        onPressed: _count > 0
                            ? () => setState(() => _count--)
                            : null,
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
                        onPressed: () => setState(() => _count++),
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ),
                DateTimeRow(
                  label: _removal ? 'Removed' : 'Added',
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
            const SizedBox(height: AppSpace.s4),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Save correction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
