import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/steps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses commas, spaces and leading dots', () {
    expect(parseSteps('0, .25 ,0.5  1'), [0, 0.25, 0.5, 1]);
  });

  test('rejects text, negatives and empty input', () {
    expect(parseSteps('0, abc'), isNull);
    expect(parseSteps('-1'), isNull);
    expect(parseSteps('  '), isNull);
  });

  test('merging sorts and drops duplicates', () {
    expect(mergeSteps([0, 1, 3], [0.5, 1, 6]), [0, 0.5, 1, 3, 6]);
  });

  test('GH and KH can be ppm or degrees; ammonia is ppm only', () {
    expect(unitOptions(Parameter.gh), ['ppm', 'dGH']);
    expect(unitOptions(Parameter.kh), ['ppm', 'dKH']);
    expect(unitOptions(Parameter.ammonia), ['ppm']);
  });
}
