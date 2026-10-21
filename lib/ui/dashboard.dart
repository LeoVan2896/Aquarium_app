import 'package:flutter/material.dart';

import '../domain/cycle_engine.dart';
import '../domain/models.dart';
import '../domain/prediction.dart';
import '../domain/recommendations.dart';
import '../domain/softened_check.dart';
import '../domain/units.dart';
import 'labels.dart';
import 'theme.dart';
import 'widgets.dart';

class CycleCard extends StatelessWidget {
  const CycleCard({super.key, required this.status, required this.prediction});

  final CycleStatus status;
  final CyclePrediction? prediction;

  @override
  Widget build(BuildContext context) {
    final p = prediction;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StageChip(status.stage),
          const SizedBox(height: AppSpace.s3),
          Text(status.reason, style: const TextStyle(fontSize: AppType.lg)),
          const SizedBox(height: AppSpace.s4),
          const _Label('Next step'),
          const SizedBox(height: AppSpace.s1),
          Text(status.nextStep),
          for (final warning in status.warnings) ...[
            const SizedBox(height: AppSpace.s3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppColors.warn,
                ),
                const SizedBox(width: AppSpace.s2),
                Expanded(
                  child: Text(
                    warning,
                    style: const TextStyle(color: AppColors.warn),
                  ),
                ),
              ],
            ),
          ],
          if (p != null) ...[
            const SizedBox(height: AppSpace.s4),
            const Divider(),
            const SizedBox(height: AppSpace.s4),
            const _Label('Predicted finish'),
            const SizedBox(height: AppSpace.s1),
            Wrap(
              spacing: AppSpace.s2,
              runSpacing: AppSpace.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  formatDateRange(p.earliest, p.latest),
                  style: const TextStyle(
                    fontSize: AppType.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                switch (p.confidence) {
                  Confidence.low => const Pill(
                    icon: Icons.help_outline_rounded,
                    text: 'Low confidence',
                  ),
                  Confidence.medium => const Pill(
                    icon: Icons.insights_rounded,
                    text: 'Medium confidence',
                    color: AppColors.text,
                  ),
                },
              ],
            ),
            const SizedBox(height: AppSpace.s2),
            Text(
              p.basis,
              style: const TextStyle(
                fontSize: AppType.sm,
                color: AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SpeciesAlertBanner extends StatelessWidget {
  const SpeciesAlertBanner(this.alerts, {super.key});

  final List<SpeciesAlert> alerts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.s4),
      decoration: BoxDecoration(
        color: AppColors.recessed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.fail.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.fail),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Outside what your stock can take',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.fail,
                  ),
                ),
                for (final a in alerts) ...[
                  const SizedBox(height: AppSpace.s2),
                  Text(
                    a.speciesName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    a.check.reason,
                    style: const TextStyle(
                      fontSize: AppType.sm,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SoftenedBanner extends StatelessWidget {
  const SoftenedBanner(this.warning, {super.key});

  final SoftenedWarning warning;

  @override
  Widget build(BuildContext context) {
    String degrees(double ppm) => (ppm / ppmPerDegree).toStringAsFixed(1);

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
          const Icon(Icons.water_damage_outlined, color: AppColors.warn),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Softened water?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warn,
                  ),
                ),
                const SizedBox(height: AppSpace.s1),
                Text(warning.message),
                const SizedBox(height: AppSpace.s2),
                Text(
                  'GH ${degrees(warning.ghPpm)} dGH · KH ${degrees(warning.khPpm)} dKH',
                  style: const TextStyle(
                    fontSize: AppType.sm,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LatestValues extends StatelessWidget {
  const LatestValues(this.readings, {super.key});

  final List<LoggedReading> readings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpace.s3) / 2;
        return Wrap(
          spacing: AppSpace.s3,
          runSpacing: AppSpace.s3,
          children: [
            for (final r in readings)
              SizedBox(
                width: width,
                child: _Card(
                  padding: AppSpace.s3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.parameter.label,
                        style: const TextStyle(
                          fontSize: AppType.sm,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: AppSpace.s1),
                      Text(
                        formatValue(r.value, r.unit),
                        style: const TextStyle(
                          fontSize: AppType.xl,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpace.s1),
                      Text(
                        formatShortDateTime(r.takenAt),
                        style: const TextStyle(
                          fontSize: AppType.xs,
                          color: AppColors.muted2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = AppSpace.s4});

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: AppType.xs + 1,
      fontWeight: FontWeight.w600,
      color: AppColors.muted,
    ),
  );
}
