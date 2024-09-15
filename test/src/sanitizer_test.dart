import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/sanitizer.dart';

void main() {
  group('Sanitizer class tests', () {
    group('createSearchList() - ', () {
      test('removes stop words correctly', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.createSearchList('once test');
        const d = ListEquality<String>();
        expect(d.equals(sanitizedWords, ['test']), true);
      });

      test('handles empty sentence correctly', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.createSearchList('');
        expect(sanitizedWords, isEmpty);
      });

      test('handles sentence with only stop words', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.createSearchList('am a an and at');

        expect(sanitizedWords, ['a']);
      });

      test('handles sentence with no stop words', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.createSearchList('Test sentence no  stop words');
        const d = ListEquality<String>();
        expect(
          d.equals(
            sanitizedWords,
            ['test', 'sentence', 'no', 'stop', 'words'],
          ),
          true,
        );
      });
      test('handles sentence with parenthesis)', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.createSearchList('Test (sentence) no  stop words');
        const d = ListEquality<String>();
        expect(
          d.equals(
            sanitizedWords,
            ['test', 'sentence', 'no', 'stop', 'words'],
          ),
          true,
        );
      });
      test('handles sentence with dashes)', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.createSearchList('Test-sentence no  stop words');
        const d = ListEquality<String>();
        expect(
          d.equals(
            sanitizedWords,
            ['test', 'sentence', 'no', 'stop', 'words'],
          ),
          true,
        );
      });
      test('Sanitizer handles sentence with percents', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.createSearchList('Test sentence no  stop 2%');
        const d = ListEquality<String>();
        expect(
          d.equals(sanitizedWords, ['test', 'sentence', 'no', 'stop', '2%']),
          true,
        );
      });
      test('Sanitizer handles sentence with 1 word', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.createSearchList('2%');
        const d = ListEquality<String>();
        expect(d.equals(sanitizedWords, ['2%']), true);
      });
    });
  });
}
