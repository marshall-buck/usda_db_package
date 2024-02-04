import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/file_service.dart';

class MockFileLoaderService extends Mock implements FileService {}

late final FileService mockFileLoaderService;

// ignore_for_file: non_constant_identifier_names
tear_down() {
  reset(mockFileLoaderService);
}

set_up_all() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockFileLoaderService = MockFileLoaderService();
}
