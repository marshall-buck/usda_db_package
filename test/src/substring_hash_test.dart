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
  group('getHashLookup() -', () {
    test('Returns correct number', () async {
      await substringHashWithMockLoader.init('fake');
      final aab = await substringHashWithMockLoader.getHashLookup('aab');
      expect(aab, 0);
      final abapple =
          await substringHashWithMockLoader.getHashLookup('abapple');
      expect(abapple, 6);
    });
    test('Returns -1 on no term', () async {
      await substringHashWithMockLoader.init('fake');
      final noTerm = await substringHashWithMockLoader.getHashLookup('noTerm');
      expect(noTerm, -1);
    });
  });
  group('getIndexes() -', () {
    test('Returns correct List', () async {
      await substringHashWithMockLoader.init('fake');
      final aab = await substringHashWithMockLoader.getIndexes(0);
      expect(aab, ["170381", "170382"]);
      final aba = await substringHashWithMockLoader.getIndexes(2);
      expect(aba, [
        "168196",
        "168454",
        "168455",
        "169093",
        "169232",
        "169233",
        "169353",
        "169400",
        "170528",
        "171428",
        "171721",
        "174212",
        "174213",
        "174528"
      ]);
    });
    test('Returns [] on no hash', () async {
      await substringHashWithMockLoader.init('fake');
      final noTerm = await substringHashWithMockLoader.getIndexes(22);
      expect(noTerm, []);
    });
  });
}
