import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/sanitizer.dart';

void main() {
  group('Sanitizer class tests', () {
    group('sanitizedWords() - ', () {
      test('removes stop words correctly', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.sanitizedWords('once test');
        const d = ListEquality();
        expect(d.equals(sanitizedWords, ['test']), true);
      });

      test('handles empty sentence correctly', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.sanitizedWords('');
        expect(sanitizedWords, isEmpty);
      });

      test('handles sentence with only stop words', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.sanitizedWords('am a an and at');

        expect(sanitizedWords, isEmpty);
      });

      test('handles sentence with no stop words', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.sanitizedWords('Test sentence no  stop words');
        const d = ListEquality();
        expect(
            d.equals(
                sanitizedWords, ['test', 'sentence', 'no', 'stop', 'words']),
            true);
      });
      test('handles sentence with parenthesis)', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.sanitizedWords('Test (sentence) no  stop words');
        const d = ListEquality();
        expect(
            d.equals(
                sanitizedWords, ['test', 'sentence', 'no', 'stop', 'words']),
            true);
      });
      test('handles sentence with dashes)', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.sanitizedWords('Test-sentence no  stop words');
        const d = ListEquality();
        expect(
            d.equals(
                sanitizedWords, ['test', 'sentence', 'no', 'stop', 'words']),
            true);
      });
      test('Sanitizer handles sentence with percents', () {
        final sanitizer = Sanitizer();
        final sanitizedWords =
            sanitizer.sanitizedWords('Test sentence no  stop 2%');
        const d = ListEquality();
        expect(
            d.equals(sanitizedWords, ['test', 'sentence', 'no', 'stop', '2%']),
            true);
      });
      test('Sanitizer handles sentence with 1 word', () {
        final sanitizer = Sanitizer();
        final sanitizedWords = sanitizer.sanitizedWords('2%');
        const d = ListEquality();
        expect(d.equals(sanitizedWords, ['2%']), true);
      });
    });
  });
}
