# How to Use the usda_db_package

> Add the package to dependencies:
 ```yaml
    dependencies:
        usda_db_package:
    git:
      url: https://github.com/marshall-buck/usda_db_package.git
```


To use the package, you can follow the steps below:

> Import the package in your flutter project:

```dart
import 'package:usda_db_package/usda_db_package.dart';
```
> Initialize the instance.
```dart
final db = UsdaDB();
```
>  Load the data.
```dart
await  db.init();
```
> There are only 3 public methods needed. Once init is run.
```dart
final FoodModel? food = db.getFood(123);

final Future<List<DescriptionRecord?>> results = await db.getAutocompleteResults('apple');

db.dispose();
```
