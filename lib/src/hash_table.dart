import 'dart:convert';

import 'package:usda_db_package/src/file_loader_service.dart';
import 'dart:developer' as dev;

class SubStringHash {
  FileLoaderService fileLoader;

  Map<String, int>? _substrings;
  Map<String, int>? get substrings => _substrings;
  Map<int, List<String>>? _indexHash;
  Map<int, List<String>>? get indexHash => _indexHash;

  static final SubStringHash _singleton = SubStringHash._internal();
  SubStringHash._internal() : fileLoader = FileLoaderService();
  factory SubStringHash(FileLoaderService fileLoader) {
    _singleton.fileLoader = fileLoader;
    return _singleton;
  }

  /// Populates [_hashTable]
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  Future<void> init(path) async {
    await _loadData(path);

    dev.log('init()',
        name:
            'WordIndex -  ${_substrings != null && _indexHash != null ? "success" : "either hashTable or substrings is null is null"}');
  }

  /// Disposes indexes.
  void dispose() {
    _substrings = null;
    _indexHash = null;
  }

  /// Opens the  file.
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  ///
  /// Returns a [Map] of the file, or {}, on error.
  Future<void> _loadData(String path) async {
    final String response = await fileLoader.loadData(path);
    Map<String, dynamic> jsonMap = await json.decode(response);
    Map<int, List<String>> hash = await _parseIndexHash(jsonMap['indexHash']);
    Map<String, int> substrings = await _parseSubstrings(jsonMap['substrings']);
    _indexHash = hash;
    _substrings = substrings;
  }

  /// Converts a Map<String, dynamic> to Map<int, List<String>>.
  Future<Map<int, List<String>>> _parseIndexHash(
      Map<String, dynamic> jsonMap) async {
    Map<int, List<String>> convertedMap = jsonMap.map((key, value) {
      List<String> convertedValue = (value).cast<String>();
      return MapEntry(int.parse(key), convertedValue);
    });
    return convertedMap;
  }

  Future<Map<String, int>> _parseSubstrings(
      Map<String, dynamic> jsonMap) async {
    Map<String, int> convertedMap = jsonMap.map((key, value) {
      return MapEntry(key, value as int);
    });
    return convertedMap;
  }

  // List<String>? getIndexes(int hash) => hashTable?[hash];
}
