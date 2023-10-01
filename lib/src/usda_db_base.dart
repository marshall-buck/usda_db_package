import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/file_paths.dart';
import 'package:usda_db/src/food_model.dart';
import 'package:usda_db/src/foods.dart';
import 'package:usda_db/src/prefix_tree.dart';
import 'package:usda_db/src/word_index.dart';

class DB {
  // FileLoaderService fileLoader;
  // static final DB _singleton = DB._internal();

  // DB._internal() : fileLoader = FileLoaderService();
  // factory DB(FileLoaderService fileLoader) {
  //   _singleton.fileLoader = fileLoader;
  //   return _singleton;
  // }

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
    _prefixTree = PrefixTree(fileLoader);
    _wordIndex = WordIndex(fileLoader);
    _foods = Foods(fileLoader);
    try {
      await Future.wait([
        _initTree(),
        _initWordIndex(),
        _initFoods(),
      ], eagerError: true);
    } catch (e, st) {
      throw DBException(e.toString(), st);
    }
  }

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
  }

  /// Gets one food from database and returns the FoodModel.
  Future<FoodModel?> getFood(String index) async {
    if (_foods != null) {
      return _foods?.getFood(index);
    }
    return Future.error('The FoodsDB has not been initialized!');
  }

  Future<void> _initTree() async => await _prefixTree!.init(pathToTree);

  Future<void> _initWordIndex() async =>
      await _wordIndex!.init(pathToWordIndex);

  Future<void> _initFoods() async => await _foods!.init(pathToFoods);
}

class DBException implements Exception {
  String errorMessage;
  StackTrace stackTrace;
  DBException(this.errorMessage, this.stackTrace);

  @override
  String toString() {
    return 'DBException: $errorMessage\n$stackTrace';
  }
}
