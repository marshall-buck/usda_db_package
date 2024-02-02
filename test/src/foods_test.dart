import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/foods.dart';
import 'package:usda_db_package/src/models/food_model.dart';

void main() {
  group('Foods', () {
    late Foods foods;

    setUp(() {
      foods = Foods();
    });

    test('init should populate foodsList', () async {
      await foods.init(
          jsonString: '{"1": {"description": "test food", "nutrients": []}}');
      expect(foods.foodsList.length, 1);
      expect(foods.foodsList[1]?.description, 'test food');
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
      await foods.init(
          jsonString: '{"1": {"description": "test food", "nutrients": []}}');
      foods.clearFoods();
      expect(foods.foodsList.isEmpty, true);
    });

    test('getFood should return correct food', () async {
      await foods.init(
          jsonString: '{"1": {"description": "test food", "nutrients": []}}');
      FoodModel? food = foods.getFood(1);
      expect(food?.description, 'test food');
    });

    test('getFood should return null for non-existent food', () async {
      await foods.init(
          jsonString: '{"1": {"description": "test food", "nutrients": []}}');
      FoodModel? food = foods.getFood(2);
      expect(food, null);
    });
  });
}
