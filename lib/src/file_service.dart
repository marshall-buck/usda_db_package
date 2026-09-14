import 'dart:developer' as dev;

// One of the two reasons this is a Flutter package rather than a pure Dart one:
// the data files are declared under `flutter: assets:` in pubspec.yaml, and
// rootBundle is what reads them out of a consuming app's bundle. A pure Dart
// package cannot declare assets at all. (The other reason is `compute`, in
// foods_data.dart and autocomplete_data.dart.)
import 'package:flutter/services.dart' show rootBundle;

import 'exceptions.dart';

/// A class that provides file-related services.
///
/// The [loadData] method takes a fileName parameter and returns the
/// contents of the file as a [String].
///
/// The [fileNameManifest] is the name of the manifest file that contains the hash
/// of the data files.
/// The [fileNameFoods] is the name of the file that contains the
/// food data.
/// The [fileNameAutocompleteData] is the name of the file that contains
/// the autocomplete data.
///
/// The [_getFileHash] method retrieves the hash from the manifest file.
class FileService {
  static const String _dataPath = 'packages/usda_db_package/lib/data';
  static const String fileNameManifest = 'file_manifest.txt';
  static const String fileNameFoods = 'foods_db.json';
  static const String fileNameAutocompleteData = 'autocomplete_hash.json';

  /// Returns the contents of the file as a [String].
  ///
  /// Throws a [DBFileException] if the asset cannot be loaded.
  Future<String> loadData({required String fileName}) async {
    final fileHash = await _getFileHash();
    final assetPath = '$_dataPath/${fileHash}_$fileName';

    return _loadAsset(assetPath);
  }

  /// Opens the manifest file and returns the hash.
  ///
  /// Throws a [DBFileException] if the asset cannot be loaded.
  Future<String> _getFileHash() => _loadAsset('$_dataPath/$fileNameManifest');

  /// Reads [assetPath] from the bundle, logging and rethrowing any failure as
  /// a [DBFileException].
  Future<String> _loadAsset(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e, st) {
      dev.log(
        'Error loading file at $assetPath',
        name: 'FileService',
        error: e.toString(),
        stackTrace: st,
      );
      throw DBFileException('Error loading file at $assetPath: $e', st);
    }
  }
}
