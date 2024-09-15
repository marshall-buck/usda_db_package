// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'models.dart';

class SrLegacyFoodModel extends Equatable {
  const SrLegacyFoodModel({
    required this.id,
    required this.description,
    required this.nutrients,
  });

  final int id;

  final String description;

  final List<SrLegacyNutrientModel> nutrients;

  @override
  List<Object> get props => [id, description, nutrients];
}
