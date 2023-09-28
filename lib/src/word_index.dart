import 'dart:convert';

class WordIndex {
  static Map<String, List<String>>? _indexes;
  static Map<String, List<String>>? get indexes => _indexes;

  /// Populates [_indexes]
  ///
  /// Parameters:
  /// - [path] The path of the rootBundle file.
  static Future<void> init(path) async {
    if (_indexes != null) {
      throw Exception('Indexes is already populated');
    }

    Map<String, List<String>> dbMap = await _loadData(path);
    _indexes = dbMap;
  }

  /// Null's out [_indexes].
  static void remove() {
    _indexes = null;
  }

  /// Opens the rootBundle file.
  ///
  /// Parameters:
  /// - [path] The path of the rootBundle file.
  ///
  /// Returns a [Map] of the file, or {}, on error.
  static Future<Map<String, List<String>>> _loadData(String path) async {
    final String response = await rootBundle.loadString(path, cache: false);
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
  static Future<Set<String>> getIndexes(List<String> words) async {
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
  static Future<Map<String, List<String>>> _convertJsonMapTypes(
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
  static List<String> _getIndexesForWord(String word) => _indexes![word] ?? [];
}
