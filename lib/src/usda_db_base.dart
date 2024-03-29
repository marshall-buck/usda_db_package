import 'dart:developer' as dev;

import 'autocomplete_data.dart';
import 'exceptions.dart';
import 'file_service.dart';

import 'foods_data.dart';

import 'models/food_model.dart';
import 'sanitizer.dart';
import 'type_def.dart';

/// A class representing the USDA database.
///
/// This class is responsible for loading and managing the data in the database.
/// It provides methods for initializing the database, retrieving food items,
/// and performing autocomplete searches.
///
/// The database must be initialized by calling the [init] method before any other
/// operations can be performed. If the initialization fails, a [DBException] will be thrown
/// and the database properties will be disposed of. To re-initialize the database,
/// the [init] method must be called again.
///
/// Once the database is initialized, the [isDataLoaded] property can be used to check
/// if the data has been loaded successfully. The [isInitializing] property can be used
/// to check if the database is currently being initialized.
///
/// Food items can be retrieved from the database using the [queryFoods] method, which
/// takes an ID as a parameter and returns the corresponding [FoodModel] object.
///
/// Autocomplete searches can be performed using the [queryFoodDescriptions] method,
/// which takes a search string as a parameter and returns a list of [DescriptionRecord] objects
/// that match the search string.
///
/// The [dispose] method can be used to clear all data properties and reset the database.
///
/// Example usage:
/// ```dart
/// final usdaDB = UsdaDB().init();

/// final food = usdaDB.getFood(1);
/// final autocompleteResults = await usdaDB.getAutocompleteResults('apple');
/// usdaDB.dispose();
/// ```
/// Note: The `UsdaDB` class requires the `FileService` class for loading data from files.
/// If no `FileService` instance is provided during initialization, a default instance will be used.
///
/// See also:
/// - [DescriptionRecord], a typedef representing a record in the autocomplete search results.

class UsdaDB {
  final FileService _fileLoader;
  AutoCompleteData? _autoCompleteData;
  FoodsData? _foodsData;
  final Sanitizer _sanitizer = Sanitizer();
  static bool _isInitializing = false;

  UsdaDB._(this._fileLoader);

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
  static Future<UsdaDB> init({FileService? fileLoader}) async {
    _isInitializing = true;
    final instance = UsdaDB._(fileLoader ?? FileService());
    try {
      await instance._loadData();
      return instance;
    } catch (e, st) {
      dev.log('create() error',
          name: 'DB', error: e.toString(), stackTrace: st);
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
        [_initAutocompleteData(), _initFoodsData()],
        eagerError: true,
      );
      dev.log('init() completed ', name: 'DB');
    } catch (e) {
      // All or none of the data should be loaded.  If an error occurs.
      dispose();
      rethrow;
    }
  }

  /// Disposes the database by clearing all data properties.
  void dispose() {
    _foodsData?.clear();
    _autoCompleteData?.clear();
    _foodsData = null;
    _autoCompleteData = null;

    dev.log('dispose completed', name: 'DB');
  }

  /// Retrieves a [FoodModel] from the database based on its [id].
  ///
  /// Returns a [Future<FoodModel>] if found, otherwise returns `null`.
  Future<FoodModel?> queryFoods(int id) async {
    if (!isDataLoaded) {
      throw DBException('The DB has not been initialized! properly');
    }
    return _foodsData!.getFood(id);
  }

  /// Retrieves a list of [DescriptionRecord]s that match the given [searchString].
  ///
  /// Throws a [DBException] if the database has not been properly initialized.
  Future<List<DescriptionRecord?>> queryFoodDescriptions(
      String searchString) async {
    if (!isDataLoaded) {
      throw DBException('The DB has not been initialized! properly');
    }
    final sanitizedWords = _sanitizer.sanitizedWords(searchString);

    if (sanitizedWords.isEmpty) return [];

    Set<int?> ids = _getIds(sanitizedWords);

    final descriptions = await _getDescriptions(ids);
    descriptions.sort((a, b) => a!.$2.compareTo(b!.$2));

    return descriptions;
  }

  /// Retrieves a set of food ids that match the given [sanitizedWords].
  Set<int?> _getIds(List<String> sanitizedWords) {
    Set<int?> ids = {};
    for (final term in sanitizedWords) {
      ids.addAll(_autoCompleteData!.getFoodIndexes(substring: term));
    }
    return ids;
  }

  /// Retrieves a list of [DescriptionRecord]s that match the given [ids].
  Future<List<DescriptionRecord?>> _getDescriptions(Set<int?> ids) async {
    List<DescriptionRecord?> descriptions = [];
    for (final id in ids.toList()) {
      final food = await queryFoods(id!);
      descriptions.add(_createDescriptionRecord(food!));
    }
    return descriptions;
  }

  /// Creates a [DescriptionRecord] from a [food] item.
  DescriptionRecord _createDescriptionRecord(FoodModel food) {
    dev.log('_createDescription', name: 'DB');
    return (food.description, food.description.length, food.id);
  }

  /// Initializes the autocomplete data by loading it from a file.
  Future<void> _initAutocompleteData() async {
    final autoCompleteDataString = await _fileLoader.loadData(
        fileName: FileService.fileNameAutocompleteData);
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
  String toString() =>
      'FoodsDb: ${_foodsData?.foodsList.length} should be a number';
}
