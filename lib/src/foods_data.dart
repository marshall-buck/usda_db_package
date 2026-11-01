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
/// always strings. `d` is the description, `c` the category code and `n` the
/// nutrients:
/// ```json
/// {
///   "167512": {
///     "d": "Pillsbury Golden Layer Buttermilk Biscuits",
///     "c": 1800,
///     "n": {"1003": 5.88, "1004": 13.2}
///   }
/// }
/// ```
class FoodsData implements DataInitializer {
  final Map<int, UsdaFoodModel> _foodsList = {};

  /// The foods table, keyed by USDA food id. Empty until [init] has run.
  Map<int, UsdaFoodModel> get foodsList => _foodsList;

  List<int> _categoryCodes = const [];

  /// The distinct category codes held by [foodsList], in ascending order.
  /// Empty until [init] has run.
  List<int> get categoryCodes => _categoryCodes;

  /// Builds [foodsList] from [jsonString], replacing whatever was there.
  ///
  /// The decode and the type conversion run on a background isolate - the foods
  /// file is several megabytes and would otherwise block the UI isolate for
  /// hundreds of milliseconds. Nothing is published unless the whole file
  /// converts, so a failure leaves [foodsList] as it was.
  ///
  /// Throws a [UsdaDbFormatException] if the JSON string cannot be decoded.
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final foods = await compute(_parseFoods, jsonString);
      _foodsList
        ..clear()
        ..addAll(foods);
      _categoryCodes = List.unmodifiable(
        foods.values.map((food) => food.categoryCode).toSet().toList()..sort(),
      );
    } catch (e, st) {
      throw UsdaDbFormatException('Error decoding foods JSON: $e', st);
    }
  }

  /// Empties [foodsList] and [categoryCodes].
  void clear() {
    _foodsList.clear();
    _categoryCodes = const [];
  }

  /// The food with [foodId], or `null` if the table has no such food.
  UsdaFoodModel? queryFood(int foodId) => _foodsList[foodId];

  /// Every food whose category is [categoryCode], in table order. Empty if
  /// none is.
  List<UsdaFoodModel> queryFoodsByCategory(int categoryCode) => [
        for (final food in _foodsList.values)
          if (food.categoryCode == categoryCode) food,
      ];
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
    final nutrientList = foodData['n'] as Map<String, dynamic>;

    foods[foodId] = UsdaFoodModel(
      id: foodId,
      description: foodData['d'] as String,
      categoryCode: foodData['c'] as int,
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
