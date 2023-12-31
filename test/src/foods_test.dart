import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../setup/startup.dart';
import '../setup/mock_file_strings.dart';

void main() async {
  setUpAll(() {
    set_up_all();
  });
  setUp(() async {
    when(() => mockFileLoaderService.loadData('fake'))
        .thenAnswer((_) async => mocDB);
  });
  tearDown(() => tear_down());
  group('Foods class tests - ', () {
    group('init() -', () {
      test('Loads file correctly', () async {
        await foodsListWithMockLoader.init('fake');
        expect(foodsListWithMockLoader.foodsList, isNotEmpty);
        expect(foodsListWithMockLoader.foodsList?.length, 6);
        expect(foodsListWithMockLoader.foodsList?.entries.first.value.id,
            foodsListWithMockLoader.foodsList?.entries.first.key);
        expect(foodsListWithMockLoader.foodsList?.entries.first.value.calories,
            307);
        expect(
            foodsListWithMockLoader
                .foodsList?.entries.first.value.descriptionLength,
            81);
        expect(foodsListWithMockLoader.foodsList?['167514']!.totSugars, 0);
        expect(foodsListWithMockLoader.foodsList?['167514']!.protein, 6.1);
      });
    });
    group('dispose() -', () {
      test('disposes list correctly', () async {
        await foodsListWithMockLoader.init('fake');
        expect(foodsListWithMockLoader.foodsList, isNotNull);
        foodsListWithMockLoader.dispose();
        expect(foodsListWithMockLoader.foodsList, isNull);
      });
    });
    group('getFood() -', () {
      test('returns correct food', () async {
        await foodsListWithMockLoader.init('fake');
        final testFood = foodsListWithMockLoader.getFood('167513');

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
        await foodsListWithMockLoader.init('fake');
        final testFood = foodsListWithMockLoader.getFood('167514');

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
        final noFood = foodsListWithMockLoader.getFood('bad index');

        expect(noFood, isNull);
      });
    });
  });
}
