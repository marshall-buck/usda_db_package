import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/extensions/string_ext.dart';

void main() {
  group('StringExtensions Unit Tests', () {
    group('removeUnwantedChars()', () {
      test(' removes unwanted characters', () {
        expect('he  llo!#!#'.removeUnwantedChars(), 'hello');
        expect('  hello-bob '.removeUnwantedChars(), 'hello-bob');
        expect('  hello)bob '.removeUnwantedChars(), 'hello)bob');
        expect('  hello(bob '.removeUnwantedChars(), 'hello(bob');
        expect('  (hello ) '.removeUnwantedChars(), '(hello)');
        // ignore: use_raw_strings
        expect('hello@\$-!@#bob '.removeUnwantedChars(), 'hello-bob');
        expect('  hello '.removeUnwantedChars(), 'hello');
        expect('  hel  lo'.removeUnwantedChars(), 'hello');
        expect(''.removeUnwantedChars(), '');
        expect(' '.removeUnwantedChars(), '');
        expect('2%'.removeUnwantedChars(), '2%');
        expect('syrup/caramel'.removeUnwantedChars(), 'syrup/caramel');
      });

      test(' keeps digits followed by a percent sign', () {
        expect('(2%)'.removeUnwantedChars(), '(2%)');
        expect('100% juice!'.removeUnwantedChars(), '100%juice');
        expect('low fat 1% milk'.removeUnwantedChars(), 'lowfat1%milk');
        expect('50%-fat'.removeUnwantedChars(), '50%-fat');
      });
    });

    group('stripDashedAndParenthesisWord()', () {
      test(' separates words with dashes or parentheses', () {
        expect(
          'hello-there'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['hello', 'there'],
        );
        expect(
          'hello'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['hello'],
        );
        expect(
          'ready-to-bake'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['ready', 'to', 'bake'],
        );
        expect(
          '-to-bake'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['', 'to', 'bake'],
        );
        expect(
          '-to-bake-'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['', 'to', 'bake', ''],
        );
        expect(
          'syrup/caramel'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['syrup', 'caramel'],
        );
        expect(
          ''.stripDashedAndParenthesisAndForwardSlashesWord(),
          isEmpty,
        );
      });

      test(' splits on every delimiter, not just the first kind', () {
        expect(
          '(pak-choi)'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['', 'pak', 'choi', ''],
        );
        expect(
          'ready-to-heat/toasted'
              .stripDashedAndParenthesisAndForwardSlashesWord(),
          ['ready', 'to', 'heat', 'toasted'],
        );
        expect(
          'chicken(raw)/beef'.stripDashedAndParenthesisAndForwardSlashesWord(),
          ['chicken', 'raw', '', 'beef'],
        );
      });
    });

    group('sanitizeSentence()', () {
      test('Sentence should be stripped of all non alpha chars', () {
        const sentence1 = 'Doughnuts, yeast-Leavened, (with) jelly filling';
        expect(
          sentence1.sanitizeSentence(),
          {'doughnuts', 'yeast', 'leavened', 'with', 'jelly', 'filling'},
        );
        const sentence2 =
            'Muffins, plain, prepared from recipe, made with low fat (2%) milk';

        expect(sentence2.sanitizeSentence(), {
          'muffins',
          'plain',
          'prepared',
          'from',
          'recipe',
          'made',
          'with',
          'low',
          'fat',
          '2%',
          'milk',
        });

        const sentence3 = 'Puff a pastry, frozen, ready- -to-bake ';

        expect(
          sentence3.sanitizeSentence(),
          {'puff', 'a', 'pastry', 'frozen', 'ready', 'to', 'bake'},
        );
      });

      test('handles an empty sentence', () {
        expect(''.sanitizeSentence(), isEmpty);
        expect('   '.sanitizeSentence(), isEmpty);
      });

      test('handles a single word', () {
        expect('2%'.sanitizeSentence(), {'2%'});
      });
    });
  });
}
