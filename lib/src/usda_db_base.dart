import 'dart:developer' as dev;

import 'package:usda_db_package/src/autocomplete_data.dart';
import 'package:usda_db_package/src/sanitizer.dart';

import 'exceptions.dart';
import 'file_service.dart';

import 'foods_data.dart';

import 'models/food_model.dart';
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
class DB {
  FileService fileLoader;
  AutoCompleteData? _autoCompleteData;
  FoodsData? _foodsData;
  Sanitizer? _sanitizer;

  DB({FileService? fileLoader}) : fileLoader = fileLoader ?? FileService();

  /// Must be run to populate the database.
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

  /// Call this method before disposing Consumer.
  void dispose() {
    _foodsData?.clear();
    _autoCompleteData?.clear();
    _foodsData = null;
    _autoCompleteData = null;

    dev.log('dispose completed', name: 'DB');
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

  /// Gets one food item from database and returns the [FoodModel] or [null] if not found.
  FoodModel? getFood(int index) => _foodsData?.getFood(index);

// TODO: Change to look for multiple terms
// - sanitize sentence int list of strings
// - for each word in list get set of indexes
// - find intersections of all sets.

// sanitize sentence into a list of searchable words
  /// Use to return a list of food descriptions from search term.
  /// Return List may be empty
  // Future<List<SearchResultRecord>> getDescriptions(String sentence) async {
  //   if (_substringHash == null || _foods == null) {
  //     throw DBException('The DB has not been initialized! properly');
  //   }
  //   final listOfWords = cleanSentence(sentence).toList(growable: false);
  //   if (listOfWords.isEmpty) return [];
  //   final hashes = _findAllHashes(listOfWords);
  //   if (listOfWords.isEmpty) return [];
  //   final indexes = _findAllIndexes(hashes);
  //   if (indexes.isEmpty) return [];
  //   final List<FoodModel?> foods = await _findAllFoods(indexes);
  //   if (foods.isEmpty) return [];
  //   final List<SearchResultRecord> descriptions =
  //       await _createSearchResultRecords(foods);
  //   return descriptions;
  // }

  List<DescriptionRecord?> getAutocompleteList(String searchString) {
    if (!isDataLoaded) {
      throw DBException('The DB has not been initialized! properly');
    }
    _sanitizer = Sanitizer(sentence: searchString);
    if (_sanitizer!.sanitizedWords.isEmpty) return [];
    final termsToSearch = _sanitizer!.sanitizedWords;
    Set<int?> ids = {};
    List<DescriptionRecord?> descriptions = [];
    // iterate through each word and get a list of indexes
    for (final term in termsToSearch) {
      ids.addAll(_autoCompleteData!.getFoodIndexes(substring: term));
    }
    for (final id in ids.toList()) {
      final food = getFood(id!);
      descriptions.add(_createDescriptionRecord(food!));
    }
    descriptions.sort((a, b) => a!.$2.compareTo(b!.$2));
    return descriptions;
  }

  /// Helper function to create a [DescriptionRecord] from a [food] item.
  DescriptionRecord _createDescriptionRecord(FoodModel food) {
    dev.log('_createDescription', name: 'DB');
    return (food.description, food.description.length, food.id);
  }

  @override
  String toString() =>
      'FoodsDb: ${_foodsData?.foodsList.length} should be a number';
}
