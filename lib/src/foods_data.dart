import 'dart:convert';
import 'dart:developer' as dev;

import 'initializer.dart';
import 'models/food_model.dart';

/// Class to handle the foods database.
/// A class that represents the data for foods.
///
/// This class is responsible for initializing the foods database and providing
/// methods to retrieve food items from the database.
///
/// The [FoodsData] class is initialized by calling the [init] method, which
/// takes a JSON string as a parameter. The JSON string is decoded and the
/// resulting map is used to populate the [foodsList] property.
///
/// The [foodsList] property is a map that stores food IDs as keys and
/// [FoodModel] objects as values.
///
/// The [getFood] method takes a food ID as a parameter and returns the
/// corresponding [FoodModel] object from the [foodsList] map. If the food ID
/// is not found in the map, the method returns null.
///
/// The  [clear] method reverts the data to an empty state by clearing the [foodsList] map.
/// Implements the [Initializer] interface.
class FoodsData implements Initializer {
  final Map<int, FoodModel> _foodsList = {};
  Map<int, FoodModel> get foodsList => _foodsList;

  /// Initializes by decoding a JSON string, and populating [_foodsList]
  /// with the decoded data.
  ///
  /// Throws a [FormatException] if the JSON string cannot be decoded.
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

  /// Empty the foodsList object.
  void clear() => _foodsList.clear();

  /// Returns a [FoodModel] from the [_foodsList] or [null] if not found.
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
