import 'package:equatable/equatable.dart';

import 'package:usda_db_package/src/extensions/string_ext.dart';
import 'package:usda_db_package/src/models/nutrient_model.dart';

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
  /// Creates a food item.
  const UsdaFoodModel({
    required this.id,
    required this.description,
    required this.nutrients,
    this.matchTerms = const [],
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

  /// The sanitized terms [matchedWords] matches against: the search words a
  /// food was returned for, or the words passed to `queryFood`'s
  /// `matchWordsFor`. Empty when neither applies.
  ///
  /// Not part of equality: the same food with different terms is still the
  /// same food.
  final List<String> matchTerms;

  /// The words in [description] that contain any of [matchTerms], in the
  /// order they appear, each once. Empty when [matchTerms] is.
  ///
  /// Words keep their original case and are split the same way the search
  /// index splits them: on whitespace, `-`, `/`, `(` and `)`, with other
  /// punctuation removed.
  ///
  /// ```dart
  /// final foods = await db.queryFoods(searchString: 'app');
  /// foods.first.matchedWords; // ['Apples']
  /// ```
  ///
  /// This is worked out on each access. Hoist it into a variable if you read
  /// it more than once, e.g. inside a `build` method.
  List<String> get matchedWords {
    if (matchTerms.isEmpty) return const [];
    final words = <String>{};
    for (final token in description.split(' ')) {
      for (final word in token
          .removeUnwantedChars()
          .stripDashedAndParenthesisAndForwardSlashesWord()) {
        if (word.isEmpty) continue;
        final lowerWord = word.toLowerCase();
        if (matchTerms.any(lowerWord.contains)) words.add(word);
      }
    }
    return words.toList();
  }

  /// A copy of this food carrying [matchTerms].
  UsdaFoodModel withMatchTerms(List<String> matchTerms) => UsdaFoodModel(
        id: id,
        description: description,
        nutrients: nutrients,
        matchTerms: matchTerms,
      );

  /// The food's [nutrients] as [UsdaNutrientModel]s, each carrying a display
  /// name and unit alongside the amount.
  ///
  /// Entries keep the order they appear in [nutrients]. Every nutrient id in
  /// the shipped data has an entry in
  /// [UsdaNutrientModel.originalNutrientTableEdit], so every entry here
  /// resolves to a name and unit.
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
