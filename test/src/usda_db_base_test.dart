import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/file_loader_service.dart';

import 'package:usda_db_package/src/file_paths.dart';
import 'package:usda_db_package/src/foods.dart';

import 'package:usda_db_package/src/usda_db_base.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    // db = DB();
    fileLoaderService = FileLoaderService();
    foodsListWithMockLoader = Foods(fileLoaderService);
    mockFileLoaderService = MockFileLoaderService();
    dbWithMockFileLoader = DB(fileLoader: mockFileLoaderService);
  });

  tearDown(() {
    tear_down();
  });
  group('DB class tests', () {
    group('Tests singleton pattern', () {
      test('Singleton pattern - instance is the same', () {
        final db1 = DB(fileLoader: mockFileLoaderService);
        final db2 = DB(fileLoader: mockFileLoaderService);

        expect(db1, db2);
      });

      test('Singleton pattern - instance is not null', () {
        final db1 = DB(fileLoader: mockFileLoaderService);
        expect(db1, isNotNull);
      });
    });
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
        expect(foodsListWithMockLoader.foodsList, isNotNull);

        dbWithMockFileLoader.dispose();
        expect(foodsListWithMockLoader.foodsList, isNull);
      });
    });

    group('getFood() - ', () {
      test('returns correct food', () async {
        final db = DB();

        await db.init();
        final testFood = db.getFood('167513');

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
}


   //   group('getDescriptions() - ', () {
    //     test('returns empty list with no matches', () async {
    //       await db.init();
    //       final res = await db.getDescriptions('bad description');
    //       expect(res, isEmpty);
    //     });
    //     test('returns expected sorted matches', () async {
    //       await db.init();
    //       final expectedResult = [
    //         (
    //           'Pillsbury, Cinnamon Rolls with Icing, refrigerated dough',
    //           56,
    //           "167513"
    //         ),
    //         (
    //           'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough',
    //           81,
    //           "167512"
    //         )
    //       ];
    //       final res = await db.getDescriptions('pill');

    //       expect(res, expectedResult);

    //       final expectedResult2 = [
    //         ("George Weston Bakeries, Thomas English Muffins", 46, "167515"),
    //         (
    //           "Kraft Foods, Shake N Bake Original Recipe, Coating for Pork, dry",
    //           64,
    //           "167514"
    //         )
    //       ];

    //       final res2 = await db.getDescriptions('bak');
    //       expect(res2, expectedResult2);

    //       final res3 = await db.getDescriptions('waffle');
    //       expect(res3.length, 2);
    //     });
    //     test('throws if DB not initiated', () {
    //       // expect(() async => await dbWithMockFileLoader.getDescriptions('term'),
    //       //     throwsA(isA<DBException>()));
    //       final expectedMessage = 'The DB has not been initialized! properly';

    //       expect(
    //           () async => await db.getDescriptions('term'),
    //           throwsA(predicate(
    //               (e) => e is DBException && e.errorMessage == expectedMessage)));
    //     });
    //   });
