import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:developer' as dev;

class FileService {
  static const String _dataPath = 'packages/usda_db_package/lib/data';
  static const String fileNameManifest = 'file_manifest.txt';
  static const String fileNameFoods = 'foods_db.json';
  static const String fileNameAutocompleteData = 'autocomplete_hash.json';

  /// Opens a file from [fileName] located in the package's assets.
  /// Returns the contents as a [String].
  Future<String> loadData({required String fileName}) async {
    final fileHash = await _getFileHash();
    final String assetPath = '$_dataPath/${fileHash}_$fileName';
    final String contents;

    try {
      contents = await rootBundle.loadString(assetPath);
    } catch (e, st) {
      dev.log('Error loading file at $assetPath',
          name: 'FileService', error: e.toString(), stackTrace: st);
      throw FileSystemException(e.toString());
    }

    return contents;
  }

  /// opens the manifest file and returns the hash.
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
