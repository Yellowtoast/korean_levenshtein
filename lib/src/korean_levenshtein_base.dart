// ignore_for_file: avoid_print

import 'models/phoneme_cost.dart';
import 'models/special_char_to_speech.dart';
import 'extensions/string_extension.dart';
import 'extensions/number_extension.dart';
import 'exceptions.dart';

/// Calculates the similarity between two Korean strings using Levenshtein distance with decomposed phonemes, enhancing accuracy.
class KoreanLevenshtein {
  static const double _defaultDistanceCost = 1.0;

  /// Calculates the similarity percentage between two Korean strings based on decomposed phonemes.
  ///
  /// Parameters:
  /// - [s1] : The first Korean string.
  /// - [s2] : The second Korean string.
  /// - [replaceNumberToKorean] : Whether to replace numeric characters with Korean representations.
  /// - [replaceSpecialCharToKorean] : Whether to replace special characters with their Korean equivalents based on provided options.
  /// - [phonemeCost] : Customized weights for different phonemes.
  /// - [specialCharReplacementOptions] : Options for replacing special characters.
  ///
  /// Returns the similarity percentage between the two strings.
  static double jamoSimilarityPercentage(
    String s1,
    String s2, {
    bool replaceNumberToKorean = true,
    bool replaceSpecialCharToKorean = true,
    PhonemeCost? phonemeCost,
    List<SpecialCharToSpeech>? specialCharReplacementOptions,
  }) {
    assert(
      !s1.containsEnglish || !s2.containsEnglish,
      'English should not be contained',
    );

    s1 = s1.replaceAll(' ', '');
    s2 = s2.replaceAll(' ', '');

    if (replaceNumberToKorean) {
      s1 = replaceNumberWithKorean(s1);
      s2 = replaceNumberWithKorean(s2);
    } else {
      s1 = s1.removeAllNumbers();
      s2 = s2.removeAllNumbers();
    }

    if (replaceSpecialCharToKorean) {
      specialCharReplacementOptions ??= commonSpecitalCharToSpeechOptions;

      s1 = replaceSpecialCharsWithKorean(s1,
          specialCharToSpeech: specialCharReplacementOptions);
      s2 = replaceSpecialCharsWithKorean(s2,
          specialCharToSpeech: specialCharReplacementOptions);
    } else {
      s1 = s1.removeAllSpecialCharsNotKorean();
      s2 = s2.removeAllSpecialCharsNotKorean();
    }

    final int maxLen = s1.length > s2.length ? s1.length : s2.length;
    final double distance = jamoLevenshteinDistance(
      s1,
      s2,
      phonemeCost: phonemeCost,
    );
    return ((maxLen - distance) / maxLen) * 100;
  }

  /// Computes the Levenshtein distance between two Korean strings based on decomposed phonemes.
  ///
  /// Parameters:
  /// - [s1] : The first Korean string.
  /// - [s2] : The second Korean string.
  /// - [phonemeCost] : Customized weights for different phonemes.
  /// - [debug] : Whether to print debugging information.
  ///
  /// Returns the Levenshtein distance between the two strings.
  static double jamoLevenshteinDistance(String s1, String s2,
      {PhonemeCost? phonemeCost, bool debug = false}) {
    if (s1.length < s2.length) {
      return jamoLevenshteinDistance(s2, s1, debug: debug);
    }

    if (s2.isEmpty) return s1.length.toDouble();

    double substitutionCost(String c1, String c2) {
      if (c1 == c2) return 0;

      final decomposedC1 = c1.decompose();
      final decomposedC2 = c2.decompose();

      if (decomposedC1 == null || decomposedC2 == null) {
        throw const NonKoreanContainsException();
      }
      return _levenshtein(
            decomposedC1.join(),
            decomposedC2.join(),
            phonemeCost: phonemeCost,
          ) /
          3;
    }

    List<double> previousRow =
        List<double>.generate(s2.length + 1, (int index) => index.toDouble());

    for (int i = 0; i < s1.length; i++) {
      List<double> currentRow = [i + _defaultDistanceCost];

      for (int j = 0; j < s2.length; j++) {
        double insertions = previousRow[j + 1] + _defaultDistanceCost;
        double deletions = currentRow[j] + _defaultDistanceCost;
        double substitutions = previousRow[j] + substitutionCost(s1[i], s2[j]);
        currentRow.add([insertions, deletions, substitutions]
            .reduce((a, b) => a < b ? a : b));
      }

      if (debug) {
        print(currentRow
            .sublist(1)
            .map((double v) => v.toStringAsFixed(3))
            .toList());
      }

      previousRow = currentRow;
    }

    return previousRow.last;
  }

  /// Computes the Levenshtein distance between two Korean strings based on character level.
  ///
  /// Parameters:
  /// - [s1] : The first Korean string.
  /// - [s2] : The second Korean string.
  /// - [phonemeCost] : Customized weights for different phonemes.
  /// - [debug] : Whether to print debugging information.
  ///
  /// Returns the Levenshtein distance between the two strings.
  static double _levenshtein(String s1, String s2,
      {PhonemeCost? phonemeCost, bool debug = false}) {
    if (s1.length < s2.length) {
      return _levenshtein(s2, s1, phonemeCost: phonemeCost, debug: debug);
    }

    if (s2.isEmpty) return s1.length.toDouble();

    List<double> previousRow =
        List<double>.generate(s2.length + 1, (int index) => index.toDouble());

    for (int i = 0; i < s1.length; i++) {
      final cost = (phonemeCost != null)
          ? phonemeCost.getCostByOrderOfPhoneme(i)
          : _defaultDistanceCost;

      List<double> currentRow = [i + cost];

      for (int j = 0; j < s2.length; j++) {
        double insertions = previousRow[j + 1] + cost;
        double deletions = currentRow[j] + cost;
        double substitutions = previousRow[j] + (s1[i] != s2[j] ? cost : 0);
        currentRow.add([insertions, deletions, substitutions]
            .reduce((a, b) => a < b ? a : b));
      }

      if (debug) print(currentRow.sublist(1));

      previousRow = currentRow;
    }

    return previousRow.last;
  }

  /// Replaces special characters in the text with their Korean equivalents based on provided options.
  ///
  /// Parameters:
  /// - [text] : The input text to be processed.
  /// - [specialCharToSpeech] : Options for replacing special characters.
  ///
  /// Returns the text with special characters replaced by their Korean equivalents.
  static String replaceSpecialCharsWithKorean(
    String text, {
    required List<SpecialCharToSpeech> specialCharToSpeech,
  }) {
    Map<String, String> specialCharsToKoreanMap = {};

    if (specialCharToSpeech.isNotEmpty) {
      specialCharsToKoreanMap.addAll(
        {for (var v in specialCharToSpeech) v.specialChar: v.speech},
      );
    }

    String result = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (specialCharsToKoreanMap.containsKey(char)) {
        result += specialCharsToKoreanMap[char] ?? '';
      } else {
        result += char;
      }
    }

    // Remove any special characters that were not replaced.
    result = result.removeAllSpecialCharsNotKorean();

    return result;
  }

  /// Replaces numeric characters in the text with their Korean representations.
  ///
  /// Parameters:
  /// - [text] : The input text to be processed.
  ///
  /// Returns the text with numeric characters replaced by their Korean representations.
  static String replaceNumberWithKorean(String text) {
    String result = '';
    String currentNumber = '';
    bool isNumber = false;

    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(text[i])) {
        currentNumber += text[i];
        isNumber = true;
      } else {
        if (isNumber) {
          result += int.parse(currentNumber).numbersToKorean();
          currentNumber = '';
          isNumber = false;
        }
        result += text[i];
      }
    }
    if (isNumber) {
      result += int.parse(currentNumber).numbersToKorean();
    }

    return result;
  }
}
