// ignore_for_file: non_constant_identifier_names

import 'package:mocktail/mocktail.dart';
import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/foods.dart';
import 'package:usda_db/src/prefix_tree.dart';
import 'package:usda_db/src/word_index.dart';

// Create a mock for FileLoaderService
class MockFileLoaderService extends Mock implements FileLoaderService {}

// Instantiate a mock object
late final FileLoaderService mockFileLoaderService;

// // Instantiate the actual instance
late final FileLoaderService fileLoaderService;
late final Foods foodsListWithMockLoader;
late final WordIndex wordIndexWithMockLoader;
late final PrefixTree prefixTreeWithMockLoader;

// void setUp() {
//   mockFileLoaderService = MockFileLoaderService();
//   fileLoaderService = FileLoaderService();
//   foodsListWithMockLoader = Foods(mockFileLoaderService);
// }

tear_down() {
  reset(mockFileLoaderService);
}
