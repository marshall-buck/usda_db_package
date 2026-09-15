import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
// `AutoCompleteData` is internal, so it comes from `src/`; `UsdaDbFormatException`
// is exported, so it comes in through the public library.
import 'package:usda_db_package/src/autocomplete_data.dart';
import 'package:usda_db_package/usda_db_package.dart';

import '../setup/mock_file_strings.dart';

void main() {
  group('AutoCompleteHashData', () {
    // Per test, not per group: `init` accumulates into the instance's maps, so
    // one shared instance made the results order-dependent.
    late AutoCompleteData hashData;

    setUp(() => hashData = AutoCompleteData());

    group('init() - ', () {
      test('properties are not empty', () async {
        final json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);

        expect(hashData.indexHash, isNotEmpty);
        expect(hashData.substringHash, isNotEmpty);
        expect(
          hashData.indexHash.entries.first.value,
          [167512, 167513, 167515],
        );
        expect(
          hashData.indexHash.entries.first.key,
          0,
        );
      });
      test('substringHash is typed correctly', () async {
        final json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        for (final element in hashData.substringHash.entries) {
          expect(element.key, isA<String>());
          expect(element.value, isA<int>());
        }
      });
      test('indexHash is typed correctly', () async {
        final json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        for (final element in hashData.indexHash.entries) {
          expect(element.key, isA<int>());
          expect(element.value, isA<List<int>>());
        }
      });
      test('throws UsdaDbFormatException if either properties are empty',
          () async {
        // ignore: inference_failure_on_collection_literal
        final emptyJson = jsonEncode({'substringHash': {}, 'indexHash': {}});

        await expectLater(
          hashData.init(jsonString: emptyJson),
          throwsA(isA<UsdaDbFormatException>()),
        );
      });

      test('throws UsdaDbFormatException if invalid json', () async {
        const invalidJson = '{substringHash: {}}';

        await expectLater(
          hashData.init(jsonString: invalidJson),
          throwsA(
            isA<UsdaDbFormatException>()
                .having(
                  (e) => e.errorMessage,
                  'errorMessage',
                  contains('FormatException'),
                )
                .having((e) => e.stackTrace, 'stackTrace', isNotNull),
          ),
        );
      });
    });

    group('getFoodIndexes() - ', () {
      test('returns correct indexes', () async {
        final json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        final indexes = hashData.getFoodIndexes(substring: 'aba');

        expect(indexes, [167512, 167513, 167515]);
      });
      test('returns empty list if substring not found', () async {
        final json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        final indexes = hashData.getFoodIndexes(substring: 'not found');

        expect(indexes, isEmpty);
      });
    });
  });
}
