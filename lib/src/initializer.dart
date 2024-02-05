/// Interface for any class that will open and read a json file
/// to populate a data structure.
abstract class Initializer {
  Future<void> init({required String jsonString});
}
