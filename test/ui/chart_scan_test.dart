import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/chart_reader.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/scanning/chart_scanner.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

List<ChartToken> row(double y, List<String> words) => [
  for (final (i, w) in words.indexed)
    ChartToken(w, left: i * 60.0, top: y, right: i * 60.0 + 40, bottom: y + 20),
];

final eightInOneChart = [
  ...row(0, ['Nitrate', '0', '20', '40', '80', '160']),
  ...row(40, ['Nitrite', '0', '0.5', '1', '3', '5', '10']),
  ...row(80, ['GH', '°dH', '0', '4', '7', '14', '21']),
  ...row(120, ['0', '25', '50', '100']),
];

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  Future<KitParameter> kitParam(String kit, Parameter parameter) async {
    final k = await (db.select(
      db.testKits,
    )..where((t) => t.name.equals(kit))).getSingle();
    return (db.select(db.kitParameters)..where(
          (p) => p.kitId.equals(k.id) & p.parameter.equalsValue(parameter),
        ))
        .getSingle();
  }

  Future<void> scanFrom(
    WidgetTester tester,
    String? kit,
    FakeChartScanner scanner,
  ) async {
    await pumpApp(tester, db, scanner: scanner);
    await tester.tap(find.text(kit ?? 'Add kit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Read steps from a photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from photos'));
    await tester.pumpAndSettle();
  }

  Future<void> tapAndSettle(WidgetTester tester, String text) async {
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  testWidgets('fills the 8-in-1 from a chart photo after review', (
    tester,
  ) async {
    final scanner = FakeChartScanner(eightInOneChart);
    await scanFrom(tester, '8-in-1 strip', scanner);

    expect(scanner.sources, [PhotoSource.gallery]);
    expect(find.text('Check the chart'), findsOneWidget);
    expect(find.text('0, 20, 40, 80, 160'), findsOneWidget);
    expect(find.text('Steps (dGH)'), findsOneWidget);
    expect(find.text('Ignore this row'), findsOneWidget);

    await tapAndSettle(tester, 'Use these steps');
    expect(find.text('Edit kit'), findsOneWidget);
    expect(
      find.textContaining('Filled steps for 3 parameters'),
      findsOneWidget,
    );

    await tapAndSettle(tester, 'Save kit');

    expect((await kitParam('8-in-1 strip', Parameter.nitrate)).stepsJson, [
      0,
      20,
      40,
      80,
      160,
    ]);
    final gh = await kitParam('8-in-1 strip', Parameter.gh);
    expect(gh.unit, 'dGH');
    expect(gh.stepsJson, [0, 4, 7, 14, 21]);
    expect((await kitParam('8-in-1 strip', Parameter.kh)).stepsJson, isNull);
    await tearDownApp(tester, db);
  });

  testWidgets('a misread number can be fixed before it is used', (
    tester,
  ) async {
    await scanFrom(tester, '8-in-1 strip', FakeChartScanner(eightInOneChart));

    await tester.enterText(
      find.widgetWithText(TextField, '0, 0.5, 1, 3, 5, 10'),
      '0, 0.5, 1, 2, 5, 10',
    );
    await tapAndSettle(tester, 'Use these steps');
    await tapAndSettle(tester, 'Save kit');

    expect((await kitParam('8-in-1 strip', Parameter.nitrite)).stepsJson, [
      0,
      0.5,
      1,
      2,
      5,
      10,
    ]);
    await tearDownApp(tester, db);
  });

  testWidgets('rejects a row edited down to one number', (tester) async {
    await scanFrom(tester, '8-in-1 strip', FakeChartScanner(eightInOneChart));

    await tester.enterText(
      find.widgetWithText(TextField, '0, 20, 40, 80, 160'),
      '20',
    );
    await tapAndSettle(tester, 'Use these steps');

    expect(
      find.text('Use at least two numbers, e.g. 0, 0.5, 1'),
      findsOneWidget,
    );
    expect(find.text('Check the chart'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('the ammonia strip takes an unlabelled row', (tester) async {
    await scanFrom(
      tester,
      'Ammonia strip',
      FakeChartScanner(row(0, ['0', '0.25', '0.5', '1', '3', '6'])),
    );
    await tapAndSettle(tester, 'Use these steps');
    await tapAndSettle(tester, 'Save kit');

    expect((await kitParam('Ammonia strip', Parameter.ammonia)).stepsJson, [
      0,
      0.25,
      0.5,
      1,
      3,
      6,
    ]);
    await tearDownApp(tester, db);
  });

  testWidgets('a new kit gets its parameters from the photo', (tester) async {
    await scanFrom(tester, null, FakeChartScanner(eightInOneChart));
    await tapAndSettle(tester, 'Use these steps');

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Tetra 6-in-1',
    );
    await tapAndSettle(tester, 'Add kit');

    final kit = await (db.select(
      db.testKits,
    )..where((k) => k.name.equals('Tetra 6-in-1'))).getSingle();
    final params = await (db.select(
      db.kitParameters,
    )..where((p) => p.kitId.equals(kit.id))).get();
    expect(params.map((p) => p.parameter).toSet(), {
      Parameter.nitrite,
      Parameter.nitrate,
      Parameter.gh,
    });
    await tearDownApp(tester, db);
  });

  testWidgets('backing out of the picker changes nothing', (tester) async {
    await scanFrom(tester, '8-in-1 strip', FakeChartScanner());

    expect(find.text('Check the chart'), findsNothing);
    expect(find.text('Edit kit'), findsOneWidget);
    await tearDownApp(tester, db);
  });

  testWidgets('a photo with no number rows says so', (tester) async {
    await scanFrom(
      tester,
      '8-in-1 strip',
      FakeChartScanner(row(0, ['Dip', 'for', '1', 'second'])),
    );

    expect(find.textContaining('find any rows'), findsOneWidget);
    await tapAndSettle(tester, 'Back to kit');
    expect(find.text('Edit kit'), findsOneWidget);
    await tearDownApp(tester, db);
  });
}
