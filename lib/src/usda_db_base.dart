// import 'package:database/src/food_model.dart';
// import 'package:database/src/foods.dart';
// import 'package:database/src/prefix_tree.dart';
// import 'package:database/src/word_index.dart';

// class DB {
//   static DB? _instance;

//   static Future<DB?> init() async {
//     return _instance;
//   }

//   void remove() {
//     _instance = null;
//   }

//   /// Gets one food  from database
//   Future<FoodModel?> getFood(String index) async => Foods.getFood(index);

//   /// Gets all words for a search term
//   Future<List<String?>> getWordsFromTerm(String term) async =>
//       PrefixTree.searchByPrefix(term);

//   static Future<List<dynamic>> _loadData() async {
//     return await Future.wait([_initTree(), _initWordIndex(), _initFoods()],
//         eagerError: true);
//   }

//   static Future<void> _initTree() async =>
//       await PrefixTree.init('lib/assets/prefix_tree.json');

//   static Future<void> _initWordIndex() async =>
//       await WordIndex.init('lib/assets/db_word_index.json');

//   static Future<void> _initFoods() async =>
//       await Foods.init('lib/assets/db_food.json');
// }
