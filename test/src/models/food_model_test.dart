import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

void main() {
  group('FoodModel class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          categoryCode: 1800,
          nutrients: {1003: 10, 1004: 10.0},
        );

        expect(foodModel, isA<UsdaFoodModel>());
        expect(foodModel.id, 1);
        expect(foodModel.description, 'Test Food');
        expect(foodModel.categoryCode, 1800);
        expect(foodModel.nutrients, isA<Map<int, double>>());
      });
    });

    group('category - ', () {
      test('resolves the code to its name', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          categoryCode: 1800,
          nutrients: {},
        );

        expect(foodModel.category.code, 1800);
        expect(foodModel.category.name, 'Baked Products');
        expect(foodModel.category.isKnown, true);
      });

      test('keeps an unknown code, marked as not known', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          categoryCode: 9999,
          nutrients: {},
        );

        expect(foodModel.category.code, 9999);
        expect(foodModel.category.name, '');
        expect(foodModel.category.isKnown, false);
      });

      test('is part of equality', () {
        const a = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          categoryCode: 1800,
          nutrients: {},
        );
        const b = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          categoryCode: 1900,
          nutrients: {},
        );

        expect(a, isNot(b));
      });
    });

    group('nutrientList - ', () {
      test('pairs each raw amount with its name and unit', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Test Food',
          categoryCode: 1800,
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
          categoryCode: 1800,
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
          categoryCode: 1800,
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
          categoryCode: 1800,
          nutrients: {},
        );

        expect(foodModel.nutrientList, isEmpty);
      });
    });

    group('nutrient() - ', () {
      const foodModel = UsdaFoodModel(
        id: 1,
        description: 'Test Food',
        categoryCode: 1800,
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

    group('matchedWords - ', () {
      test('is empty without match terms', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Apples, raw',
          categoryCode: 1800,
          nutrients: {},
        );

        expect(foodModel.matchedWords, isEmpty);
      });

      test('lists words containing a term, in original case', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Apples, raw, with pineapple (Apples)',
          categoryCode: 1800,
          nutrients: {},
          matchTerms: ['app'],
        );

        expect(foodModel.matchedWords, ['Apples', 'pineapple']);
      });

      test('splits on dashes, slashes and parentheses', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Waffles, ready-to-heat/toasted (Heat)',
          categoryCode: 1800,
          nutrients: {},
          matchTerms: ['heat', 'toast'],
        );

        expect(foodModel.matchedWords, ['heat', 'toasted', 'Heat']);
      });

      test('is empty when no word contains a term', () {
        const foodModel = UsdaFoodModel(
          id: 1,
          description: 'Apples, raw',
          categoryCode: 1800,
          nutrients: {},
          matchTerms: ['kale'],
        );

        expect(foodModel.matchedWords, isEmpty);
      });
    });

    group('withMatchTerms() - ', () {
      const foodModel = UsdaFoodModel(
        id: 1,
        description: 'Apples, raw',
        categoryCode: 1800,
        nutrients: {1008: 52.0},
      );

      test('copies the food with the terms', () {
        final copy = foodModel.withMatchTerms(['app']);

        expect(copy.id, 1);
        expect(copy.description, 'Apples, raw');
        expect(copy.nutrients, {1008: 52.0});
        expect(copy.categoryCode, 1800);
        expect(copy.matchTerms, ['app']);
        expect(foodModel.matchTerms, isEmpty);
      });

      test('match terms are not part of equality', () {
        expect(foodModel.withMatchTerms(['app']), foodModel);
      });
    });
  });
}
