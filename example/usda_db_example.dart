import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usda_db_package/src/usda_db_base.dart';
import 'package:usda_db_package/usda_db_package.dart';

/// Flutter code sample for [Autocomplete].
///
late final DB db;

void main() async {
  db = DB();
  await db.init();
  runApp(const AutocompleteExampleApp());
}

class AutocompleteBasicUserExample extends StatelessWidget {
  AutocompleteBasicUserExample({super.key});
  static late final List<SearchResultRecord> results;

  static String _displayStringForOption(SearchResultRecord option) => option.$1;

  /// What happens as keys are pressed
  /// A function that returns the current selectable options objects given the current TextEditingValue.
  static FutureOr<Iterable<SearchResultRecord>> _optionsBuilder(
      TextEditingValue textEditingValue) async {
    debugPrint('textEditingValue ${textEditingValue.text}');

    if (textEditingValue.text.length >= 3) {
      results = await db.getDescriptions(textEditingValue.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<SearchResultRecord>(
      displayStringForOption: _displayStringForOption,
      optionsBuilder: _optionsBuilder,
      onSelected: ((String, num, String) selection) {
        debugPrint('You just selected ${_displayStringForOption(selection)}');
      },
    );
  }
}

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autocomplete Basic User'),
        ),
        body: const Center(
          child: AutocompleteBasicUserExample(),
        ),
      ),
    );
  }
}

// @immutable
// class User {
//   final String email;

//   final String name;
//   const User({
//     required this.email,
//     required this.name,
//   });

//   @override
//   int get hashCode => Object.hash(email, name);

//   @override
//   bool operator ==(Object other) {
//     if (other.runtimeType != runtimeType) {
//       return false;
//     }
//     return other is User && other.name == name && other.email == email;
//   }

//   @override
//   String toString() {
//     return '$name, $email';
//   }
// }
