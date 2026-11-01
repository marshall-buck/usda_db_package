import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/usda_db_package.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

// Every test here runs against the mock data strings - nothing in this file
// touches the real asset bundle. The bundled files are covered by
// `test/live_test.dart`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFileService fileLoader;
  late UsdaDb db;

  setUp(() {
    fileLoader = mockFileService();
    db = UsdaDb();
    addTearDown(db.dispose);
  });

  group('DB class tests', () {
    group('init() - ', () {
      test('loads properties', () async {
        await db.init(fileLoader: fileLoader);

        expect(db.isDataLoaded, true);
      });
      test('throws UsdaDbException on failure', () async {
        when(() => fileLoader.loadData(fileName: FileService.fileNameFoods))
            .thenThrow(Exception('loadData error'));

        await expectLater(
          db.init(fileLoader: fileLoader),
          throwsA(isA<UsdaDbException>()),
        );
      });
      test('can be retried after a failure', () async {
        var shouldFail = true;
        when(() => fileLoader.loadData(fileName: FileService.fileNameFoods))
            .thenAnswer((_) async {
          if (shouldFail) throw Exception('loadData error');
          return mockDBString;
        });

        await expectLater(
          db.init(fileLoader: fileLoader),
          throwsA(isA<UsdaDbException>()),
        );
        expect(db.isDataLoaded, false);

        shouldFail = false;
        await db.init(fileLoader: fileLoader);

        expect(db.isDataLoaded, true);
      });
      test('isInitializing is not shared between instances', () async {
        final gate = Completer<String>();
        when(() => fileLoader.loadData(fileName: FileService.fileNameFoods))
            .thenAnswer((_) => gate.future);

        final other = UsdaDb();

        final pending = db.init(fileLoader: fileLoader);
        await pumpEventQueue();

        expect(db.isInitializing, true);
        expect(other.isInitializing, false);

        gate.complete(mockDBString);
        await pending;

        expect(db.isInitializing, false);
      });
    });

    group('isDataLoaded(), and dispose() - ', () {
      test('returns false once disposed', () async {
        await db.init(fileLoader: fileLoader);
        expect(db.isDataLoaded, true);

        db.dispose();

        expect(db.isDataLoaded, false);
      });
      test('queries throw once disposed', () async {
        await db.init(fileLoader: fileLoader);
        db.dispose();

        await expectLater(
          db.queryFood(id: 167512),
          throwsA(isA<UsdaDbException>()),
        );
      });
    });

    group('queryFood() - ', () {
      test('returns the food with that id', () async {
        await db.init(fileLoader: fileLoader);

        final foodItem = await db.queryFood(id: 167512);

        expect(foodItem?.id, 167512);
        expect(
          foodItem?.description,
          'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, '
          'refrigerated dough',
        );
      });
      test('returns null if no food', () async {
        await db.init(fileLoader: fileLoader);

        final foodItem = await db.queryFood(id: 1675121);

        expect(foodItem, isNull);
      });
      test('has no matched words without matchWordsFor', () async {
        await db.init(fileLoader: fileLoader);

        final foodItem = await db.queryFood(id: 167512);

        expect(foodItem?.matchedWords, isEmpty);
      });
      test('lists matched words for matchWordsFor', () async {
        await db.init(fileLoader: fileLoader);

        final foodItem =
            await db.queryFood(id: 167512, matchWordsFor: 'butter, DOUGH');

        expect(foodItem?.matchedWords, ['Buttermilk', 'dough']);
      });
      test('returns the food when nothing matches matchWordsFor', () async {
        await db.init(fileLoader: fileLoader);

        final foodItem = await db.queryFood(id: 167512, matchWordsFor: 'kale');

        expect(foodItem?.id, 167512);
        expect(foodItem?.matchedWords, isEmpty);
      });
    });

    group('queryFoods() - ', () {
      test('returns a list of FoodModels, with one word term 2 chars length',
          () async {
        await db.init(fileLoader: fileLoader);

        final list = await db.queryFoods(searchString: 'ab');

        // 'ab' hashes to index 0 -> [167512, 167513, 167515].
        expect(
          list.map((food) => food.id),
          unorderedEquals([167512, 167513, 167515]),
        );
      });
      test('returns a list of FoodModels, with one word term', () async {
        await db.init(fileLoader: fileLoader);

        final list = await db.queryFoods(searchString: 'aba');

        expect(
          list.map((food) => food.id),
          unorderedEquals([167512, 167513, 167515]),
        );
      });

      test('is empty when no word in a 2 word input matches', () async {
        await db.init(fileLoader: fileLoader);

        final list = await db.queryFoods(searchString: 'aa rrr');

        expect(list, isEmpty);
      });
      test('is empty when only one word of a 2 word input matches', () async {
        await db.init(fileLoader: fileLoader);

        // 'aba' matches three foods, 'rrr' matches none, so the intersection
        // the `all` path builds is empty.
        final list = await db.queryFoods(searchString: 'aba rrr');

        expect(list, isEmpty);
      });

      test('expect list to return only descriptions with ALL words', () async {
        await db.init(fileLoader: fileLoader);

        // 'aba' -> [167512, 167513, 167515], 'dough' -> [167514, 167515].
        final list = await db.queryFoods(searchString: 'aba, dough');

        expect(list.map((food) => food.id), [167515]);
      });
      test('carries the sanitized search words on every food', () async {
        await db.init(fileLoader: fileLoader);

        final list =
            await db.queryFoods(searchString: 'Aba, dough', all: false);

        for (final food in list) {
          expect(food.matchTerms, ['aba', 'dough']);
        }
      });
      test('expect list to return only descriptions with ANY words', () async {
        await db.init(fileLoader: fileLoader);

        final list =
            await db.queryFoods(searchString: 'aba, dough', all: false);

        expect(
          list.map((food) => food.id),
          unorderedEquals([167512, 167513, 167514, 167515]),
        );
      });
      test('ANY search carries only the words the index matched', () async {
        await db.init(fileLoader: fileLoader);

        final list = await db.queryFoods(searchString: 'aba rrr', all: false);

        expect(list, isNotEmpty);
        for (final food in list) {
          expect(food.matchTerms, ['aba']);
        }
      });
      test('drops ids the foods table does not hold', () async {
        await db.init(fileLoader: fileLoader);

        // 'abap' maps to index 1 -> [171845, 174077], neither of which is in
        // the mock foods table.
        final list = await db.queryFoods(searchString: 'abap');

        expect(list, isEmpty);
      });
      test('with categoryCode returns only foods in that category', () async {
        await db.init(fileLoader: fileLoader);

        // 'aba' or 'dough' -> [167512, 167513, 167514, 167515]; only 167514
        // is in category 600.
        final list = await db.queryFoods(
          searchString: 'aba, dough',
          all: false,
          categoryCode: 600,
        );

        expect(list.map((food) => food.id), [167514]);
        expect(list.single.matchTerms, ['aba', 'dough']);
      });
      test('is empty when no match is in categoryCode', () async {
        await db.init(fileLoader: fileLoader);

        // 'aba' -> [167512, 167513, 167515], all in category 1800.
        final list =
            await db.queryFoods(searchString: 'aba', categoryCode: 600);

        expect(list, isEmpty);
      });
      test('is empty for an unknown categoryCode', () async {
        await db.init(fileLoader: fileLoader);

        final list =
            await db.queryFoods(searchString: 'aba', categoryCode: 9999);

        expect(list, isEmpty);
      });
    });

    group('queryFoodsByCategory() - ', () {
      test('returns every food in the category', () async {
        await db.init(fileLoader: fileLoader);

        final list = await db.queryFoodsByCategory(categoryCode: 1800);

        expect(
          list.map((food) => food.id),
          [167512, 167513, 167515, 167516, 167517],
        );
        expect(list.first.matchedWords, isEmpty);
      });
      test('is empty for an unknown categoryCode', () async {
        await db.init(fileLoader: fileLoader);

        final list = await db.queryFoodsByCategory(categoryCode: 9999);

        expect(list, isEmpty);
      });
      test('throws before init', () async {
        await expectLater(
          db.queryFoodsByCategory(categoryCode: 1800),
          throwsA(isA<UsdaDbException>()),
        );
      });
    });

    group('categories - ', () {
      test('lists the categories in the data, in code order', () async {
        await db.init(fileLoader: fileLoader);

        expect(
          db.categories,
          const [
            UsdaFoodCategoryModel(
              code: 600,
              name: 'Soups, Sauces, and Gravies',
            ),
            UsdaFoodCategoryModel(code: 1800, name: 'Baked Products'),
          ],
        );
      });
      test('throws before init', () {
        expect(() => db.categories, throwsA(isA<UsdaDbException>()));
      });
    });
  });
}
