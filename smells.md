# Code Smells — `usda_db_package`

A deep pass over `lib/`, `test/`, `example/` and package config. Ordered roughly by severity.

---

## Correctness / real bugs

✅ ~~**`init()` can only ever be called once per instance — a second call throws `LateInitializationError`.**~~
`lib/src/usda_db_base.dart:48,69` — `late final FileService _fileLoader` is assigned on line 69, *outside* the `try`. Retrying `init()` after a failure (the documented recovery path, since `_loadData` disposes everything on error) blows up with an uncaught `LateInitializationError` instead of the advertised `DBException`.
*Resolution:* `_fileLoader` is now a plain field with a default `FileService()`, reassigned on each `init()`. Regression test `init() - can be retried after a failure` covers the retry path.

✅ ~~**`_isInitializing` is `static` but exposed as an instance getter.**~~
`lib/src/usda_db_base.dart:52,58,68,81` — all `UsdaDbDAO` instances share one flag. Two overlapping `init()` calls: the first to reach `finally` clears the flag while the second is still loading, so `isInitializing` lies. Nothing about this state is class-level; it should be an instance field.
*Resolution:* `_isInitializing` is now an instance field. Regression test `init() - isInitializing is not shared between instances` covers it.

✅ ~~**`stripDashedAndParenthesisAndForwardSlashesWord()` only handles the *first* delimiter it finds.**~~
`lib/src/extensions/string_ext.dart:25-36` — the chain of early `return`s means `"ready-to-heat/toasted"` splits on `-` only, leaving `"heat/toasted"` as one token; `"chicken(raw)/beef"` splits on `/` and leaves `"chicken(raw)"`. USDA descriptions routinely mix these characters, so search terms silently fail to match.
*Confirmed against the shipped data:* the 22,529 `substringHash` keys contain no `-`, `/`, `(` or `)`, and `getFoodIndexes` is an exact map lookup, so any token still carrying a delimiter matches nothing. Searching the verbatim description `Cabbage, chinese (pak-choi), raw` returned 0 results.
*Resolution:* one `split(RegExp('[-/()]'))` pass replaces the early-return chain. Regression tests `stripDashedAndParenthesisWord() - splits on every delimiter, not just the first kind` and the live test `queryFoods() - matches a description that mixes dashes and parentheses` cover it.

✅ ~~**The `(\d+%)` regex branch is a no-op, and the doc comment says the opposite of what the code does.**~~
`lib/src/extensions/string_ext.dart:2-21` — `%` is already inside the allowed set `[^\w()%\-\/]`, so digits-plus-percent are never candidates for removal; the alternation matches `"2%"` and replaces it with `match.group(1)` — itself. Meanwhile the doc claims it "removes … numbers followed by a %". Dead branch plus a lying comment.
*Resolution:* dropped the alternation and the `replaceAllMapped` callback in favour of `replaceAll(RegExp(r'[^\w()%\-/]'), '')`, which is byte-for-byte equivalent, and rewrote the doc comment to describe what the pattern actually keeps. Regression test `removeUnwantedChars() - keeps digits followed by a percent sign` pins the `%` behaviour.

✅ ~~**`UsdaNutrientModel.fromMapEntry` force-unwraps an unchecked lookup.**~~ *Fixed.*
`lib/src/models/nutrient_model.dart:27` — `originalNutrientTableEdit[id]!` threw on any nutrient id not in the hardcoded table, while the sibling `fromJson` factory handled the same miss gracefully with `?? ''`. Two factories, two different failure policies.
*Resolution:* both now delegate to the new `fromId`, which resolves misses to empty `name`/`unit` and never discards the amount. `fromMapEntry` still throws `FormatException` on a non-integer key, which is now documented and tested.

✅ ~~**`queryFoods` silently returns `null` entries.**~~
`lib/src/usda_db_base.dart:131-154` — the return type is `List<UsdaFoodModel?>`. A `null` there means the autocomplete index references a food id absent from `foods_db.json` — a data-integrity failure that is handed to the caller as a null to trip over rather than logged or filtered.
*Resolution:* `queryFoods` now returns `List<UsdaFoodModel>`; a dangling id is logged via `dev.log` and skipped. The nullability was gratuitous all the way down - `AutoCompleteData._indexHash` is `Map<int, List<int>>`, so `getFoodIndexes` now returns `List<int>` and `_getIdsAll`/`_getIdsAny` return `Set<int>`, which also removes the `id!` force-unwrap. README and the class doc example updated. Regression test `queryFoods() - drops ids the foods table does not hold`.

---

## Type / API design

✅ ~~**Nullable-`int` ids propagate through the whole search path for no reason.**~~
`lib/src/autocomplete_data.dart:105` returns `List<int?>`, `_getIdsAll`/`_getIdsAny` return `Set<int?>` (`usda_db_base.dart:158,186`), and it's finally force-unwrapped at `usda_db_base.dart:150` with `id!`. `_indexHash` is typed `Map<int, List<int>>` — these values are *never* null. The whole chain should be non-nullable `int`.
*Resolution:* fixed alongside the `queryFoods` null-entry smell above — the chain is non-nullable `int` end to end and the `id!` is gone.

✅ ~~**`await` on values that are not `Future`s.**~~
`lib/src/autocomplete_data.dart:78` and `lib/src/foods_data.dart:37` — `await jsonDecode(jsonString)`. `jsonDecode` is synchronous; the `await` buys nothing and disguises the real problem (below). Likewise `dispose()` (`usda_db_base.dart:106`) and `FoodsData._convertJsonMapTypes` are `Future<void>` while doing zero async work.
*Resolution:* the fake awaits are gone. Both `init` methods now `await` a real `Future` — the `compute()` call below — so the `async` is earned. `dispose()` is `void`, and `FoodsData._convertJsonMapTypes` no longer exists; its work moved into the isolate entry point. Call sites in the tests and the README dropped their `await`.

✅ ~~**~8 MB of JSON is parsed on the UI isolate.**~~
`lib/data/002735_foods_db.json` (4.6 MB) and `002735_autocomplete_hash.json` (3.6 MB) are decoded *and* converted key-by-key (`foods_data.dart:59-77`, `autocomplete_data.dart:109-136`) synchronously in `init()`. In a Flutter app this is a multi-hundred-millisecond frame freeze. Nothing here uses `compute()` or an isolate.
*Resolution:* the decode and the type conversion are now top-level functions (`_parseFoods`, `_parseAutoCompleteData`) handed to `compute()`, so both files are parsed on a background isolate and the UI isolate only receives the finished maps. `compute` was chosen over `Isolate.run` because it degrades to an inline call on web, where isolates do not exist. A side effect worth having: parsing no longer populates the instance incrementally, so a file that fails halfway through no longer leaves a half-built table behind — pinned by `FoodsData - init leaves foodsList empty when an entry fails to convert`.

✅ ~~**`queryFoods` awaits a synchronous map lookup once per result, re-validating state each time.**~~
`lib/src/usda_db_base.dart:148-152` — the loop `await queryFood(id: id!)` re-runs the `isDataLoaded` check and allocates a `Future` for what is ultimately `_foodsList[id]`. The `ids.toList()` on line 149 is also a pointless copy of a `Set` that is already iterable.
*Resolution:* the loop hoists `_foodsData!` once and calls the synchronous `FoodsData.queryFood` directly, so there is one `isDataLoaded` check per query instead of one per result and no `Future` per row. The `ids.toList()` copy went with the nullable-id fix above. The public `queryFood`/`queryFoods` keep their `Future` return types — that is the API consumers already build against.

✅ ~~**Exception type laundering.**~~
`lib/src/file_service.dart:42,63` converted *any* asset-bundle failure into `FileSystemException(e.toString())` — a `dart:io` type for something that never touched the filesystem, with the original exception flattened to a string. `foods_data.dart` threw `const FormatException('Error decoding JSON in FoodsData class')` and dropped `e` entirely, while `autocomplete_data.dart` interpolated it — two conventions, one of them lossy.
*Resolution:* replaced with a package-owned `DBFileException` that keeps the asset path and the stack trace; both throw sites now share one `_loadAsset` helper. `DBException` and `DBFileException` are also exported from `usda_db_package.dart` — they are thrown by the public API but were previously unreachable by consumers, so there was no way to catch them by type.
Both decode failures now throw one type, `DBFormatException`, carrying the underlying error in the message *and* the original stack trace — the same shape as `DBFileException`, and exported alongside it. The distinction it preserves is worth keeping: `DBFileException` means the asset could not be read, `DBFormatException` means it was read but would not decode. The `const FormatException`s inside `_parseAutoCompleteData` stay as they are — they are the genuine format-validation errors, raised on the isolate and wrapped on the way out.
The four log-and-throw pairs went with it. `foods_data.init`, `autocomplete_data.init`, `FileService._loadAsset` and `UsdaDbDAO.init` each called `dev.log` with the error and stack trace and then threw an exception carrying the same two things, so one decode failure was reported twice — once as a log line the caller cannot suppress, once as the exception. Now they only throw; the caller decides whether to log. The logs that remain are the ones that are not also thrown: `init()`/`dispose` completion, and the dangling-food-id warning in `queryFoods`, which is deliberately logged *instead of* thrown.

✅ ~~**`dart:io` import makes the package uncompilable for web.**~~ *Fixed.*
`lib/src/file_service.dart:2` — imported solely for `FileSystemException`. Removed along with that exception type; `lib/` no longer references `dart:io` anywhere.

> **Package type.** The only remaining Flutter dependency in `lib/` is `rootBundle` in `file_service.dart:3` — everything else (models, parsing, search, extensions) is already plain Dart. That one import is load-bearing: `rootBundle` reads the files declared under `flutter: assets:`, which is how the 8 MB of JSON reaches a consuming app. A pure Dart package cannot declare Flutter assets, so dropping it would force every consumer to vendor and re-declare the data files. Decision: stay a Flutter package, and fix the scaffold damage instead.

---

## Dead code / duplication

✅ ~~**`Sanitizer` is a 128-line class whose only real content is dead.**~~ *Fixed.*
`lib/src/sanitizer.dart` — the 100-entry `stopWords` list was referenced only by `_removeStopWords`, which was commented out, which was called from a commented-out line in `createSearchList`. What survived was `createSearchList` → `_sanitizeSentence` → `sentence.sanitizeSentence()`: two layers of indirection over a one-line extension call, wrapped in a stateless class instantiated as a field.
*Resolution:* deleted `lib/src/sanitizer.dart` and its duplicate test; `queryFoods` now calls `searchString.sanitizeSentence().toList()` directly. The two cases only `sanitizer_test.dart` covered (empty sentence, single word) moved to `test/src/extensions/string_ext_test.dart`.

✅ ~~**`UsdaNutrientModel` is fully unused by the package it ships in.**~~ *Mostly fixed.*
`lib/src/models/nutrient_model.dart` — exported publicly and exercised only by its own test. Worse than unused: it was structurally *unreachable*. `UsdaFoodModel.nutrients` is `Map<int, double>`, but the only bridging factory, `fromMapEntry`, took `MapEntry<String, double>` and called `int.parse(entry.key)` — so `food.nutrients.entries.map(UsdaNutrientModel.fromMapEntry)` would not compile.
*Resolution:* added `UsdaNutrientModel.fromId({id, amount})` matching the map's actual types, plus `nameFor`/`unitFor` statics and an `isKnown` flag; `fromJson` and `fromMapEntry` now delegate to it, which also removes the `!` crash on unknown ids (see the fixed entry below). `UsdaFoodModel` gained a computed `nutrientList` getter and a `nutrient(id)` lookup, documented in the README. Verified against the shipped data: all 7,006 foods resolve, zero unknown nutrient ids.
The dead `keepTheseNutrients` list (96 entries, zero references — it belongs to the `usda_db_creation` package that generates the JSON, not to this one) has been deleted.

✅ ~~**`lib/main.dart` is the unmodified Flutter counter demo, inside a library package.**~~ *Fixed.*
125 lines of `MyHomePage`/`_incrementCounter` boilerplate with the stock tutorial comments still in place, sitting in `lib/` and dragging `flutter/material` in. `test/widget_test.dart` was its companion: a `testWidgets` block with every assertion commented out — a test that asserted nothing and always passed.
*Root cause:* `.metadata` declared `project_type: app`. The repo was scaffolded with `flutter create` as an **app**, not `--template=package`, which is where `main.dart`, `web/`, `widget_test.dart` and the IDE run config all came from.
*Resolution:* deleted `lib/main.dart`, `test/widget_test.dart` and `.idea/runConfigurations/main_dart.xml`; `.metadata` is now `project_type: package` with the app/web migration entries stripped. (`web/` was already gone and was never tracked.)

✅ ~~**Empty duplicate at the repo root.**~~ *Fixed.*
`usda_db_example.dart` (root) was a 1-byte file containing a newline, shadowing the real `example/usda_db_example.dart`. Deleted.

✅ ~~**`fromJson`'s parameter is named `jsonString` but takes a `Map`.**~~ *Fixed.*
`lib/src/models/nutrient_model.dart` — renamed to `json`.

✅ ~~**Duplicated error string with mangled punctuation.**~~ *Fixed.*
`'The DB has not been initialized! properly'` appeared verbatim at `usda_db_base.dart:120` and `:136`. Both now call a single `_requireDataLoaded()` guard, and the punctuation is no longer mid-sentence.

---

## Tests

✅ ~~**Tests bypass the public API.**~~
Every test imported `package:usda_db_package/src/...` directly rather than `package:usda_db_package/usda_db_package.dart`, so nothing verified that the exported surface is actually usable.
*Root cause found on the way:* `UsdaDbDAO.init({FileService? fileLoader})` named a type the package did not export. A consumer could not write that call at all, so the one injection seam in the API was reachable only from inside the package — which is exactly why every test had to reach into `src/`.
*Resolution:* `src/file_service.dart` is now exported, making the signature honest. `live_test.dart`, `usda_db_base_test.dart`, both model tests and `setup/startup.dart` import only the public library. The three unit tests of genuinely internal classes (`FoodsData`, `AutoCompleteData`, `FileService`) still import `src/` for the class under test — that is correct for a unit test — but take their exception types through the public library.
New `test/public_api_test.dart` imports the public library and nothing from `src/`: it initializes a `UsdaDbDAO` with an injected loader, queries by id, catches `DBException`, and walks `UsdaFoodModel` → `nutrient()` → `UsdaNutrientModel`. A dropped `export` line now fails to compile rather than shipping.

✅ ~~**~10 lines of identical mock setup copy-pasted into all 9 tests.**~~
`test/src/usda_db_base_test.dart` — 24 `when(() => mockFileLoaderService.loadData(...))` stubs across 279 lines, every one of them the same pair. This belongs in `setUp`. Two tests (lines 231-248 and 213-230) are byte-identical in body with different names.

✅ ~~**Unit tests reach for real assets.**~~
`test/src/usda_db_base_test.dart:252-278` ("Test Db files") and all of `test/src/file_service_test.dart` load the actual 8 MB bundled files, inside the mocked-unit-test file. `test/live_test.dart` already covers this, and duplicates `usda_db_base_test.dart`'s structure test-for-test against live data.

✅ ~~**Shared mutable fixture across tests.**~~
`test/src/autocomplete_data_test.dart:11` — one `AutoCompleteData()` created at group scope, `init()` called repeatedly on it with no `clear()`; state accumulates across tests and results become order-dependent.

✅ ~~**`late final` top-level mock reassigned in `setUpAll`.**~~
`test/setup/startup.dart:7,15` — works only because each test file gets a fresh isolate; `tearDown` calls `reset()` on it, but a second `setUpAll` in the same isolate would throw.

✅ ~~**Assertions that can't fail.**~~
`test/src/autocomplete_data_test.dart:82` — `expect(indexes, isA<List<void>>())` is true for basically any list. `test/src/usda_db_base_test.dart` and `live_test.dart` assert `isA<UsdaFoodModel>()` on values already statically typed as such.

---

## Packaging / config

✅ ~~**`collection` is a runtime dependency used only by tests.**~~
`pubspec.yaml:11` — the only imports were `test/src/sanitizer_test.dart:1` and `test/src/autocomplete_data_test.dart:3`. Belonged in `dev_dependencies`.
*Resolution:* deleted outright rather than moved. Both importers are already gone — `sanitizer_test.dart` with the `Sanitizer` class, and the `DeepCollectionEquality` in `autocomplete_data_test.dart` when that assertion was replaced with a plain list matcher. Nothing in `lib/`, `test/` or `example/` imports `package:collection` now.

✅ ~~**`pubspec.yaml` description describes a different package.**~~
`"A package to json-ize the usda db"` — that's the *creation* package (`usda_db_creation`, per the README). This one only reads and queries. `repository:` is commented out, `build_runner` is a commented-out dev dep, and the file carries three blank-line gaps mid-block.

✅ ~~**README documents an API that doesn't exist.**~~
`README.md:38` — `final Future<UsdaDbDAO> db = await UsdaDbDAO.init();` implies a static factory returning an instance. The real API is `final db = UsdaDbDAO(); await db.init();` (see `example/usda_db_example.dart:11-12`). The class doc comment is worse — `usda_db_base.dart:38-41` still refers to `UsdaDB` and `FoodModel`, names changed two commits ago.

✅ ~~**Doc comments that restate the implementation line by line.**~~
`lib/src/autocomplete_data.dart:6-64` — ~60 lines narrating each method and private helper before a 70-line class. `lib/src/usda_db_base.dart:14-44` and `lib/src/foods_data.dart:7-25` do the same. They have already drifted (see above), which is exactly the failure mode this style invites.

✅ ~~**`.gitignore` contradicts the working tree.**~~
`/web`, `pubspec.lock`, and `doc/api/` are all listed as ignored, yet `web/`, `pubspec.lock` and a full generated `doc/api/` tree are present in the repo. `analysis_options.yaml` separately excludes `web/**` from analysis. Three `.DS_Store` files are sitting in the tree (`./`, `lib/`, `lib/data/`) — and `lib/data/.DS_Store` is inside the directory declared wholesale as a Flutter asset (`pubspec.yaml:27-28`), so it gets bundled into every consuming app.

✅ ~~**The manifest hash is read from disk on every single `loadData` call.**~~
`lib/src/file_service.dart:29,51-65` — `_getFileHash()` re-loads `file_manifest.txt` for each of the two data files. It is a 6-byte constant for the lifetime of the app; nothing caches it.

✅ ~~**Lints switched off rather than satisfied.**~~
`analysis_options.yaml:10-14` disables `public_member_api_docs`, `avoid_print` and `always_use_package_imports`. Consistent with `print` calls commented out in `usda_db_base.dart:139,144`, a live `print` in `example/usda_db_example.dart:24`, and mixed import styles (`package:usda_db_package/src/initializer.dart` in `autocomplete_data.dart:4` vs. relative `'initializer.dart'` in `foods_data.dart:4`) — including the odd `import '../src/models/models.dart'` in `usda_db_base.dart:4`, which walks up and back into its own directory.
