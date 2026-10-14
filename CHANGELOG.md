# Changelog

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
