import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/file_service.dart';
import 'package:usda_db_package/src/models/food_model.dart';

import 'package:usda_db_package/src/usda_db_base.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  setUpAll(() => set_up_all());
  tearDown(() => tear_down());

  group('DB class tests', () {
    group('init() - ', () {
      test('loads properties', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        // final db = UsdaDB(fileLoader: mockFileLoaderService);
        // await db.init();
        expect(db.isDataLoaded, true);
      });
      test('throws DBException on failure', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenThrow(Exception('loadData error'));
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        // final db = UsdaDB(fileLoader: mockFileLoaderService);

        expect(() async => await UsdaDB.init(fileLoader: mockFileLoaderService),
            throwsA(isA<DBException>()));
      });
    });
    group('isDataLoaded() - ', () {
      test('returns false if properties are empty', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        await db.dispose();

        expect(db.isDataLoaded, equals(false));
      });
    });
    group('dispose() - ', () {
      test('clears properties', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        await db.dispose();
        expect(db.isDataLoaded, false);
      });
    });

    group('queryFoods() - ', () {
      test('returns a FoodModel', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        final foodItem = await db.queryFood(id: 167512);
        expect(foodItem, isNotNull);
        expect(foodItem, isA<FoodModel>());
      });
    });

    group('queryFoods() - ', () {
      test('returns a list of FoodModels', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aab');
        expect(list, isNotEmpty);
        expect(list[0], isA<FoodModel>());
      });

      test('expect list to be empty with no results with input', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aa rrr');
        expect(list, isEmpty);
      });
      test('expect list to be correct with more than one word', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aab dough');
        expect(list.length, 4);
      });
      // test('throws DBException if db has not been initialized', () async {
      //   final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
      //   expect(() => db.queryFoods('apple'),
      //       throwsA(isA<DBException>()));
      // });
    });
  });
}
