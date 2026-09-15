import 'dart:async';
import 'dart:developer' as dev;

import 'package:usda_db_package/src/autocomplete_data.dart';
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/extensions/string_ext.dart';
import 'package:usda_db_package/src/file_service.dart';
import 'package:usda_db_package/src/foods_data.dart';
import 'package:usda_db_package/src/models/models.dart';

/// Read-only access to the packaged USDA SR Legacy database.
///
/// Construct one, [init] it, then query it. [init] reads and parses both data
/// assets - a few hundred milliseconds of work, off the UI isolate - and
/// throws a [UsdaDbException] if either fails. Query before that, or after
/// [dispose], and it throws the same.
///
/// ```dart
/// final db = UsdaDb();
/// await db.init();
///
/// final food = await db.queryFood(id: 167512);
/// final foods = await db.queryFoods(searchString: 'apple');
///
/// db.dispose();
/// ```
///
/// [init] takes an optional [FileService], which is how a test supplies data
/// without going through the asset bundle; the default reads the packaged
/// files.
class UsdaDb {
  /// Creates an empty database. Call [init] before querying it.
  UsdaDb();

  /// Assigned on every [init] call so a failed initialization can be retried.
  FileService _fileLoader = FileService();
  AutoCompleteData? _autoCompleteData;
  FoodsData? _foodsData;
  bool _isInitializing = false;

  /// Whether both data tables are loaded and the db can be queried.
  bool get isDataLoaded => _autoCompleteData != null && _foodsData != null;

  /// Returns true while [init] is running.
  bool get isInitializing => _isInitializing;

  /// Loads and parses both data files. Await this before querying.
  ///
  /// Any failure arrives as a [UsdaDbException] carrying the underlying error and
  /// its stack trace. Nothing is left half loaded: a failed call can simply be
  /// awaited again.
  Future<void> init({FileService? fileLoader}) async {
    _isInitializing = true;
    _fileLoader = fileLoader ?? FileService();
    try {
      await _loadData();
    } catch (e, st) {
      throw UsdaDbException(e.toString(), st);
    } finally {
      _isInitializing = false;
    }
  }

  /// Loads both files, discarding either if the other fails.
  Future<void> _loadData() async {
    try {
      await Future.wait(
        [
          _initAutocompleteData(),
          _initFoodsData(),
        ],
        eagerError: true,
      );
      dev.log('init() completed ', name: 'DB');
    } catch (e) {
      // All or none: a half-loaded db would answer some queries and not
      // others.
      dispose();
      rethrow;
    }
  }

  /// Drops both data tables. [init] can be called again afterwards.
  void dispose() {
    _foodsData?.clear();
    _autoCompleteData?.clear();
    _foodsData = null;
    _autoCompleteData = null;

    dev.log('dispose completed', name: 'DB');
  }

  /// Throws a [UsdaDbException] unless [init] has completed successfully.
  void _requireDataLoaded() {
    if (!isDataLoaded) {
      throw UsdaDbException('The DB has not been initialized properly!');
    }
  }

  /// The food with the USDA [id], or `null` if the database has no such food.
  Future<UsdaFoodModel?> queryFood({required int id}) async {
    _requireDataLoaded();
    return _foodsData!.queryFood(id);
  }

  /// The foods matching [searchString], empty if none do.
  ///
  /// [searchString] is split on whitespace and punctuation. With [all] set, a
  /// food has to match every word; with it clear, any one word is enough.
  ///
  /// An id the autocomplete index reports but the foods table does not hold is
  /// a data-integrity failure; it is logged and dropped rather than handed back
  /// to the caller as a `null` to trip over.
  Future<List<UsdaFoodModel>> queryFoods({
    required String searchString,
    bool all = true,
  }) async {
    _requireDataLoaded();
    final sanitizedWords = searchString.sanitizeSentence().toList();
    if (sanitizedWords.isEmpty) return [];

    final ids =
        all == true ? _getIdsAll(sanitizedWords) : _getIdsAny(sanitizedWords);

    if (ids.isEmpty) return [];

    final foodsData = _foodsData!;
    final foods = <UsdaFoodModel>[];
    for (final id in ids) {
      final food = foodsData.queryFood(id);
      if (food == null) {
        dev.log(
          'Autocomplete index references food id $id, '
          'which is missing from the foods table.',
          name: 'UsdaDb Package: UsdaDb.queryFoods()',
          error: 'Dangling food id $id',
        );
        continue;
      }
      foods.add(food);
    }
    return foods;
  }

  /// Food ids whose description contains every word in [sanitizedWords].
  Set<int> _getIdsAll(List<String> sanitizedWords) {
    if (sanitizedWords.isEmpty) {
      return {};
    }

    var ids =
        _autoCompleteData!.getFoodIndexes(substring: sanitizedWords[0]).toSet();

    if (sanitizedWords.length == 1) {
      return ids;
    }
    for (var i = 1; i < sanitizedWords.length; i++) {
      final term = sanitizedWords[i];
      final setTerm =
          _autoCompleteData!.getFoodIndexes(substring: term).toSet();
      ids = ids.intersection(setTerm);

      if (ids.isEmpty) {
        break;
      }
    }

    return ids;
  }

  /// Food ids whose description contains any word in [sanitizedWords].
  Set<int> _getIdsAny(List<String> sanitizedWords) {
    final ids = <int>{};
    for (final term in sanitizedWords) {
      ids.addAll(_autoCompleteData!.getFoodIndexes(substring: term));
    }
    return ids;
  }

  Future<void> _initAutocompleteData() async {
    final autoCompleteDataString = await _fileLoader.loadData(
      fileName: FileService.fileNameAutocompleteData,
    );
    _autoCompleteData = AutoCompleteData();

    await _autoCompleteData?.init(jsonString: autoCompleteDataString);
  }

  Future<void> _initFoodsData() async {
    final foodsString =
        await _fileLoader.loadData(fileName: FileService.fileNameFoods);
    _foodsData = FoodsData();

    await _foodsData?.init(jsonString: foodsString);
  }

  @override
  String toString() => isDataLoaded
      ? 'UsdaDb: ${_foodsData!.foodsList.length} foods from the USDA '
          'SR Legacy database, ready to search.'
      : 'UsdaDb: not initialized.';
}
