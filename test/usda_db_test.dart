import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usda_db_package/src/file_paths.dart';

import 'setup/mock_file_strings.dart';
import 'setup/startup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    set_up_all();
  });

  tearDown(() {
    tear_down();
  });
  group('DB Class Tests', () {
    group('init()', () {
      test('should not throw', () async {
        when(() => mockFileLoaderService.loadData(pathToFoods))
            .thenAnswer((_) async => mocDB);
        when(() => mockFileLoaderService.loadData(pathToSubstringHash))
            .thenAnswer((_) async => mocHashTable);
        expect(() async => await dbWithMockFileLoader.init(), returnsNormally);
        expect(() => dbWithMockFileLoader.getFood('index'), returnsNormally);
      });
    });
  });
}
