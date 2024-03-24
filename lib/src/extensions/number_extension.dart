extension NumberExtension on int {
  /// Converts the integer number to Korean representation.
  ///
  /// Returns the Korean representation of the integer number.
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
        // Do not output '일' character for units above ten. ex) 일십 -> 십
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
