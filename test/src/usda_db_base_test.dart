import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:usda_db/src/file_paths.dart';
import 'package:usda_db/src/foods.dart';
import 'package:usda_db/src/prefix_tree.dart';

import 'package:usda_db/src/usda_db_base.dart';
import 'package:usda_db/src/word_index.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  setUpAll(() {
    mockFileLoaderService = MockFileLoaderService();
    dbWithMockFileLoader = DB(fileLoader: mockFileLoaderService);
    foodsListWithMockLoader = Foods(mockFileLoaderService);
    prefixTreeWithMockLoader = PrefixTree(mockFileLoaderService);
    wordIndexWithMockLoader = WordIndex(mockFileLoaderService);
    mockFoods = MockFoodsList();
  });
  setUp(() async {
    when(() => mockFileLoaderService.loadData(pathToFoods))
        .thenAnswer((_) async => testDB);
    when(() => mockFileLoaderService.loadData(pathToTree))
        .thenAnswer((_) async => testTree);
    when(() => mockFileLoaderService.loadData(pathToWordIndex))
        .thenAnswer((_) async => testIndex);
  });
  tearDown(() {
    dbWithMockFileLoader.dispose();
    tear_down();
  });
  group('DB class tests', () {
    group('Tests singleton pattern', () {
      test('Singleton pattern - instance  without loader', () {
        final loader3 = DB();
        final loader4 = DB();

        expect(loader3, loader4);
      });
      test('Singleton pattern - instance is the same', () {
        final loader2 = DB(fileLoader: mockFileLoaderService);

        expect(loader2, same(dbWithMockFileLoader));
      });

      test('Singleton pattern - instance is not null', () {
        expect(dbWithMockFileLoader, isNotNull);
      });
    });
    group('init() - ', () {
      test('fileLoader.loadData is called 3 times ', () async {
        await dbWithMockFileLoader.init();
        verify(() => mockFileLoaderService.loadData(any())).called(3);
      });
      test('throws DB exception properly', () {
        when(() => mockFileLoaderService.loadData(pathToFoods))
            .thenThrow(Exception());
        // expect(() async => await dbWithMockFileLoader.init(), isException);
        expect(() async => await dbWithMockFileLoader.init(),
            throwsA(isA<DBException>()));
      });
    });
    group('dispose() - ', () {
      test(
          'properties are set to null correctly with a db that has been initiated',
          () async {
        await dbWithMockFileLoader.init();
        verify(() => mockFileLoaderService.loadData(any())).called(3);
        expect(foodsListWithMockLoader.foodsList, isNotNull);
        expect(prefixTreeWithMockLoader.root, isNotNull);
        expect(wordIndexWithMockLoader.indexes, isNotNull);
        dbWithMockFileLoader.dispose();
        expect(foodsListWithMockLoader.foodsList, isNull);
        expect(prefixTreeWithMockLoader.root, isNull);
        expect(wordIndexWithMockLoader.indexes, isNull);
      });
    });

    group('getFood() - ', () {
      test('returns correct food', () async {
        await dbWithMockFileLoader.init();
        final testFood = dbWithMockFileLoader.getFood('167513');

        expect(testFood?.id, '167513');
        expect(testFood?.description,
            'Pillsbury, Cinnamon Rolls with Icing, refrigerated dough');
        expect(testFood?.descriptionLength, 56);
        expect(testFood?.protein, 4.34);
        expect(testFood?.dietaryFiber, 1.4);
        expect(testFood?.satFat, 3.25);
        expect(testFood?.totFat, 11.3);
        expect(testFood?.totCarb, 53.4);
        expect(testFood?.calories, 330);
        expect(testFood?.totSugars, 21.3);
      });

      test('returns null on bad index', () {
        final noFood = foodsListWithMockLoader.getFood('bad index');

        expect(noFood, isNull);
      });
    });
  });
}
