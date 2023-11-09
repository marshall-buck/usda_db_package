// import 'dart:io';
import 'package:flutter/services.dart';

/// Class to load the rootBundle file.  It only has one method,
/// but I did this to make testing easier.
/// May add some type of init method later
class FileLoaderService {
  Future<String> loadData(String path) async =>
      await rootBundle.loadString(path);
}
