import 'dart:convert';
import 'dart:developer' as dev;

import 'file_service.dart';
import 'food_model.dart';

/// Class to handle the main foods database.
class Foods {
  FileService fileLoader;
  final Map<String, FoodModel> _foodsList = {};
  Map<String, FoodModel> get foodsList => _foodsList;

  Foods(this.fileLoader);

  /// Initializes the instance
  ///
  /// Parameters:
  /// - [path] The path of the  file.

  Future<void> init(String path) async {
    // Map<String, FoodModel> dbMap = await _loadData(path);
    // _foodsList = dbMap;

    dev.log('init()',
        name:
            'Foods -  ${_foodsList.isEmpty ? "success" : "foodList is null"}');
  }

  /// Dispose foodsList
  void dispose() => _foodsList.clear();

  FoodModel? getFood(String index) => _foodsList[index];

  /// Opens the  file.
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  ///
  /// Returns a [Map] of the file, or {}, on error.
  Future<Map<String, FoodModel>> _loadData(String path) async {
    final String response =
        await fileLoader.loadData(fileName: FileService.fileNameFoods);
    Map<String, dynamic> jsonMap = await json.decode(response);

    return _convertJsonMapTypes(jsonMap);
  }

  // Converts a Map<String, dynamic> to Map<String, List<String>>.
  Map<String, FoodModel> _convertJsonMapTypes(Map<String, dynamic> jsonMap) {
    throw UnimplementedError();
    // Map<String, FoodModel> convertedMap = jsonMap.map((key, value) {
    //   // print('$key, $value');
    //   FoodModel convertedValue = FoodModel(
    //     id: key,
    //     description: value['description'],
    //     descriptionLength: value['descriptionLength'],
    //     protein: max(value['Protein'] ?? 0, 0),
    //     dietaryFiber: max(value['Dietary Fiber'] ?? 0, 0),
    //     satFat: max(value['Saturated Fat'] ?? 0, 0),
    //     totCarb: max(value['Total Carbs'] ?? 0, 0),
    //     totFat: max(value['Total Fat'] ?? 0, 0),
    //     calories: max(value['Calories'] ?? 0, 0),
    //     totSugars: max(value['Total Sugars'] ?? 0, 0),
    //   );
    //   return MapEntry(key, convertedValue);
    // });
    // return convertedMap;
  }
}
