import 'dart:developer' as dev;

import 'package:usda_db_package/src/autocomplete_data.dart';

import 'exceptions.dart';
import 'file_service.dart';

import 'foods.dart';

import 'type_def.dart';

class DB {
  FileService fileLoader;
  AutoCompleteData? _autoCompleteData;
  Foods? _foods;

  DB({FileService? fileLoader}) : fileLoader = fileLoader ?? FileService();

  // Initialization Methods.

  /// Must be run to populate the database.
  // Future<void> init() async {
  //   try {
  //     _substringHash = SubStringHash(fileLoader);
  //     _foods = Foods(fileLoader);
  //     await Future.wait([
  //       _initSubstringHash(),
  //       _initFoods(),
  //     ], eagerError: true);
  //     dev.log('init() completed ', name: 'DB');
  //   } catch (e, st) {
  //     dev.log('init() error', name: 'DB', error: e.toString(), stackTrace: st);
  //     throw DBException(e.toString(), st);
  //   }
  // }

  // Future<void> _initSubstringHash() async =>
  //     await _substringHash!.init(pathToSubstringHash);
  // Future<void> _initFoods() async => await _foods!.init(pathToFoods);

  /// Call this method before disposing Consumer.
  void dispose() {
    _foods?.clear();
    _autoCompleteData?.clear();
    _foods = null;

    dev.log('dispose completed', name: 'DB');
  }

  /// Gets one food from database and returns the [FoodModel].
  // FoodModel? getFood(String index) {
  //   if (_foods == null) {
  //     throw DBException('The DB has not been initialized properly!');
  //   }
  //   return _foods!.getFood(index);
  // }
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
  List<String> _findAllIndexes(List<int> hashes) {
    dev.log('_findAllIndexes', name: 'DB');
    List<Set<String>> indexes = [];
    for (final hash in hashes) {
      final index = _substringHash!.getIndexes(hash).toSet();
      if (index.isNotEmpty) {
        indexes.add(index);
      }
    }

    return _intersectAll(indexes);
  }

  List<int> _findAllHashes(List<String> words) {
    Set<int> hashes = {};
    for (final word in words) {
      final hash = _substringHash!.getHashLookup(word);
      if (hash != -1) {
        hashes.add(hash);
      }
    }
    return hashes.toList();
  }

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

  // Future<List<SearchResultRecord>> _createSearchResultRecords(
  //     List<FoodModel?> foods) async {
  //   dev.log('_createDescriptions', name: 'DB');
  //   if (foods.isEmpty) return [];
  //   final List<SearchResultRecord> out =
  //       foods.map((food) => _createSearchResultRecord(food!)).toList();

  //   out.sort((a, b) => a.$2.compareTo(b.$2));
  //   return out;
  // }

  // /// Helper function to create a [SearchResultRecord] for the food description
  // SearchResultRecord _createSearchResultRecord(FoodModel food) {
  //   dev.log('_createDescription', name: 'DB');
  //   return (food.description, food.descriptionLength, food.id);
  // }

  @override
  String toString() =>
      'FoodsDb: ${_foods?.foodsList?.length} should be a number';
}
