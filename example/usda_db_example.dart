import 'dart:async';

import 'package:flutter/material.dart';
import 'package:usda_db_package/usda_db_package.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = UsdaDB();
  await db.init();
  runApp(
    AutocompleteExampleApp(
      db: db,
    ),
  );
}

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({required this.db, super.key});
  final UsdaDB db;

  Future<void> _onChanged(String string) async {
    final results = await db.queryFoods(searchString: string);
    print(results.length);
  }

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
          child: SearchBar(
            onChanged: _onChanged,
          ),
        ),
      ),
    );
  }
}
