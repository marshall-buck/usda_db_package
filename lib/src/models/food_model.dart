import 'package:freezed_annotation/freezed_annotation.dart';

import 'nutrient_model.dart';

part 'food_model.freezed.dart';

@freezed
class SrLegacyFoodModel with _$SrLegacyFoodModel {
  const factory SrLegacyFoodModel(
          {required final int id,
          required final String description,
          required final List<SrLegacyNutrientModel> nutrients}) =
      _SrLegacyFoodModel;

  const SrLegacyFoodModel._();

  factory SrLegacyFoodModel.fromJson(
      {required final Map<String, dynamic> jsonMap}) {
    final foodJson = jsonMap.values.first;
    final nutrientsJson = foodJson['nutrients'] as List<dynamic>;

    final nutrients = nutrientsJson
        .map((e) => SrLegacyNutrientModel.fromJson(jsonString: e))
        .toList();

    return SrLegacyFoodModel(
      id: int.parse(jsonMap.keys.first),
      description: foodJson['description'],
      nutrients: nutrients,
    );
  }
}

typedef _InternalFoods = SrLegacyFoodModel;
typedef SrLegacyFoodType = _InternalFoods;
