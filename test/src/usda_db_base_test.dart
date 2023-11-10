import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/exceptions.dart';

import 'package:usda_db_package/src/file_paths.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    set_up_all();
  });

  tearDown(() {
    tear_down();
  });
  group('DB class tests', () {
    group('init() - ', () {
      test('properties are not null', () async {
        when(() => mockFileLoaderService.loadData(pathToFoods))
            .thenAnswer((_) async => mocDB);
        when(() => mockFileLoaderService.loadData(pathToSubstringHash))
            .thenAnswer((_) async => mocHashTable);
        await expectLater(dbWithMockFileLoader.init(), completes);
      });
      test('throws DB exception properly', () async {
        when(() => mockFileLoaderService.loadData(any()))
            .thenThrow(Exception());
        when(() => mockFileLoaderService.loadData(any()))
            .thenThrow(Exception());
        await expectLater(
            dbWithMockFileLoader.init(), throwsA(isA<DBException>()));
      });
    });
    group('dispose() - ', () {
      test(
          'properties are set to null correctly with a db that has been initiated',
          () async {
        when(() => mockFileLoaderService.loadData(pathToFoods))
            .thenAnswer((_) async => mocDB);
        when(() => mockFileLoaderService.loadData(pathToSubstringHash))
            .thenAnswer((_) async => mocHashTable);

        await dbWithMockFileLoader.init();

        verify(() => mockFileLoaderService.loadData(any())).called(2);
        expect(dbWithMockFileLoader.getFood('167513'), isNotNull);

        dbWithMockFileLoader.dispose();
        expect(() => dbWithMockFileLoader.getFood('167513'),
            throwsA(isA<DBException>()));
      });
    });

    group('getFood() - ', () {
      test('returns correct food', () async {
        when(() => mockFileLoaderService.loadData(pathToFoods))
            .thenAnswer((_) async => mocDB);
        when(() => mockFileLoaderService.loadData(pathToSubstringHash))
            .thenAnswer((_) async => mocHashTable);
        await dbWithMockFileLoader.init();
        final testFood = dbWithMockFileLoader.getFood('167513');

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

      test('returns null on bad index', () {
        final noFood = foodsListWithMockLoader.getFood('bad index');

        expect(noFood, isNull);
      });
    });
  });

  group('getDescriptions() - ', () {
    test('returns empty list with no matches', () async {
      when(() => mockFileLoaderService.loadData(pathToFoods))
          .thenAnswer((_) async => mocDB);
      when(() => mockFileLoaderService.loadData(pathToSubstringHash))
          .thenAnswer((_) async => mocHashTable);
      await dbWithMockFileLoader.init();
      final res = await dbWithMockFileLoader.getDescriptions('bad description');
      expect(res, isEmpty);
    });
    test('returns expected sorted matches', () async {
      when(() => mockFileLoaderService.loadData(pathToFoods))
          .thenAnswer((_) async => mocDB);
      when(() => mockFileLoaderService.loadData(pathToSubstringHash))
          .thenAnswer((_) async => mocHashTable);
      await dbWithMockFileLoader.init();
      final expectedResult = [
        (
          'Pillsbury, Cinnamon Rolls with Icing, refrigerated dough',
          56,
          "167513"
        ),
        (
          'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough',
          81,
          "167512"
        )
      ];
      final res = await dbWithMockFileLoader.getDescriptions('ill');

      expect(res, expectedResult);

      final expectedResult2 = [
        ("George Weston Bakeries, Thomas English Muffins", 46, "167515"),
        (
          "Kraft Foods, Shake N Bake Original Recipe, Coating for Pork, dry",
          64,
          "167514"
        )
      ];

      final res2 = await dbWithMockFileLoader.getDescriptions('ake');
      expect(res2, expectedResult2);
    });
    test('throws if DB not initiated', () {
      final expectedMessage = 'The DB has not been initialized! properly';

      expect(
          () async => await dbWithMockFileLoader.getDescriptions('term'),
          throwsA(predicate(
              (e) => e is DBException && e.errorMessage == expectedMessage)));
    });
  });
}
