import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/file_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FileService', () {
    final fileService = FileService();

    test('loadData returns file contents as string', () async {
      final String fileName = 'test.json';

      final String contents = await fileService.loadData(fileName: fileName);
      expect(contents, isA<String>());
      expect(contents, isNotEmpty);
    });

    test('loadData throws exception if file does not exist', () async {
      final String fileName = 'non_existent_file.txt';

      expect(
        () async => await fileService.loadData(fileName: fileName),
        throwsA(isA<Error>()),
      );
    });
  });
}
