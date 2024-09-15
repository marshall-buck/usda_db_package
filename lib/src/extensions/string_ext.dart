extension StringExtensions on String {
  /// Removes all non-alpha except dashes and parentheses,
  /// and numbers followed by a %.
  ///
  /// [^\w()%\-] matches any character that is not (letters, numbers, underscores),
  /// not a parenthesis (( or )) and not a hyphen (-).
  /// | is the OR operator in regular expressions, which means the pattern will
  ///  match if either the left side or the right side of the | is true.
  /// (\d+%) matches one or more digits followed by a percent sign (%).
  ///
  /// So, this pattern will match any string that contains a character
  /// not in the set defined by [^\w()%\-] or a string that contains one or more
  /// digits followed by a percent sign.
  String removeUnwantedChars() {
    final stringSanitizerRegEx = RegExp(r'[^\w()%\-\/]|(\d+%)');

    return replaceAllMapped(
      stringSanitizerRegEx,
      (match) => match.group(1) ?? '',
    );
  }

  /// Separates words with dashes or parentheses and forward slashes.
  /// Returns a list of a word(s), list may be empty and may contain empty strings.
  List<String> stripDashedAndParenthesisAndForwardSlashesWord() {
    if (contains('-')) return split('-');
    if (contains('/')) return split('/');
    if (startsWith('(') && endsWith(')')) {
      final trimmed = substring(1, length - 1);
      return [trimmed];
    }
    if (contains('(')) return split('(');
    if (contains(')')) return split(')');

    return isNotEmpty ? [this] : [];
  }

  /// Cleans up a sentence, removing all unwanted characters
  /// Returns a set of lowercased words to be indexed.
  Set<String> getWordsToIndex() {
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
