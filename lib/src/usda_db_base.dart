import 'dart:developer' as dev;

import 'package:usda_db_package/src/file_loader_service.dart';
import 'package:usda_db_package/src/file_paths.dart';
import 'package:usda_db_package/src/foods.dart';
// import 'package:usda_db_package/src/prefix_tree.dart';
import 'package:usda_db_package/src/substring_hash.dart';

// import 'package:usda_db_package/src/word_index.dart';
import 'package:usda_db_package/usda_db_package.dart';

class DB {
  FileLoaderService fileLoader;
  static final DB _singleton = DB._internal();

  DB._internal({FileLoaderService? fileLoader})
      : fileLoader = fileLoader ??
            FileLoaderService(); // Use the provided fileLoader or the default

  factory DB({FileLoaderService? fileLoader}) {
    _singleton.fileLoader = fileLoader ??
        FileLoaderService(); // Use the provided fileLoader or the default
    return _singleton;
  }
  // static PrefixTree? _prefixTree;
  static SubStringHash? _substringHash;
  // static WordIndex? _wordIndex;
  static Foods? _foods;

  /// Initialization Methods.
  // Future<void> _initTree() async => await _prefixTree!.init(pathToTree);
  Future<void> _initSubstringHash() async =>
      await _substringHash!.init(pathToWordIndex);
  Future<void> _initFoods() async => await _foods!.init(pathToFoods);

  /// Must be run to populate the database.
  Future<void> init() async {
    try {
      // _prefixTree = PrefixTree(fileLoader);
      _substringHash = SubStringHash(fileLoader);
      _foods = Foods(fileLoader);
      await Future.wait([
        // _initTree(),
        _initSubstringHash(),
        _initFoods(),
      ], eagerError: true);
      dev.log('init() completed ', name: 'DB');
    } catch (e, st) {
      dev.log('init() error', name: 'DB', error: e.toString(), stackTrace: st);
      throw DBException(e.toString(), st);
    }
  }

  /// Call this method before disposing Consumer.
  void dispose() {
    // if (_prefixTree != null) {
    //   _prefixTree!.dispose();
    //   _prefixTree = null;
    // }
    if (_foods != null) {
      _foods!.dispose();
      _foods = null;
    }
    if (_substringHash != null) {
      _substringHash!.dispose();
      _substringHash = null;
    }

    dev.log('dispose completed', name: 'DB');
  }

  /// Gets one food from database and returns the [FoodModel].
  FoodModel? getFood(String index) {
    if (_foods == null) {
      throw DBException('The DB has not been initialized properly!');
    }
    return _foods!.getFood(index);
  }

  /// Use to return a list of food descriptions from search term.
  /// Return List may be empty
  Future<List<SearchResultRecord>> getDescriptions(String term) async {
    if (_substringHash == null || _foods == null) {
      throw DBException('The DB has not been initialized! properly');
    }

    final List<String?> indexes = await _findAllIndexes(term);
    final List<FoodModel?> foods = await _findAllFoods(indexes);
    final List<SearchResultRecord> descriptions =
        await _createSearchResultRecords(foods);
    return descriptions;
  }

  /// Finds all words for a search term.
  // Future<List<String?>> _findAllWords(String term) async {
  //   dev.log('_findAllWords', name: 'DB');
  //   if (_prefixTree == null) {
  //     throw DBException('The DB has not been initialized! properly');
  //   }
  //   return _prefixTree!.searchByPrefix(term);
  // }

  /// Return all indexes for a list of words.
  Future<List<String>> _findAllIndexes(String term) async {
    dev.log('_findAllIndexes', name: 'DB');
    final int hash = await _substringHash!.getHashLookup(term);
    if (hash == -1) return [];

    return await _substringHash!.getIndexes(hash);
  }

  /// Finds all foods from a list of indexes
  Future<List<FoodModel?>> _findAllFoods(List<String?> indexes) async {
    dev.log('_findAllFoods', name: 'DB');
    final List<FoodModel?> out = [];
    for (final index in indexes) {
      final food = getFood(index ?? '');
      if (food != null) {
        out.add(food);
      }
    }
    return out;
  }

  Future<List<SearchResultRecord>> _createSearchResultRecords(
      List<FoodModel?> foods) async {
    dev.log('_createDescriptions', name: 'DB');
    if (foods.isEmpty) return [];
    final List<SearchResultRecord> out =
        foods.map((food) => _createSearchResultRecord(food!)).toList();

    out.sort((a, b) => a.$2.compareTo(b.$2));
    return out;
  }

  /// Helper function to create a [SearchResultRecord] for the food description
  SearchResultRecord _createSearchResultRecord(FoodModel food) {
    dev.log('_createDescription', name: 'DB');
    return (food.description, food.descriptionLength, food.id);
  }

  @override
  String toString() =>
      'FoodsDb: ${_foods?.foodsList?.length} should be a number';
}
