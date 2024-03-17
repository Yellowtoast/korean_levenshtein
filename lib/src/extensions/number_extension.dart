List<String> _numberUnits = [
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
List<String> _numberDigits = ['영', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

extension NumberExtension on int {
  String numbersToKorean() {
    if (this == 0) {
      return '영';
    }

    List<int> numList = [];
    int number = this;
    while (number > 0) {
      numList.add(number % 10);
      number ~/= 10;
    }

    String result = '';
    for (int i = numList.length - 1; i >= 0; i--) {
      int digit = numList[i];
      if (digit != 0) {
        result += _numberDigits[digit];
        result += _numberUnits[i];
      }
    }

    return result;
  }
}
