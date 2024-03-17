import '../extensions/string_extension.dart';

class SpecialCharToSpeech {
  final String specialChar;
  final String speech;

  SpecialCharToSpeech({required this.specialChar, required this.speech})
      : assert(speech.isKoreanChar, 'Speech to convert is not Korean');
}

final List<SpecialCharToSpeech> defaultSpecitalCharOptions = [
  SpecialCharToSpeech(
    specialChar: '%',
    speech: '퍼센트',
  ),
  SpecialCharToSpeech(
    specialChar: '-',
    speech: '다시',
  ),
];
