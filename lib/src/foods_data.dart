import 'dart:convert';
import 'dart:developer' as dev;

import 'initializer.dart';
import 'models/food_model.dart';

/// Class to handle the main foods database.
class FoodsData implements Initializer {
  final Map<int, FoodModel> _foodsList = {};
  Map<int, FoodModel> get foodsList => _foodsList;

  /// Initializes the instance
  ///
  /// Parameters:
  /// - [path] The path of the  file.

  @override
  Future<void> init({required String jsonString}) async {
    try {
      final Map<String, dynamic> jsonMap = await jsonDecode(jsonString);

      _convertJsonMapTypes(jsonMap);
    } catch (e, st) {
      dev.log('Error decoding JSON',
          name: 'Foods', error: e.toString(), stackTrace: st);
      throw const FormatException('Error decoding JSON in FoodsData class');
    }
  }

  /// Dispose foodsList
  void clear() => _foodsList.clear();

  FoodModel? getFood(int index) => _foodsList[index];

  // Converts a Map<String, dynamic> to Map<int, FoodModel>>.
  void _convertJsonMapTypes(Map<String, dynamic> jsonMap) {
    for (final entry in jsonMap.entries) {
      final Map<String, dynamic> arg = Map.from({entry.key: entry.value});
      final food = FoodModel.fromJson(jsonMap: arg);
      _foodsList[food.id] = food;
    }
  }
}
