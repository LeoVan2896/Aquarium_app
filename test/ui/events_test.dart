import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = testDatabase());

  Future<void> openLogEvent(WidgetTester tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log event'));
    await tester.pumpAndSettle();
  }

  testWidgets('logs a water change with Prime', (tester) async {
    await openLogEvent(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Water changed'),
      '30',
    );
    await tester.tap(find.widgetWithText(ChoiceChip, 'Prime'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount (optional)'),
      '1',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save event'));
    await tester.pumpAndSettle();

    expect(find.text('Water change'), findsOneWidget);
    expect(find.textContaining('30% changed · Prime · 1 ml'), findsOneWidget);
    final event = await db.select(db.events).getSingle();
    expect(event.type, EventType.waterChange);
    expect(event.percentChanged, 30);
    expect(event.product, 'Prime');
    expect(event.amount, 1);
    expect(event.amountUnit, 'ml');
    expect(event.occurredAt, DateTime(2026, 10, 21));
    await tearDownApp(tester, db);
  });

  testWidgets('ammonia dose fills in the product and drops percent', (
    tester,
  ) async {
    await openLogEvent(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Ammonia dose'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Water changed'), findsNothing);
    await tester.tap(find.text('Save event'));
    await tester.pumpAndSettle();

    final event = await db.select(db.events).getSingle();
    expect(event.type, EventType.ammoniaDose);
    expect(event.product, 'Ammonia');
    expect(event.percentChanged, isNull);
    expect(event.amountUnit, isNull);
    await tearDownApp(tester, db);
  });

  testWidgets('rejects a percent over 100', (tester) async {
    await openLogEvent(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Water changed'),
      '150',
    );
    await tester.tap(find.text('Save event'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a percent from 1 to 100.'), findsOneWidget);
    expect(await db.select(db.events).get(), isEmpty);
    await tearDownApp(tester, db);
  });

  testWidgets('correcting an event adds a row pointing at the original', (
    tester,
  ) async {
    final tank = await db.select(db.tanks).getSingle();
    await db.addEvent(
      EventsCompanion.insert(
        tankId: tank.id,
        type: EventType.waterChange,
        percentChanged: const Value(25),
        occurredAt: DateTime(2026, 10, 20, 18),
      ),
    );
    await pumpApp(tester, db);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Water change'));
    await tester.pumpAndSettle();
    expect(find.text('Correct event'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Water changed'),
      '50',
    );
    await tester.tap(find.text('Save correction'));
    await tester.pumpAndSettle();

    expect(find.textContaining('50% changed'), findsOneWidget);
    expect(find.textContaining('25% changed'), findsNothing);
    expect(find.textContaining('Corrected'), findsOneWidget);

    final rows = await (db.select(
      db.events,
    )..orderBy([(e) => OrderingTerm.asc(e.id)])).get();
    expect(rows, hasLength(2));
    expect(rows.first.percentChanged, 25);
    expect(rows.last.percentChanged, 50);
    expect(rows.last.correctsId, rows.first.id);
    expect(rows.last.tankId, tank.id);
    expect(rows.last.occurredAt, DateTime(2026, 10, 20, 18));
    await tearDownApp(tester, db);
  });
}
