import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/file_service.dart';
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
    });
  });
}
