import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/models.dart';
import 'package:aquarium_app/domain/units.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  test('1 dGH is 17.86 ppm', () {
    expect(toPpm(1, 'dGH'), 17.86);
    expect(toPpm(3, 'dKH'), closeTo(53.58, 1e-9));
  });

  test('ppm values pass through unchanged', () {
    expect(toPpm(40, 'ppm'), 40);
  });

  test('reading exposes its value in ppm', () {
    expect(reading(Parameter.gh, 2, day(0), unit: 'dGH').ppm, 35.72);
  });

  test('a correction supersedes the row it corrects', () {
    final original = reading(Parameter.ammonia, 1, day(0));
    final fix = reading(
      Parameter.ammonia,
      0.5,
      day(0),
      correctsId: original.id,
    );
    final fixOfFix = reading(
      Parameter.ammonia,
      0.25,
      day(0),
      correctsId: fix.id,
    );

    expect(effectiveOnly([original, fix, fixOfFix]), [fixOfFix]);
  });
}
