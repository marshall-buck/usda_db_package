// ignore_for_file: non_constant_identifier_names

import 'package:mocktail/mocktail.dart';
import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/foods.dart';
import 'package:usda_db/src/prefix_tree.dart';
import 'package:usda_db/src/word_index.dart';
import 'package:usda_db/usda_db.dart';

// Create a mock for FileLoaderService
class MockFileLoaderService extends Mock implements FileLoaderService {}

class MockFoodsList extends Mock implements Foods {
  // @override
  // FileLoaderService fileLoader;
  // MockFoodsList(this.fileLoader);
}

class MockPrefixTree extends Mock implements PrefixTree {}

class MockWordIndex extends Mock implements WordIndex {}

// Instantiate a mock object
late final FileLoaderService mockFileLoaderService;
late final Foods mockFoods;
late final PrefixTree mockTree;
late final WordIndex mockWords;

// // Instantiate the actual instance
late final FileLoaderService fileLoaderService;
late final Foods foodsListWithMockLoader;
late final WordIndex wordIndexWithMockLoader;
late final PrefixTree prefixTreeWithMockLoader;
late final DB dbWithMockFileLoader;

// void setUp() {
//   mockFileLoaderService = MockFileLoaderService();
//   fileLoaderService = FileLoaderService();
//   foodsListWithMockLoader = Foods(mockFileLoaderService);
// }

tear_down() {
  reset(mockFileLoaderService);
}
