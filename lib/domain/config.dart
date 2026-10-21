typedef DayRange = ({int min, int max});

class Sourced<T> {
  const Sourced(this.value, this.source);

  final T value;
  final String source;
}

class DomainConfig {
  const DomainConfig({
    this.soilMinDays = const Sourced(
      28,
      'Unverified: hobbyist guidance on aquasoil leaching ammonia; no primary source.',
    ),
    this.passesRequired = const Sourced(
      2,
      'Unverified: common fishless-cycle advice; no primary source.',
    ),
    this.doseWindowStartHours = const Sourced(
      18,
      'Unverified: derived from "test 24 h after dosing" advice; no primary source.',
    ),
    this.doseWindowEndHours = const Sourced(
      30,
      'Unverified: derived from "test 24 h after dosing" advice; no primary source.',
    ),
    this.softenedGhMaxDgh = const Sourced(
      2.0,
      'Unverified: GH near 0 suggests ion-exchange softening; threshold not from a primary source.',
    ),
    this.softenedKhMinDkh = const Sourced(
      3.0,
      'Unverified: softeners leave KH roughly intact; threshold not from a primary source.',
    ),
    this.nitritePhaseDays = const Sourced((
      min: 7,
      max: 21,
    ), 'Estimate: typical nitrite-stage length; not from a primary source.'),
    this.doseTestDays = const Sourced(
      (min: 2, max: 7),
      'Estimate: time to pass the required dose tests; not from a primary source.',
    ),
    this.conditionsMaxAgeDays = const Sourced(
      30,
      'Huy accepted: research gives no number, only periodic re-testing as aquasoil buffering fades.',
    ),
    this.maturityFactor = const Sourced(
      1.0,
      'Placeholder: Huy\'s rule is that maturity depends on cycle speed; sources only say "many months" (ACO).',
    ),
    this.predationSizeRatio = const Sourced<double?>(
      null,
      'No source found. Until set, any smaller tankmate of a fish-eater gets a caution.',
    ),
    this.rangeMargin = 0,
    this.softenedWindowHours = 48,
    this.readyNitrateMaxPpm = 20,
    this.doseTargetPpm = 2,
    this.typicalWeeks = (min: 4, max: 8),
    this.soilTypicalWeeks = (min: 6, max: 8),
    this.predictionClampWeeks = 2,
    this.minReadingsForTrend = 5,
    this.trendWindowDays = 7,
    this.fishInFeedLightlyDays = 14,
  });

  final Sourced<int> soilMinDays;
  final Sourced<int> passesRequired;
  final Sourced<int> doseWindowStartHours;
  final Sourced<int> doseWindowEndHours;
  final Sourced<double> softenedGhMaxDgh;
  final Sourced<double> softenedKhMinDkh;
  final Sourced<DayRange> nitritePhaseDays;
  final Sourced<DayRange> doseTestDays;
  final Sourced<int> conditionsMaxAgeDays;
  final Sourced<double> maturityFactor;
  final Sourced<double?> predationSizeRatio;
  final double rangeMargin;
  final int softenedWindowHours;
  final double readyNitrateMaxPpm;
  final double doseTargetPpm;
  final DayRange typicalWeeks;
  final DayRange soilTypicalWeeks;
  final int predictionClampWeeks;
  final int minReadingsForTrend;
  final int trendWindowDays;
  final int fishInFeedLightlyDays;
}
