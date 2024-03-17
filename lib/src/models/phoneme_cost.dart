class PhonemeCost {
  static const _totalPhonemeCost = 3.0;
  static const _defaultSinglePhonemeCost = 1.0;
  static const _korSyllableNumber = 3;

  final double chosungCost;
  final double jungsungCost;
  final double jongsungCost;

  const PhonemeCost({
    this.chosungCost = 1.5,
    this.jungsungCost = 1.0,
    this.jongsungCost = 0.5,
  }) : assert((chosungCost + jungsungCost + jongsungCost) == _totalPhonemeCost,
            'Total cost weight should be 3.0');

  double getCostByOrderOfPhoneme(int orderIndex) {
    int phonemeIndex = orderIndex % _korSyllableNumber;

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
