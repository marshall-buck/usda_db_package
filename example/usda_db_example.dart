import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usda_db_package/src/type_def.dart';
import 'package:usda_db_package/usda_db_package.dart';

final db = DB();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await db.init();
  runApp(const AutocompleteExampleApp());
}

class AutocompleteBasicUserExample extends StatelessWidget {
  const AutocompleteBasicUserExample({super.key});
  static late final List<DescriptionRecord> results;

  static String _displayStringForOption(DescriptionRecord option) => option.$1;

  /// What happens as keys are pressed
  /// A function that returns the current selectable options objects given
  ///  the current TextEditingValue.
  static FutureOr<List<DescriptionRecord>> _optionsBuilder(
      TextEditingValue textEditingValue) async {
    debugPrint('textEditingValue ${textEditingValue.text}');

    if (textEditingValue.text.length > 1) {
      final results = await db.getAutocompleteResults(textEditingValue.text);
      // Filter out any null results, if necessary, to ensure the list only contains non-nullable elements.
      return results.whereType<DescriptionRecord>().toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Autocomplete<DescriptionRecord>(
        displayStringForOption: _displayStringForOption,
        optionsBuilder: _optionsBuilder,
        onSelected: (DescriptionRecord selection) {
          debugPrint('You just selected ${_displayStringForOption(selection)}');
        },
      ),
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
        body: const Center(
          child: AutocompleteBasicUserExample(),
        ),
      ),
    );
  }
}
