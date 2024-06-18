import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/foods_data.dart';
import 'package:usda_db_package/src/models/food_model.dart';
import 'package:usda_db_package/src/models/nutrient_model.dart';

import '../setup/mock_file_strings.dart';

void main() {
  group('FoodsData class test', () {
    late FoodsData foods;

    setUp(() {
      foods = FoodsData();
    });
    tearDown(() => foods.clear());

    test('init should populate foodsList', () async {
      await foods.init(jsonString: mockDBString);

      expect(foods.foodsList.length, 6);

      expect(foods.foodsList, isA<Map<int, SrLegacyFoodModel>>());
      expect(foods.foodsList[167512]?.description,
          "Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough");
      expect(foods.foodsList[167512]?.nutrients,
          isA<List<SrLegacyNutrientModel>>());
      expect(foods.foodsList[167512]?.nutrients.length, 7);
    });
    test('init should throw FormatException on invalid JSON', () async {
      try {
        await foods.init(jsonString: 'invalid json');
        fail('Expected to throw FormatException');
      } catch (e) {
        expect(e, isA<FormatException>());
      }
    });

    test('clearFoods should clear foodsList', () async {
      await foods.init(jsonString: mockDBString);
      foods.clear();
      expect(foods.foodsList.isEmpty, true);
    });

    test('getFood should return correct food', () async {
      await foods.init(jsonString: mockDBString);
      SrLegacyFoodModel? food = foods.getFood(167517);
      expect(food?.description,
          "Waffle, buttermilk, frozen, ready-to-heat, toasted");
    });

    test('getFood should return null for non-existent food', () async {
      await foods.init(jsonString: mockDBString);
      SrLegacyFoodModel? food = foods.getFood(2);
      expect(food, null);
    });
  });
}
