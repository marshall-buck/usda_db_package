import 'dart:async';
import 'dart:developer' as dev;

import '../src/models/models.dart';

import 'autocomplete_data.dart';
import 'exceptions.dart';
import 'file_service.dart';

import 'foods_data.dart';

import 'sanitizer.dart';

/// A class representing the USDA database.
///
/// This class is responsible for loading and managing the data in the database.
/// It provides methods for initializing the database, retrieving food items,
/// and performing autocomplete searches.
///
/// The database must be initialized by calling the [init] method before any other
/// operations can be performed. If the initialization fails, a [DBException] will be thrown.
///
/// The [isDataLoaded] property can be used to check
/// if the data has been loaded successfully. The [isInitializing] property can be used
/// to check if the database is currently being initialized.
///
/// Food items can be retrieved from the database using the [queryFood] method, which
/// takes an [int] as a parameter and returns the corresponding [FoodDTO] object.
///
/// Autocomplete searches can be performed using the [queryFoods] method,
/// which takes a search string as a parameter and returns a list of [FoodDTO] objects
/// that match the search string.
///
/// The [dispose] method can be used to clear all data properties and reset the database.
///
/// Example usage:
/// ```dart
/// final Future<UsdaDB> db = await  UsdaDB.init();
/// final Future<FoodModel?> food = await db.queryFood(id: 123);
/// final Future<List<FoodModel?>> foods = await db.queryFoods(searchString: 'apple');
/// await db.dispose();
/// ```
/// Note: The `UsdaDB` class requires the `FileService` class for loading data from files.
/// If no `FileService` instance is provided during initialization, a default instance will be used.

class UsdaDB {
  UsdaDB();
  late final FileService _fileLoader;
  AutoCompleteData? _autoCompleteData;
  FoodsData? _foodsData;
  final Sanitizer _sanitizer = Sanitizer();
  static bool _isInitializing = false;

  /// Returns false if either [_autoCompleteData] or [_foodsData] is null.
  bool get isDataLoaded => _autoCompleteData != null && _foodsData != null;

  /// Returns true while [init] is running.
  bool get isInitializing => _isInitializing;

  /// Initializes the [UsdaDB].
  ///
  /// This static method is used to initialize the class by loading the data
  /// and returning an instance of [UsdaDB].
  ///
  /// If an error occurs during the initialization process, a [DBException] is
  /// thrown with the error message and stack trace.
  Future<void> init({FileService? fileLoader}) async {
    _isInitializing = true;
    _fileLoader = fileLoader ?? FileService();
    try {
      await _loadData();
    } catch (e, st) {
      dev.log(
        'error',
        name: 'UsdaDB Package: UsdaDB.init()',
        error: e.toString(),
        stackTrace: st,
      );
      throw DBException(e.toString(), st);
    } finally {
      _isInitializing = false;
    }
  }

  /// Loads the from the files and initializes the [_autoCompleteData] and [_foodsData].
  ///
  /// Rethrows to [init] method if an error occurs.
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
      await // All or none of the data should be loaded.  If an error occurs.
          dispose();
      rethrow;
    }
  }

  /// Disposes the database by clearing all data properties.
  Future<void> dispose() async {
    _foodsData?.clear();
    _autoCompleteData?.clear();
    _foodsData = null;
    _autoCompleteData = null;

    dev.log('dispose completed', name: 'DB');
  }

  /// Retrieves a [FoodDTO] from the database based on its [id].
  ///
  /// Returns a [Future<FoodModel>] if found, otherwise returns `null`.
  Future<FoodDTO?> queryFood({required int id}) async {
    if (!isDataLoaded) {
      throw DBException('The DB has not been initialized! properly');
    }
    return _foodsData!.queryFood(id);
  }

  /// Returns a [List] of [FoodDTO] items based on a searchTerm.
  ///
  /// [all] determines whether the food description contains any word,
  ///  or must contain all words in the searchTerm.
  ///
  /// [List] will return empty if no matches are found.
  Future<List<FoodDTO?>> queryFoods({
    required String searchString,
    bool all = true,
  }) async {
    if (!isDataLoaded) {
      throw DBException('The DB has not been initialized! properly');
    }
    final sanitizedWords = _sanitizer.createSearchList(searchString);
    // print(sanitizedWords);
    if (sanitizedWords.isEmpty) return [];

    final ids =
        all == true ? _getIdsAll(sanitizedWords) : _getIdsAny(sanitizedWords);
    // print(ids);

    if (ids.isEmpty) return [];

    final foods = <FoodDTO?>[];
    for (final id in ids.toList()) {
      final food = await queryFood(id: id!);
      foods.add(food);
    }
    return foods;
  }

  /// Retrieves a set of foodIds whose descriptions must contain ALL the words in the
  /// list of [sanitizedWords]
  Set<int?> _getIdsAll(List<String> sanitizedWords) {
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

      // Early exit if intersection is empty
      if (ids.isEmpty) {
        break;
      }
    }

    return ids;
  }

  /// Retrieves a set of foodIds whose descriptions contain ANY of the words
  ///  in the list of [sanitizedWords], this list will be larger then the ALL.
  Set<int?> _getIdsAny(List<String> sanitizedWords) {
    final ids = <int?>{};
    for (final term in sanitizedWords) {
      ids.addAll(_autoCompleteData!.getFoodIndexes(substring: term));
    }
    return ids;
  }

  /// Initializes the autocomplete data by loading it from a file.
  Future<void> _initAutocompleteData() async {
    final autoCompleteDataString = await _fileLoader.loadData(
      fileName: FileService.fileNameAutocompleteData,
    );
    _autoCompleteData = AutoCompleteData();

    await _autoCompleteData?.init(jsonString: autoCompleteDataString);
  }

  /// Initializes the foods data by loading it from a file.
  Future<void> _initFoodsData() async {
    final substringHashRootString =
        await _fileLoader.loadData(fileName: FileService.fileNameFoods);
    _foodsData = FoodsData();

    await _foodsData?.init(jsonString: substringHashRootString);
  }

  @override
  String toString() => '''
            FoodsDb: There are ${_foodsData?.foodsList.length} food items
            ready to search in the USDA SR Legacy Database.
      ''';
}
