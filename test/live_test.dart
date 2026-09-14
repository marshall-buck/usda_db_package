import 'package:flutter_test/flutter_test.dart';

import 'package:usda_db_package/src/models/models.dart';

import 'package:usda_db_package/src/usda_db_base.dart';

import './setup/startup.dart';

void main() {
  setUpAll(setUpStartup);
  tearDown(tearDownStartup);

  group('Live tests', () {
    group('init() - ', () {
      test('loads properties', () async {
        final db = UsdaDbDAO();
        await db.init();

        expect(db.isDataLoaded, true);
        db.dispose();
      });
    });
    group('isDataLoaded(),and dispose() - ', () {
      test('returns false if properties are empty', () async {
        final db = UsdaDbDAO();
        await db.init();
        db.dispose();
        expect(db.isDataLoaded, equals(false));
      });
    });

    group('queryFood() - ', () {
      test('returns a FoodModel', () async {
        final db = UsdaDbDAO();
        await db.init();
        final foodItem = await db.queryFood(id: 167512);
        expect(foodItem, isNotNull);
        expect(foodItem, isA<UsdaFoodModel>());
        db.dispose();
      });
      test('returns null if no food', () async {
        final db = UsdaDbDAO();
        await db.init();
        final foodItem = await db.queryFood(id: 1675121);
        expect(foodItem, isNull);
        db.dispose();
      });
    });

    group('queryFoods() - ', () {
      test('returns a list of FoodModels, with one word term 2 chars length',
          () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(searchString: 'tr');

        expect(list, isNotEmpty);
        expect(list.length, 1455);
        expect(list[0], isA<UsdaFoodModel>());
        db.dispose();
      });
      test('returns a list of FoodModels, with one word term', () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(searchString: 'aba');

        expect(list, isNotEmpty);
        expect(list.length, 14);
        expect(list[0], isA<UsdaFoodModel>());
        db.dispose();
      });

      test(
          'expect list to be empty  with 2 word input, each input does not have a match',
          () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(searchString: 'aa rrr');

        expect(list, isEmpty);
        db.dispose();
      });
      test(
          'expect list will all parameter set to false, one input does not have a match and one does',
          () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(searchString: 'gua rrr', all: false);

        expect(list.length, 10);
        db.dispose();
      });

      test('expect list to return only descriptions with ALL words', () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(searchString: 'ste, gua');

        expect(list.length, 1);
        db.dispose();
      });
      test('expect list to return only descriptions with ANY words', () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(searchString: 'ste, gua', all: false);

        expect(list.length, 1101);
        db.dispose();
      });

      test('matches a description that mixes dashes and parentheses', () async {
        final db = UsdaDbDAO();
        await db.init();
        final list = await db.queryFoods(
          searchString: 'Cabbage, chinese (pak-choi), raw',
        );

        expect(list.length, 1);
        expect(list[0].description, 'Cabbage, chinese (pak-choi), raw');
        db.dispose();
      });
    });
  });
}
