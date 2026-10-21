import 'enums.dart';
import 'steps.dart';

class ChartToken {
  const ChartToken(
    this.text, {
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;

  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;
}

class DetectedSteps {
  const DetectedSteps(this.steps, {this.unit});

  final List<double> steps;
  final String? unit;
}

class ChartReading {
  const ChartReading({required this.matched, required this.unmatched});

  final Map<Parameter, DetectedSteps> matched;
  final List<List<double>> unmatched;

  bool get isEmpty => matched.isEmpty && unmatched.isEmpty;
}

// KH before GH: "carbonate hardness" also contains "hardness".
const _aliases = <(Parameter, List<String>)>[
  (Parameter.ammonia, ['total ammonia', 'ammonia', 'nh3', 'nh4']),
  (Parameter.nitrite, ['nitrite', 'no2']),
  (Parameter.nitrate, ['nitrate', 'no3']),
  (Parameter.kh, ['carbonate hardness', 'alkalinity', 'carbonate', 'kh']),
  (Parameter.gh, ['total hardness', 'general hardness', 'hardness', 'gh']),
  (Parameter.ph, ['ph']),
  (Parameter.chlorine, ['free chlorine', 'chlorine', 'cl2']),
];

final _degreeHint = RegExp(r'°\s*d|\bdgh\b|\bdkh\b|\bdh\b');

ChartReading readChart(
  List<ChartToken> tokens, {
  Set<Parameter>? kitParameters,
}) {
  final rows = _groupRows(tokens);
  final matched = <Parameter, DetectedSteps>{};
  final unmatched = <List<double>>[];
  Parameter? pendingLabel;

  for (final row in rows) {
    final numbers = [for (final t in row) ?_number(t.text)];
    final words = row
        .where((t) => _number(t.text) == null)
        .map((t) => t.text)
        .join(' ')
        .toLowerCase();
    final label = _label(words);

    if (numbers.length < 2) {
      pendingLabel = label ?? pendingLabel;
      continue;
    }

    final parameter = label ?? pendingLabel;
    pendingLabel = null;
    final steps = mergeSteps(const [], numbers);
    if (parameter == null || matched.containsKey(parameter)) {
      unmatched.add(steps);
      continue;
    }
    final degrees =
        (parameter == Parameter.gh || parameter == Parameter.kh) &&
        _degreeHint.hasMatch(words);
    matched[parameter] = DetectedSteps(
      steps,
      unit: degrees ? (parameter == Parameter.gh ? 'dGH' : 'dKH') : null,
    );
  }

  final needing = kitParameters?.difference(matched.keys.toSet());
  if (matched.isEmpty &&
      needing != null &&
      needing.length == 1 &&
      unmatched.isNotEmpty) {
    final longest = unmatched.reduce((a, b) => b.length > a.length ? b : a);
    unmatched.remove(longest);
    matched[needing.single] = DetectedSteps(longest);
  }

  return ChartReading(matched: matched, unmatched: unmatched);
}

List<List<ChartToken>> _groupRows(List<ChartToken> tokens) {
  if (tokens.isEmpty) return const [];
  final heights = [for (final t in tokens) t.height]..sort();
  final tolerance = heights[heights.length ~/ 2] * 0.6;
  final sorted = [...tokens]..sort((a, b) => a.centerY.compareTo(b.centerY));

  final rows = <List<ChartToken>>[];
  for (final t in sorted) {
    final row = rows.lastOrNull;
    if (row != null && (t.centerY - _meanCenter(row)).abs() <= tolerance) {
      row.add(t);
    } else {
      rows.add([t]);
    }
  }
  for (final row in rows) {
    row.sort((a, b) => a.left.compareTo(b.left));
  }
  return rows;
}

double _meanCenter(List<ChartToken> row) =>
    row.map((t) => t.centerY).reduce((a, b) => a + b) / row.length;

final _unitSuffix = RegExp(r'(ppm|mg/?l|°?d[gk]?h)$', caseSensitive: false);

double? _number(String raw) {
  var text = raw.trim().replaceAll(_unitSuffix, '');
  if (text == 'O' || text == 'o') text = '0';
  if (!RegExp(r'^\d*\.?\d+$').hasMatch(text)) return null;
  return double.tryParse(text);
}

Parameter? _label(String words) {
  final normalized = ' ${words.replaceAll(RegExp(r'[^a-z0-9]+'), ' ')} ';
  for (final (parameter, aliases) in _aliases) {
    if (aliases.any((a) => normalized.contains(' $a '))) return parameter;
  }
  return null;
}
