import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/hash_table.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  setUpAll(() {
    mockFileLoaderService = MockFileLoaderService();
    hashTableWithMockLoader = SubStringHash(mockFileLoaderService);
  });
  setUp(() async {
    when(() => mockFileLoaderService.loadData('fake'))
        .thenAnswer((_) async => testHashTable);
  });
  group('init() -', () {
    test('Loads file correctly', () async {
      await hashTableWithMockLoader.init('fake');
      expect(hashTableWithMockLoader.indexHash, isNotEmpty);
      expect(hashTableWithMockLoader.indexHash?.length, 8);
      expect(hashTableWithMockLoader.substrings, isNotEmpty);
      expect(hashTableWithMockLoader.substrings?.length, 18);
    });
  });
}
