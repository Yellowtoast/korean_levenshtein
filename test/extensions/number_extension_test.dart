import 'package:flutter_test/flutter_test.dart';
import 'package:korean_levenshtein/src/extensions/number_extension.dart';

void main() {
  group('NumberExtension', () {
    test('numbersToKorean', () {
      // Test cases for numbers from 0 to 9
      expect(0.numbersToKorean(), "");
      expect(1.numbersToKorean(), "일");
      expect(2.numbersToKorean(), "이");
      expect(3.numbersToKorean(), "삼");
      expect(4.numbersToKorean(), "사");
      expect(5.numbersToKorean(), "오");
      expect(6.numbersToKorean(), "육");
      expect(7.numbersToKorean(), "칠");
      expect(8.numbersToKorean(), "팔");
      expect(9.numbersToKorean(), "구");
    });

    test('test2', () {
      // Test cases for numbers from 10 to 99
      expect(10.numbersToKorean(), "십");
      expect(11.numbersToKorean(), "십일");
      expect(20.numbersToKorean(), "이십");
      expect(21.numbersToKorean(), "이십일");
      expect(99.numbersToKorean(), "구십구");
    });
    test('test3', () {
      // Test cases for numbers from 100 to 999
      expect(100.numbersToKorean(), "백");
      expect(101.numbersToKorean(), "백일");
      expect(111.numbersToKorean(), "백십일");
      expect(200.numbersToKorean(), "이백");
      expect(999.numbersToKorean(), "구백구십구");
    });
    test('test4', () {
      // Test cases for numbers from 1000 to 9999
      expect(1000.numbersToKorean(), "천");
      expect(1001.numbersToKorean(), "천일");
      expect(1010.numbersToKorean(), "천십");
      expect(1100.numbersToKorean(), "천백");
      expect(9999.numbersToKorean(), "구천구백구십구");
    });
    test('test5', () {
      // Test cases for numbers greater than 9999
      expect(10000.numbersToKorean(), "만");
      expect(100000.numbersToKorean(), "십만");
      expect(1000000.numbersToKorean(), "백만");
      expect(10000000.numbersToKorean(), "천만");
      expect(100000000.numbersToKorean(), "일억");
      expect(1000000000.numbersToKorean(), "십억");
      expect(10000000000.numbersToKorean(), "백억");
      expect(100000000000.numbersToKorean(), "천억");
      expect(1000000000000.numbersToKorean(), "일조");
      expect(10000000000000.numbersToKorean(), "십조");
      expect(100000000000000.numbersToKorean(), "백조");
      expect(1000000000000000.numbersToKorean(), "천조");
      expect(10000000000000000.numbersToKorean(), "일경");
      expect(100000000000000000.numbersToKorean(), "십경");
      expect(1000000000000000000.numbersToKorean(), "백경");
    });
    test('test6', () {
      expect(123.numbersToKorean(), "백이십삼");
      expect(1234.numbersToKorean(), "천이백삼십사");
      expect(34500.numbersToKorean(), "삼만사천오백");
      expect(16000.numbersToKorean(), "일만육천");
      expect(124500.numbersToKorean(), "십이만사천오백");
      expect(1240000.numbersToKorean(), "백이십사만");
    });
  });
}
