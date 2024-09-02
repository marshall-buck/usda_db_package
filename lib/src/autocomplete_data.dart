import 'dart:convert';
import 'dart:developer' as dev;

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
/// from the given JSON string. It decodes the JSON string, converts the index hash and substring hash to the proper types, and stores them in the respective properties.
///
/// The [clear] method reverts the data to an empty state by clearing the
/// [substringHash] and [indexHash] maps.
///
/// The [getFoodIndexes] method takes a [substring] as input and returns a
/// list of food IDs associated with that substring. It retrieves the hash value of the substring from the [substringHash] map and uses it to retrieve the corresponding list of food IDs from the [indexHash] map. If the substring is not found in the [substringHash] map, an empty list is returned.
///
/// The [AutoCompleteData] class also includes private helper methods
/// [_convertIndexHashToType] and [_convertSubstringHashToType] to convert the
/// index hash and substring hash from the JSON format to the proper types.
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
/// ```
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
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final Map<String, dynamic> jsonMap = await jsonDecode(jsonString);
      _convertIndexHashToType(jsonMap['indexHash']);
      _convertSubstringHashToType(jsonMap['substringHash']);
    } catch (e, st) {
      dev.log('Error decoding JSON',
          name: 'AutoCompleteHashData', error: e.toString(), stackTrace: st);
      throw FormatException('Error decoding JSON: $e');
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
  List<int?> getFoodIndexes({required String substring}) =>
      _indexHash[_substringHash[substring]] ?? [];

  /// Converts the provided JSON map into the appropriate type for the [_indexHash] property.
  void _convertIndexHashToType(Map<String, dynamic> mapFromJson) {
    if (mapFromJson.isEmpty) {
      dev.log('IndexHash is empty',
          name: 'AutoCompleteHashData.fromJson', error: 'IndexHash is empty');
      throw const FormatException('IndexHash is empty');
    }
    mapFromJson.forEach((key, value) {
      _indexHash[int.parse(key)] = List<int>.from(value);
    });
  }

  /// Converts the provided JSON map into the appropriate type for the [_substringHash] property.
  void _convertSubstringHashToType(Map<String, dynamic> mapFromJson) {
    if (mapFromJson.isEmpty) {
      dev.log('SubstringHash is empty',
          name: 'AutoCompleteHashData.fromJson',
          error: 'SubstringHash is empty');
      throw const FormatException('SubstringHash is empty');
    }
    mapFromJson.forEach((key, value) {
      _substringHash[key] = value;
    });
  }
}
