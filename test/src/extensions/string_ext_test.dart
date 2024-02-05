import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/extensions/string_ext.dart';

void main() {
  group('StringExtensions Unit Tests', () {
    group('removeUnwantedChars()', () {
      test(' removes unwanted characters', () {
        expect("he  llo!#!#".removeUnwantedChars(), 'hello');
        expect('  hello-bob '.removeUnwantedChars(), 'hello-bob');
        expect('  hello)bob '.removeUnwantedChars(), 'hello)bob');
        expect('  hello(bob '.removeUnwantedChars(), 'hello(bob');
        expect('  (hello ) '.removeUnwantedChars(), '(hello)');
        expect('hello@\$-!@#bob '.removeUnwantedChars(), 'hello-bob');
        expect('  hello '.removeUnwantedChars(), 'hello');
        expect('  hel  lo'.removeUnwantedChars(), 'hello');
        expect(''.removeUnwantedChars(), '');
        expect(' '.removeUnwantedChars(), '');
        expect('2%'.removeUnwantedChars(), '2%');
        expect('syrup/caramel'.removeUnwantedChars(), 'syrup/caramel');
      });
    });

    group('stripDashedAndParenthesisWord()', () {
      test(' separates words with dashes or parentheses', () {
        expect('hello-there'.stripDashedAndParenthesisAndForwardSlashesWord(),
            ['hello', 'there']);
        expect('hello'.stripDashedAndParenthesisAndForwardSlashesWord(),
            ['hello']);
        expect('ready-to-bake'.stripDashedAndParenthesisAndForwardSlashesWord(),
            ['ready', 'to', 'bake']);
        expect('-to-bake'.stripDashedAndParenthesisAndForwardSlashesWord(),
            ['', 'to', 'bake']);
        expect('-to-bake-'.stripDashedAndParenthesisAndForwardSlashesWord(),
            ['', 'to', 'bake', '']);
        expect('syrup/caramel'.stripDashedAndParenthesisAndForwardSlashesWord(),
            ['syrup', 'caramel']);
      });
    });

    group('getWordsToIndex()', () {
      test('Sentence should be stripped of all non alpha chars', () {
        const sentence1 = 'Doughnuts, yeast-Leavened, (with) jelly filling';
        expect(sentence1.getWordsToIndex(),
            {'doughnuts', 'yeast', 'leavened', 'with', 'jelly', 'filling'});
        const sentence2 =
            'Muffins, plain, prepared from recipe, made with low fat (2%) milk';

        expect(sentence2.getWordsToIndex(), {
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
          'milk'
        });

        const sentence3 = 'Puff pastry, frozen, ready- -to-bake ';

        expect(sentence3.getWordsToIndex(),
            {'puff', 'pastry', 'frozen', 'ready', 'to', 'bake'});
      });
    });
  });
}
