import 'dart:convert';

// `compute` rather than `Isolate.run` from dart:isolate: this package is used
// from Flutter apps that may be built for web, where isolates do not exist and
// `Isolate.run` throws. `compute` runs the callback inline there and on a real
// background isolate everywhere else. This is one of the two things keeping the
// package on Flutter instead of pure Dart; the other is `rootBundle` in
// file_service.dart.
import 'package:flutter/foundation.dart' show compute;

import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/initializer.dart';
import 'package:usda_db_package/src/models/models.dart';

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
/// [UsdaFoodModel] objects as values.
///
/// The [queryFood] method takes a food ID as a parameter and returns the
/// corresponding [UsdaFoodModel] object from the [foodsList] map. If the food ID
/// is not found in the map, the method returns null.
///
/// The  [clear] method reverts the data to an empty state by clearing the [foodsList] map.
/// Implements the [DataInitializer] interface.
class FoodsData implements DataInitializer {
  final Map<int, UsdaFoodModel> _foodsList = {};

  /// The foods table, keyed by USDA food id. Empty until [init] has run.
  Map<int, UsdaFoodModel> get foodsList => _foodsList;

  /// Initializes by decoding a JSON string, and populating [_foodsList]
  /// with the decoded data.
  ///
  /// The decode and the type conversion run on a background isolate - the foods
  /// file is several megabytes and would otherwise block the UI isolate for
  /// hundreds of milliseconds.
  ///
  /// Throws a [DBFormatException] if the JSON string cannot be decoded.
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final foods = await compute(_parseFoods, jsonString);
      _foodsList
        ..clear()
        ..addAll(foods);
    } catch (e, st) {
      throw DBFormatException('Error decoding foods JSON: $e', st);
    }
  }

  /// Empty the foodsList object.
  void clear() => _foodsList.clear();

  /// Returns a [UsdaFoodModel] from the [_foodsList] or null if not found.
  UsdaFoodModel? queryFood(int foodId) => _foodsList[foodId];
}

/// Decodes [jsonString] and converts it into the foods table.
///
/// Top level so it can be handed to [compute] and run on a background isolate.
Map<int, UsdaFoodModel> _parseFoods(String jsonString) {
  final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
  final foods = <int, UsdaFoodModel>{};

  for (final entry in jsonMap.entries) {
    final foodId = int.parse(entry.key);
    final foodData = entry.value as Map<String, dynamic>;

    // Explicitly cast the nutrients list
    final nutrientList = foodData['nutrients'] as Map<String, dynamic>;

    foods[foodId] = UsdaFoodModel(
      id: foodId,
      description: foodData['description'] as String,
      nutrients: _createNutrients(nutrientList),
    );
  }

  return foods;
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
