import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:usda_db_package/src/file_paths.dart';
import 'package:usda_db_package/src/foods.dart';
import 'package:usda_db_package/src/prefix_tree.dart';

import 'package:usda_db_package/src/usda_db_base.dart';
import 'package:usda_db_package/src/word_index.dart';

import '../setup/mock_db_file_strings.dart';

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
        .thenAnswer((_) async => mocDB);

    when(() => mockFileLoaderService.loadData(pathToTree))
        .thenAnswer((_) async => mocTree);

    when(() => mockFileLoaderService.loadData(pathToWordIndex))
        .thenAnswer((_) async => mocWordIndex);
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
    group('getDescriptions() - ', () {
      test('returns empty list with no matches', () async {
        await dbWithMockFileLoader.init();
        final res = await dbWithMockFileLoader.getDescriptions('');
        expect(res, isEmpty);
      });
      test('returns expected matches', () async {
        await dbWithMockFileLoader.init();
        final expectedResult = [
          (
            'Pillsbury, Cinnamon Rolls with Icing, refrigerated dough',
            56,
            "167513"
          ),
          (
            'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, refrigerated dough',
            81,
            "167512"
          )
        ];
        final res = await dbWithMockFileLoader.getDescriptions('pill');
        expect(res.length, 2);
        expect(res, expectedResult);

        final res2 = await dbWithMockFileLoader.getDescriptions('bak');
        expect(res2.length, 2);

        final res3 = await dbWithMockFileLoader.getDescriptions('waffle');
        expect(res3.length, 2);
      });
      test('throws if DB not initiated', () {
        // expect(() async => await dbWithMockFileLoader.getDescriptions('term'),
        //     throwsA(isA<DBException>()));
        final expectedMessage = 'The DB has not been initialized! properly';

        expect(
            () async => await dbWithMockFileLoader.getDescriptions('term'),
            throwsA(predicate(
                (e) => e is DBException && e.errorMessage == expectedMessage)));
      });
    });
  });
}
