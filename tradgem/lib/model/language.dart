class Language {
  final String name;
  final String code;
  final String flag; // emoji de bandeira

  const Language({
    required this.name,
    required this.code,
    required this.flag,
  });
}

// Lista de idiomas disponíveis para tradução
final List<Language> availableLanguages = [
  const Language(name: 'Português',  code: 'pt', flag: '🇧🇷'),
  const Language(name: 'Inglês',     code: 'en', flag: '🇺🇸'),
  const Language(name: 'Espanhol',   code: 'es', flag: '🇪🇸'),
  const Language(name: 'Francês',    code: 'fr', flag: '🇫🇷'),
  const Language(name: 'Alemão',     code: 'de', flag: '🇩🇪'),
  const Language(name: 'Italiano',   code: 'it', flag: '🇮🇹'),
  const Language(name: 'Japonês',    code: 'ja', flag: '🇯🇵'),
  const Language(name: 'Chinês',     code: 'zh', flag: '🇨🇳'),
  const Language(name: 'Árabe',      code: 'ar', flag: '🇸🇦'),
  const Language(name: 'Russo',      code: 'ru', flag: '🇷🇺'),
  const Language(name: 'Coreano',    code: 'ko', flag: '🇰🇷'),
  const Language(name: 'Hindi',      code: 'hi', flag: '🇮🇳'),
];