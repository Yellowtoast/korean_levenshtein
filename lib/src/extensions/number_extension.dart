import 'dart:math';

extension NumberExtention on int {
  // Convert numbers to Korean words
  String numbersToKorean() {
    // List of Korean number units for single digits (0-9)
    List<String> _numberUnits = [
      "",
      "일",
      "이",
      "삼",
      "사",
      "오",
      "육",
      "칠",
      "팔",
      "구"
    ];

// List of Korean number units for tens (10, 20, 30, ...)
    List<String> _tenUnits = ["", "십", "백", "천"];

// List of Korean number units for thousands (만, 억, 조, ...)
    List<String> _thousandUnits = ["", "만", "억", "조", "경", "해"];

    // Helper function to chunk the number string from end
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

      // Pad the number with leading zeros to ensure it's of length 4
      String zeroNum = item.padLeft(4, "0");

      // Iterate over each digit in the chunk and convert it to Korean
      for (int i = 0; i < 4; i++) {
        int number = int.parse(zeroNum[i]);

        // If the digit is not zero, convert it to Korean
        if (number != 0) {
          String unit = _tenUnits[3 - i];

          // Append the Korean representation of the digit along with its unit
          numberUnit +=
              "${unit.isNotEmpty && number == 1 ? "" : _numberUnits[number]}$unit";
        }
      }

      // Remove the next thousand unit from the list and append it to the result
      String thousandUnit = _thousandUnits.removeAt(0);

      // Append the chunk with its corresponding thousand unit to the accumulated result
      return "${numberUnit + thousandUnit}$acc";
    }).trim(); // Trim any leading/trailing whitespaces
  }
}
