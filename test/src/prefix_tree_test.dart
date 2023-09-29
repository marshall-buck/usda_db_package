import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:usda_db/src/prefix_tree.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() async {
  setUpAll(() {
    mockFileLoaderService = MockFileLoaderService();
    prefixTreeWithMockLoader = PrefixTree(mockFileLoaderService);
  });
  setUp(() async {
    when(() => mockFileLoaderService.loadData('fake'))
        .thenAnswer((_) async => testTree);
  });
  tearDown(() => tear_down());
  group('PrefixTree class tests', () {
    group('Tests singleton pattern', () {
      test('Singleton pattern - instance is the same', () {
        final loader2 = PrefixTree(mockFileLoaderService);

        expect(loader2, same(prefixTreeWithMockLoader));
      });

      test('Singleton pattern - instance is not null', () {
        // final instance = Foods(mockFileLoaderService);

        expect(prefixTreeWithMockLoader, isNotNull);
      });
    });
    group('init() - ', () {
      test('When called it loads PrefixTree instance correctly', () async {
        await prefixTreeWithMockLoader.init('fake');
        expect(prefixTreeWithMockLoader.root!.key, 'a');
        expect(prefixTreeWithMockLoader.root!.middle!.key, 'l');
        expect(prefixTreeWithMockLoader.root!.middle!.right!.key, 'n');
        expect(prefixTreeWithMockLoader.root!.middle!.right!.middle!.key, 'n');
        expect(
            prefixTreeWithMockLoader.root!.middle!.right!.middle!.middle!.key,
            'a');
        expect(
            prefixTreeWithMockLoader.root!.middle!.right!.middle!.middle!.isEnd,
            true);
        expect(prefixTreeWithMockLoader.root!.middle!.middle!.key, 'i');
        expect(prefixTreeWithMockLoader.root!.middle!.middle!.isEnd, true);
        expect(prefixTreeWithMockLoader.root!.middle!.middle!.middle!.key, 'c');
        expect(
            prefixTreeWithMockLoader.root!.middle!.middle!.middle!.middle!.key,
            'e');
        expect(
            prefixTreeWithMockLoader
                .root!.middle!.middle!.middle!.middle!.isEnd,
            true);

        expect(prefixTreeWithMockLoader.root!.right!.key, 'e');
        expect(prefixTreeWithMockLoader.root!.right!.middle!.key, 'l');
        expect(prefixTreeWithMockLoader.root!.right!.middle!.middle!.key, 'i');
        expect(
            prefixTreeWithMockLoader.root!.right!.middle!.middle!.middle!.key,
            'a');
        expect(
            prefixTreeWithMockLoader
                .root!.right!.middle!.middle!.middle!.middle!.key,
            's');
        expect(
            prefixTreeWithMockLoader
                .root!.right!.middle!.middle!.middle!.middle!.isEnd,
            true);

        expect(
            prefixTreeWithMockLoader
                .root!.right!.middle!.middle!.middle!.right!.key,
            'z');
        expect(
            prefixTreeWithMockLoader
                .root!.right!.middle!.middle!.middle!.right!.middle!.key,
            'a');
        expect(
            prefixTreeWithMockLoader
                .root!.right!.middle!.middle!.middle!.right!.middle!.isEnd,
            true);
      });
    });

    group('searchByPrefix() - ', () {
      test('Searches words by prefix correctly', () async {
        await prefixTreeWithMockLoader.init('fake');
        expect(prefixTreeWithMockLoader.searchByPrefix('al'), ['ali', 'alice']);
        expect(
            prefixTreeWithMockLoader.searchByPrefix('el'), ['elias', 'eliza']);
        expect(prefixTreeWithMockLoader.searchByPrefix('elis'), []);
        expect(prefixTreeWithMockLoader.searchByPrefix('anna'), ['anna']);
        expect(prefixTreeWithMockLoader.searchByPrefix('z'), []);
        expect(prefixTreeWithMockLoader.searchByPrefix(''), []);
        expect(prefixTreeWithMockLoader.searchByPrefix('   '), []);
      });
    });
  });
}
