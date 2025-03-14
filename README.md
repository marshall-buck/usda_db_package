# usda_db_package

This library uses 2 json files representing the usda sr legacy database. the library also need the manifest file to get the hash.

The files are created from this package:
- https://github.com/marshall-buck/usda_db_creation
The files are as follows:
1. *hash*_foods_db.json
   - this contains a json representation of the foods and nutrients chosen in the creation package.
2. *hash*_autocomplete_hash.json
   - this contains a json representation of the autocomplete data for the foods in the foods_db.json file.
3. file_manifest.txt
   - this contains the hash of the files used to create the db.



## To use the package.

> Add the package to dependencies:
 ```yaml
    dependencies:
        usda_db_package:
    git:
      url: https://github.com/marshall-buck/usda_db_package.git
```




> Import the package in your flutter project:

```dart
import 'package:usda_db_package/usda_db_package.dart';
```
> Initialize the class by calling the static `init` method which will return the instance.

```dart
final Future<UsdaDbDAO> db = await UsdaDbDAO.init();
```

> Once init is run, the following methods can be called.
- Run dispose in your app when disposing your instance.
```dart
final Future<UsdaFoodModel?> food = await db.queryFood(id: 123);

final Future<List<UsdaFoodModel?>> foods = await db.queryFoods(searchString: 'apple');

await db.dispose();
```

The `isDataLoaded` property can be used to check if the data has been loaded successfully.

The `isInitializing` property can be used to check if the database is currently being initialized.
