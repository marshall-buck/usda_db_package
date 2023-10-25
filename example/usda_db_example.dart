import 'dart:async';

import 'package:flutter/material.dart';

import 'package:usda_db_package/usda_db_package.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DB();
  await db.init();
  runApp(const AutocompleteExampleApp());
}

class AutocompleteBasicUserExample extends StatelessWidget {
  AutocompleteBasicUserExample({super.key});
  static late final List<SearchResultRecord> results;
  static final db = DB();

  static String _displayStringForOption(SearchResultRecord option) => option.$1;

  /// What happens as keys are pressed
  /// A function that returns the current selectable options objects given the current TextEditingValue.
  static FutureOr<List<SearchResultRecord>> _optionsBuilder(
      TextEditingValue textEditingValue) async {
    debugPrint('textEditingValue ${textEditingValue.text}');

    if (textEditingValue.text.length >= 3) {
      return await db.getDescriptions(textEditingValue.text);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<SearchResultRecord>(
      displayStringForOption: _displayStringForOption,
      optionsBuilder: _optionsBuilder,
      onSelected: (SearchResultRecord selection) {
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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autocomplete Basic User'),
        ),
        body: Center(
          child: AutocompleteBasicUserExample(),
        ),
      ),
    );
  }
}
