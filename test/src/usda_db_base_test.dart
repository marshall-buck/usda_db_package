import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/file_service.dart';
import 'package:usda_db_package/src/models/models.dart';

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
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);

        expect(db.isDataLoaded, true);
        await db.dispose();
      });
      test('throws DBException on failure', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenThrow(Exception('loadData error'));
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = UsdaDB();

        expect(() async => await db.init(fileLoader: mockFileLoaderService),
            throwsA(isA<DBException>()));
        await db.dispose();
      });
    });
    group('isDataLoaded(),and dispose() - ', () {
      test('returns false if properties are empty', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        await db.dispose();
        expect(db.isDataLoaded, equals(false));
      });
    });

    group('queryFood() - ', () {
      test('returns a FoodModel', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final foodItem = await db.queryFood(id: 167512);
        expect(foodItem, isNotNull);
        expect(foodItem, isA<SrLegacyFoodModel>());
        await db.dispose();
      });
      test('returns null if no food', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final foodItem = await db.queryFood(id: 1675121);
        expect(foodItem, isNull);
        await db.dispose();
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
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aab');
        expect(list, isNotEmpty);
        expect(list[0], isA<SrLegacyFoodModel>());
        await db.dispose();
      });

      test('expect list to be empty with no results with input', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aa rrr');
        expect(list, isEmpty);
        await db.dispose();
      });
      test('expect list to be correct with more than one word', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aab dough');
        expect(list.length, 4);
        await db.dispose();
      });
      // test('throws DBException if db has not been initialized', () async {
      //   final db = await UsdaDB.init(fileLoader: mockFileLoaderService);
      //   expect(() => db.queryFoods('apple'),
      //       throwsA(isA<DBException>()));
      // });
    });
  });
}
