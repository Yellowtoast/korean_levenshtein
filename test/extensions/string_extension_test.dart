import 'package:flutter_test/flutter_test.dart';
import 'package:korean_levenshtein/src/extensions/string_extension.dart';

void main() {
  group('isKoreanChar', () {
    test('should return true for Korean characters', () {
      expect('가'.isKoreanChar, true);
      expect('힣'.isKoreanChar, true);
      expect('ㄱ'.isKoreanChar, true);
      expect('ㅎ'.isKoreanChar, true);
    });

    test('should return false for non-Korean characters', () {
      expect('a'.isKoreanChar, false);
      expect('A'.isKoreanChar, false);
      expect('1'.isKoreanChar, false);
      expect(' '.isKoreanChar, false);
      expect('%'.isKoreanChar, false);
    });
  });

  group('containsEnglish', () {
    test('should return true if string contains English characters', () {
      expect('Hello'.containsEnglish, true);
      expect('안녕하세요Hello'.containsEnglish, true);
      expect('1234abc'.containsEnglish, true);
      expect('  '.containsEnglish, false);
    });

    test('should return false if string does not contain English characters',
        () {
      expect('안녕하세요'.containsEnglish, false);
      expect('1234'.containsEnglish, false);
      expect(' '.containsEnglish, false);
      expect('가나다라'.containsEnglish, false);
    });
  });

  group('decompose', () {
    test('should return null for non-Korean characters', () {
      expect('a'.decompose(), null);
      expect('A'.decompose(), null);
      expect('1'.decompose(), null);
      expect(' '.decompose(), null);
      expect('%'.decompose(), null);
    });

    test('should return decomposed phonemes for Korean characters', () {
      expect('가'.decompose(), ['ㄱ', 'ㅏ', ' ']);
      expect('감'.decompose(), ['ㄱ', 'ㅏ', 'ㅁ']);
      expect('뷁'.decompose(), ['ㅂ', 'ㅞ', 'ㄺ']);
      expect('한'.decompose(), ['ㅎ', 'ㅏ', 'ㄴ']);
    });
  });

  group('removeAllNumbers', () {
    test('should remove all numbers from the string', () {
      expect('Hello123'.removeAllNumbers(), 'Hello');
      expect('1234'.removeAllNumbers(), '');
      expect('abc123def456'.removeAllNumbers(), 'abcdef');
      expect(' '.removeAllNumbers(), ' ');
    });
  });

  group('removeAllSpecialCharsNotKorean', () {
    test(
        'should remove all special characters except Korean characters and spaces',
        () {
      expect('Hello! 안녕? 123'.removeAllSpecialCharsNotKorean(), 'Hello 안녕 123');
      expect('@#%^&*'.removeAllSpecialCharsNotKorean(), '');
      expect('가나다라 123 ㄱㄴㄷㅅ'.removeAllSpecialCharsNotKorean(), '가나다라 123 ㄱㄴㄷㅅ');
      expect('안녕하세요Hello123'.removeAllSpecialCharsNotKorean(), '안녕하세요Hello123');
    });
  });
}
