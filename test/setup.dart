import 'package:mocktail/mocktail.dart';
import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/foods.dart';

// Create a mock for FileLoaderService
class MockFileLoaderService extends Mock implements FileLoaderService {}

// Instantiate a mock object
final FileLoaderService mockFileLoaderService = MockFileLoaderService();

// // Instantiate the actual instance
final FileLoaderService fileLoaderService = FileLoaderService();
final Foods foodsListMockLoader = Foods(mockFileLoaderService);
