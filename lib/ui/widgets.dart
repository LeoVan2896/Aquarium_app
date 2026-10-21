import 'package:flutter/material.dart';

import '../domain/cycle_engine.dart';
import 'labels.dart';
import 'theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpace.s1, bottom: AppSpace.s2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppType.sm,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({super.key, required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.muted;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s2 + 2,
        vertical: AppSpace.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: AppSpace.s1),
          Text(
            text,
            style: TextStyle(
              fontSize: AppType.xs + 1,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class StageChip extends StatelessWidget {
  const StageChip(this.stage, {super.key});

  final CycleStage stage;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (stage) {
      CycleStage.notStarted => (Icons.radio_button_unchecked, AppColors.muted),
      CycleStage.ammoniaPhase || CycleStage.nitritePhase => (
        Icons.hourglass_bottom_rounded,
        AppColors.warn,
      ),
      CycleStage.doseTest => (Icons.science_outlined, AppColors.text),
      CycleStage.cycled => (Icons.check_rounded, AppColors.pass),
      CycleStage.readyToStock => (Icons.check_circle_rounded, AppColors.pass),
    };
    return Pill(icon: icon, text: stage.label, color: color);
  }
}

// Navigator.pop() after a save bypasses this; only back button and gesture are guarded.
class DiscardChangesGuard extends StatelessWidget {
  const DiscardChangesGuard({
    super.key,
    required this.hasChanges,
    required this.child,
  });

  final bool Function() hasChanges;
  final Widget child;

  Future<bool> _confirm(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Discard changes?'),
          content: const Text("You haven't saved. Your changes will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep editing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.fail),
              child: const Text('Discard'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!hasChanges() || await _confirm(context)) navigator.pop(result);
      },
      child: child,
    );
  }
}

class DateTimeRow extends StatelessWidget {
  const DateTimeRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  Future<void> _pick(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
    );
    if (time == null) return;
    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _pick(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      leading: const Icon(Icons.schedule_rounded, color: AppColors.muted),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formatDateTime(value)),
          const SizedBox(width: AppSpace.s1),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.muted2,
          ),
        ],
      ),
    );
  }
}

class GroupedSection extends StatelessWidget {
  const GroupedSection({super.key, required this.children});

  final List<Widget> children;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) const Divider(indent: AppSpace.s4),
            child,
          ],
        ],
      ),
    );
  }
}
