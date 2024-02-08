import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer' as dev;

/// A class that provides file-related services.
///
/// The [loadData] method takes a [fileName] parameter and returns the
/// contents of the file as a [String].
///
/// The [fileNameManifest] is the name of the manifest file that contains the hash
/// of the data files.
/// The [fileNameFoods] is the name of the file that contains the
/// food data.
/// he [fileNameAutocompleteData] is the name of the file that contains
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
  /// Throws a [FileSystemException] if the file cannot be loaded.
  Future<String> loadData({required String fileName}) async {
    final fileHash = await _getFileHash();
    final String assetPath = '$_dataPath/${fileHash}_$fileName';
    final String fileString;

    try {
      fileString = await rootBundle.loadString(assetPath);
    } catch (e, st) {
      dev.log('Error loading file at $assetPath',
          name: 'FileService', error: e.toString(), stackTrace: st);
      throw FileSystemException(e.toString());
    }

    return fileString;
  }

  /// Opens the manifest file and returns the hash.
  ///
  /// Throws a [FileSystemException] if the file cannot be loaded.
  Future<String> _getFileHash() async {
    try {
      final String hash =
          await rootBundle.loadString('$_dataPath/$fileNameManifest');
      return hash;
    } catch (e, st) {
      // If there's an error loading the asset, print the error and the attempted path
      dev.log('Error loading file at $_dataPath/$fileNameManifest',
          name: 'FileService', error: e.toString(), stackTrace: st);
      throw FileSystemException(e.toString());
    }
  }
}
