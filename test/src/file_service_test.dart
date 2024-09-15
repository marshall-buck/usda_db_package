import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:usda_db_package/src/file_service.dart';

import '../setup/startup.dart';

void main() {
  setUpAll(setUpStartup);
  tearDown(tearDownStartup);
  group('FileService', () {
    final fileService = FileService();
    group('loadData() - ', () {
      test('loadData returns Autocomplete file contents as string ', () async {
        final contents = await fileService.loadData(
          fileName: FileService.fileNameAutocompleteData,
        );
        expect(contents, isA<String>());
        expect(contents, isNotEmpty);
        // print(contents);
      });
      test('loadData returns Foods file contents as string ', () async {
        final contents =
            await fileService.loadData(fileName: FileService.fileNameFoods);
        expect(contents, isA<String>());
        expect(contents, isNotEmpty);
        // print(contents);
      });

      test('loadData throws exception if file does not exist', () async {
        const fileName = 'non_existent_file.txt';

        expect(
          () async => fileService.loadData(fileName: fileName),
          throwsA(isA<FileSystemException>()),
        );
      });
    });
  });
}
