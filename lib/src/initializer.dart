/// Abstract class for any class that will open and read a json file to populate a data structure.
abstract class DataInitializer {
  Future<void> init({required String jsonString});
}
