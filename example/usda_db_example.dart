// import 'dart:async';

// import 'package:flutter/material.dart';

// import 'package:usda_db_package/usda_db_package.dart';

// late final UsdaDB db;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   db = await UsdaDB.init();
//   runApp(const AutocompleteExampleApp());
// }

// class AutocompleteBasicUserExample extends StatelessWidget {
//   const AutocompleteBasicUserExample({super.key});
//   static late final List<FoodModel> results;

//   static String _displayStringForOption(FoodModel option) => option.description;

//   /// What happens as keys are pressed
//   /// A function that returns the current selectable options objects given
//   ///  the current TextEditingValue.
//   static FutureOr<List<FoodModel>> _optionsBuilder(
//       TextEditingValue textEditingValue) async {
//     debugPrint('textEditingValue ${textEditingValue.text}');

//     if (textEditingValue.text.length > 1) {
//       final results = await db.queryFoods(searchString: textEditingValue.text);
//       // Filter out any null results, if necessary, to ensure the list only contains non-nullable elements.
//       return results.whereType<FoodModel>().toList();
//     }
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Autocomplete<FoodModel>(
//         displayStringForOption: _displayStringForOption,
//         optionsBuilder: _optionsBuilder,
//         onSelected: (FoodModel selection) {
//           debugPrint('You just selected ${_displayStringForOption(selection)}');
//         },
//       ),
//     );
//   }
// }

// class AutocompleteExampleApp extends StatelessWidget {
//   const AutocompleteExampleApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.green,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Autocomplete Basic User'),
//         ),
//         body: const Center(
//           child: AutocompleteBasicUserExample(),
//         ),
//       ),
//     );
//   }
// }
