import 'dart:convert';

// `compute` rather than `Isolate.run` from dart:isolate - see the note in
// foods_data.dart: `Isolate.run` throws on web, `compute` degrades to an inline
// call there.
import 'package:flutter/foundation.dart' show compute;
import 'package:usda_db_package/src/exceptions.dart';
import 'package:usda_db_package/src/initializer.dart';

///
/// Class to represent the [AutoCompleteData]'s structure and methods.
///
/// This class implements the [DataInitializer] interface, which provides a method to
/// initialize the [AutoCompleteData] instance from a JSON string.
///
/// The [AutoCompleteData] class represents a substring tree and a lookup table for
///  substring values. The lookup table is a map of substring values to a list of food IDs.
///
/// The [substringHash] property is a map that stores the substring values as keys
/// and their corresponding hash values as values.
///
/// The [indexHash] property is a map that stores the hash values as keys and the
/// list of food IDs as values.
///
/// The [init] method populates the [substringHash] and [indexHash] properties
/// from the given JSON string. It decodes the JSON string, converts the index hash a
/// nd substring hash to the proper types, and stores them in the respective properties.
///
/// The [clear] method reverts the data to an empty state by clearing the
/// [substringHash] and [indexHash] maps.
///
/// The [getFoodIndexes] method takes a substring as input and returns a
/// list of food IDs associated with that substring. It retrieves the hash value of
/// the substring from the [substringHash] map and uses it to retrieve the corresponding
/// list of food IDs from the [indexHash] map. If the substring is not found in the
/// [substringHash] map, an empty list is returned.
///
/// The decoding and the conversion to the proper types happen on a background
/// isolate, so a multi-megabyte autocomplete file does not stall the UI.
///
/// Example usage:
/// ```dart
/// final autoCompleteData = AutoCompleteData();
/// await autoCompleteData.init(jsonString: jsonString);
/// final foodIndexes = autoCompleteData.getFoodIndexes(substring: 'aba');
/// ```
///
/// Note: This class assumes that the JSON string provided for
///  initialization follows a specific format, as described in the class documentation.
/// /// The json file format is as follows:
/// /*Cspell:disable
/// ```dart
///  {
/// substringHash = {
///   'aba': 0,
///   'abap': 0,
///   'abapp': 0,
///   'abappl': 1,
///   'abapple': 0, ...
///    },
///   indexHash = {
///     0: [3, 4],
///     1: [1, 2, 3, 4]
///    }
///   }
/// ```
///  /*Cspell:enable

class AutoCompleteData implements DataInitializer {
  final Map<String, int> _substringHash = {};
  final Map<int, List<int>> _indexHash = {};

  Map<String, int> get substringHash => _substringHash;
  Map<int, List<int>> get indexHash => _indexHash;

  /// Initializes the instance by populating the [substringHash] and [indexHash] properties
  /// using the provided [jsonString].
  ///
  /// The decode and the type conversion run on a background isolate.
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

  /// Resets the instance to its initial state by clearing the
  /// [substringHash] and [indexHash] properties.
  void clear() {
    _substringHash.clear();
    _indexHash.clear();
  }

  /// Returns a list of food IDs associated with the provided [substring].
  /// If the [substring] is not found, an empty list is returned.
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
