import 'config.dart';
import 'enums.dart';
import 'models.dart';
import 'units.dart';

const softenedWaterMessage =
    'GH near 0 with normal KH usually means softened water. Softener swaps calcium/magnesium for sodium — use your unsoftened source for water changes.';

class SoftenedWarning {
  const SoftenedWarning({required this.ghPpm, required this.khPpm});

  final double ghPpm;
  final double khPpm;

  String get message => softenedWaterMessage;
}

SoftenedWarning? checkSoftenedWater(
  Iterable<LoggedReading> readings, {
  DomainConfig config = const DomainConfig(),
}) {
  final effective = effectiveOnly(readings);
  final gh = _latest(effective, Parameter.gh);
  final kh = _latest(effective, Parameter.kh);
  if (gh == null || kh == null) return null;

  if (gh.takenAt.difference(kh.takenAt).abs() >
      Duration(hours: config.softenedWindowHours)) {
    return null;
  }

  final softened =
      gh.ppm <= degreesToPpm(config.softenedGhMaxDgh.value) &&
      kh.ppm >= degreesToPpm(config.softenedKhMinDkh.value);
  return softened ? SoftenedWarning(ghPpm: gh.ppm, khPpm: kh.ppm) : null;
}

LoggedReading? _latest(List<LoggedReading> readings, Parameter parameter) {
  LoggedReading? latest;
  for (final r in readings) {
    if (r.parameter == parameter &&
        (latest == null || r.takenAt.isAfter(latest.takenAt))) {
      latest = r;
    }
  }
  return latest;
}
