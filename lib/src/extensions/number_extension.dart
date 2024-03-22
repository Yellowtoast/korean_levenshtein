extension NumberExtension on int {
  String numbersToKorean() {
    int number = this;
    List<String> koreanNumber = [
      '',
      '일',
      '이',
      '삼',
      '사',
      '오',
      '육',
      '칠',
      '팔',
      '구'
    ];
    List<String> tenUnit = ['', '십', '백', '천'];
    List<String> tenThousandUnit = ['조', '억', '만', ''];
    int unit = 10000;

    String answer = '';

    while (number > 0) {
      int mod = number % unit;
      List<String> modToArray = mod.toString().split('');
      int length = modToArray.length - 1;

      String modToKorean = modToArray.asMap().entries.fold('', (acc, entry) {
        int index = entry.key;
        int valueToNumber = int.parse(entry.value);
        if (valueToNumber == 0) return acc;
        // 단위가 십 이상인 '일'글자는 출력하지 않는다. ex) 일십 -> 십
        String numberToKorean = index < length && valueToNumber == 1
            ? ''
            : koreanNumber[valueToNumber];
        return '$acc$numberToKorean${tenUnit[length - index]}';
      });

      answer = '$modToKorean${tenThousandUnit.removeLast()}$answer';
      number = (number / unit).floor();
    }

    return answer.trim();
  }
}

// extension NumberExtension on int {
//   static const List<String> _numberUnits = [
//     "",
//     "일",
//     "이",
//     "삼",
//     "사",
//     "오",
//     "육",
//     "칠",
//     "팔",
//     "구"
//   ];
//   static const List<String> _tenUnits = ["", "십", "백", "천"];
//   static const List<String> _thousandUnits = ["", "만", "억", "조", "경", "해"];

//   String numbersToKorean() {
//     int number = this;
//     if (number == 0) return '영';

//     List<String> digits = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];
//     List<String> units = ['', '십', '백', '천'];
//     List<String> largeUnits = ['', '만', '억', '조', '경', '해'];

//     String result = '';
//     int unitIndex = 0;

//     while (number > 0) {
//       int digit = number % 10;
//       number ~/= 10;

//       if (digit > 0) {
//         if (unitIndex % 4 == 0 && result.isNotEmpty) {
//           result = largeUnits[unitIndex ~/ 4] + result;
//         }
//         result = units[unitIndex % 4] + result;
//         if (digit != 1 || unitIndex % 4 != 1) {
//           result = digits[digit] + result;
//         }
//       }
//       unitIndex++;
//     }

//     return result;
//   }
// }

// void main() {
//   print(123456789.numbersToKorean()); // Prints: "일억이천삼백사십오만육천칠백팔십구"
// }
