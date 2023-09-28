import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:usda_db/src/file_loader_service.dart';
import 'setup.dart';

void main() {
  group('FileLoaderService class tests', () {
    group('loadFile - ', () {
      test('loads file correctly', () async {
        final res = await fileLoaderService.loadData('lib/assets/text.txt');
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
