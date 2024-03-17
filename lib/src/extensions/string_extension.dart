/// Unicode for the start point of Korean characters
const int _korBegin = 44032;

/// Unicode for the end point of Korean characters
const int _korEnd = 55203;

/// Unicode for the start point of the first phoneme of Korean characters (Chosung)
const int _chosungBase = 588;

/// Unicode for the start point of the second phoneme of Korean characters (Jungsung)
const int _jungsungBase = 28;

/// Unicode for the start point of Korean consonants
const int _jaumBegin = 12593;

/// Unicode for the end point of Korean consonants
const int _jaumEnd = 12622;

/// Unicode for the start point of Korean vowels
const int _moumBegin = 12623;

/// Unicode for the end point of Korean vowels
const int _moumEnd = 12643;

/// Array of Korean consonants sorted in the same order as Unicode
List<String> _chosungList = [
  'ㄱ',
  'ㄲ',
  'ㄴ',
  'ㄷ',
  'ㄸ',
  'ㄹ',
  'ㅁ',
  'ㅂ',
  'ㅃ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅉ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ'
];

/// Array of Korean vowels sorted in the same order as Unicode
List<String> _jungsungList = [
  'ㅏ',
  'ㅐ',
  'ㅑ',
  'ㅒ',
  'ㅓ',
  'ㅔ',
  'ㅕ',
  'ㅖ',
  'ㅗ',
  'ㅘ',
  'ㅙ',
  'ㅚ',
  'ㅛ',
  'ㅜ',
  'ㅝ',
  'ㅞ',
  'ㅟ',
  'ㅠ',
  'ㅡ',
  'ㅢ',
  'ㅣ'
];

/// Array of Korean consonants sorted in the same order as Unicode
List<String> _jongsungList = [
  ' ',
  'ㄱ',
  'ㄲ',
  'ㄳ',
  'ㄴ',
  'ㄵ',
  'ㄶ',
  'ㄷ',
  'ㄹ',
  'ㄺ',
  'ㄻ',
  'ㄼ',
  'ㄽ',
  'ㄾ',
  'ㄿ',
  'ㅀ',
  'ㅁ',
  'ㅂ',
  'ㅄ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ'
];

extension KoreanStrExtension on String {
  /// Checks if the character is a Korean character
  bool get isKoreanChar {
    int i = codeUnitAt(0);
    return ((_korBegin <= i && i <= _korEnd) ||
        (_jaumBegin <= i && i <= _jaumEnd) ||
        (_moumBegin <= i && i <= _moumEnd));
  }

  /// Checks if the string contains English characters
  bool get containsEnglish {
    RegExp regex = RegExp(r'[a-zA-Z]');
    return regex.hasMatch(this);
  }

  /// Decomposes the Korean character into phonemes
  List<String>? decompose() {
    if (!isKoreanChar) return null;
    int i = codeUnitAt(0);
    if (_jaumBegin <= i && i <= _jaumEnd) return [this, ' ', ' '];
    if (_moumBegin <= i && i <= _moumEnd) return [' ', this, ' '];

    // Decomposition rule
    i -= _korBegin;
    int cho = i ~/ _chosungBase;
    int jung = (i - cho * _chosungBase) ~/ _jungsungBase;
    int jong = (i - cho * _chosungBase - jung * _jungsungBase);
    return [_chosungList[cho], _jungsungList[jung], _jongsungList[jong]];
  }

  /// Removes all numbers from the string
  String removeAllNumbers() {
    return replaceAll(RegExp(r'[0-9]+'), '');
  }

  /// Removes all special characters except Korean characters and spaces from the string
  String removeAllSpecialCharsNotKorean() {
    return replaceAll(RegExp(r'[^\w\sㄱ-ㅎㅏ-ㅣ가-힣]'), '');
  }
}
