import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../domain/reminder_schedule.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

const maxEveryNDays = 30;

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key, required this.tank, this.existing});

  final Tank tank;
  final Reminder? existing;

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  late bool _enabled = widget.existing?.enabled ?? true;
  late int _everyNDays = widget.existing?.everyNDays ?? 1;
  late TimeOfDayHm _time =
      parseTimeOfDay(widget.existing?.timeOfDay ?? '') ?? (hour: 9, minute: 0);
  late final List<Object?> _initial;
  bool _permissionDenied = false;
  bool _testSent = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _initial = _snapshot();
  }

  List<Object?> _snapshot() => [_enabled, _everyNDays, _time];

  bool _hasChanges() => !listEquals(_snapshot(), _initial);

  Future<bool> _ensurePermission() async {
    final granted = await ref
        .read(reminderNotifierProvider)
        .requestPermission();
    if (mounted) setState(() => _permissionDenied = !granted);
    return granted;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(databaseProvider)
        .saveReminder(
          tankId: widget.tank.id,
          everyNDays: _everyNDays,
          timeOfDay: formatTimeOfDay(_time),
          enabled: _enabled,
        );
    final granted = !_enabled || await _ensurePermission();
    if (!mounted) return;
    if (granted) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
      _initial
        ..clear()
        ..addAll(_snapshot());
    }
  }

  Future<void> _sendTest() async {
    if (!await _ensurePermission()) return;
    await ref.read(reminderNotifierProvider).sendTest(widget.tank.name);
    if (mounted) setState(() => _testSent = true);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _time.hour, minute: _time.minute),
    );
    if (picked != null) {
      setState(() => _time = (hour: picked.hour, minute: picked.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final readings = ref.watch(allReadingsProvider).value ?? const [];
    final lastTest = lastTestFor(readings, widget.tank.id);
    final upcoming = upcomingReminders(
      everyNDays: _everyNDays,
      time: _time,
      now: ref.watch(clockProvider)(),
      lastTestAt: lastTest,
      count: 3,
    );
    final timeLabel = formatTime(
      DateTime(2000, 1, 1, _time.hour, _time.minute),
    );

    return DiscardChangesGuard(
      hasChanges: _hasChanges,
      child: Scaffold(
        appBar: AppBar(title: const Text('Reminders')),
        body: ListView(
          padding: const EdgeInsets.all(AppSpace.s4),
          children: [
            if (_permissionDenied) ...[
              const _PermissionBanner(),
              const SizedBox(height: AppSpace.s4),
            ],
            GroupedSection(
              children: [
                SwitchListTile(
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                  title: const Text('Remind me to test'),
                  subtitle: Text(
                    widget.tank.name,
                    style: const TextStyle(
                      fontSize: AppType.sm,
                      color: AppColors.muted,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s4,
                  ),
                ),
                if (_enabled) ...[
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      left: AppSpace.s4,
                      right: AppSpace.s2,
                    ),
                    leading: const Icon(
                      Icons.repeat_rounded,
                      color: AppColors.muted,
                    ),
                    title: Text(
                      _everyNDays == 1
                          ? 'Every day'
                          : 'Every $_everyNDays days',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Fewer days',
                          onPressed: _everyNDays > 1
                              ? () => setState(() => _everyNDays--)
                              : null,
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        IconButton(
                          tooltip: 'More days',
                          onPressed: _everyNDays < maxEveryNDays
                              ? () => setState(() => _everyNDays++)
                              : null,
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: _pickTime,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.s4,
                    ),
                    leading: const Icon(
                      Icons.schedule_rounded,
                      color: AppColors.muted,
                    ),
                    title: const Text('Time'),
                    trailing: Text(timeLabel),
                  ),
                ],
              ],
            ),
            if (_enabled) ...[
              const SizedBox(height: AppSpace.s5),
              const SectionHeader('Next reminders'),
              GroupedSection(
                children: [
                  for (final at in upcoming)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.s4,
                      ),
                      title: Text(formatDateTime(at)),
                    ),
                ],
              ),
              const SizedBox(height: AppSpace.s2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s1),
                child: Text(
                  lastTest == null
                      ? 'Counted from today until you log a reading.'
                      : 'Counted from your last reading on ${formatDate(lastTest)}. Logging a reading moves them.',
                  style: const TextStyle(
                    fontSize: AppType.sm,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpace.s5),
            GroupedSection(
              children: [
                ListTile(
                  onTap: _sendTest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s4,
                  ),
                  leading: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.muted,
                  ),
                  title: const Text('Send a test reminder'),
                  subtitle: _testSent
                      ? const Text(
                          'Sent. It should appear within a minute.',
                          style: TextStyle(
                            fontSize: AppType.sm,
                            color: AppColors.pass,
                          ),
                        )
                      : null,
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
              onPressed: _saving ? null : _save,
              child: const Text('Save reminders'),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.s4),
      decoration: BoxDecoration(
        color: AppColors.recessed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.warn.withValues(alpha: 0.5)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_off_outlined, color: AppColors.warn),
          SizedBox(width: AppSpace.s3),
          Expanded(
            child: Text(
              'Notifications are off for this app, so reminders can\'t appear. Turn them on in Android Settings › Apps › aquarium_app › Notifications.',
            ),
          ),
        ],
      ),
    );
  }
}
