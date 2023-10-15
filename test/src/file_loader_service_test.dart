import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/file_loader_service.dart';

import '../setup/startup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    mockFileLoaderService = MockFileLoaderService();
    fileLoaderService = FileLoaderService();
  });
  // setUp(() async {
  //   // when(() => mockFileLoaderService.loadData('fake'))
  //   //     .thenAnswer((_) async => testDB);
  //   await foodsListWithMockLoader.init('fake');
  // });
  tearDown(() => tear_down());
  group('FileLoaderService class tests', () {
    group('loadFile - ', () {
      test('loads real file correctly', () async {
        final res = await fileLoaderService.loadData(pathToTestFile);
        expect(res, 'Here is a text file?');
      });
      test('mocks file correctly', () async {
        when(() => mockFileLoaderService.loadData('fake'))
            .thenAnswer((_) async => 'Here is a mock text file?');
        final res = await mockFileLoaderService.loadData('fake');

        expect(res, 'Here is a mock text file?');
      });
    });
    group('Tests singleton pattern', () {
      test('Singleton pattern - instance is the same', () {
        final loader2 = FileLoaderService();

        expect(fileLoaderService, same(loader2));
      });

      test('Singleton pattern - instance is not null', () {
        final instance = FileLoaderService();

        expect(instance, isNotNull);
      });
    });
  });
}
