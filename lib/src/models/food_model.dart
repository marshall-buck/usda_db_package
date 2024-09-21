// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';

class SrLegacyFoodModel extends Equatable {
  const SrLegacyFoodModel({
    required this.id,
    required this.description,
    required this.nutrients,
  });

  final int id;

  final String description;

  final Map<int, num> nutrients;

  @override
  List<Object> get props => [id, description, nutrients];
}
