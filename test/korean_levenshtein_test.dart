import 'package:flutter_test/flutter_test.dart';
import 'package:korean_levenshtein/korean_levenshtein.dart';

void main() {
  group('KoreanLevenshtein', () {
    test('jamoSimilarityPercentage', () {
      // Test case 1: identical strings
      String s1 = '안녕하세요';
      String s2 = '안녕하세요';
      double similarity = KoreanLevenshtein.jamoSimilarityPercentage(s1, s2);
      expect(similarity, equals(100));

      // Test case 2: different strings
      s1 = '안녕하세요';
      s2 = '반갑습니다';
      similarity = KoreanLevenshtein.jamoSimilarityPercentage(s1, s2);
      expect(similarity, lessThan(50));

      // Add more test cases as needed
    });

    test('jamoLevenshteinDistance', () {
      // Test case 1: identical strings
      String s1 = '안녕하세요';
      String s2 = '안녕하세요';
      double distance = KoreanLevenshtein.jamoLevenshteinDistance(s1, s2);
      expect(distance, equals(0));

      // Test case 2: different strings
      s1 = '안녕하세요';
      s2 = '반갑습니다';
      distance = KoreanLevenshtein.jamoLevenshteinDistance(s1, s2);
      expect(distance, greaterThan(0));

      // Add more test cases as needed
    });

    test('replaceSpecialCharsWithKorean', () {
      // Test case 1: replacing special characters
      String text = '특수문자를 치환해봅시다! @%^';
      List<SpecialCharToSpeech> options = [
        SpecialCharToSpeech(specialChar: '@', speech: '에이트'),
        SpecialCharToSpeech(specialChar: '%', speech: '퍼센트'),
        SpecialCharToSpeech(specialChar: '^', speech: '캐럿'),
      ];
      String result = KoreanLevenshtein.replaceSpecialCharsWithKorean(text,
          specialCharToSpeech: options);
      expect(result, equals('특수문자를 치환해봅시다 에이트퍼센트캐럿'));

      // Test case 2: no special characters to replace
      text = '이 문자열에는 특수문자가 없습니다';
      result = KoreanLevenshtein.replaceSpecialCharsWithKorean(text,
          specialCharToSpeech: options);
      expect(result, equals(text));

      // Add more test cases as needed
    });

    test('replaceNumberWithKorean', () {
      // Test case 1: replacing numeric characters
      String text = '1234';
      String result = KoreanLevenshtein.replaceNumberWithKorean(text);
      expect(result, equals('천이백삼십사'));

      // Test case 2: no numeric characters to replace
      text = '숫자가 없는 문자열입니다.';
      result = KoreanLevenshtein.replaceNumberWithKorean(text);
      expect(result, equals(text));

      // Add more test cases as needed
    });
  });
}
