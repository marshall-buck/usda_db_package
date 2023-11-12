import 'dart:convert';

import 'package:usda_db_package/src/file_loader_service.dart';
import 'dart:developer' as dev;

/// Class to handle substring hash db.
class SubStringHash {
  FileLoaderService fileLoader;

  Map<String, int>? _substrings;
  Map<String, int>? get substrings => _substrings;

  Map<int, List<String>>? _indexHash;
  Map<int, List<String>>? get indexHash => _indexHash;

  SubStringHash(this.fileLoader);

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

  /// Parses the indexHash part of the json string to the [_indexHash] property
  Future<Map<int, List<String>>> _parseIndexHash(
      Map<String, dynamic> jsonMap) async {
    Map<int, List<String>> convertedMap = jsonMap.map((key, value) {
      List<String> convertedValue = (value).cast<String>();
      return MapEntry(int.parse(key), convertedValue);
    });
    return convertedMap;
  }

  /// Parses the indexHash part of the json string to the [_substrings] property
  Future<Map<String, int>> _parseSubstrings(
      Map<String, dynamic> jsonMap) async {
    Map<String, int> convertedMap = jsonMap.map((key, value) {
      return MapEntry(key, value as int);
    });
    return convertedMap;
  }

  int getHashLookup(String term) => _substrings?[term] ?? -1;

  List<String> getIndexes(int hash) => _indexHash?[hash] ?? [];
}
