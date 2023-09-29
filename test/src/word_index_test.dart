//import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:usda_db/src/word_index.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

const indexesTestPath = 'lib/assets/test_db_word_index.json';
void main() async {
  setUpAll(() {
    mockFileLoaderService = MockFileLoaderService();
    wordIndexWithMockLoader = WordIndex(mockFileLoaderService);
  });
  setUp(() async {
    when(() => mockFileLoaderService.loadData('fake'))
        .thenAnswer((_) async => testIndex);
  });
  tearDown(() => tear_down());
  group('WordIndexes class tests', () {
    group('Tests singleton pattern', () {
      test('Singleton pattern - instance is the same', () {
        final loader2 = WordIndex(mockFileLoaderService);

        expect(loader2, same(wordIndexWithMockLoader));
      });

      test('Singleton pattern - instance is not null', () {
        expect(wordIndexWithMockLoader, isNotNull);
      });
    });
    group('init() -', () {
      test('Loads file correctly', () async {
        await wordIndexWithMockLoader.init('fake');
        expect(wordIndexWithMockLoader.indexes, isNotEmpty);
        expect(wordIndexWithMockLoader.indexes?.length, 7);
      });
    });
    group('getIndexes() -', () {
      test('returns set of indexes from list of words', () async {
        await wordIndexWithMockLoader.init('fake');
        final set = await wordIndexWithMockLoader
            .getIndexes(['abalone', 'acerola', "fake"]);
        expect(set.length, 4);
        expect(set, {"174212", "174213", "171686", "171687"});
        expect(await wordIndexWithMockLoader.getIndexes([]), isEmpty);
        final abbott = await wordIndexWithMockLoader.getIndexes(['abbott']);
        expect(abbott.length, 31);
      });
      test('returns empty set on bad word', () async {
        await wordIndexWithMockLoader.init('fake');
        final badWord = await wordIndexWithMockLoader.getIndexes(["badWord"]);
        expect(badWord, isEmpty);
      });
    });
  });
}
