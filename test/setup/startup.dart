import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/file_service.dart';

class MockFileLoaderService extends Mock implements FileService {}

// class MockFoodsList extends Mock implements Foods {}

// class MockSubStringHash extends Mock implements SubStringHash {}

late final FileService mockFileLoaderService;

// ignore_for_file: non_constant_identifier_names
tear_down() {
  reset(mockFileLoaderService);
  // foodsListWithMockLoader.dispose();
  // substringHashWithMockLoader.dispose();
  // dbWithMockFileLoader.dispose();
}

set_up_all() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockFileLoaderService = MockFileLoaderService();
  // fileLoaderService = FileService();
  // foodsListWithMockLoader = Foods(mockFileLoaderService);
  // substringHashWithMockLoader = SubStringHash(mockFileLoaderService);
  // dbWithMockFileLoader = DB(fileLoader: mockFileLoaderService);
}
