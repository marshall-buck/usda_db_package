extension StringExtensions on String {
  /// Removes every character that is not a word character (letters, digits,
  /// underscores), a parenthesis, a percent sign, a hyphen or a forward slash.
  ///
  /// Percent signs are kept so measures such as `2%` and `100%` survive - the
  /// autocomplete index stores them verbatim.
  String removeUnwantedChars() {
    final stringSanitizerRegEx = RegExp(r'[^\w()%\-/]');

    return replaceAll(stringSanitizerRegEx, '');
  }

  /// Separates words with dashes or parentheses and forward slashes.
  ///
  /// Every delimiter is split on in a single pass, so descriptions that mix
  /// them - `(pak-choi)`, `ready-to-heat/toasted` - yield individual words
  /// instead of leaving a delimiter stuck to a token.
  ///
  /// Returns a list of a word(s), list may be empty and may contain empty strings.
  List<String> stripDashedAndParenthesisAndForwardSlashesWord() {
    if (isEmpty) return [];
    final delimiterRegEx = RegExp('[-/()]');

    return split(delimiterRegEx);
  }

  /// Cleans up a sentence, removing all unwanted characters.
  /// Returns a set of lowercased words.
  Set<String> sanitizeSentence() {
    final words = <List<String>>[];

    for (final word in split(' ')) {
      final charDash = word.removeUnwantedChars().toLowerCase();
      final splitWords =
          charDash.stripDashedAndParenthesisAndForwardSlashesWord();

      if (splitWords.isNotEmpty) {
        words.add(splitWords);
      }
    }
    final wordsSet = words.expand((list) => list).toSet();
    // ignore: cascade_invocations
    wordsSet.remove('');
    return wordsSet;
  }
}
