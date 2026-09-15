import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// The point of this file: it imports the public library and nothing from
// `src/`, so it fails to compile if an `export` line goes missing from
// `usda_db_package.dart`. Behaviour is covered in the unit tests under
// `test/src/` - what is under test here is the exported surface itself.
import 'package:usda_db_package/usda_db_package.dart';

import 'setup/startup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFileService fileLoader;

  setUp(() => fileLoader = mockFileService());

  group('exported surface', () {
    test('a consumer can initialize and query the db', () async {
      final db = UsdaDb();
      expect(db.isDataLoaded, false);
      expect(db.isInitializing, false);

      // `init` names `FileService` in its signature, so the type has to be
      // reachable from outside the package for this call to be writable.
      await db.init(fileLoader: fileLoader);
      expect(db.isDataLoaded, true);

      final food = await db.queryFood(id: 167512);
      expect(
        food?.description,
        'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, '
        'refrigerated dough',
      );

      final foods = await db.queryFoods(searchString: 'apple');
      expect(foods, isA<List<UsdaFoodModel>>());

      db.dispose();
      expect(db.isDataLoaded, false);
    });

    test('a consumer can catch the failure types by name', () async {
      // Querying before init is the one failure reachable without reaching
      // into `src/` to stub a broken loader.
      final db = UsdaDb();
      await expectLater(
        db.queryFood(id: 167512),
        throwsA(isA<UsdaDbException>()),
      );

      when(() => fileLoader.loadData(fileName: FileService.fileNameFoods))
          .thenThrow(UsdaDbFileException('missing asset', StackTrace.current));
      await expectLater(
        db.init(fileLoader: fileLoader),
        throwsA(isA<UsdaDbException>()),
      );

      when(() => fileLoader.loadData(fileName: FileService.fileNameFoods))
          .thenAnswer((_) async => 'not json');
      await expectLater(
        db.init(fileLoader: fileLoader),
        throwsA(isA<UsdaDbException>()),
      );

      // Named only to prove they are exported - they are thrown from inside
      // the package and wrapped in `UsdaDbException` by `init`.
      expect(
        UsdaDbFormatException('x').toString(),
        contains('UsdaDbFormatException'),
      );
    });

    test('the nutrient models are reachable from a queried food', () async {
      final db = UsdaDb();
      await db.init(fileLoader: fileLoader);
      addTearDown(db.dispose);

      final food = await db.queryFood(id: 167512);
      final calories = food!.nutrient(1008);

      expect(calories, isA<UsdaNutrientModel>());
      expect(calories?.amount, 307);
      expect(calories?.name, UsdaNutrientModel.nameFor(1008));
      expect(calories?.unit, UsdaNutrientModel.unitFor(1008));
      expect(calories?.isKnown, true);
      expect(food.nutrientList, hasLength(food.nutrients.length));
    });
  });
}
