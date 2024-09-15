import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/models/models.dart';

void main() {
  group('FoodModel class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const foodModel = SrLegacyFoodModel(
          id: 1,
          description: 'Test Food',
          nutrients: [
            SrLegacyNutrientModel(
              id: 1,
              name: 'Test Nutrient',
              amount: 10.0,
              unit: 'g',
            ),
          ],
        );

        expect(foodModel, isA<SrLegacyFoodModel>());
        expect(foodModel.id, 1);
        expect(foodModel.description, 'Test Food');
        expect(foodModel.nutrients.first.id, 1);
        expect(foodModel.nutrients.first.name, 'Test Nutrient');
        expect(foodModel.nutrients.first.amount, 10.0);
        expect(foodModel.nutrients.first.unit, 'g');
      });
    });
    // group('fromJson', () {
    //   test('converts json to FoodModel', () {
    //     final json = <String, dynamic>{
    //       '1': {
    //         'description': 'Test Food',
    //         'nutrients': [
    //           {'id': 1003, 'amount': 10.0},
    //           {'id': 1004, 'amount': 20.0},
    //         ],
    //       },
    //     };

    //     final jsonValue = json['1'] as Map<String, dynamic>;

    //     final foodModel =
    //         SrLegacyFoodModel.fromJson(jsonValue: jsonValue, id: 1);

    //     expect(foodModel, isA<SrLegacyFoodModel>());
    //     expect(foodModel.id, 1);
    //     expect(foodModel.description, 'Test Food');
    //     expect(foodModel.nutrients.first.id, 1003);
    //     expect(foodModel.nutrients.first.name, 'Protein');
    //     expect(foodModel.nutrients.first.amount, 10.0);
    //     expect(foodModel.nutrients.first.unit, 'g');
    //     expect(foodModel.nutrients.last.id, 1004);
    //     expect(foodModel.nutrients.last.name, 'Total Fat');
    //     expect(foodModel.nutrients.last.amount, 20.0);
    //     expect(foodModel.nutrients.last.unit, 'g');
    //   });
    // });
  });
}
