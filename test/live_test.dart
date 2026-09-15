import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

// The only test file that touches the real asset bundle, and the one file with
// no counterpart in `lib/` - it exercises the whole package end to end.
// Everything that can be shown with stubbed data belongs beside its class in
// `test/src/`, so what is left here is what only the shipped ~8 MB can show:
// that the assets are present and decodable, and that the search counts
// against the full index are what they should be.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Live tests', () {
    // One instance for the read-only query tests: `init` parses ~8 MB, and
    // doing that per test made this file most of the suite's runtime. The
    // dispose test below builds its own, because it mutates state.
    late UsdaDbDAO db;

    setUpAll(() async {
      db = UsdaDbDAO();
      await db.init();
    });

    tearDownAll(() => db.dispose());

    test('init loads the bundled files', () {
      expect(db.isDataLoaded, true);
    });

    test('dispose empties a live db', () async {
      final ownDb = UsdaDbDAO();
      await ownDb.init();

      ownDb.dispose();

      expect(ownDb.isDataLoaded, false);
    });

    group('queryFood() - ', () {
      test('returns the real food for an id', () async {
        final foodItem = await db.queryFood(id: 167512);

        expect(
          foodItem?.description,
          'Pillsbury Golden Layer Buttermilk Biscuits, Artificial Flavor, '
          'refrigerated dough',
        );
      });
    });

    group('queryFoods() - ', () {
      test('one word term, 2 chars length', () async {
        final list = await db.queryFoods(searchString: 'tr');

        expect(list, hasLength(1455));
      });
      test('one word term', () async {
        final list = await db.queryFoods(searchString: 'aba');

        expect(list, hasLength(14));
      });
      test('all parameter false, one input matches and one does not', () async {
        final list = await db.queryFoods(searchString: 'gua rrr', all: false);

        expect(list, hasLength(10));
      });
      test('returns only descriptions with ALL words', () async {
        final list = await db.queryFoods(searchString: 'ste, gua');

        expect(list, hasLength(1));
      });
      test('returns only descriptions with ANY words', () async {
        final list = await db.queryFoods(searchString: 'ste, gua', all: false);

        expect(list, hasLength(1101));
      });
      test('matches a description that mixes dashes and parentheses', () async {
        final list = await db.queryFoods(
          searchString: 'Cabbage, chinese (pak-choi), raw',
        );

        expect(list.map((food) => food.description), [
          'Cabbage, chinese (pak-choi), raw',
        ]);
      });
    });
  });
}
