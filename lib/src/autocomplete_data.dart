import 'dart:convert';

// `compute` rather than `Isolate.run` from dart:isolate - see the note in
// foods_data.dart: `Isolate.run` throws on web, `compute` degrades to an inline
// call there.
import 'package:flutter/foundation.dart' show compute;
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/initializer.dart';

/// The autocomplete index: which foods a search substring matches.
///
/// The lookup is two hops. [substringHash] maps a substring to a key, and
/// [indexHash] maps that key to the food ids whose description contains it -
/// so every substring matching the same set of foods shares one list instead
/// of repeating it. [getFoodIndexes] walks both.
///
/// ```dart
/// final autoCompleteData = AutoCompleteData();
/// await autoCompleteData.init(jsonString: jsonString);
/// final foodIndexes = autoCompleteData.getFoodIndexes(substring: 'aba');
/// ```
///
/// The shape of the file [init] expects, which the code alone does not give
/// away:
/// <!-- Cspell:disable -->
/// ```json
/// {
///   "substringHash": {"aba": 0, "abap": 0, "abappl": 1, "abapple": 0},
///   "indexHash": {"0": [3, 4], "1": [1, 2, 3, 4]}
/// }
/// ```
/// <!-- Cspell:enable -->
class AutoCompleteData implements DataInitializer {
  final Map<String, int> _substringHash = {};
  final Map<int, List<int>> _indexHash = {};

  /// Maps a searchable substring to the key of its entry in [indexHash].
  Map<String, int> get substringHash => _substringHash;

  /// Maps a [substringHash] value to the food ids that match that substring.
  Map<int, List<int>> get indexHash => _indexHash;

  /// Builds [substringHash] and [indexHash] from [jsonString], replacing
  /// whatever was there.
  ///
  /// The decode and the type conversion run on a background isolate. Neither
  /// map is published unless the whole file converts.
  ///
  /// Throws a [DBFormatException] if the JSON string cannot be decoded.
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final parsed = await compute(_parseAutoCompleteData, jsonString);
      _substringHash
        ..clear()
        ..addAll(parsed.substringHash);
      _indexHash
        ..clear()
        ..addAll(parsed.indexHash);
    } catch (e, st) {
      throw DBFormatException('Error decoding autocomplete JSON: $e', st);
    }
  }

  /// Empties both maps.
  void clear() {
    _substringHash.clear();
    _indexHash.clear();
  }

  /// The food ids matching [substring], empty if it is not in the index.
  List<int> getFoodIndexes({required String substring}) =>
      _indexHash[_substringHash[substring]] ?? [];
}

/// Decodes [jsonString] and converts both hashes to their proper types.
///
/// Top level so it can be handed to [compute] and run on a background isolate.
({Map<String, int> substringHash, Map<int, List<int>> indexHash})
    _parseAutoCompleteData(String jsonString) {
  final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
  final indexHashFromJson = jsonMap['indexHash'] as Map<String, dynamic>;
  final substringHashFromJson =
      jsonMap['substringHash'] as Map<String, dynamic>;

  if (indexHashFromJson.isEmpty) {
    throw const FormatException('IndexHash is empty');
  }
  if (substringHashFromJson.isEmpty) {
    throw const FormatException('SubstringHash is empty');
  }

  final indexHash = <int, List<int>>{};
  indexHashFromJson.forEach((key, value) {
    indexHash[int.parse(key)] = List<int>.from(value as Iterable);
  });

  final substringHash = <String, int>{};
  substringHashFromJson.forEach((key, value) {
    substringHash[key] = value as int;
  });

  return (substringHash: substringHash, indexHash: indexHash);
}
