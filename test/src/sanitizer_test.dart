import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/sanitizer.dart';

void main() {
  group('Sanitizer class tests', () {
    group('get sanitizedWords', () {
      test('removes stop words correctly', () {
        final sanitizer = Sanitizer(sentence: '2% only milk');
        final sanitizedWords = sanitizer.sanitizedWords;
        const d = ListEquality();
        expect(d.equals(sanitizedWords, ['2%', 'milk']), true);
      });

      test('handles empty sentence correctly', () {
        final sanitizer = Sanitizer(sentence: '');
        final sanitizedWords = sanitizer.sanitizedWords;
        expect(sanitizedWords, isEmpty);
      });

      test('handles sentence with only stop words', () {
        final sanitizer = Sanitizer(sentence: 'am a an and at');
        final sanitizedWords = sanitizer.sanitizedWords;
        expect(sanitizedWords, isEmpty);
      });

      test('handles sentence with no stop words', () {
        final sanitizer = Sanitizer(sentence: 'Test sentence no  stop words');
        final sanitizedWords = sanitizer.sanitizedWords;
        const d = ListEquality();
        expect(
            d.equals(
                sanitizedWords, ['test', 'sentence', 'no', 'stop', 'words']),
            true);
      });
      test('handles sentence with parenthesis)', () {
        final sanitizer = Sanitizer(sentence: 'Test (sentence) no  stop words');
        final sanitizedWords = sanitizer.sanitizedWords;
        const d = ListEquality();
        expect(
            d.equals(
                sanitizedWords, ['test', 'sentence', 'no', 'stop', 'words']),
            true);
      });
      test('handles sentence with dashes)', () {
        final sanitizer = Sanitizer(sentence: 'Test-sentence no  stop words');
        final sanitizedWords = sanitizer.sanitizedWords;
        const d = ListEquality();
        expect(
            d.equals(
                sanitizedWords, ['test', 'sentence', 'no', 'stop', 'words']),
            true);
      });
      test('Sanitizer handles sentence with percents', () {
        final sanitizer = Sanitizer(sentence: 'Test sentence no  stop 2%');
        final sanitizedWords = sanitizer.sanitizedWords;
        const d = ListEquality();
        expect(
            d.equals(sanitizedWords, ['test', 'sentence', 'no', 'stop', '2%']),
            true);
      });
    });
  });
}
