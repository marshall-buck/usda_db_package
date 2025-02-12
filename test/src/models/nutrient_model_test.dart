// ignore_for_file: prefer_int_literals

import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/models/models.dart';

void main() {
  group('Nutrient class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const nutrient = NutrientDTO(
          id: 1,
          name: 'Test Nutrient',
          amount: 10.0,
          unit: 'g',
        );

        expect(nutrient, isA<NutrientDTO>());
        expect(nutrient.id, 1);
        expect(nutrient.name, 'Test Nutrient');
        expect(nutrient.amount, 10.0);
        expect(nutrient.amount, isA<double>());
        expect(nutrient.unit, 'g');
      });
    });
    group('fromMapEntry', () {
      test('converts MapEntry to Nutrient', () {
        const entry = MapEntry('1003', 10.0);

        final nutrient = NutrientDTO.fromMapEntry(entry: entry);

        expect(nutrient, isA<NutrientDTO>());
        expect(nutrient.id, 1003);
        expect(nutrient.name, 'Protein');
        expect(nutrient.amount, 10.0);
        expect(nutrient.amount, isA<double>());
        expect(nutrient.unit, 'g');
      });
    });
    group('fromJson', () {
      test('converts json to Nutrient', () {
        final json = <String, dynamic>{
          'id': 1003,
          'amount': 10.0,
        };

        final nutrient = NutrientDTO.fromJson(jsonString: json);

        expect(nutrient, isA<NutrientDTO>());
        expect(nutrient.id, 1003);
        expect(nutrient.name, 'Protein');
        expect(nutrient.amount, 10.0);
        expect(nutrient.amount, isA<double>());
        expect(nutrient.unit, 'g');
      });
    });
  });
}
