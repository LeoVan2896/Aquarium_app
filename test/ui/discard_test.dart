import 'package:aquarium_app/data/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
  }

  testWidgets('leaving an untouched form does not ask', (tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Add tank'));
    await tester.pumpAndSettle();

    await back(tester);

    expect(find.text('Discard changes?'), findsNothing);
    expect(find.text('New tank'), findsNothing);
    await tearDownApp(tester, db);
  });

  testWidgets('tank form asks before discarding, and Keep editing stays', (
    tester,
  ) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Add tank'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Quarantine',
    );

    await back(tester);
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('New tank'), findsOneWidget);
    expect(find.text('Quarantine'), findsOneWidget);

    await back(tester);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('New tank'), findsNothing);
    expect(await db.select(db.tanks).get(), hasLength(1));
    await tearDownApp(tester, db);
  });

  testWidgets('kit setup asks when steps were added but not saved', (
    tester,
  ) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Ammonia strip'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Add steps (ppm)'),
      '0, 0.25, 0.5',
    );
    await tester.tap(find.byTooltip('Add steps'));
    await tester.pumpAndSettle();

    await back(tester);
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.text('Edit kit'), findsNothing);
    final params = await db.select(db.kitParameters).get();
    expect(params.every((p) => p.stepsJson == null), isTrue);
    await tearDownApp(tester, db);
  });

  testWidgets('steps typed but not added still count as a change', (
    tester,
  ) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Ammonia strip'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Add steps (ppm)'),
      '0, 1',
    );

    await back(tester);
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    await tearDownApp(tester, db);
  });

  testWidgets('saving still leaves without asking', (tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('Ammonia strip'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Add steps (ppm)'),
      '0, 1',
    );
    await tester.tap(find.byTooltip('Add steps'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save kit'));
    await tester.pumpAndSettle();

    expect(find.text('Discard changes?'), findsNothing);
    expect(find.text('Edit kit'), findsNothing);
    await tearDownApp(tester, db);
  });
}
