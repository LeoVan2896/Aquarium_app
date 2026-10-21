import 'package:aquarium_app/data/database.dart';
import 'package:aquarium_app/domain/enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  late AppDatabase db;
  late Tank tank;

  setUp(() async {
    db = testDatabase();
    tank = await db.select(db.tanks).getSingle();
  });

  Future<void> log(Parameter p, double value, DateTime at) => db.addReadings([
    ReadingsCompanion.insert(
      tankId: tank.id,
      parameter: p,
      value: value,
      unit: p == Parameter.ph ? 'pH' : 'ppm',
      takenAt: at,
    ),
  ]);

  Future<void> event(EventType type, DateTime at) => db.addEvent(
    EventsCompanion.insert(tankId: tank.id, type: type, occurredAt: at),
  );

  Future<void> openTank(WidgetTester tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Trends'));
  }

  List<LineChart> charts(WidgetTester tester) =>
      tester.widgetList<LineChart>(find.byType(LineChart)).toList();

  testWidgets('one chart per default cycle parameter, ph toggled off', (
    tester,
  ) async {
    await log(Parameter.ammonia, 2, DateTime(2026, 10, 18, 9));
    await log(Parameter.ammonia, 1, DateTime(2026, 10, 20, 9));
    await log(Parameter.nitrite, 0.5, DateTime(2026, 10, 20, 9));
    await log(Parameter.ph, 7.4, DateTime(2026, 10, 20, 9));
    await openTank(tester);

    expect(find.text('Ammonia (ppm)'), findsOneWidget);
    expect(find.text('Nitrite (ppm)'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'pH'), findsOneWidget);
    expect(find.text('pH (pH)'), findsNothing);
    expect(charts(tester), hasLength(2));
    final ammonia = charts(tester).first.data.lineBarsData.single.spots;
    expect(ammonia.map((s) => s.y), [2, 1]);
    expect(ammonia.last.x - ammonia.first.x, 2);
    await tearDownApp(tester, db);
  });

  testWidgets('toggling a chip adds and removes its chart', (tester) async {
    await log(Parameter.ammonia, 2, DateTime(2026, 10, 18, 9));
    await log(Parameter.ph, 7.4, DateTime(2026, 10, 20, 9));
    await openTank(tester);
    expect(charts(tester), hasLength(1));

    await tester.tap(find.widgetWithText(FilterChip, 'pH'));
    await tester.pumpAndSettle();
    expect(charts(tester), hasLength(2));

    await tester.tap(find.widgetWithText(FilterChip, 'Ammonia'));
    await tester.pumpAndSettle();
    expect(charts(tester), hasLength(1));
    expect(find.text('Ammonia (ppm)'), findsNothing);
    await tearDownApp(tester, db);
  });

  testWidgets('events become labelled vertical markers', (tester) async {
    await log(Parameter.ammonia, 2, DateTime(2026, 10, 18, 9));
    await event(EventType.ammoniaDose, DateTime(2026, 10, 19, 9));
    await event(EventType.waterChange, DateTime(2026, 10, 20, 9));
    await event(EventType.other, DateTime(2026, 10, 20, 12));
    await openTank(tester);

    final lines = charts(tester).single.data.extraLinesData.verticalLines;
    expect(lines.map((l) => l.label.labelResolver(l)), ['NH₃', 'WC']);
    expect(lines.map((l) => l.x), [1 + 9 / 24, 2 + 9 / 24]);
    expect(
      find.text('WC = Water change  ·  NH₃ = Ammonia dose'),
      findsOneWidget,
    );
    await tearDownApp(tester, db);
  });

  testWidgets('no Trends section without readings', (tester) async {
    await pumpApp(tester, db);
    await tester.tap(find.text('20 gal planted'));
    await tester.pumpAndSettle();

    expect(find.text('Trends'), findsNothing);
    expect(find.byType(LineChart), findsNothing);
    await tearDownApp(tester, db);
  });
}
