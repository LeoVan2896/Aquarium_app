import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  Future<KitParameter> kitParam(String kitName, Parameter parameter) async {
    final kit = await (db.select(
      db.testKits,
    )..where((k) => k.name.equals(kitName))).getSingle();
    return (db.select(db.kitParameters)..where(
          (p) => p.kitId.equals(kit.id) & p.parameter.equalsValue(parameter),
        ))
        .getSingle();
  }

  testWidgets('enters color chart steps for the ammonia strip', (tester) async {
    await pumpApp(tester, db);
    expect(find.text('Steps needed'), findsNWidgets(2));

    await tester.tap(find.text('Ammonia strip'));
    await tester.pumpAndSettle();
    expect(find.text('Edit kit'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Add steps (ppm)'),
      '0, 0.25, 0.5, 1, 3, 6',
    );
    await tester.tap(find.byTooltip('Add steps'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(InputChip, '0.25'), findsOneWidget);

    await tester.tap(find.text('Save kit'));
    await tester.pumpAndSettle();

    expect(find.text('Steps needed'), findsOneWidget);
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

  testWidgets('rejects steps that are not numbers', (tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Ammonia strip'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Add steps (ppm)'),
      '0, low',
    );
    await tester.tap(find.byTooltip('Add steps'));
    await tester.pumpAndSettle();

    expect(
      find.text('Use numbers separated by commas, e.g. 0, 0.5, 1'),
      findsOneWidget,
    );
    await tearDownApp(tester, db);
  });

  testWidgets('switches GH on the 8-in-1 strip to dGH', (tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('8-in-1 strip'));
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('dGH'));
    await tester.tap(find.text('dGH'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save kit'));
    await tester.pumpAndSettle();

    expect((await kitParam('8-in-1 strip', Parameter.gh)).unit, 'dGH');
    expect((await kitParam('8-in-1 strip', Parameter.kh)).unit, 'ppm');
    await tearDownApp(tester, db);
  });

  testWidgets('adds a new kit with a typed-number parameter', (tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Add kit'));
    await tester.pumpAndSettle();
    expect(find.text('New kit'), findsOneWidget);

    await tester.tap(find.text('Add kit').last);
    await tester.pumpAndSettle();
    expect(find.text('Enter a kit name.'), findsOneWidget);
    expect(
      tester
          .widget<Text>(find.text('Add each parameter this kit tests.'))
          .style
          ?.color,
      isNot(const Color(0xFF86868B)),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Liquid nitrate',
    );
    await tester.tap(find.text('Add parameter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nitrate'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Type a number'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add kit').last);
    await tester.pumpAndSettle();

    expect(find.text('Liquid nitrate'), findsOneWidget);
    final param = await kitParam('Liquid nitrate', Parameter.nitrate);
    expect(param.inputMode, InputMode.free);
    expect(param.stepsJson, isNull);
    await tearDownApp(tester, db);
  });
}
