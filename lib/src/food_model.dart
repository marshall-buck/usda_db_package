import 'package:freezed_annotation/freezed_annotation.dart';

import 'nutrient.dart';

part 'food_model.freezed.dart';

@freezed
class FoodModel with _$FoodModel {
  const factory FoodModel(
      {required final int id,
      required final String description,
      required final List<Nutrient> nutrients}) = _FoodModel;

  const FoodModel._();

  Map<String, dynamic> toJson() {
    final nutrientList = nutrients.map((e) => e.toJson()).toList();

    return {
      id.toString(): {
        'description': description,
        'nutrients': nutrientList,
      }
    };
  }

  factory FoodModel.fromJson(final Map<int, dynamic> json) {
    final foodJson = json.values.first;
    final nutrientsJson = foodJson['nutrients'] as List<dynamic>;

    final nutrients = nutrientsJson
        .map((e) => Nutrient.fromJson(e as Map<String, dynamic>))
        .toList();

    return FoodModel(
      id: json.keys.first,
      description: foodJson['description'],
      nutrients: nutrients,
    );
  }
}
