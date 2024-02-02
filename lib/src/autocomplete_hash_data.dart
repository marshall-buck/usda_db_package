import 'dart:convert';
import 'dart:developer' as dev;

import 'package:usda_db_package/src/initializer.dart';

/// Class to represent the [AutoCompleteHashData]'s structure and methods.
/// This is the data structure that represents a substring tree, and a lookup table
/// for the substrings values.
///
/// The json file format is as follows:
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
class AutoCompleteHashData implements Initializer {
  final Map<String, int> _substringHash = {};
  final Map<int, List<int>> _indexHash = {};

  Map<String, int> get substringHash => _substringHash;
  Map<int, List<int>> get indexHash => _indexHash;

  /// Populates the [substringHash] and [indexHash] properties, from
  /// the given [jsonString].
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final Map<String, dynamic> jsonMap = await jsonDecode(jsonString);
      _convertIndexHashToType(jsonMap['indexHash']);
      _convertSubstringHashToType(jsonMap['substringHash']);
    } catch (e, st) {
      dev.log('Error decoding JSON',
          name: 'AutoCompleteHashData', error: e.toString(), stackTrace: st);
      throw const FormatException('Error decoding JSON');
    }
  }

  /// Gets the list of indexes from the [substring].
  List<int?> getIndexes({required String substring}) {
    if (_substringHash.containsKey(substring)) {
      final lookUpIndex = _substringHash[substring];
      return _indexHash[lookUpIndex] ?? [];
    }
    return [];
  }

  /// Convert to proper types
  void _convertIndexHashToType(Map<String, dynamic> map) {
    if (map.isEmpty) {
      dev.log('IndexHash is empty',
          name: 'AutoCompleteHashData.fromJson', error: 'IndexHash is empty');
      throw const FormatException('IndexHash is empty');
    }
    map.forEach((key, value) {
      _indexHash[int.parse(key)] = List<int>.from(value);
    });
  }

  /// Convert to proper types
  void _convertSubstringHashToType(Map<String, dynamic> map) {
    if (map.isEmpty) {
      dev.log('SubstringHash is empty',
          name: 'AutoCompleteHashData.fromJson',
          error: 'SubstringHash is empty');
      throw const FormatException('SubstringHash is empty');
    }
    map.forEach((key, value) {
      _substringHash[key] = value;
    });
  }
}
