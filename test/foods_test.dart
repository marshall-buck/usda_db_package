import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:usda_db/src/foods.dart';

import 'setup.dart';
import 'test_objects.dart';

void main() async {
  when(() => mockFileLoaderService.loadData('fake'))
      .thenAnswer((_) async => testDB);
  await foodsListMockLoader.init('fake');
  group('Foods class tests', () {
    group('Tests singleton pattern', () {
      test('Singleton pattern - instance is the same', () {
        final loader2 = Foods(mockFileLoaderService);

        expect(loader2, same(foodsListMockLoader));
      });

      test('Singleton pattern - instance is not null', () {
        final instance = Foods(mockFileLoaderService);

        expect(instance, isNotNull);
      });
    });
    group('init() -', () {
      test('Loads file correctly', () async {
        expect(foodsListMockLoader.foodsList, isNotEmpty);
        expect(foodsListMockLoader.foodsList?.length, 5);
        expect(foodsListMockLoader.foodsList?.entries.first.value.id,
            foodsListMockLoader.foodsList?.entries.first.key);
        expect(
            foodsListMockLoader.foodsList?.entries.first.value.calories, 307);
        expect(
            foodsListMockLoader
                .foodsList?.entries.first.value.descriptionLength,
            81);
        expect(foodsListMockLoader.foodsList?['167514']!.totSugars, 0);
        expect(foodsListMockLoader.foodsList?['167514']!.protein, 6.1);
      });
    });
    group('getFood() -', () {
      test('returns correct food', () async {
        final testFood = await foodsListMockLoader.getFood('167513');

        expect(testFood?.id, '167513');
        expect(testFood?.description,
            'Pillsbury, Cinnamon Rolls with Icing, refrigerated dough');
        expect(testFood?.descriptionLength, 56);
        expect(testFood?.protein, 4.34);
        expect(testFood?.dietaryFiber, 1.4);
        expect(testFood?.satFat, 3.25);
        expect(testFood?.totFat, 11.3);
        expect(testFood?.totCarb, 53.4);
        expect(testFood?.calories, 330);
        expect(testFood?.totSugars, 21.3);
      });

      test('returns correct food with missing nutrients', () async {
        final testFood = await foodsListMockLoader.getFood('167514');

        expect(testFood?.id, '167514');
        expect(testFood?.description,
            'Kraft Foods, Shake N Bake Original Recipe, Coating for Pork, dry');
        expect(testFood?.descriptionLength, 64);
        expect(testFood?.protein, 6.1);
        expect(testFood?.dietaryFiber, 0);
        expect(testFood?.satFat, 0);
        expect(testFood?.totFat, 3.7);
        expect(testFood?.totCarb, 79.8);
        expect(testFood?.calories, 377);
        expect(testFood?.totSugars, 0);
      });
      test('returns null on bad index', () async {
        final noFood = await foodsListMockLoader.getFood('bad index');

        expect(noFood, isNull);
      });
    });
  });
}
