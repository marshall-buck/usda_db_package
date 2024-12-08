import 'dart:convert';
import 'dart:developer' as dev;

import 'initializer.dart';
import 'models/models.dart';

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
/// [SrLegacyFoodModel] objects as values.
///
/// The [queryFood] method takes a food ID as a parameter and returns the
/// corresponding [SrLegacyFoodModel] object from the [foodsList] map. If the food ID
/// is not found in the map, the method returns null.
///
/// The  [clear] method reverts the data to an empty state by clearing the [foodsList] map.
/// Implements the [DataInitializer] interface.
class FoodsData implements DataInitializer {
  final Map<int, SrLegacyFoodModel> _foodsList = {};
  Map<int, SrLegacyFoodModel> get foodsList => _foodsList;

  /// Initializes by decoding a JSON string, and populating [_foodsList]
  /// with the decoded data.
  ///
  /// Throws a [FormatException] if the JSON string cannot be decoded.
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final jsonMap = await jsonDecode(jsonString);
      // ignore: avoid_dynamic_calls

      await _convertJsonMapTypes(jsonMap as Map<String, dynamic>);
    } catch (e, st) {
      dev.log(
        'Error decoding JSON',
        name: 'Foods',
        error: e.toString(),
        stackTrace: st,
      );
      throw const FormatException('Error decoding JSON in FoodsData class');
    }
  }

  /// Empty the foodsList object.
  void clear() => _foodsList.clear();

  /// Returns a [SrLegacyFoodModel] from the [_foodsList] or null if not found.
  SrLegacyFoodModel? queryFood(int foodId) => _foodsList[foodId];

  /// Converts a Map<String, dynamic> to Map<int, SrLegacyFoodModel>>.
  Future<void> _convertJsonMapTypes(Map<String, dynamic> jsonMap) async {
    for (final entry in jsonMap.entries) {
      final foodId = int.parse(entry.key);
      final foodData = entry.value as Map<String, dynamic>;

      // Explicitly cast the nutrients list
      final nutrientList = foodData['nutrients'] as Map<String, dynamic>;

      final nutrients = _createNutrients(nutrientList);

      final food = SrLegacyFoodModel(
        id: foodId,
        description: foodData['description'] as String,
        nutrients: nutrients,
      );

      _foodsList[foodId] = food;
    }
  }

  /// Creates a map of nutrient IDs to nutrient values.
  Map<int, double> _createNutrients(Map<String, dynamic> nutrientList) {
    final nutrients = <int, double>{};
    for (final entry in nutrientList.entries) {
      final value = entry.value as num;
      final key = int.parse(entry.key);
      nutrients[key] = value.toDouble();
    }
    return nutrients;
  }
}
