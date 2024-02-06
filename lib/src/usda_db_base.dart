import 'dart:developer' as dev;

import 'autocomplete_data.dart';
import 'exceptions.dart';
import 'file_service.dart';

import 'foods_data.dart';

import 'models/food_model.dart';
import 'sanitizer.dart';
import 'type_def.dart';

/// Class to handle the main database. This is the only class that should be
/// exposed to the user.  All searching and data retrieval should be done through
/// this class.
///
/// An optional [fileLoader] can be passed to the constructor.  This is useful
/// for testing purposes.  If no [fileLoader] is passed, the default [FileService]
/// will be used.
///
/// The initialization of the database is done by calling the [init] method.
///
/// Example:
/// ```dart
/// final db = DB();
/// await db.init();
/// ```

/// It is suggested to use the class as some sort of singleton, perhaps using
/// a package like get_it.
class UsdaDB {
  FileService fileLoader;
  AutoCompleteData? _autoCompleteData;
  FoodsData? _foodsData;
  final Sanitizer _sanitizer = Sanitizer();

  UsdaDB({FileService? fileLoader}) : fileLoader = fileLoader ?? FileService();

  /// Must be run to populate the database.
  /// Will throw a [DBException] if either the foods or autocomplete data
  /// fails to load. If an error occurs the database properties
  /// will be disposed of and will need to be re-initialized.
  @override
  Future<void> init() async {
    try {
      await Future.wait(
        [_initAutocompleteData(), _initFoodsData()],
        eagerError: true,
      );
      dev.log('init() completed ', name: 'DB');
    } catch (e, st) {
      // All or none of the data should be loaded.  If an error occurs.
      dispose();

      dev.log('init() error', name: 'DB', error: e.toString(), stackTrace: st);
      throw DBException(e.toString(), st);
    }
  }

  /// Helper method to check if the database has been initialized.
  bool get isDataLoaded => _autoCompleteData != null && _foodsData != null;

  /// Sets all data properties to null.
  void dispose() {
    _foodsData?.clear();
    _autoCompleteData?.clear();
    _foodsData = null;
    _autoCompleteData = null;

    dev.log('dispose completed', name: 'DB');
  }

  /// Gets one food item from database and returns the [FoodModel] or [null] if not found.
  FoodModel? getFood(int id) => _foodsData?.getFood(id);

  /// Returns a list of [DescriptionRecord]'s that match the [searchString].
  Future<List<DescriptionRecord?>> getAutocompleteResults(
      String searchString) async {
    if (!isDataLoaded) {
      throw DBException('The DB has not been initialized! properly');
    }
    final sanitizedWords = _sanitizer.sanitizedWords(searchString);

    if (sanitizedWords.isEmpty) return [];

    Set<int?> ids = _getIds(sanitizedWords);

    final descriptions = _getDescriptions(ids);
    descriptions.sort((a, b) => a!.$2.compareTo(b!.$2));

    return descriptions;
  }

  /// Returns a [Set] of food ids that match the [sanitizedWords].
  Set<int?> _getIds(List<String> sanitizedWords) {
    Set<int?> ids = {};
    for (final term in sanitizedWords) {
      ids.addAll(_autoCompleteData!.getFoodIndexes(substring: term));
    }
    return ids;
  }

  /// Returns a [List] of [DescriptionRecord]'s that match the [ids].
  List<DescriptionRecord?> _getDescriptions(Set<int?> ids) {
    List<DescriptionRecord?> descriptions = [];
    for (final id in ids.toList()) {
      final food = getFood(id!);
      descriptions.add(_createDescriptionRecord(food!));
    }
    return descriptions;
  }

  /// Helper function to create a [DescriptionRecord] from a [food] item.
  DescriptionRecord _createDescriptionRecord(FoodModel food) {
    dev.log('_createDescription', name: 'DB');
    return (food.description, food.description.length, food.id);
  }

  Future<void> _initAutocompleteData() async {
    final autoCompleteDataString = await fileLoader.loadData(
        fileName: FileService.fileNameAutocompleteData);
    _autoCompleteData = AutoCompleteData();

    await _autoCompleteData?.init(jsonString: autoCompleteDataString);
  }

  Future<void> _initFoodsData() async {
    final substringHashRootString =
        await fileLoader.loadData(fileName: FileService.fileNameFoods);
    _foodsData = FoodsData();

    await _foodsData?.init(jsonString: substringHashRootString);
  }

  @override
  String toString() =>
      'FoodsDb: ${_foodsData?.foodsList.length} should be a number';
}
