import 'dart:developer' as dev;

import 'package:usda_db_package/src/file_loader_service.dart';
import 'package:usda_db_package/src/file_paths.dart';
import 'package:usda_db_package/src/foods.dart';
import 'package:usda_db_package/src/prefix_tree.dart';
import 'package:usda_db_package/src/word_index.dart';
import 'package:usda_db_package/usda_db.dart';

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
  static PrefixTree? _prefixTree;
  static WordIndex? _wordIndex;
  static Foods? _foods;

  /// Must be run to populate the database.
  Future<void> init() async {
    try {
      _prefixTree = PrefixTree(fileLoader);
      _wordIndex = WordIndex(fileLoader);
      _foods = Foods(fileLoader);
      await Future.wait([
        _initTree(),
        _initWordIndex(),
        _initFoods(),
      ], eagerError: true);
      dev.log('init() completed ', name: 'DB');
    } catch (e, st) {
      dev.log('init() error', name: 'DB', error: e, stackTrace: st);
      throw DBException(e.toString(), st);
    }
  }

  /// Call this method before disposing Consumer.
  void dispose() {
    if (_prefixTree != null) {
      _prefixTree!.dispose();
      _prefixTree = null;
    }
    if (_foods != null) {
      _foods!.dispose();
      _foods = null;
    }
    if (_wordIndex != null) {
      _wordIndex!.dispose();
      _wordIndex = null;
    }

    dev.log('dispose completed', name: 'DB');
  }

  Future<void> _initTree() async => await _prefixTree!.init(pathToTree);

  Future<void> _initWordIndex() async =>
      await _wordIndex!.init(pathToWordIndex);

  Future<void> _initFoods() async => await _foods!.init(pathToFoods);

  /// Gets one food from database and returns the FoodModel.
  FoodModel? getFood(String index) {
    if (_foods != null) {
      return _foods?.getFood(index);
    }
    throw DBException('The DB has not been initialized! properly');
  }

  /// Use to return a list of food descriptions from search term.
  ///
  ///Returns (description, length, id).
  Future<List<(String, num, String)?>> getDescriptions(String term) async {
    final List<String?> words = await _findAllWords(term);
    final Set<String?> indexes = await _findAllIndexes(words);
    final List<FoodModel?> foods = await _findAllFoods(indexes);
    final List<(String, num, String)?> descriptions =
        await _createDescriptions(foods);
    return descriptions;
  }

  /// Finds all words for a search term.
  Future<List<String?>> _findAllWords(String term) async {
    dev.log('_findAllWords', name: 'DB');
    if (_prefixTree != null) {
      return _prefixTree!.searchByPrefix(term);
    }
    throw DBException('The DB has not been initialized! properly');
  }

  /// Finds all indexes for a list of words.
  Future<Set<String?>> _findAllIndexes(List<String?> words) async {
    dev.log('_findAllIndexes', name: 'DB');
    if (_wordIndex != null) {
      return await _wordIndex!.getIndexes(words);
    }
    throw DBException('The DB has not been initialized! properly');
  }

  /// Finds all foods from a list of indexes
  Future<List<FoodModel?>> _findAllFoods(Set<String?> indexes) async {
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

  Future<List<(String, num, String)?>> _createDescriptions(
      List<FoodModel?> foods) async {
    dev.log('_createDescriptions', name: 'DB');
    final List<(String, num, String)> out = [];
    for (final food in foods) {
      if (food != null) {
        out.add(_createDescription(food));
      }
    }
    return out;
  }

  /// Helper function to create a Record for the food description
  (String, num, String) _createDescription(FoodModel food) {
    dev.log('_createDescription', name: 'DB');
    return (food.description, food.descriptionLength, food.id);
  }
}

class DBException implements Exception {
  String errorMessage;
  StackTrace? stackTrace;
  DBException(this.errorMessage, [this.stackTrace]);
}
