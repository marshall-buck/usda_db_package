# Changelog

## 2.0.0

- **BREAKING:** `UsdaFoodModel` has a new required `categoryCode` parameter.
  Code that constructs a `UsdaFoodModel` directly must pass it.
- **BREAKING:** `categoryCode` is part of `UsdaFoodModel` equality.
- **BREAKING:** the foods asset now uses the single character keys written by
  `usda_db_creation` 2.0: `d` for the description, `c` for the category code
  and `n` for the nutrients. A foods JSON supplied through a custom
  `FileService` must use the new keys.
- `UsdaFoodModel.categoryCode` holds the food's USDA category code, for
  example `1800`.
- `UsdaFoodModel.category` returns the code as a `UsdaFoodCategoryModel`
  carrying its display name, for example `Baked Products`.
- New `UsdaFoodCategoryModel` with `code`, `name`, `isKnown`, `fromCode`,
  `nameFor` and the static `foodCategories` table of all 28 USDA categories.
- `UsdaDb.queryFoods` takes an optional `categoryCode` that keeps only foods in
  that category.
- `UsdaDb.queryFoodsByCategory` returns every food in a category.
- `UsdaDb.categories` lists the categories the loaded foods belong to, in code
  order.

## 1.1.0

- `UsdaFoodModel.matchedWords` lists the words in a food's description that
  matched the search it was returned for, in their original case.
- `UsdaFoodModel.matchTerms` holds the sanitized terms behind
  `matchedWords`. It is not part of equality.
- `UsdaFoodModel.withMatchTerms()` copies a food with new match terms.
- `UsdaDb.queryFoods` sets the match terms on every food it returns, keeping
  only the search words the index matched.
- `UsdaDb.queryFood` takes an optional `matchWordsFor` to fill `matchedWords`.
  It does not affect which food is returned.

## 1.0.0

- Initial release.
