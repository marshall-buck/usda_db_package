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

/// The foods table: every food in the packaged database, keyed by USDA id.
///
/// [init] builds it from the packaged JSON, [queryFood] reads one entry, and
/// [clear] drops the lot.
///
/// The shape of the file [init] expects, which the code alone does not give
/// away - nutrient ids and food ids arrive as strings because JSON keys are
/// always strings:
/// ```json
/// {
///   "167512": {
///     "description": "Pillsbury Golden Layer Buttermilk Biscuits",
///     "nutrients": {"1003": 5.88, "1004": 13.2}
///   }
/// }
/// ```
class FoodsData implements DataInitializer {
  final Map<int, UsdaFoodModel> _foodsList = {};

  /// The foods table, keyed by USDA food id. Empty until [init] has run.
  Map<int, UsdaFoodModel> get foodsList => _foodsList;

  /// Builds [foodsList] from [jsonString], replacing whatever was there.
  ///
  /// The decode and the type conversion run on a background isolate - the foods
  /// file is several megabytes and would otherwise block the UI isolate for
  /// hundreds of milliseconds. Nothing is published unless the whole file
  /// converts, so a failure leaves [foodsList] as it was.
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

  /// Empties [foodsList].
  void clear() => _foodsList.clear();

  /// The food with [foodId], or `null` if the table has no such food.
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
