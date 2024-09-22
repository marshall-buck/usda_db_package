import 'extensions/string_ext.dart';

/// A class that provides string sanitization services.
///
/// The [createSearchList] method takes a sentence parameter and returns a
/// list of strings. The method removes stop words and words with a length of 1
/// from the sentence and returns the remaining words as a list.
class Sanitizer {
  /// Returns a list of sanitized strings from the given [sentence].
  List<String> createSearchList(String sentence) {
    final sanitized = _sanitizeSentence(sentence);
    //No need
    // final withoutStopWords = _removeStopWords(sanitized);
    return sanitized;
  }

  List<String> _sanitizeSentence(String sentence) =>
      sentence.sanitizeSentence().toList();

  // List<String> _removeStopWords(List<String> sentence) =>
  //     sentence.where((element) => !stopWords.contains(element)).toList();

  /// A list of stop words to be removed from the input sentence.
  static const List<String> stopWords = [
    'about',
    'above',
    'added',
    'after',
    'again',
    'against',
    'all',
    'am',
    'an',
    'and',
    'are',
    'as',
    'at',
    'be',
    'because',
    'been',
    'before',
    'being',
    'below',
    'between',
    'both',
    'but',
    'by',
    'can',
    'could',
    'did',
    'do',
    'does',
    'doing',
    'down',
    'during',
    'each',
    'few',
    'for',
    'from',
    'had',
    'has',
    'have',
    'having',
    'how',
    'if',
    'in',
    'into',
    'is',
    'it',
    'its',
    'just',
    'made',
    'more',
    'most',
    'not',
    'now',
    'of',
    'off',
    'on',
    'once',
    'only',
    'or',
    'other',
    'our',
    'ours',
    'out',
    'over',
    'own',
    'same',
    'she',
    'should',
    'so',
    'some',
    'such',
    'than',
    'that',
    'the',
    'their',
    'them',
    'then',
    'there',
    'these',
    'they',
    'this',
    'those',
    'through',
    'to',
    'too',
    'trimmed',
    'under',
    'until',
    'up',
    'very',
    'was',
    'we',
    'were',
    'what',
    'when',
    'where',
    'which',
    'while',
    'who',
    'will',
    'with',
    'without',
    'you',
    'your',
  ];
}
