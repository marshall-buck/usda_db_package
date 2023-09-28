// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodModelImpl _$$FoodModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodModelImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      descriptionLength: json['descriptionLength'] as num,
      protein: json['protein'] as num?,
      dietaryFiber: json['dietaryFiber'] as num?,
      satFat: json['satFat'] as num?,
      totCarb: json['totCarb'] as num?,
      calories: json['calories'] as num?,
      totFat: json['totFat'] as num?,
      totSugars: json['totSugars'] as num?,
    );

Map<String, dynamic> _$$FoodModelImplToJson(_$FoodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'descriptionLength': instance.descriptionLength,
      'protein': instance.protein,
      'dietaryFiber': instance.dietaryFiber,
      'satFat': instance.satFat,
      'totCarb': instance.totCarb,
      'calories': instance.calories,
      'totFat': instance.totFat,
      'totSugars': instance.totSugars,
    };
