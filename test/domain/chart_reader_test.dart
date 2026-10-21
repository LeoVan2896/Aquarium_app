import 'package:aquarium_app/domain/chart_reader.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

// One printed row: words laid out left to right at a given line.
List<ChartToken> row(double y, List<String> words, {double x = 0}) => [
  for (final (i, w) in words.indexed)
    ChartToken(
      w,
      left: x + i * 60,
      top: y,
      right: x + i * 60 + 40,
      bottom: y + 20,
    ),
];

void main() {
  test('labelled rows map to parameters, sorted and deduped', () {
    final reading = readChart([
      ...row(0, ['Nitrate', '0', '20', '40', '80', '160', '200']),
      ...row(40, ['Nitrite', '0', '0.5', '1', '3', '5', '10']),
      ...row(80, ['pH', '6.4', '6.8', '7.2', '7.6', '8.0', '8.4']),
      ...row(120, ['Chlorine', '0', '0.8', '1.5', '3']),
    ]);

    expect(reading.matched.keys, [
      Parameter.nitrate,
      Parameter.nitrite,
      Parameter.ph,
      Parameter.chlorine,
    ]);
    expect(reading.matched[Parameter.nitrite]!.steps, [0, 0.5, 1, 3, 5, 10]);
    expect(reading.matched[Parameter.ph]!.steps.first, 6.4);
    expect(reading.unmatched, isEmpty);
  });

  test('a label on its own line applies to the numbers below it', () {
    final reading = readChart([
      ...row(0, ['Total', 'Hardness', '(GH)']),
      ...row(30, ['0', '30', '60', '120', '180']),
    ]);
    expect(reading.matched[Parameter.gh]!.steps, [0, 30, 60, 120, 180]);
  });

  test('carbonate hardness is KH, not GH', () {
    final reading = readChart([
      ...row(0, ['Carbonate', 'Hardness', '0', '40', '80', '120']),
    ]);
    expect(reading.matched.keys, [Parameter.kh]);
  });

  test('degree markers set the GH/KH unit', () {
    final reading = readChart([
      ...row(0, ['GH', '°dH', '0', '3', '7', '14']),
      ...row(40, ['KH', 'ppm', '0', '40', '80', '120']),
    ]);
    expect(reading.matched[Parameter.gh]!.unit, 'dGH');
    expect(reading.matched[Parameter.kh]!.unit, isNull);
  });

  test('strips units and reads leading dots and a letter O as zero', () {
    final reading = readChart([
      ...row(0, ['NH3', 'O', '.25', '0.5ppm', '1', '3', '6mg/L']),
    ]);
    expect(reading.matched[Parameter.ammonia]!.steps, [0, 0.25, 0.5, 1, 3, 6]);
  });

  test('tokens a few pixels off still share a row', () {
    final tokens = [
      const ChartToken('Nitrate', left: 0, top: 0, right: 50, bottom: 20),
      const ChartToken('0', left: 60, top: 4, right: 70, bottom: 24),
      const ChartToken('20', left: 120, top: -3, right: 140, bottom: 17),
      const ChartToken('40', left: 180, top: 2, right: 200, bottom: 22),
    ];
    expect(readChart(tokens).matched[Parameter.nitrate]!.steps, [0, 20, 40]);
  });

  test('unlabelled rows are returned for the user to assign', () {
    final reading = readChart([
      ...row(0, ['Nitrate', '0', '20', '40']),
      ...row(40, ['0', '1', '2', '3']),
    ]);
    expect(reading.unmatched, [
      [0, 1, 2, 3],
    ]);
  });

  test('a one-parameter kit takes the only unlabelled row', () {
    final reading = readChart(
      [
        ...row(0, ['0', '0.25', '0.5', '1', '3', '6']),
        ...row(40, ['Lot', '2291']),
      ],
      kitParameters: {Parameter.ammonia},
    );
    expect(reading.matched[Parameter.ammonia]!.steps, [0, 0.25, 0.5, 1, 3, 6]);
    expect(reading.unmatched, isEmpty);
  });

  test('single numbers and ranges are not steps', () {
    final reading = readChart([
      ...row(0, ['Dip', 'for', '1', 'second']),
      ...row(40, ['Range', '0-50', 'ppm']),
    ]);
    expect(reading.isEmpty, isTrue);
  });
}
