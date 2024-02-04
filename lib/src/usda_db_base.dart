import 'dart:developer' as dev;

import 'package:usda_db_package/src/autocomplete_data.dart';

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

  /// Gets one food item from database and returns the [FoodModel].
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

  // Future<List<SearchResultRecord>> getDescriptions(String term) async {
  //   if (_substringHash == null || _foods == null) {
  //     throw DBException('The DB has not been initialized! properly');
  //   }

  //   final List<String?> indexes = await _findAllIndexes(term);
  //   final List<FoodModel?> foods = await _findAllFoods(indexes);
  //   final List<SearchResultRecord> descriptions =
  //       await _createSearchResultRecords(foods);
  //   return descriptions;
  // }

  List<String> _intersectAll(List<Set<String>> sets) {
    // If there are no sets, return an empty list
    if (sets.isEmpty) return [];

    // Start with the first set as the initial intersection
    Set<String> intersection = sets.first;

    // Iterate over the rest of the sets and update the intersection
    for (var set in sets.skip(1)) {
      intersection = intersection.intersection(set);
    }

    // Return the intersection as a list
    return intersection.toList();
  }

  /// Return all indexes for a list of hashes.
  // List<String> _findAllIndexes(List<int> hashes) {
  //   dev.log('_findAllIndexes', name: 'DB');
  //   List<Set<String>> indexes = [];
  //   for (final hash in hashes) {
  //     final index = _substringHash!.getIndexes(hash).toSet();
  //     if (index.isNotEmpty) {
  //       indexes.add(index);
  //     }
  //   }

  //   return _intersectAll(indexes);
  // }

  // List<int> _findAllHashes(List<String> words) {
  //   Set<int> hashes = {};
  //   for (final word in words) {
  //     final hash = _substringHash!.getHashLookup(word);
  //     if (hash != -1) {
  //       hashes.add(hash);
  //     }
  //   }
  //   return hashes.toList();
  // }

  /// Finds all foods from a list of indexes
  // Future<List<FoodModel?>> _findAllFoods(List<String?> indexes) async {
  //   dev.log('_findAllFoods', name: 'DB');
  //   final List<FoodModel?> out = [];
  //   for (final index in indexes) {
  //     final food = getFood(index ?? '');
  //     if (food != null) {
  //       out.add(food);
  //     }
  //   }
  //   return out;
  // }

  /// Helper function to create a list of [DescriptionRecord] from a list of [FoodModel]'s.
  List<DescriptionRecord?> _createDescriptionRecords(List<FoodModel?> foods) {
    dev.log('_createDescriptions', name: 'DB');
    // if (foods.isEmpty) return [];
    // final List<DescriptionRecord> descriptionsList =
    //     foods.map((food) => _createDescriptionRecord(food!)).toList();

    // descriptionsList.sort((a, b) => a.$2.compareTo(b.$2));
    // return descriptionsList;

    return foods.isEmpty
        ? []
        : foods.map((food) => _createDescriptionRecord(food!)).toList()
      ..sort((a, b) => a!.$2.compareTo(b!.$2));
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
