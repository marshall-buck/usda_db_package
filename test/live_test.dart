// import 'package:flutter_test/flutter_test.dart';

// import 'package:usda_db_package/src/models/models.dart';

// import 'package:usda_db_package/src/usda_db_base.dart';

// import './setup/startup.dart';

// void main() {
//   setUpAll(setUpStartup);
//   tearDown(tearDownStartup);

//   group('Live  tests', () {
//     group('init() - ', () {
//       test('loads properties', () async {
//         final db = UsdaDB();
//         await db.init();

//         expect(db.isDataLoaded, true);
//         await db.dispose();
//       });
//     });
//     group('isDataLoaded(),and dispose() - ', () {
//       test('returns false if properties are empty', () async {
//         final db = UsdaDB();
//         await db.init();
//         await db.dispose();
//         expect(db.isDataLoaded, equals(false));
//       });
//     });

//     group('queryFood() - ', () {
//       test('returns a FoodModel', () async {
//         final db = UsdaDB();
//         await db.init();
//         final foodItem = await db.queryFood(id: 167512);
//         expect(foodItem, isNotNull);
//         expect(foodItem, isA<SrLegacyFoodModel>());
//         await db.dispose();
//       });
//       test('returns null if no food', () async {
//         final db = UsdaDB();
//         await db.init();
//         final foodItem = await db.queryFood(id: 1675121);
//         expect(foodItem, isNull);
//         await db.dispose();
//       });
//     });

//     group('queryFoods() - ', () {
//       test('returns a list of FoodModels, with one word term 2 chars length',
//           () async {
//         final db = UsdaDB();
//         await db.init();
//         final list = await db.queryFoods(searchString: 'trimmed');
//         print(list.length);
//         // expect(list, isNotEmpty);
//         // expect(list.length, 3);
//         // expect(list[0], isA<SrLegacyFoodModel>());
//         // await db.dispose();
//       });
//       test('returns a list of FoodModels, with one word term', () async {
//         final db = UsdaDB();
//         await db.init();
//         final list = await db.queryFoods(searchString: 'aba');
//         // expect(list, isNotEmpty);
//         // expect(list.length, 3);
//         // expect(list[0], isA<SrLegacyFoodModel>());
//         // await db.dispose();
//       });

//       test(
//           'expect list to be empty with no results with 2 word input, each input does not have a match',
//           () async {
//         final db = UsdaDB();
//         await db.init();
//         final list = await db.queryFoods(searchString: 'aa rrr');
//         // expect(list, isEmpty);
//         // await db.dispose();
//       });
//       test(
//           'expect list to be empty with no results with 2 word input, one input does not have a match and one does',
//           () async {
//         final db = UsdaDB();
//         await db.init();
//         final list = await db.queryFoods(searchString: 'aab rrr');
//         expect(list, isEmpty);
//         await db.dispose();
//       });

//       test('expect list to return only descriptions with ALL words', () async {
//         final db = UsdaDB();
//         await db.init();
//         final list = await db.queryFoods(searchString: 'aba, dough');
//         // expect(list.length, 1);
//         // await db.dispose();
//       });
//       test('expect list to return only descriptions with ANY words', () async {
//         final db = UsdaDB();
//         await db.init();
//         final list =
//             await db.queryFoods(searchString: 'aba, dough', all: false);
//         // expect(list.length, 4);
//         // await db.dispose();
//       });
//       test('expect list to return with 2 letter words', () async {
//         final db = UsdaDB();
//         await db.init();
//         final list =
//             await db.queryFoods(searchString: 'aba, dough', all: false);
//         // expect(list.length, 4);
//         // await db.dispose();
//       });
//     });
//   });
// }