import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:usda_db_package/src/file_service.dart';

import '../setup/startup.dart';

void main() {
  setUpAll(() => set_up_all());
  tearDown(() => tear_down());
  group('FileService', () {
    final fileService = FileService();
    group('loadData() - ', () {
      test('loadData returns Autocomplete file contents as string ', () async {
        final String contents = await fileService.loadData(
            fileName: FileService.fileNameAutocompleteData);
        expect(contents, isA<String>());
        expect(contents, isNotEmpty);
        // print(contents);
      });
      test('loadData returns Foods file contents as string ', () async {
        final String contents =
            await fileService.loadData(fileName: FileService.fileNameFoods);
        expect(contents, isA<String>());
        expect(contents, isNotEmpty);
        // print(contents);
      });

      test('loadData throws exception if file does not exist', () async {
        const String fileName = 'non_existent_file.txt';

        expect(
          () async => await fileService.loadData(fileName: fileName),
          throwsA(isA<FileSystemException>()),
        );
      });
    });
  });
}
