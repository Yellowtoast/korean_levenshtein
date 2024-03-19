import 'dart:math';

// extension NumberExtention on int {
//   // Convert numbers to Korean words
//   String numbersToKorean() {
//     // List of Korean number units for single digits (0-9)
//     List<String> _numberUnits = [
//       "영",
//       "일",
//       "이",
//       "삼",
//       "사",
//       "오",
//       "육",
//       "칠",
//       "팔",
//       "구"
//     ];

// // List of Korean number units for tens (10, 20, 30, ...)
//     List<String> _tenUnits = ["", "십", "백", "천"];

// // List of Korean number units for thousands (만, 억, 조, ...)
//     List<String> _thousandUnits = ["", "만", "억", "조", "경", "해"];

//     // Helper function to chunk the number string from end
//     List<String> _chunkAtEnd(String value, [int n = 1]) {
//       List<String> result = [];
//       for (int end = value.length; end > 0; end -= n) {
//         result.add(value.substring(max(0, end - n), end));
//       }
//       return result;
//     }

//     return _chunkAtEnd(toString(), 4).fold<String>("", (acc, item) {
//       if (int.parse(item) == 0) {
//         return acc;
//       }

//       String numberUnit = "";

//       // Pad the number with leading zeros to ensure it's of length 4
//       String zeroNum = item.padLeft(4, "0");

//       // Iterate over each digit in the chunk and convert it to Korean
//       for (int i = 0; i < 4; i++) {
//         int number = int.parse(zeroNum[i]);

//         // If the digit is not zero, convert it to Korean
//         if (number != 0) {
//           String unit = _tenUnits[3 - i];
//           bool sadf = zeroNum.length >= 4 &&
//               unit.contains(RegExp(r'(백|천|만)')) &&
//               zeroNum[zeroNum.length - 1] == '1';

//           // Append the Korean representation of the digit along with its unit
//           numberUnit +=
//               "${(unit.isNotEmpty && number == 1) || sadf ? "" : _numberUnits[number]}$unit";
//         }
//       }

//       // Remove the next thousand unit from the list and append it to the result
//       String thousandUnit = _thousandUnits.removeAt(0);

//       // Append the chunk with its corresponding thousand unit to the accumulated result
//       return "${numberUnit + thousandUnit}$acc";
//     }).trim(); // Trim any leading/trailing whitespaces
//   }
// }
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
//     if (this == 0) {
//       return "영";
//     }

//     String result = '';
//     String numberString = toString();
//     int chunkCount = 0;

//     while (numberString.isNotEmpty) {
//       String chunk = numberString.length >= 4
//           ? numberString.substring(numberString.length - 4)
//           : numberString;
//       numberString = numberString.substring(0, max(0, numberString.length - 4));

//       String chunkResult = '';
//       bool isFirstDigit = true;
//       bool isLastChunk = chunkCount == 0 && numberString.isEmpty;
//       for (int i = 0; i < chunk.length; i++) {
//         int digit = int.parse(chunk[i]);
//         if (digit != 0) {
//           if (!isFirstDigit ||
//               (isFirstDigit && chunk.length == 1 && !isLastChunk)) {
//             chunkResult += _numberUnits[digit];
//           }
//           chunkResult += '${_tenUnits[chunk.length - 1 - i]}';
//           isFirstDigit = false;
//         }
//       }

//       if (chunkResult.isNotEmpty) {
//         chunkResult += _thousandUnits[chunkCount];
//       }

//       result = chunkResult + result;
//       chunkCount++;
//     }

//     return result;
//   }
// }
extension NumberExtension on int {
  static const List<String> _numberUnits = [
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
  static const List<String> _tenUnits = ["", "십", "백", "천"];
  static const List<String> _thousandUnits = ["", "만", "억", "조", "경", "해"];

  String numbersToKorean() {
    if (this == 0) {
      return "영";
    }

    String result = '';
    int chunkCount = 0;

    // Split number into 4-digit chunks
    String numberString = toString();
    while (numberString.isNotEmpty) {
      String chunk = numberString.length >= 4
          ? numberString.substring(numberString.length - 4)
          : numberString;
      numberString = numberString.substring(0, max(0, numberString.length - 4));

      // Convert chunk to Korean
      String chunkResult = '';
      for (int i = 0; i < chunk.length; i++) {
        int digit = int.parse(chunk[i]);
        if (digit != 0) {
          final asdf = (this < 1000 || chunk.length <= 2) &&
              chunk[i] == '1' &&
              numberString.isEmpty;
          chunkResult += (asdf)
              ? _tenUnits[chunk.length - 1 - i]
              : '${_numberUnits[digit]}${_tenUnits[chunk.length - 1 - i]}';
        }
      }

      // Add chunk unit
      chunkResult += _thousandUnits[chunkCount];

      // Combine chunk result with previous chunks
      result = chunkResult + result;
      chunkCount++;
    }

    return result;
  }
}

void main() {
  print(123456789.numbersToKorean()); // Prints: "일억이천삼백사십오만육천칠백팔십구"
}
