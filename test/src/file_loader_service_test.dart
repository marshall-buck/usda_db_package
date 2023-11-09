import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../setup/startup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    set_up_all();
  });

  tearDown(() => tear_down());
  group('FileLoaderService class tests', () {
    group('loadFile - ', () {
      test('loads real file correctly', () async {
        final res = await fileLoaderService.loadData(pathToTestFile);
        expect(res, 'Here is a text file?');
      });
      test('mocks file correctly', () async {
        when(() => mockFileLoaderService.loadData('fake'))
            .thenAnswer((_) async => 'Here is a mock text file?');
        final res = await mockFileLoaderService.loadData('fake');

        expect(res, 'Here is a mock text file?');
      });
    });
  });
}
