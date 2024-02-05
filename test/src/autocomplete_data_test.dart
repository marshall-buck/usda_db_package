import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:usda_db_package/src/autocomplete_data.dart';

import '../setup/mock_file_strings.dart';

void main() {
  group('AutoCompleteHashData', () {
    final hashData = AutoCompleteData();
    group('init() - ', () {
      test('properties are not empty', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);

        expect(hashData.indexHash, isNotEmpty);
        expect(hashData.substringHash, isNotEmpty);
        expect(
          hashData.indexHash.entries.first.value,
          [167512, 167513],
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
        const invalidJson = '{substringHash: {}}';

        expect(
          () async => await hashData.init(jsonString: invalidJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('getFoodIndexes() - ', () {
      test('returns correct indexes', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        final indexes = hashData.getFoodIndexes(substring: 'aab');
        const d = DeepCollectionEquality();
        expect(d.equals(indexes, [167512, 167513]), true);
      });
      test('returns empty list if substring not found', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        final indexes = hashData.getFoodIndexes(substring: 'not found');
        expect(indexes.isEmpty, true);
        expect(indexes, isA<List>());
      });
    });
  });
}
