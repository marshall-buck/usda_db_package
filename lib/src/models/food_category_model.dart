import 'package:equatable/equatable.dart';

/// A USDA food category: its [code] and display [name].
///
/// `UsdaFoodModel` stores its category as a raw `int` code. This class pairs
/// that code with the name it means. You rarely need to build one by hand —
/// read it off a food instead:
///
/// ```dart
/// final food = await db.queryFood(id: 167512);
/// print(food!.category.name); // Baked Products
/// ```
///
/// Names come from [foodCategories], a fixed table keyed by USDA category
/// code. Every category code in the shipped data is in that table, so a
/// category read off a food always has a name. A code you supply yourself that
/// the table does not hold yields an empty [name]; see [isKnown].
class UsdaFoodCategoryModel extends Equatable {
  /// Creates a category with its display [name] already resolved.
  ///
  /// Prefer [UsdaFoodCategoryModel.fromCode], which looks the name up for you.
  const UsdaFoodCategoryModel({
    required this.code,
    required this.name,
  });

  /// Builds a category from a USDA category [code], looking up the name in
  /// [foodCategories].
  ///
  /// If [code] is not in the table, [name] is an empty string rather than an
  /// error. Check [isKnown] if you need to tell the two cases apart.
  factory UsdaFoodCategoryModel.fromCode(int code) => UsdaFoodCategoryModel(
        code: code,
        name: foodCategories[code] ?? '',
      );

  /// The USDA category code, e.g. `1800` for Baked Products.
  final int code;

  /// Display name, e.g. `'Baked Products'`. Empty if [code] is not a known
  /// category.
  final String name;

  /// Whether [code] was found in [foodCategories], and so whether [name] is
  /// meaningful.
  bool get isKnown => foodCategories.containsKey(code);

  /// The display name for a USDA category [code], or `null` if unknown.
  static String? nameFor(int code) => foodCategories[code];

  @override
  String toString() => name;

  @override
  List<Object?> get props => [code, name];

  /// USDA category code to its display name.
  ///
  /// The code is USDA's four digit string read as an int, so `0100` is `100`.
  /// The table holds every USDA category, including the ones excluded from
  /// the shipped data. See [nameFor] for single lookups.
  static const Map<int, String> foodCategories = {
    100: 'Dairy and Egg Products',
    200: 'Spices and Herbs',
    300: 'Baby Foods',
    400: 'Fats and Oils',
    500: 'Poultry Products',
    600: 'Soups, Sauces, and Gravies',
    700: 'Sausages and Luncheon Meats',
    800: 'Breakfast Cereals',
    900: 'Fruits and Fruit Juices',
    1000: 'Pork Products',
    1100: 'Vegetables and Vegetable Products',
    1200: 'Nut and Seed Products',
    1300: 'Beef Products',
    1400: 'Beverages',
    1410: 'Alcoholic Beverages',
    1500: 'Finfish and Shellfish Products',
    1600: 'Legumes and Legume Products',
    1700: 'Lamb, Veal, and Game Products',
    1800: 'Baked Products',
    1900: 'Sweets',
    2000: 'Cereal Grains and Pasta',
    2100: 'Fast Foods',
    2200: 'Meals, Entrees, and Side Dishes',
    2500: 'Snacks',
    2600: 'Quality Control Materials',
    3500: 'American Indian/Alaska Native Foods',
    3600: 'Restaurant Foods',
    4500: 'Branded Food Products Database',
  };
}
