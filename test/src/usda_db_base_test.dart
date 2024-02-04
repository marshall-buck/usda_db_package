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

        final db = DB(fileLoader: mockFileLoaderService);
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

        final db = DB(fileLoader: mockFileLoaderService);

        expect(() async => await db.init(), throwsA(isA<DBException>()));
        expect(db.isDataLoaded, false);
      });
    });
    group('isDataLoaded() - ', () {
      test('returns false if db has not been initiated', () {
        final db = DB(fileLoader: mockFileLoaderService);
        expect(db.isDataLoaded, false);
      });
      test('returns false if db.init throws', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenThrow(Exception('loadData error'));
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);
        final db = DB(fileLoader: mockFileLoaderService);
        await db.init().catchError((e, st) => null);
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

        final db = DB(fileLoader: mockFileLoaderService);
        await db.init();
        db.dispose();
        expect(db.isDataLoaded, false);
      });
    });

    group('getFood() - ', () {
      test('returns a FoodModel', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = DB(fileLoader: mockFileLoaderService);
        await db.init();
        final foodItem = db.getFood(167512);
        expect(foodItem, isNotNull);
        expect(foodItem, isA<FoodModel>());
      });
    });

    group('getAutocompleteList() - ', () {
      test('returns a list of DescriptionRecord', () async {
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameFoods))
            .thenAnswer((_) async => mockDBString);
        when(() => mockFileLoaderService.loadData(
                fileName: FileService.fileNameAutocompleteData))
            .thenAnswer((_) async => mockHashString);

        final db = DB(fileLoader: mockFileLoaderService);
        await db.init();
        final list = db.getAutocompleteList('apple');
        expect(list, isNotEmpty);
        expect(list, isA<List<DescriptionRecord>>());
      });
      test('throws DBException if db has not been initialized', () {
        final db = DB(fileLoader: mockFileLoaderService);
        expect(
            () => db.getAutocompleteList('apple'), throwsA(isA<DBException>()));
      });
    });
  });
}
