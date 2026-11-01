import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

void main() {
  group('FoodCategory class tests', () {
    group('Constructor tests', () {
      test('initiates properly', () {
        const category = UsdaFoodCategoryModel(
          code: 1,
          name: 'Test Category',
        );

        expect(category, isA<UsdaFoodCategoryModel>());
        expect(category.code, 1);
        expect(category.name, 'Test Category');
      });
    });

    group('fromCode', () {
      test('looks up the name for a known code', () {
        final category = UsdaFoodCategoryModel.fromCode(1800);

        expect(category.code, 1800);
        expect(category.name, 'Baked Products');
        expect(category.isKnown, true);
      });

      test('falls back to an empty name for an unknown code', () {
        final category = UsdaFoodCategoryModel.fromCode(9999);

        expect(category.code, 9999);
        expect(category.name, '');
        expect(category.isKnown, false);
      });
    });

    group('nameFor() - ', () {
      test('returns the table value for a known code', () {
        expect(UsdaFoodCategoryModel.nameFor(100), 'Dairy and Egg Products');
      });

      test('returns null for an unknown code', () {
        expect(UsdaFoodCategoryModel.nameFor(9999), isNull);
      });
    });

    group('foodCategories - ', () {
      test('holds all 28 USDA categories', () {
        expect(UsdaFoodCategoryModel.foodCategories.length, 28);
      });
    });

    test('toString is the name', () {
      expect(UsdaFoodCategoryModel.fromCode(1800).toString(), 'Baked Products');
    });
  });
}
