// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';

class UsdaFoodModel extends Equatable {
  const UsdaFoodModel({
    required this.id,
    required this.description,
    required this.nutrients,
  });

  /// Food id.
  final int id;

  /// Food Description.
  final String description;

  /// The id of the nutrient and the amount {id: amount}.
  final Map<int, double> nutrients;

  @override
  List<Object> get props => [id, description, nutrients];
}
