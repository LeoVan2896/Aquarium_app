import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/softened_check.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  test('fires on GH 0 / KH 6 dKH', () {
    final warning = checkSoftenedWater([
      reading(Parameter.gh, 0, day(1), unit: 'dGH'),
      reading(Parameter.kh, 6, day(1), unit: 'dKH'),
    ]);
    expect(warning, isNotNull);
    expect(warning!.message, softenedWaterMessage);
  });

  test('does not fire on GH 8 / KH 6 dKH', () {
    final warning = checkSoftenedWater([
      reading(Parameter.gh, 8, day(1), unit: 'dGH'),
      reading(Parameter.kh, 6, day(1), unit: 'dKH'),
    ]);
    expect(warning, isNull);
  });

  test('works with strip readings in ppm', () {
    final warning = checkSoftenedWater([
      reading(Parameter.gh, 0, day(1)),
      reading(Parameter.kh, 120, day(1)),
    ]);
    expect(warning, isNotNull);
  });

  test('ignores GH and KH taken more than 48 h apart', () {
    final warning = checkSoftenedWater([
      reading(Parameter.gh, 0, day(1), unit: 'dGH'),
      reading(Parameter.kh, 6, day(4), unit: 'dKH'),
    ]);
    expect(warning, isNull);
  });

  test('uses only the latest GH', () {
    final warning = checkSoftenedWater([
      reading(Parameter.gh, 0, day(1), unit: 'dGH'),
      reading(Parameter.gh, 8, day(2), unit: 'dGH'),
      reading(Parameter.kh, 6, day(2), unit: 'dKH'),
    ]);
    expect(warning, isNull);
  });
}
