<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# KoreanLevenshtein

The KoreanLevenshtein algorithm is a modification of the traditional Levenshtein distance algorithm, specifically tailored to handle Korean text. It calculates the similarity between two Korean strings by measuring the difference in their characters, accounting for the nuances of the Korean language, such as decomposed phonemes and special characters.

## Features

- **Decomposed Phonemes Handling**: Korean characters consist of decomposed phonemes, namely, chosung, jungsung, and jongsung. The algorithm decomposes each character into its constituent phonemes, allowing for a more accurate comparison.
  
- **Numeric Character Replacement**: Optionally replaces numeric characters with their Korean representations, ensuring uniformity in text comparison regardless of numeric presence.
  
- **Special Character Replacement**: Optionally replaces special characters with their Korean speech equivalents, facilitating consistent comparison by considering special characters as part of the language.
  
- **Customized Phoneme Weights**: Allows users to customize the weights assigned to different phonemes, enabling fine-tuning of the comparison process based on specific requirements.

## Getting Started

To use this package, add `korean_levenshtein` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Usage

The KoreanLevenshtein algorithm provides functions for text comparison. Below is an example of how to use it:

```dart
import 'package:korean_levenshtein/korean_levenshtein.dart';

void main() {
  // Example usage of jamoSimilarityPercentage function
  double similarity = KoreanLevenshtein.jamoSimilarityPercentage(
    '안녕하세요',
    '안녕하십니까?',
    replaceNumberToKorean: true,
    replaceSpecialCharToKorean: true,
  );

  print('Similarity Percentage: $similarity');
}
```
