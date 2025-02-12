import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/file_service.dart';
import 'package:usda_db_package/src/models/models.dart';

import 'package:usda_db_package/src/usda_db_base.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  setUpAll(setUpStartup);
  tearDown(tearDownStartup);

  group('DB class tests', () {
    group('init() - ', () {
      test('loads properties', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);

        expect(db.isDataLoaded, true);
        await db.dispose();
      });
      test('throws DBException on failure', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenThrow(Exception('loadData error'));
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);

        final db = UsdaDB();

        expect(
          () async => db.init(fileLoader: mockFileLoaderService),
          throwsA(isA<DBException>()),
        );
        await db.dispose();
      });
    });
    group('isDataLoaded(),and dispose() - ', () {
      test('returns false if properties are empty', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        await db.dispose();
        expect(db.isDataLoaded, equals(false));
      });
    });

    group('queryFood() - ', () {
      test('returns a FoodModel', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final foodItem = await db.queryFood(id: 167512);
        expect(foodItem, isNotNull);
        expect(foodItem, isA<FoodDTO>());
        await db.dispose();
      });
      test('returns null if no food', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final foodItem = await db.queryFood(id: 1675121);
        expect(foodItem, isNull);
        await db.dispose();
      });
    });

    group('queryFoods() - ', () {
      test('returns a list of FoodModels, with one word term 2 chars length',
          () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'ab');
        expect(list, isNotEmpty);
        expect(list.length, 3);
        expect(list[0], isA<FoodDTO>());
        await db.dispose();
      });
      test('returns a list of FoodModels, with one word term', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aba');
        expect(list, isNotEmpty);
        expect(list.length, 3);
        expect(list[0], isA<FoodDTO>());
        await db.dispose();
      });

      test(
          'expect list to be empty with no results with 2 word input, each input does not have a match',
          () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aa rrr');
        expect(list, isEmpty);
        await db.dispose();
      });
      test(
          'expect list to be empty with no results with 2 word input, one input does not have a match and one does',
          () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aab rrr');
        expect(list, isEmpty);
        await db.dispose();
      });

      test('expect list to return only descriptions with ALL words', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list = await db.queryFoods(searchString: 'aba, dough');
        expect(list.length, 1);
        await db.dispose();
      });
      test('expect list to return only descriptions with ANY words', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list =
            await db.queryFoods(searchString: 'aba, dough', all: false);
        expect(list.length, 4);
        await db.dispose();
      });
      test('expect list to return with 2 letter words', () async {
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameFoods,
          ),
        ).thenAnswer((_) async => mockDBString);
        when(
          () => mockFileLoaderService.loadData(
            fileName: FileService.fileNameAutocompleteData,
          ),
        ).thenAnswer((_) async => mockHashString);
        final db = UsdaDB();
        await db.init(fileLoader: mockFileLoaderService);
        final list =
            await db.queryFoods(searchString: 'aba, dough', all: false);
        expect(list.length, 4);
        await db.dispose();
      });
    });
  });

  group('Test Db files', () {
    test('Opening foods_db returns a  string', () async {
      final fileLoader = FileService();

      final jsonString = await fileLoader.loadData(fileName: 'foods_db.json');
      expect(jsonString, isA<String>());
      try {
        final jsonObject = jsonDecode(jsonString);
        expect(jsonObject, isA<Map<String, dynamic>>());
      } catch (e) {
        fail('Failed to decode JSON: $e');
      }
    });
    test('Opening autocomplete_hash returns a  string', () async {
      final fileLoader = FileService();

      final jsonString =
          await fileLoader.loadData(fileName: 'autocomplete_hash.json');
      expect(jsonString, isA<String>());
      try {
        final jsonObject = jsonDecode(jsonString);
        expect(jsonObject, isA<Map<String, dynamic>>());
      } catch (e) {
        fail('Failed to decode JSON: $e');
      }
    });
  });
}
