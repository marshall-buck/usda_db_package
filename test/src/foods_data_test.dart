import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/foods_data.dart';
import 'package:usda_db_package/src/models/food_model.dart';

import '../setup/mock_file_strings.dart';

void main() {
  group('FoodsData class test', () {
    late FoodsData foods;

    setUp(() {
      foods = FoodsData();
    });
    tearDown(() => foods.clear());

    test('init should populate foodsList', () async {
      final String fakeDBString = jsonEncode(stringKeyedMap);
      await foods.init(jsonString: fakeDBString);

      expect(foods.foodsList.length, 6);

      expect(foods.foodsList, isA<Map<int, FoodModel>>());
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
      foods.clear();
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
