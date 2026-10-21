import 'package:aquarium_app/domain/enums.dart';
import 'package:aquarium_app/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

var _nextId = 0;

LoggedStock entry(
  String speciesId,
  int change, {
  SpeciesType type = SpeciesType.animal,
  int? correctsId,
}) => LoggedStock(
  id: ++_nextId,
  speciesId: speciesId,
  speciesType: type,
  change: change,
  occurredAt: DateTime.utc(2026, 11, 1),
  correctsId: correctsId,
);

void main() {
  test('adds and removals sum per species', () {
    expect(stockCounts([entry('tetra', 8), entry('tetra', -2)]), {
      (type: SpeciesType.animal, speciesId: 'tetra'): 6,
    });
  });

  test('a correction replaces the entry it corrects', () {
    final wrong = entry('tetra', 8);
    expect(stockCounts([wrong, entry('tetra', 6, correctsId: wrong.id)]), {
      (type: SpeciesType.animal, speciesId: 'tetra'): 6,
    });
  });

  test('species removed down to zero drop out', () {
    expect(stockCounts([entry('tetra', 3), entry('tetra', -3)]), isEmpty);
  });

  test('a fish and a plant with the same id are counted apart', () {
    expect(
      stockCounts([entry('x', 2), entry('x', 5, type: SpeciesType.plant)]),
      hasLength(2),
    );
  });
}
