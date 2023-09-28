import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_model.freezed.dart';

part 'food_model.g.dart';

@freezed
class FoodModel with _$FoodModel {
  const factory FoodModel(
      {required String id,
      required String description,
      required num descriptionLength,
      num? protein,
      num? dietaryFiber,
      num? satFat,
      num? totCarb,
      num? calories,
      num? totFat,
      num? totSugars}) = _FoodModel;

  factory FoodModel.fromJson(Map<String, Object?> json) =>
      _$FoodModelFromJson(json);
}
