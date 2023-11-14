import 'package:usda_db_package/src/stop_words.dart';

/// Regex to find non-chars,and spaces,  EXCEPT for a dashes
final stringSanitizerRegEx = RegExp(r'[^a-zA-Z\-]');

/// Keeps only chars and dashes in a string.
///
/// Parameters:
/// [word]
///
/// Returns [word] with only alpha chars and dashes or empty string.
String keepCharAndDash(String word) {
  return word.contains(stringSanitizerRegEx)
      ? word.replaceAll(stringSanitizerRegEx, '')
      : word;
}

/// Separates dashed words.
///
/// Parameters:
/// [word]
///
/// Returns a list of a word(s), list may be empty.
List<String> stripDashedWord(String word) {
  return word.isNotEmpty ? word.split('-') : [];
}

/// Cleans up a sentence, removing all non alpha characters
///
/// Parameters: [sentence]
///
/// Returns a set of lowercased words with only alpha chars.

Set<String> cleanSentence(String sentence) {
  List<List<String>> words = [];

  for (var word in sentence.split(' ')) {
    final String charDash = keepCharAndDash(word).toLowerCase();
    final List<String> splitDashed = stripDashedWord(charDash);

    if (splitDashed.isNotEmpty) {
      words.add(splitDashed);
    }
  }
  final wordsSet = words.expand((list) => list).toSet();
  wordsSet.remove('');
  return wordsSet;
}

bool isStopWord(word) {
  return stopWords.contains(word);
}
