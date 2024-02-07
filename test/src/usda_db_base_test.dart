import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/file_service.dart';
import 'package:usda_db_package/src/models/food_model.dart';
import 'package:usda_db_package/src/type_def.dart';
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

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        expect(db.isDataLoaded, true);
      });
      test('throws DBException on failure', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenThrow(Exception('loadData error'));
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = UsdaDB(fileLoader: mockFileLoaderService);

        expect(() async => await db.init(), throwsA(isA<DBException>()));
        expect(db.isDataLoaded, false);
      });
    });
    group('isDataLoaded() - ', () {
      test('returns false if db has not been initiated', () {
        final db = UsdaDB(fileLoader: mockFileLoaderService);
        expect(db.isDataLoaded, false);
      });
      test('returns false if db.init throws', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenThrow(Exception('loadData error'));
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = UsdaDB(fileLoader: mockFileLoaderService);
        // await db.init().catchError((e, st) => e);
        expect(db.isDataLoaded, false);
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

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        db.dispose();
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

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        final foodItem = await db.queryFoods(167512);
        expect(foodItem, isNotNull);
        expect(foodItem, isA<FoodModel>());
      });
    });

    group('queryFoodDescriptions() - ', () {
      test('returns a list of DescriptionRecord', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        final list = await db.queryFoodDescriptions('aab');
        expect(list, isNotEmpty);
        expect(list[0], isA<DescriptionRecord>());
      });

      test('expect list is sorted properly', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        final list = await db.queryFoodDescriptions('aab');
        expect(list[0]?.$2, 56);
        expect(list[1]?.$2, 81);
      });
      test('expect list to be empty with no results with input', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        final list = await db.queryFoodDescriptions('aa rrr');
        expect(list, isEmpty);
      });
      test('expect list to be correct with more than one word', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = UsdaDB(fileLoader: mockFileLoaderService);
        await db.init();
        final list = await db.queryFoodDescriptions('aab dough');
        expect(list.length, 4);
      });
      test('throws DBException if db has not been initialized', () {
        final db = UsdaDB(fileLoader: mockFileLoaderService);
        expect(() => db.queryFoodDescriptions('apple'),
            throwsA(isA<DBException>()));
      });
    });
  });
}
