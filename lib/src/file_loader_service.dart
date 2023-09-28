import 'dart:io';

class FileLoaderService {
  static final FileLoaderService _singleton = FileLoaderService._internal();

  factory FileLoaderService() {
    return _singleton;
  }

  FileLoaderService._internal();

  Future<String> loadData(String path) async {
    final file = File(path);

    return await file.readAsString();
  }
}
