import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/usda_db_package.dart';

// The asset bundle is stubbed rather than read: the shipped data files are
// ~13 MB and reading them here would only re-prove what `test/live_test.dart`
// already covers. Stubbing also lets the hash in the manifest differ from the
// real one, which is the only way to see that `loadData` composes the asset
// path out of it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const dataPath = 'packages/usda_db_package/lib/data';
  const hash = '999999';

  late Map<String, String> bundledAssets;
  late Map<String, int> reads;

  void stubAssetBundle() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      reads[key] = (reads[key] ?? 0) + 1;
      final contents = bundledAssets[key];
      // A null reply is how the real bundle reports a missing asset.
      if (contents == null) return null;
      return ByteData.sublistView(Uint8List.fromList(utf8.encode(contents)));
    });
  }

  setUp(() {
    reads = {};
    bundledAssets = {
      '$dataPath/${FileService.fileNameManifest}': hash,
      '$dataPath/${hash}_${FileService.fileNameFoods}': '{"foods": true}',
      '$dataPath/${hash}_${FileService.fileNameAutocompleteData}':
          '{"autocomplete": true}',
    };
    stubAssetBundle();
    // rootBundle caches by asset key, so it has to be emptied around every
    // test or the first stub leaks into the rest of the file.
    rootBundle.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
    rootBundle.clear();
  });

  group('FileService', () {
    final fileService = FileService();

    group('loadData() - ', () {
      test('returns the foods file contents', () async {
        final contents =
            await fileService.loadData(fileName: FileService.fileNameFoods);

        expect(contents, '{"foods": true}');
      });

      test('returns the autocomplete file contents', () async {
        final contents = await fileService.loadData(
          fileName: FileService.fileNameAutocompleteData,
        );

        expect(contents, '{"autocomplete": true}');
      });

      test('keeps the manifest cached and the data files not', () async {
        await fileService.loadData(fileName: FileService.fileNameFoods);
        await fileService.loadData(
          fileName: FileService.fileNameAutocompleteData,
        );
        await fileService.loadData(fileName: FileService.fileNameFoods);

        // The manifest is served from rootBundle's cache after the first read.
        expect(reads['$dataPath/${FileService.fileNameManifest}'], 1);

        // The data files are not cached: megabytes of JSON that the caller
        // parses and drops would otherwise be retained for the life of the
        // app. Reading foods twice has to hit the bundle twice.
        expect(reads['$dataPath/${hash}_${FileService.fileNameFoods}'], 2);
        expect(
          reads['$dataPath/${hash}_${FileService.fileNameAutocompleteData}'],
          1,
        );
      });

      test('composes the asset path from the hash in the manifest', () async {
        bundledAssets['$dataPath/${FileService.fileNameManifest}'] = '000001';

        // The foods file is in the stubbed bundle only under the old hash, so
        // the read fails - and fails at the path built from the new one.
        await expectLater(
          fileService.loadData(fileName: FileService.fileNameFoods),
          throwsA(
            isA<UsdaDbFileException>().having(
              (e) => e.errorMessage,
              'errorMessage',
              contains('000001_${FileService.fileNameFoods}'),
            ),
          ),
        );
      });

      test('throws UsdaDbFileException naming the asset that is missing',
          () async {
        const fileName = 'non_existent_file.txt';

        await expectLater(
          fileService.loadData(fileName: fileName),
          throwsA(
            isA<UsdaDbFileException>()
                .having(
                  (e) => e.errorMessage,
                  'errorMessage',
                  contains('$dataPath/${hash}_$fileName'),
                )
                .having((e) => e.stackTrace, 'stackTrace', isNotNull),
          ),
        );
      });

      test('throws UsdaDbFileException if the manifest itself is missing',
          () async {
        bundledAssets.remove('$dataPath/${FileService.fileNameManifest}');

        await expectLater(
          fileService.loadData(fileName: FileService.fileNameFoods),
          throwsA(
            isA<UsdaDbFileException>().having(
              (e) => e.errorMessage,
              'errorMessage',
              contains(FileService.fileNameManifest),
            ),
          ),
        );
      });
    });
  });
}
