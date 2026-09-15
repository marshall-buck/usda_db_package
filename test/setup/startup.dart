import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/usda_db_package.dart';

import 'mock_file_strings.dart';

class MockFileService extends Mock implements FileService {}

/// A fresh [FileService] mock, already stubbed to hand back the mock data
/// files.
///
/// Built per call rather than shared through a top-level `late final`: that
/// only worked because each test file gets its own isolate, it throws on a
/// second `setUpAll` in the same isolate, and a mock shared between tests
/// carries its stubs and its recorded invocations from one into the next.
///
/// Re-stub inside a test to change one file's behaviour - the later `when`
/// wins:
///
/// ```dart
/// when(() => fileLoader.loadData(fileName: FileService.fileNameFoods))
///     .thenThrow(Exception('boom'));
/// ```
MockFileService mockFileService() {
  final mock = MockFileService();
  when(() => mock.loadData(fileName: FileService.fileNameFoods))
      .thenAnswer((_) async => mockDBString);
  when(() => mock.loadData(fileName: FileService.fileNameAutocompleteData))
      .thenAnswer((_) async => mockHashString);
  return mock;
}
