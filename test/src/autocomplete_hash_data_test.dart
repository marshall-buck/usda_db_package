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
      test('loads properties', () async {
        final String json = jsonEncode(mockHashTable);

        await hashData.init(jsonString: json);
        print(hashData.substringHash);

        // expect(hashData.indexHash, isNotEmpty);
        // expect(hashData.substringHash, isNotEmpty);
        // expect(hashData.indexHash.entries.first, {
        //   0: [170381, 170382]
        // });
      });
      test('throws FormatException', () async {});
      test('throws Error', () async {});
    });
  });
}
