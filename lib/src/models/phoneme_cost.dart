/// Class to specify Levenshtein distance weights for Korean phonemes
class PhonemeCost {
  /// Sum of values for three phonemes that constitute one syllable
  static const _totalPhonemeCost = 3.0;

  /// Default cost assigned to a single phoneme
  static const _defaultSinglePhonemeCost = 1.0;

  /// Number of phonemes in a Korean syllable
  static const _koreanCharSyllableNumber = 3;

  /// Weight assigned to the first phoneme of a syllable
  final double chosungCost;

  /// Weight assigned to the second phoneme of a syllable
  final double jungsungCost;

  /// Weight assigned to the third phoneme of a syllable
  final double jongsungCost;

  /// Constructs a PhonemeCost object with specified weights for each phoneme
  const PhonemeCost({
    this.chosungCost = 1.5,
    this.jungsungCost = 1.0,
    this.jongsungCost = 0.5,
  }) : assert((chosungCost + jungsungCost + jongsungCost) == _totalPhonemeCost,
            'Total cost weight should be 3.0');

  /// Retrieves the weight based on the order of the phoneme in a syllable
  ///
  /// The [orderIndex] indicates the position of the phoneme within the syllable,
  /// with 0 being the first phoneme, 1 being the second, and 2 being the third.
  /// If the [orderIndex] is out of range, the default single phoneme cost is returned.
  double getCostByOrderOfPhoneme(int orderIndex) {
    int phonemeIndex = orderIndex % _koreanCharSyllableNumber;

    if (phonemeIndex == 0) {
      return chosungCost;
    } else if (phonemeIndex == 1) {
      return jungsungCost;
    } else if (phonemeIndex == 2) {
      return jongsungCost;
    } else {
      return _defaultSinglePhonemeCost;
    }
  }
}
