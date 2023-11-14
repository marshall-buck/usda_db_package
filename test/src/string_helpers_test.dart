import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:usda_db_package/src/string_helpers.dart';

void main() {
  group('keepCharAndDash', () {
    test('string should only keep chars and dashes', () {
      expect(keepCharAndDash("he  llo!#!#"), 'hello');
      expect(keepCharAndDash('  hello-bob '), 'hello-bob');
      expect(keepCharAndDash('hello@\$-!@#%bob '), 'hello-bob');
      expect(keepCharAndDash('  hello '), 'hello');
      expect(keepCharAndDash('  hel  lo'), 'hello');

      expect(keepCharAndDash(''), '');
      expect(keepCharAndDash(' '), '');
    });
  });
  group('stripDashedWord', () {
    test('a dashed string should be split into a list', () {
      expect(stripDashedWord('hello-there'), ['hello', 'there']);
      expect(stripDashedWord('hello'), ['hello']);
      expect(stripDashedWord('ready-to-bake'), ['ready', 'to', 'bake']);
      expect(stripDashedWord('-to-bake'), ['', 'to', 'bake']);
      expect(stripDashedWord('-to-bake-'), ['', 'to', 'bake', '']);

      expect(stripDashedWord(''), []);
    });
  });
  group('cleanSentence', () {
    test('Sentence should be stripped of all non alpha chars', () {
      expect(cleanSentence('Doughnuts, yeast-Leavened, with jelly filling'),
          {'doughnuts', 'yeast', 'leavened', 'with', 'jelly', 'filling'});

      expect(
          cleanSentence(
              'Muffins, plain, prepared from recipe, made with low fat (2%) milk'),
          {
            'muffins',
            'plain',
            'prepared',
            'from',
            'recipe',
            'made',
            'with',
            'low',
            'fat',
            'milk'
          });

      expect(cleanSentence('Puff pastry, frozen, ready- -to-bake '),
          {'puff', 'pastry', 'frozen', 'ready', 'to', 'bake'});
    });
  });
}
