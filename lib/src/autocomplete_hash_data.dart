import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:usda_db_package/src/initializer.dart';

import './extensions/map_ext.dart';

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
  late final Map<String, int> _substringHash;
  late final Map<int, List<int>> _indexHash;

  Map<String, int> get substringHash => _substringHash;
  Map<int, List<int>> get indexHash => _indexHash;

  /// Populates the [substringHash] and [indexHash] properties, from
  /// the given [jsonString].
  @override
  Future<void> init({required String jsonString}) async {
    try {
      final Map<String, dynamic> jsonMap = await jsonDecode(jsonString);
      // Manually converting the dynamic types to the expected Map types
      _substringHash = {};
      jsonMap['substringHash'].forEach((key, value) {
        _substringHash[key] = value;
      });

      _indexHash = {};
      jsonMap['indexHash'].forEach((key, value) {
        _indexHash[int.parse(key)] = List<int>.from(value);
      });

      if (_substringHash.isEmpty || _indexHash.isEmpty) {
        dev.log('Properties are empty',
            name: 'AutoCompleteHashData.fromJson',
            error: 'Class properties must not be');
        throw FormatException('Class properties must not be empty');
      }
    } catch (e, st) {
      dev.log('Error decoding JSON',
          name: 'AutoCompleteHashData', error: e.toString(), stackTrace: st);
      throw FormatException('Error decoding JSON');
    }
  }
}
