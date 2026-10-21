import 'enums.dart';
import 'units.dart';

abstract interface class Correctable {
  int get id;
  int? get correctsId;
}

List<T> effectiveOnly<T extends Correctable>(Iterable<T> rows) {
  final superseded = {
    for (final r in rows)
      if (r.correctsId != null) r.correctsId,
  };
  return [
    for (final r in rows)
      if (!superseded.contains(r.id)) r,
  ];
}

class TankProfile {
  const TankProfile({
    required this.hasSoil,
    required this.cycleMethod,
    this.cycleStartedAt,
    this.stockedAt,
  });

  final bool hasSoil;
  final CycleMethod cycleMethod;
  final DateTime? cycleStartedAt;
  final DateTime? stockedAt;
}

class LoggedReading implements Correctable {
  const LoggedReading({
    required this.id,
    required this.parameter,
    required this.value,
    required this.unit,
    required this.takenAt,
    this.correctsId,
  });

  @override
  final int id;
  @override
  final int? correctsId;
  final Parameter parameter;
  final double value;
  final String unit;
  final DateTime takenAt;

  double get ppm => toPpm(value, unit);
}

class LoggedEvent implements Correctable {
  const LoggedEvent({
    required this.id,
    required this.type,
    required this.occurredAt,
    this.correctsId,
  });

  @override
  final int id;
  @override
  final int? correctsId;
  final EventType type;
  final DateTime occurredAt;
}

class LoggedStock implements Correctable {
  const LoggedStock({
    required this.id,
    required this.speciesId,
    required this.speciesType,
    required this.change,
    required this.occurredAt,
    this.correctsId,
  });

  @override
  final int id;
  @override
  final int? correctsId;
  final String speciesId;
  final SpeciesType speciesType;
  final int change;
  final DateTime occurredAt;
}

typedef StockKey = ({SpeciesType type, String speciesId});

// Like a balance from posted entries: summed every time, never stored.
Map<StockKey, int> stockCounts(Iterable<LoggedStock> entries) {
  final counts = <StockKey, int>{};
  for (final e in effectiveOnly(entries)) {
    final key = (type: e.speciesType, speciesId: e.speciesId);
    counts[key] = (counts[key] ?? 0) + e.change;
  }
  counts.removeWhere((_, count) => count <= 0);
  return counts;
}
