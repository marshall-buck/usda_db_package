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
    final stringSanitizerRegEx = RegExp(r"[^\w()%\-\/]|(\d+%)");

    return replaceAllMapped(
        stringSanitizerRegEx, (final match) => match.group(1) ?? '');
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
    final List<List<String>> words = [];

    for (final word in split(' ')) {
      final String charDash = word.removeUnwantedChars().toLowerCase();
      final List<String> splitWords =
          charDash.stripDashedAndParenthesisAndForwardSlashesWord();

      if (splitWords.isNotEmpty) {
        words.add(splitWords);
      }
    }
    final wordsSet = words.expand((final list) => list).toSet();
    wordsSet.remove('');
    return wordsSet;
  }

  /// Checks if [String] is in provided [List]
  bool isStopWord(final List<String> stopWords) {
    return stopWords.contains(this);
  }

  /// Checks if a [String] contains either digits followed by a %,
  /// 'or' a string of lowercase characters.
  bool isLowerCaseOrNumberWithPercent() {
    final lowerCaseRegex = RegExp(r"^[a-z]+$");
    final numberWithPercentRegex = RegExp(r"^\d+%$");

    return lowerCaseRegex.hasMatch(this) ||
        numberWithPercentRegex.hasMatch(this);
  }

  /// Checks if [String] is a number followed by a `%` sign.
  bool isNumberWithPercent() {
    final numberWithPercentRegex = RegExp(r"^\d+%$");
    return numberWithPercentRegex.hasMatch(this);
  }

  /// Checks if string is a digit.
  bool isNumber() {
    final numberRegex = RegExp(r"^\d+$");
    return numberRegex.hasMatch(this);
  }

  /// Creates a list of phrase's from a [String] sentence.
  /// Meant to be used on typical sentence.
  ///
  /// The phrase will be at least [minPhraseLength] long.
  ///
  /// separateIntoPhrasesWithMinimumLength(
  ///           "Quietly, an old oak stood, surrounded by natures.", 20) =>
  /// [
  ///        "Quietly, an old oak stood,",
  ///        "Quietly, an old oak stood, surrounded",
  ///        "Quietly, an old oak stood, surrounded by",
  ///        "Quietly, an old oak stood, surrounded by natures.",
  ///        "an old oak stood, surrounded",
  ///        "an old oak stood, surrounded by",
  ///        "an old oak stood, surrounded by natures.",
  ///        "old oak stood, surrounded",
  ///        "old oak stood, surrounded by",
  ///        "old oak stood, surrounded by natures.",
  ///        "oak stood, surrounded",
  ///        "oak stood, surrounded by",
  ///        "oak stood, surrounded by natures.",
  ///        "stood, surrounded by",
  ///        "stood, surrounded by natures.",
  ///        "surrounded by natures."
  ///      ];

  List<String?> separateIntoPhrasesWithMinimumLength({
    // required final String sentence,
    required final int minPhraseLength,
  }) {
    final Set<String> listOfPhrases = {};

    final List<String> wordList = split(' ');

    int length = wordList.join(' ').length;

    while (length >= minPhraseLength) {
      String phrase = wordList.removeAt(0);

      for (final word in wordList) {
        phrase = '$phrase $word';
        if (phrase.length >= minPhraseLength) {
          listOfPhrases.add(phrase);
        }
      }
      length = wordList.join(' ').length;
    }

    return listOfPhrases.toList();
  }
}
