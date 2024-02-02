import 'dart:convert';
import 'dart:developer' as dev;

import 'initializer.dart';
import 'models/food_model.dart';
import 'models/nutrient_model.dart';

/// Class to handle the main foods database.
class Foods implements Initializer {
  final Map<int, FoodModel> _foodsList = {};
  Map<int, FoodModel> get foodsList => _foodsList;

  /// Initializes the instance
  ///
  /// Parameters:
  /// - [path] The path of the  file.

  @override
  Future<void> init({required String jsonString}) async {
    try {
      final Map<String, dynamic> jsonMap = await jsonDecode(jsonString);
      _convertJsonMapTypes(jsonMap);
    } catch (e, st) {
      dev.log('Error decoding JSON',
          name: 'Foods', error: e.toString(), stackTrace: st);
      throw const FormatException('Error decoding JSON');
    }
  }

  /// Dispose foodsList
  void clearFoods() => _foodsList.clear();

  FoodModel? getFood(int index) => _foodsList[index];

  // Converts a Map<String, dynamic> to Map<String, List<String>>.
  void _convertJsonMapTypes(Map<String, dynamic> jsonMap) {
    Map<int, FoodModel> convertedMap = jsonMap.map((key, value) {
      // print('$key, $value');
      FoodModel convertedValue = FoodModel(
        id: int.parse(key),
        description: value['description'],
        nutrients: List<Nutrient>.from(value['nutrients']),
      );
      return MapEntry(convertedValue.id, convertedValue);
    });
    _foodsList.addAll(convertedMap);
  }
}
