import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/file_service.dart';

class MockFileLoaderService extends Mock implements FileService {}

late final FileService mockFileLoaderService;

void tearDownStartup() {
  reset(mockFileLoaderService);
}

void setUpStartup() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockFileLoaderService = MockFileLoaderService();
}
