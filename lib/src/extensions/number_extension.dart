import 'dart:math';

const _numberUnits = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];
const _tenUnits = ["", "십", "백", "천"];
const _thousandUnits = ["", "만", "억", "조", "경", "해"];

extension NumberExtention on int {
  String numbersToKorean() {
    List<String> _chunkAtEnd(String value, [int n = 1]) {
      List<String> result = [];
      for (int end = value.length; end > 0; end -= n) {
        result.add(value.substring(max(0, end - n), end));
      }
      return result;
    }

    return _chunkAtEnd(toString(), 4).fold<String>("", (acc, item) {
      if (int.parse(item) == 0) {
        return acc;
      }

      String numberUnit = "";

      String zeroNum = item.padLeft(4, "0");

      for (int i = 0; i < 4; i++) {
        int number = int.parse(zeroNum[i]);

        if (number != 0) {
          String unit = _tenUnits[3 - i];

          numberUnit +=
              "${unit.isNotEmpty && number == 1 ? "" : _numberUnits[number]}$unit";
        }
      }

      String thousandUnit = _thousandUnits.removeAt(0);

      return "${numberUnit + thousandUnit}$acc";
    }).trim();
  }
}
