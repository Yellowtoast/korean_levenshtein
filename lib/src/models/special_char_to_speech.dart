import '../extensions/string_extension.dart';

/// Represents a mapping from special characters to their Korean speech equivalents.
class SpecialCharToSpeech {
  /// The special character to be replaced.
  final String specialChar;

  /// The Korean speech equivalent of the special character.
  final String speech;

  /// Constructs a [SpecialCharToSpeech] instance.
  ///
  /// Parameters:
  /// - [specialChar] : The special character to be replaced.
  /// - [speech] : The Korean equivalent of the special character.
  ///
  /// Throws an [AssertionError] if the provided [speech] contains non-Korean characters.
  SpecialCharToSpeech({
    required this.specialChar,
    required this.speech,
  }) : assert(speech.isKoreanChar, 'Speech to convert is not Korean');
}

/// List of common special character to speech conversion options.
final List<SpecialCharToSpeech> commonSpecitalCharToSpeechOptions = [
  SpecialCharToSpeech(
    specialChar: '%',
    speech: '퍼센트',
  ),
  SpecialCharToSpeech(
    specialChar: '-',
    speech: '다시',
  ),
];
