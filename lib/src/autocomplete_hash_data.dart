import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

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
class AutoCompleteHashData {
  final Map<String, int> substringHash = {};
  final Map<int, List<int>> indexHash = {};
  late final String jsonString;

  AutoCompleteHashData({required this.jsonString});

  Future<void> _fromJson() async {
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      Map<String, int> substringHash = jsonMap['substringHash'];
      Map<int, List<int>> indexHash = jsonMap['indexHash'];
      indexHash.deepConvertMapKeyToInt();

      if (substringHash.isEmpty || indexHash.isEmpty) {
        dev.log('Error decoding JSON',
            name: 'AutoCompleteHashData.fromJson',
            error: 'Invalid JSON format');
        throw FormatException('Invalid JSON format');
      }
    } catch (e, st) {
      dev.log('Error decoding JSON',
          name: 'AutoCompleteHashData', error: e.toString(), stackTrace: st);
      throw FileSystemException(e.toString());
    }
  }
}
