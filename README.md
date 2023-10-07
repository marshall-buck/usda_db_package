<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Dart only package, for front end flutter app to search the usda food database.

## Features

Searches for foods with a prefix tree

## Getting started

Import the package to flutter. in pub.spec

## Usage

Must initialize the database


```dart
final db = DB();
await db.init();
```

## Additional information

The DB class is a singleton, once initialized, you have access to 2 methods.

```dart
db.getDescriptions('term');
```
Returns a List of Records (String description, int description length, String index).

You can use the list to fill out an autocomplete result based on the term.

 The list is unsorted.

 ```dart
 db.getFood('index');
 ```
 Used to return a FoodModel instance with the following properties
 ```dart
String id,
String description,
num descriptionLength,
num? protein,
num? dietaryFiber,
num? satFat,
num? totCarb,
num? calories,
num? totFat,
num? totSugars
 ```

