import '../domain/models.dart';
import 'database.dart';

extension TankToDomain on Tank {
  TankProfile toProfile() => TankProfile(
    hasSoil: hasSoil,
    cycleMethod: cycleMethod,
    cycleStartedAt: cycleStartedAt,
    stockedAt: stockedAt,
  );
}

extension ReadingToDomain on Reading {
  LoggedReading toLogged() => LoggedReading(
    id: id,
    parameter: parameter,
    value: value,
    unit: unit,
    takenAt: takenAt,
    correctsId: correctsId,
  );
}

extension EventToDomain on Event {
  LoggedEvent toLogged() => LoggedEvent(
    id: id,
    type: type,
    occurredAt: occurredAt,
    correctsId: correctsId,
  );
}

extension StockEntryToDomain on StockEntry {
  LoggedStock toLogged() => LoggedStock(
    id: id,
    speciesId: speciesId,
    speciesType: speciesType,
    change: change,
    occurredAt: occurredAt,
    correctsId: correctsId,
  );
}
