library korean_levenshtein;

import 'package:korean_levenshtein/phoneme_cost.dart';

part 'korean_jamo_info.dart';

class KoreanLevenshtein {
  static const double _defaultDistanceCost = 1.0;

  static bool isKoreanChar(String c) {
    int i = c.codeUnitAt(0);
    return ((_korBegin <= i && i <= _korEnd) ||
        (_jaumBegin <= i && i <= _jaumEnd) ||
        (_moumBegin <= i && i <= _moumEnd));
  }

  String convertTextToKorean(String text) {
    // 숫자를 한글로 변환하는 함수
    String numberToKorean(int number) {
      if (number == 0) {
        return '영';
      }

      List<String> units = [
        '',
        '십',
        '백',
        '천',
        '만',
        '십만',
        '백만',
        '천만',
        '억',
        '십억',
        '백억',
        '천억',
        '조',
        '십조',
        '백조',
        '천조',
        '경',
        '십경',
        '백경',
        '천경'
      ];
      List<String> digits = ['영', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

      List<int> numList = [];
      while (number > 0) {
        numList.add(number % 10);
        number ~/= 10;
      }

      String result = '';
      for (int i = numList.length - 1; i >= 0; i--) {
        int digit = numList[i];
        if (digit != 0) {
          result += digits[digit];
          result += units[i];
        }
      }

      return result;
    }

    // 텍스트에서 숫자 부분을 한글로 변환하는 함수
    String replaceNumberWithKorean(String text) {
      String result = '';
      String currentNumber = '';
      bool isNumber = false;

      for (int i = 0; i < text.length; i++) {
        if (RegExp(r'[0-9]').hasMatch(text[i])) {
          currentNumber += text[i];
          isNumber = true;
        } else {
          if (isNumber) {
            result += numberToKorean(int.parse(currentNumber));
            currentNumber = '';
            isNumber = false;
          }
          result += text[i];
        }
      }
      if (isNumber) {
        result += numberToKorean(int.parse(currentNumber));
      }

      return result;
    }

    return replaceNumberWithKorean(text);
  }

  static List<String>? decompose(String c) {
    if (!isKoreanChar(c)) return null;
    int i = c.codeUnitAt(0);
    if (_jaumBegin <= i && i <= _jaumEnd) return [c, ' ', ' '];
    if (_moumBegin <= i && i <= _moumEnd) return [' ', c, ' '];

    // decomposition rule
    i -= _korBegin;
    int cho = i ~/ _chosungBase;
    int jung = (i - cho * _chosungBase) ~/ _jungsungBase;
    int jong = (i - cho * _chosungBase - jung * _jungsungBase);
    return [_chosungList[cho], _jungsungList[jung], _jongsungList[jong]];
  }

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
          ? phonemeCost.getCostByIndexOfPhonemeList(i)
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

  static double jamoLevenshteinDistance(String s1, String s2,
      {PhonemeCost? phonemeCost, bool debug = false}) {
    if (s1.length < s2.length) {
      return jamoLevenshteinDistance(s2, s1, debug: debug);
    }

    if (s2.isEmpty) return s1.length.toDouble();

    double substitutionCost(String c1, String c2) {
      if (c1 == c2) return 0;
      return _levenshtein(decompose(c1)!.join(), decompose(c2)!.join(),
              phonemeCost: phonemeCost) /
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

  static double jamoSimilarityPercentage(
    String s1,
    String s2, {
    bool replaceNumberToKorean = true,
  }) {
    int maxLen = s1.length > s2.length ? s1.length : s2.length;
    double distance = jamoLevenshteinDistance(
      s1,
      s2,
    );
    return ((maxLen - distance) / maxLen) * 100;
  }

  static double jamoSimilarityPercentageWithPhonemeCost(
    String s1,
    String s2, {
    bool replaceNumberToKorean = true,
    required PhonemeCost phonemeCost,
  }) {
    int maxLen = s1.length > s2.length ? s1.length : s2.length;
    double distance = jamoLevenshteinDistance(
      s1,
      s2,
      phonemeCost: phonemeCost,
    );
    return ((maxLen - distance) / maxLen) * 100;
  }
}
