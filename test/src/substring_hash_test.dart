import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/substring_hash.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  setUpAll(() {
    mockFileLoaderService = MockFileLoaderService();
    substringHashWithMockLoader = SubStringHash(mockFileLoaderService);
  });
  setUp(() async {
    when(() => mockFileLoaderService.loadData('fake'))
        .thenAnswer((_) async => mocHashTable);
  });
  group('init() -', () {
    test('Loads file correctly', () async {
      await substringHashWithMockLoader.init('fake');
      expect(substringHashWithMockLoader.indexHash, isNotEmpty);
      expect(substringHashWithMockLoader.indexHash?.length, 8);
      expect(substringHashWithMockLoader.substrings, isNotEmpty);
      expect(substringHashWithMockLoader.substrings?.length, 18);

      final indexHashKeysAreInt =
          // ignore: unnecessary_type_check
          substringHashWithMockLoader.indexHash?.keys.every((k) => k is int);

      expect(indexHashKeysAreInt, isTrue);
      final substringValsAreInt =
          // ignore: unnecessary_type_check
          substringHashWithMockLoader.substrings?.values.every((v) => v is int);

      expect(substringValsAreInt, isTrue);
    });
  });
}
