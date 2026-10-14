/// Abstract class for any class that will open and read a json file to populate a data structure.
abstract interface class DataInitializer {
  /// Populates the data structure from the contents of [jsonString].
  Future<void> init({required String jsonString});
}
