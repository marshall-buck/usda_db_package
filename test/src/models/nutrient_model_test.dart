import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/models/models.dart';

void main() {
  group('Nutrient class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const SrLegacyNutrientModel nutrient = SrLegacyNutrientModel(
          id: 1,
          name: 'Test Nutrient',
          amount: 10.0,
          unit: 'g',
        );

        expect(nutrient, isA<SrLegacyNutrientModel>());
        expect(nutrient.id, 1);
        expect(nutrient.name, 'Test Nutrient');
        expect(nutrient.amount, 10.0);
        expect(nutrient.unit, 'g');
      });
    });
    group('fromJson', () {
      test('converts json to Nutrient', () {
        final Map<String, dynamic> json = {
          'id': 1003,
          'amount': 10.0,
        };

        final SrLegacyNutrientModel nutrient =
            SrLegacyNutrientModel.fromJson(jsonString: json);

        expect(nutrient, isA<SrLegacyNutrientModel>());
        expect(nutrient.id, 1003);
        expect(nutrient.name, 'Protein');
        expect(nutrient.amount, 10.0);
        expect(nutrient.unit, 'g');
      });
    });
  });
}
