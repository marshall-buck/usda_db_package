// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/file_loader_service.dart';
import 'package:usda_db_package/src/foods.dart';

import 'package:usda_db_package/src/prefix_tree.dart';
import 'package:usda_db_package/src/substring_hash.dart';
import 'package:usda_db_package/src/usda_db_base.dart';
import 'package:usda_db_package/src/word_index.dart';

import 'package:path/path.dart' as p;

final pathToTestFile = p.join('assets', 'text.txt');

// Create a mock for FileLoaderService
class MockFileLoaderService extends Mock implements FileLoaderService {}

class MockFoodsList extends Mock implements Foods {}

class MockPrefixTree extends Mock implements PrefixTree {}

class MockWordIndex extends Mock implements WordIndex {}

class MockSubStringHash extends Mock implements SubStringHash {}

// Instantiate a mock object
late final FileLoaderService mockFileLoaderService;
late final Foods mockFoods;
late final PrefixTree mockTree;
late final WordIndex mockWords;
late final SubStringHash substringHashWithMockLoader;

// // Instantiate the actual instance
late final FileLoaderService fileLoaderService;
late final Foods foodsListWithMockLoader;
late final WordIndex wordIndexWithMockLoader;
late final PrefixTree prefixTreeWithMockLoader;
late final DB dbWithMockFileLoader;
// late final SubStringHash hashTableWithMockLoader;

tear_down() {
  reset(mockFileLoaderService);
}
