// ignore_for_file: prefer_int_literals

import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

void main() {
  group('Nutrient class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const nutrient = UsdaNutrientModel(
          id: 1,
          name: 'Test Nutrient',
          amount: 10.0,
          unit: 'g',
        );

        expect(nutrient, isA<UsdaNutrientModel>());
        expect(nutrient.id, 1);
        expect(nutrient.name, 'Test Nutrient');
        expect(nutrient.amount, 10.0);
        expect(nutrient.amount, isA<double>());
        expect(nutrient.unit, 'g');
      });
    });
    group('fromId', () {
      test('looks up name and unit for a known id', () {
        final nutrient = UsdaNutrientModel.fromId(id: 1003, amount: 10.0);

        expect(nutrient.id, 1003);
        expect(nutrient.name, 'Protein');
        expect(nutrient.amount, 10.0);
        expect(nutrient.unit, 'g');
        expect(nutrient.isKnown, true);
      });

      test('falls back to empty name and unit for an unknown id', () {
        final nutrient = UsdaNutrientModel.fromId(id: 999999, amount: 10.0);

        expect(nutrient.id, 999999);
        expect(nutrient.name, '');
        expect(nutrient.unit, '');
        expect(nutrient.amount, 10.0, reason: 'amount must not be lost');
        expect(nutrient.isKnown, false);
      });
    });

    group('nameFor()/unitFor() - ', () {
      test('return the table values for a known id', () {
        expect(UsdaNutrientModel.nameFor(1008), 'Calories');
        expect(UsdaNutrientModel.unitFor(1008), 'kcal');
      });

      test('return null for an unknown id', () {
        expect(UsdaNutrientModel.nameFor(999999), isNull);
        expect(UsdaNutrientModel.unitFor(999999), isNull);
      });
    });

    group('fromMapEntry', () {
      test('converts MapEntry to Nutrient', () {
        const entry = MapEntry('1003', 10.0);

        final nutrient = UsdaNutrientModel.fromMapEntry(entry: entry);

        expect(nutrient, isA<UsdaNutrientModel>());
        expect(nutrient.id, 1003);
        expect(nutrient.name, 'Protein');
        expect(nutrient.amount, 10.0);
        expect(nutrient.amount, isA<double>());
        expect(nutrient.unit, 'g');
      });

      test('does not throw on an id missing from the table', () {
        const entry = MapEntry('999999', 10.0);

        final nutrient = UsdaNutrientModel.fromMapEntry(entry: entry);

        expect(nutrient.id, 999999);
        expect(nutrient.name, '');
        expect(nutrient.isKnown, false);
      });

      test('throws FormatException on a non-integer key', () {
        const entry = MapEntry('protein', 10.0);

        expect(
          () => UsdaNutrientModel.fromMapEntry(entry: entry),
          throwsFormatException,
        );
      });
    });
    group('fromJson', () {
      test('converts json to Nutrient', () {
        final json = <String, dynamic>{
          'id': 1003,
          'amount': 10.0,
        };

        final nutrient = UsdaNutrientModel.fromJson(json: json);

        expect(nutrient, isA<UsdaNutrientModel>());
        expect(nutrient.id, 1003);
        expect(nutrient.name, 'Protein');
        expect(nutrient.amount, 10.0);
        expect(nutrient.amount, isA<double>());
        expect(nutrient.unit, 'g');
      });
    });
  });
}
