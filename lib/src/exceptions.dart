class NonKoreanContainsException implements Exception {
  final String? msg;

  const NonKoreanContainsException([this.msg]);

  @override
  String toString() => msg ?? 'Input String contains non-korean';
}
