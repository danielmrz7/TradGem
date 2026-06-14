class TranslationItem {
  final String originalText;
  final String translatedText;
  final String fromLanguage;
  final String toLanguage;
  final String fromFlag;
  final String toFlag;
  final DateTime timestamp;
  bool isFavorite;

  TranslationItem({
    required this.originalText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
    required this.fromFlag,
    required this.toFlag,
    required this.timestamp,
    this.isFavorite = false,
  });
}