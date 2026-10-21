import 'enums.dart';

List<String> unitOptions(Parameter parameter) => switch (parameter) {
  Parameter.ammonia ||
  Parameter.nitrite ||
  Parameter.nitrate ||
  Parameter.chlorine => const ['ppm'],
  Parameter.ph => const ['pH'],
  Parameter.gh => const ['ppm', 'dGH'],
  Parameter.kh => const ['ppm', 'dKH'],
  Parameter.temperature => const ['F'],
};

List<double>? parseSteps(String input) {
  final tokens = input
      .split(RegExp(r'[,\s]+'))
      .where((t) => t.isNotEmpty)
      .toList();
  if (tokens.isEmpty) return null;
  final values = <double>[];
  for (final t in tokens) {
    final value = double.tryParse(t);
    if (value == null || value < 0) return null;
    values.add(value);
  }
  return values;
}

List<double> mergeSteps(List<double> existing, List<double> added) =>
    {...existing, ...added}.toList()..sort();
