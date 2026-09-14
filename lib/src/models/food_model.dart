// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';

import 'nutrient_model.dart';

/// A food item from the USDA SR Legacy database.
///
/// [nutrients] is the raw data: a map of USDA nutrient id to amount per 100g.
/// For nutrients carrying their display name and unit, use [nutrientList] or
/// [nutrient]:
///
/// ```dart
/// final food = await db.queryFood(id: 167512);
///
/// for (final n in food!.nutrientList) {
///   print('${n.name}: ${n.amount}${n.unit}');  // Protein: 4.34g
/// }
///
/// final calories = food.nutrient(1008)?.amount;
/// ```
class UsdaFoodModel extends Equatable {
  const UsdaFoodModel({
    required this.id,
    required this.description,
    required this.nutrients,
  });

  /// Food id.
  final int id;

  /// Food Description.
  final String description;

  /// The id of the nutrient and the amount {id: amount}.
  ///
  /// Amounts are per 100g of the food. See [nutrientList] for the same data
  /// paired with nutrient names and units.
  final Map<int, double> nutrients;

  /// The food's [nutrients] as [UsdaNutrientModel]s, each carrying a display
  /// name and unit alongside the amount.
  ///
  /// Entries keep the order they appear in [nutrients]. Nutrient ids with no
  /// entry in [UsdaNutrientModel.originalNutrientTableEdit] are still
  /// included, with an empty name and unit — filter on
  /// [UsdaNutrientModel.isKnown] to drop them.
  ///
  /// This builds a new list on each access. Hoist it into a variable if you
  /// read it more than once, e.g. inside a `build` method.
  List<UsdaNutrientModel> get nutrientList => [
        for (final entry in nutrients.entries)
          UsdaNutrientModel.fromId(id: entry.key, amount: entry.value),
      ];

  /// The nutrient with the given USDA [nutrientId], or `null` if this food
  /// has no value recorded for it.
  ///
  /// ```dart
  /// food.nutrient(1008); // Calories: 336.0kcal
  /// ```
  UsdaNutrientModel? nutrient(int nutrientId) {
    final amount = nutrients[nutrientId];
    if (amount == null) return null;
    return UsdaNutrientModel.fromId(id: nutrientId, amount: amount);
  }

  @override
  List<Object> get props => [id, description, nutrients];
}
