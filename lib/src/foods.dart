import 'dart:convert';
import 'dart:math';

import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/food_model.dart';
import 'dart:developer' as dev;

class Foods {
  FileLoaderService fileLoader;
  Map<String, FoodModel>? _foodsList;
  Map<String, FoodModel>? get foodsList => _foodsList;

  static final Foods _singleton = Foods._internal();
  Foods._internal() : fileLoader = FileLoaderService();
  factory Foods(FileLoaderService fileLoader) {
    _singleton.fileLoader = fileLoader;
    return _singleton;
  }

  /// Initializes the instance
  ///
  /// Parameters:
  /// - [path] The path of the  file.

  Future<void> init(String path) async {
    Map<String, FoodModel> dbMap = await _loadData(path);
    _foodsList = dbMap;

    dev.log('init()',
        name:
            'Foods -  ${_foodsList != null ? "success" : "foodList is null"}');
  }

  /// Dispose foodsList
  void dispose() => _foodsList = null;

  FoodModel? getFood(String index) => _foodsList?[index];

  /// Opens the  file.
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  ///
  /// Returns a [Map] of the file, or {}, on error.
  Future<Map<String, FoodModel>> _loadData(String path) async {
    final String response = await fileLoader.loadData(path);
    Map<String, dynamic> jsonMap = await json.decode(response);

    return _convertJsonMapTypes(jsonMap);
  }

  /// Converts a Map<String, dynamic> to Map<String, List<String>>.
  Map<String, FoodModel> _convertJsonMapTypes(Map<String, dynamic> jsonMap) {
    Map<String, FoodModel> convertedMap = jsonMap.map((key, value) {
      // print('$key, $value');
      FoodModel convertedValue = FoodModel(
        id: key,
        description: value['description'],
        descriptionLength: value['descriptionLength'],
        protein: max(value['Protein'] ?? 0, 0),
        dietaryFiber: max(value['Dietary Fiber'] ?? 0, 0),
        satFat: max(value['Saturated Fat'] ?? 0, 0),
        totCarb: max(value['Total Carbs'] ?? 0, 0),
        totFat: max(value['Total Fat'] ?? 0, 0),
        calories: max(value['Calories'] ?? 0, 0),
        totSugars: max(value['Total Sugars'] ?? 0, 0),
      );
      return MapEntry(key, convertedValue);
    });
    return convertedMap;
  }
}
