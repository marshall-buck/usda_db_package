import 'dart:convert';

import 'package:usda_db/src/file_loader_service.dart';

class WordIndex {
  FileLoaderService fileLoader;
  Map<String, List<String>>? _indexes;
  Map<String, List<String>>? get indexes => _indexes;

  static final WordIndex _singleton = WordIndex._internal();
  WordIndex._internal() : fileLoader = FileLoaderService();
  factory WordIndex(FileLoaderService fileLoader) {
    _singleton.fileLoader = fileLoader;
    return _singleton;
  }

  /// Populates [_indexes]
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  Future<void> init(path) async {
    Map<String, List<String>> dbMap = await _loadData(path);
    _indexes = dbMap;
  }

  /// Disposes indexes.
  void dispose() => _indexes = null;

  /// Opens the  file.
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  ///
  /// Returns a [Map] of the file, or {}, on error.
  Future<Map<String, List<String>>> _loadData(String path) async {
    final String response = await fileLoader.loadData(path);
    Map<String, dynamic> jsonMap = await json.decode(response);

    return await _convertJsonMapTypes(jsonMap);
  }

  /// Finds all indexes for all words.
  ///
  /// Parameters
  /// - [list] A list of words to search.
  ///
  /// Returns [output].
  ///
  Future<Set<String>> getIndexes(List<String> words) async {
    final Set<String> output = {};
    for (final word in words) {
      final indexes = _getIndexesForWord(word);
      if (indexes.isNotEmpty) {
        output.addAll(indexes);
      }
    }
    return output;
  }

  /// Converts a Map<String, dynamic> to Map<String, List<String>>.
  Future<Map<String, List<String>>> _convertJsonMapTypes(
      Map<String, dynamic> jsonMap) async {
    Map<String, List<String>> convertedMap = jsonMap.map((key, value) {
      List<String> convertedValue = (value).cast<String>();
      return MapEntry(key, convertedValue);
    });
    return convertedMap;
  }

  /// Finds indexes for one word
  ///
  /// Parameters:
  /// [word]
  ///Returns a List of strings representing a [LocalFoodItem's] index
  ///
  List<String> _getIndexesForWord(String word) => _indexes![word] ?? [];
}
