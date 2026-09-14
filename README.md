# usda_db_package

This library uses 2 json files representing the usda sr legacy database. the library also need the manifest file to get the hash.

The files are created from this package:

- <https://github.com/marshall-buck/usda_db_creation>
The files are as follows:

1. *hash*_foods_db.json
   - this contains a json representation of the foods and nutrients chosen in the creation package.
2. *hash*_autocomplete_hash.json
   - this contains a json representation of the autocomplete data for the foods in the foods_db.json file.
3. file_manifest.txt
   - this contains the hash of the files used to create the db.

## Why this is a Flutter package and not a pure Dart one

The package depends on the Flutter SDK, so it can only be used from a Flutter app. Two things require it:

1. **`rootBundle`** (`lib/src/file_service.dart`) — the three data files are shipped as Flutter assets, declared under `flutter: assets:` in this package's `pubspec.yaml`. `rootBundle` is what reads them back out of the consuming app's bundle. A pure Dart package cannot declare assets, so the alternative would be making every consumer vendor and re-declare ~8 MB of JSON themselves.
2. **`compute`** (`lib/src/foods_data.dart`, `lib/src/autocomplete_data.dart`) — the two data files are decoded and converted on a background isolate, so `init()` does not freeze the UI for the few hundred milliseconds that parse takes. `Isolate.run` from `dart:isolate` would do the same on the VM but throws on web, where isolates do not exist; `compute` runs the callback inline there instead.

Everything else — the models, the search, the string extensions — is plain Dart.

## To use the package

> Add the package to dependencies:

 ```yaml
    dependencies:
        usda_db_package:
    git:
      url: https://github.com/marshall-buck/usda_db_package.git
```

> Import the package in your flutter project:

```dart
import 'package:usda_db_package/usda_db_package.dart';
```

> Initialize the class by calling the static `init` method which will return the instance.

```dart
final Future<UsdaDbDAO> db = await UsdaDbDAO.init();
```

> Once init is run, the following methods can be called.

- Run dispose in your app when disposing your instance.

```dart
final Future<UsdaFoodModel?> food = await db.queryFood(id: 123);

final Future<List<UsdaFoodModel>> foods = await db.queryFoods(searchString: 'apple');

db.dispose();
```

The `isDataLoaded` property can be used to check if the data has been loaded successfully.

The `isInitializing` property can be used to check if the database is currently being initialized.

## Reading nutrients

`UsdaFoodModel.nutrients` is the raw data — a `Map<int, double>` of USDA nutrient id to amount per 100g:

```dart
food.nutrients[1008]; // 307.0
```

To get those amounts with their names and units, use `nutrientList` or `nutrient()`, which return `UsdaNutrientModel`s:

```dart
final food = await db.queryFood(id: 167512);

for (final nutrient in food!.nutrientList) {
  print('${nutrient.name}: ${nutrient.amount}${nutrient.unit}');
}
// Protein: 5.88g
// Ash: 3.5g
// Fiber, total dietary: 1.2g
// ...

final calories = food.nutrient(1008); // Calories: 307.0kcal
```

`nutrient()` returns `null` if the food has no value recorded for that id.

Entries in `nutrientList` keep the order they appear in `nutrients`, and it builds a new list on each access — hoist it into a variable if you read it more than once, for example inside a `build` method.

Names and units are resolved from `UsdaNutrientModel.originalNutrientTableEdit`, keyed by USDA nutrient id. Every nutrient id in the shipped database is present in that table, but if you build a model from an id that is not, `name` and `unit` are empty strings and `isKnown` is `false` — the amount is never discarded. The table is also reachable directly:

```dart
UsdaNutrientModel.nameFor(1008); // 'Calories'
UsdaNutrientModel.unitFor(1008); // 'kcal'
```
