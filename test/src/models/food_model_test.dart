import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

void main() {
  group('FoodModel class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          nutrients: {1003: 10, 1004: 10.0},
        );

        expect(foodModel, isA<UsdaFoodModel>());
        expect(foodModel.id, 1);
        expect(foodModel.description, 'Test Food');
        expect(foodModel.nutrients, isA<Map<int, double>>());
      });
    });

    group('nutrientList - ', () {
      test('pairs each raw amount with its name and unit', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          nutrients: {1003: 4.34, 1008: 336.0},
        );

        final list = foodModel.nutrientList;

        expect(list.length, 2);
        expect(list.first.id, 1003);
        expect(list.first.name, 'Protein');
        expect(list.first.amount, 4.34);
        expect(list.first.unit, 'g');
        expect(list.last.name, 'Calories');
        expect(list.last.unit, 'kcal');
      });

      test('preserves the order of the raw nutrients map', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          nutrients: {1008: 336.0, 1003: 4.34, 1004: 13.1},
        );

        expect(
          foodModel.nutrientList.map((n) => n.id),
          [1008, 1003, 1004],
        );
      });

      test('keeps unknown nutrient ids, marked as not known', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          nutrients: {1003: 4.34, 999999: 1.0},
        );

        final list = foodModel.nutrientList;

        expect(list.length, 2);
        expect(list.first.isKnown, true);
        expect(list.last.isKnown, false);
        expect(list.last.name, '');
        expect(list.last.unit, '');
        expect(list.last.amount, 1.0, reason: 'amount must not be lost');
        expect(list.where((n) => n.isKnown).length, 1);
      });

      test('is empty when the food has no nutrients', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          nutrients: {},
        );

        expect(foodModel.nutrientList, isEmpty);
      });
    });

    group('nutrient() - ', () {
      const foodModel = UsdaFoodModel(
        id: 1,
        description: 'Test Food',
        nutrients: {1003: 4.34, 1008: 336.0},
      );

      test('returns the nutrient when present', () {
        final calories = foodModel.nutrient(1008);

        expect(calories, isNotNull);
        expect(calories!.name, 'Calories');
        expect(calories.amount, 336.0);
        expect(calories.unit, 'kcal');
      });

      test('returns null when the food has no value for that id', () {
        expect(foodModel.nutrient(1004), isNull);
      });

      test('returns null for an unknown nutrient id', () {
        expect(foodModel.nutrient(999999), isNull);
      });
    });
  });
}
