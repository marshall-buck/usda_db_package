import 'package:flutter_test/flutter_test.dart';
// `FoodsData` is internal, so it comes from `src/`; everything the package
// actually exports comes in through the public library.
import 'package:usda_db_package/src/foods_data.dart';
import 'package:usda_db_package/usda_db_package.dart';

import '../setup/mock_file_strings.dart';

void main() {
  group('FoodsData class test', () {
    late FoodsData foods;

    setUp(() {
      foods = FoodsData();
    });
    tearDown(() => foods.clear());

    test('init should populate foodsList', () async {
      await foods.init(jsonString: mockDBString);

      expect(foods.foodsList.length, 6);

      expect(foods.foodsList, isA<Map<int, UsdaFoodModel>>());
      expect(
        foods.foodsList[167512]?.description,
        'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough',
      );
      expect(
        foods.foodsList[167512]?.nutrients,
        isA<Map<int, num>>(),
      );
      expect(foods.foodsList[167512]?.nutrients.length, 7);
    });
    test('init should throw DBFormatException on invalid JSON', () async {
      await expectLater(
        foods.init(jsonString: 'invalid json'),
        throwsA(
          isA<DBFormatException>()
              .having(
                (e) => e.errorMessage,
                'errorMessage',
                contains('FormatException'),
              )
              .having((e) => e.stackTrace, 'stackTrace', isNotNull),
        ),
      );
    });

    test('init leaves foodsList empty when an entry fails to convert', () async {
      // The first entry is well formed, the second is not - parsing happens off
      // the instance, so nothing is published unless the whole file converts.
      const halfBadJson = '{"167512":{"description":"Biscuits",'
          '"nutrients":{"1003":5.88}},'
          '"167513":{"description":"Bread","nutrients":{"1003":"nope"}}}';

      await expectLater(
        foods.init(jsonString: halfBadJson),
        throwsA(isA<DBFormatException>()),
      );
      expect(foods.foodsList, isEmpty);
    });

    test('clearFoods should clear foodsList', () async {
      await foods.init(jsonString: mockDBString);
      foods.clear();
      expect(foods.foodsList.isEmpty, true);
    });

    test('getFood should return correct food', () async {
      await foods.init(jsonString: mockDBString);
      final food = foods.queryFood(167517);
      expect(
        food?.description,
        'Waffle, buttermilk, frozen, ready-to-heat, toasted',
      );
    });

    test('getFood should return null for non-existent food', () async {
      await foods.init(jsonString: mockDBString);
      final food = foods.queryFood(2);
      expect(food, null);
    });
  });
}
