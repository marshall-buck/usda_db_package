import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/file_paths.dart';
import 'package:usda_db/src/food_model.dart';
import 'package:usda_db/src/foods.dart';
import 'package:usda_db/src/prefix_tree.dart';
import 'package:usda_db/src/word_index.dart';
import 'dart:developer' as dev;

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

  ///PUBLIC FUNCTIONS
  /// Gets one food from database and returns the FoodModel.
  FoodModel? getFood(String index) {
    if (_foods != null) {
      return _foods?.getFood(index);
    }
    throw DBException('The FoodsDB has not been initialized!');
  }

  List getDescriptions(String term) {
    final words = _findAllWords(term);
    final indexes = _findAllIndexes(words);
    final foods = _findAllFoods(indexes);
    final descriptions = _getDescriptions(foods);
    return descriptions;
  }

  _findAllWords(String term) {}

  Future<Set<String>> _findAllIndexes(List<String> words) async {
    if (_wordIndex != null) {
      return await _wordIndex!.getIndexes(words);
    }
    throw DBException('The FoodsDB has not been initialized!');
  }

  Future<List<(String, num, String)>> _findAllFoods(indexes) async {
    final List<(String, num, String)> out = [];
    for (final index in indexes) {
      final food = getFood(index);
      if (food != null) {
        out.add(_createDescription(food));
      }
    }
    return out;
  }

  _getDescriptions(foods) {}

  (String, num, String) _createDescription(FoodModel food) =>
      (food.description, food.descriptionLength, food.id);
}

class DBException implements Exception {
  String errorMessage;
  StackTrace? stackTrace;
  DBException(this.errorMessage, [this.stackTrace]);

  @override
  String toString() {
    return 'DBException: $errorMessage\n$stackTrace';
  }
}
