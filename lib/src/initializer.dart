/// Abstract class for any class that will open and read a json file to populate a data structure.
// ignore: one_member_abstracts
abstract interface class DataInitializer {
  /// Populates the data structure from the contents of [jsonString].
  Future<void> init({required String jsonString});
}
