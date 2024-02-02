import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/autocomplete_hash_data.dart';

import 'package:usda_db_package/src/file_service.dart';

import '../setup/mock_file_strings.dart';
import '../setup/startup.dart';

void main() {
  group('AutoCompleteHashData', () {
    final hashData = AutoCompleteHashData();
    group('init() - ', () {
      test('properties are not empty', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);

        expect(hashData.indexHash, isNotEmpty);
        expect(hashData.substringHash, isNotEmpty);
        expect(
          hashData.indexHash.entries.first.value,
          [170381, 170382],
        );
        expect(
          hashData.indexHash.entries.first.key,
          0,
        );
      });
      test('substringHash is typed correctly', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        for (final element in hashData.substringHash.entries) {
          expect(element.key, isA<String>());
          expect(element.value, isA<int>());
        }
      });
      test('indexHash is typed correctly', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        for (final element in hashData.indexHash.entries) {
          expect(element.key, isA<int>());
          expect(element.value, isA<List<int>>());
        }
      });
      test('throws FormatException if either properties are empty', () async {
        final emptyJson = jsonEncode({'substringHash': {}, 'indexHash': {}});

        expect(
          () async => await hashData.init(jsonString: emptyJson),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException if invalid json', () async {
        final invalidJson = '{substringHash: {}}';

        expect(
          () async => await hashData.init(jsonString: invalidJson),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
