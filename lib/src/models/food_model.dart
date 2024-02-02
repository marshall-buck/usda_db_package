import 'package:freezed_annotation/freezed_annotation.dart';

import 'nutrient_model.dart';

part 'food_model.freezed.dart';

@freezed
class FoodModel with _$FoodModel {
  const factory FoodModel(
      {required final int id,
      required final String description,
      required final List<Nutrient> nutrients}) = _FoodModel;

  const FoodModel._();

  factory FoodModel.fromJson({required final Map<String, dynamic> jsonMap}) {
    final foodJson = jsonMap.values.first;
    final nutrientsJson = foodJson['nutrients'] as List<dynamic>;

    final nutrients =
        nutrientsJson.map((e) => Nutrient.fromJson(jsonString: e)).toList();

    return FoodModel(
      id: int.parse(jsonMap.keys.first),
      description: foodJson['description'],
      nutrients: nutrients,
    );
  }
}
