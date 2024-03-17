const int _korBegin = 44032;
const int _korEnd = 55203;
const int _chosungBase = 588;
const int _jungsungBase = 28;
const int _jaumBegin = 12593;
const int _jaumEnd = 12622;
const int _moumBegin = 12623;
const int _moumEnd = 12643;

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
  bool get isKoreanChar {
    int i = codeUnitAt(0);
    return ((_korBegin <= i && i <= _korEnd) ||
        (_jaumBegin <= i && i <= _jaumEnd) ||
        (_moumBegin <= i && i <= _moumEnd));
  }

  bool get containsEnglish {
    RegExp regex = RegExp(r'[a-zA-Z]');
    return regex.hasMatch(this);
  }

  List<String>? decompose() {
    if (!isKoreanChar) return null;
    int i = codeUnitAt(0);
    if (_jaumBegin <= i && i <= _jaumEnd) return [this, ' ', ' '];
    if (_moumBegin <= i && i <= _moumEnd) return [' ', this, ' '];

    // decomposition rule
    i -= _korBegin;
    int cho = i ~/ _chosungBase;
    int jung = (i - cho * _chosungBase) ~/ _jungsungBase;
    int jong = (i - cho * _chosungBase - jung * _jungsungBase);
    return [_chosungList[cho], _jungsungList[jung], _jongsungList[jong]];
  }

  String removeAllNumbers() {
    return replaceAll(RegExp(r'[0-9]+'), '');
  }

  String removeAllSpecialCharsNotKorean() {
    return replaceAll(RegExp(r'[^\w\sㄱ-ㅎㅏ-ㅣ가-힣]'), '');
  }
}
