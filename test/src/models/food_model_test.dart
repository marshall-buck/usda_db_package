import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/models/models.dart';

void main() {
  group('FoodModel class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const foodModel = FoodDTO(
          id: 1,
          description: 'Test Food',
          nutrients: {1003: 10, 1004: 10.0},
        );

        expect(foodModel, isA<FoodDTO>());
        expect(foodModel.id, 1);
        expect(foodModel.description, 'Test Food');
        expect(foodModel.nutrients, isA<Map<int, double>>());
      });
    });
  });
}
