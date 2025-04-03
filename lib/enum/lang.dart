enum Language { english, indonesian }

extension LanguageExtension on Language {
  String get code {
    switch (this) {
      case Language.english:
        return 'en';
      case Language.indonesian:
        return 'id';
    }
  }

  String get flag {
    switch (this) {
      case Language.english:
        return '🇺🇸';
      case Language.indonesian:
        return '🇮🇩';
    }
  }
}
