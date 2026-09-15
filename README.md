# usda_db_package

An offline copy of the USDA SR Legacy food database for Flutter apps: 7,006
foods with their nutrient amounts, plus a substring index for autocomplete
search. The data ships inside the package as Flutter assets, so there is no
network call, no API key and nothing for the consuming app to declare.

Flutter only — see [Requirements](#requirements).

## Install

```yaml
dependencies:
  usda_db_package:
    git:
      url: https://github.com/marshall-buck/usda_db_package.git
```

```dart
import 'package:usda_db_package/usda_db_package.dart';
```

## Quick start

```dart
final db = UsdaDb();
await db.init();

final food = await db.queryFood(id: 167512);
// Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough

final foods = await db.queryFoods(searchString: 'cheddar cheese'); // 14 foods

db.dispose();
```

`init()` reads and parses both data files and must complete before any query.
It does that work on a background isolate, so it does not block the frame; it
still takes a few hundred milliseconds, so call it once at startup rather than
per screen. A failed `init()` leaves nothing half loaded and can simply be
awaited again.

## UsdaDb

| Member | Returns | Notes |
| --- | --- | --- |
| `init({FileService? fileLoader})` | `Future<void>` | Loads both data files. Throws `UsdaDbException` on failure. |
| `queryFood({required int id})` | `Future<UsdaFoodModel?>` | `null` if no food has that id. |
| `queryFoods({required String searchString, bool all = true})` | `Future<List<UsdaFoodModel>>` | Empty if nothing matches. |
| `isDataLoaded` | `bool` | True between a successful `init()` and `dispose()`. |
| `isInitializing` | `bool` | True while `init()` is running. Per instance. |
| `dispose()` | `void` | Drops both tables. `init()` can be called again afterwards. |

Querying before `init()` or after `dispose()` throws `UsdaDbException`.

## Searching

`queryFoods` matches **substrings of the food description**, not whole words.
The search string is lowercased, stripped of punctuation other than `%`, then
split on spaces and on `-`, `/`, `(`, `)`. Each resulting word must be at least
two characters; shorter ones match nothing.

- `all: true` (default) — a food must contain **every** word.
- `all: false` — a food need contain **any** one word.

```dart
await db.queryFoods(searchString: 'kale');               // 6
await db.queryFoods(searchString: 'kale raw');           // 1  - contains both
await db.queryFoods(searchString: 'kale raw', all: false); // 1,425 - either
```

Because matching is by substring, `utter` finds the 155 foods with
`buttermilk`, `butter` and so on in their description. The index holds 22,529
substrings, 2 to 15 characters long.

## Foods and nutrients

`UsdaFoodModel` carries `id`, `description`, and `nutrients` — a
`Map<int, double>` of USDA nutrient id to amount **per 100 g of the food**:

```dart
food.nutrients[1008]; // 307.0
```

For amounts with their names and units, use `nutrientList` or `nutrient()`,
which return `UsdaNutrientModel`s:

```dart
for (final nutrient in food.nutrientList) {
  print('${nutrient.name}: ${nutrient.amount}${nutrient.unit}');
}
// Protein: 5.88g
// Ash: 3.5g
// Fiber, total dietary: 1.2g
// ...

food.nutrient(1008); // Calories: 307.0kcal
food.nutrient(9999); // null - this food has no such nutrient
```

`nutrientList` keeps the order the nutrients appear in `nutrients` and builds a
new list on every access — hoist it into a variable if you read it more than
once, for example inside a `build` method.

Names and units come from `UsdaNutrientModel.originalNutrientTableEdit`, keyed
by USDA nutrient id, also reachable directly:

```dart
UsdaNutrientModel.nameFor(1008); // 'Calories'
UsdaNutrientModel.unitFor(1008); // 'kcal'
```

Every nutrient id in the shipped data is in that table. If you build a model
from an id that is not, `name` and `unit` are empty strings and `isKnown` is
`false` — the amount is never discarded.

## Errors

| Exception | When |
| --- | --- |
| `UsdaDbException` | `init()` failed, or a query ran before `init()` / after `dispose()`. |
| `UsdaDbFileException` | A data asset could not be read. |
| `UsdaDbFormatException` | A data asset was read but could not be decoded. |

`init()` wraps any failure in `UsdaDbException`, with the underlying
`UsdaDbFileException` or `UsdaDbFormatException` in its message and the
original stack trace in `stackTrace`. Catching `UsdaDbException` around
`init()` is enough.

A `UsdaDbFileException` from `init()` means the asset bundle does not hold the
data files — most often because the hash in `file_manifest.txt` no longer
matches the file names in `lib/data/`.

## What's in the database

- 7,006 foods, ids 167512–175304, from USDA SR Legacy.
- 93 distinct nutrients across the set; 1 to 81 per food. Calories (1008) is
  present for every food.
- All amounts are per 100 g.
- Two assets, about 13 MB total: `<hash>_foods_db.json` (9.5 MB) and
  `<hash>_autocomplete_hash.json` (3.6 MB), plus `file_manifest.txt`, which
  holds the hash their names are prefixed with.

The raw JSON is not kept in memory after parsing, and `dispose()` releases the
parsed tables.

The files are generated by a separate package,
<https://github.com/marshall-buck/usda_db_creation>.

## Requirements

- Dart SDK ^3.1.0, and Flutter — the package cannot be used from pure Dart.

Two Flutter APIs are load-bearing. `rootBundle` reads the data out of the
consuming app's asset bundle, which is what lets the package ship its own data;
a pure Dart package cannot declare assets. `compute` moves parsing to a
background isolate. On web, where isolates do not exist, `compute` runs inline —
`init()` works, but it blocks while parsing.

## Testing against the package

`init` takes an optional `FileService`, which is how a test supplies its own
data instead of reading the bundle:

```dart
class MockFileService extends Mock implements FileService {}

when(() => loader.loadData(fileName: FileService.fileNameFoods))
    .thenAnswer((_) async => myFoodsJson);

await db.init(fileLoader: loader);
```
