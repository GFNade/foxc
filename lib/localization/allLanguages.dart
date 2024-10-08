import 'dart:ui';

enum Language {
  Arabic,
  Chinese,
  English,
  Danish,
  Dutch,
  French,
  German,
  Greek,
  Hindi,
  Indonesian,
  Italian,
  Japanese,
  Korean,
  Norwegian,
  Polish,
  Portuguese,
  Russian,
  Spanish,
  Swedish,
  Thai,
  Turkish,
  Vietnamese,
}

List<Lang> LANGUAGES = [
  Lang(
      displayName: "English",
      nameInEnglish: "English",
      language: Language.English),
  Lang(
      displayName: "العربية",
      nameInEnglish: "Arabic",
      language: Language.Arabic),
  Lang(displayName: "中文", nameInEnglish: "Chinese", language: Language.Chinese),
  Lang(
      displayName: "Dansk", nameInEnglish: "Danish", language: Language.Danish),
  Lang(
      displayName: "Nederlands",
      nameInEnglish: "Dutch",
      language: Language.Dutch),
  Lang(
      displayName: "Français",
      nameInEnglish: "French",
      language: Language.French),
  Lang(
      displayName: "Deutsch",
      nameInEnglish: "German",
      language: Language.German),
  Lang(
      displayName: "Ελληνικά",
      nameInEnglish: "Greek",
      language: Language.Greek),
  Lang(displayName: "हिन्दी", nameInEnglish: "Hindi", language: Language.Hindi),
  Lang(
      displayName: "Bahasa Indonesia",
      nameInEnglish: "Indonesian",
      language: Language.Indonesian),
  Lang(
      displayName: "Italiano",
      nameInEnglish: "Italian",
      language: Language.Italian),
  Lang(
      displayName: "日本語",
      nameInEnglish: "Japanese",
      language: Language.Japanese),
  Lang(displayName: "한국어", nameInEnglish: "Korean", language: Language.Korean),
  Lang(
      displayName: "Norsk",
      nameInEnglish: "Norwegian",
      language: Language.Norwegian),
  Lang(
      displayName: "Polski",
      nameInEnglish: "Polish",
      language: Language.Polish),
  Lang(
      displayName: "Português",
      nameInEnglish: "Portuguese",
      language: Language.Portuguese),
  Lang(
      displayName: "Русский",
      nameInEnglish: "Russian",
      language: Language.Russian),
  Lang(
      displayName: "Español",
      nameInEnglish: "Spanish",
      language: Language.Spanish),
  Lang(
      displayName: "Svenska",
      nameInEnglish: "Swedish",
      language: Language.Swedish),
  Lang(displayName: "ไทย", nameInEnglish: "Thai", language: Language.Thai),
  Lang(
      displayName: "Türkçe",
      nameInEnglish: "Turkish",
      language: Language.Turkish),
  Lang(
      displayName: "Tiếng Việt",
      nameInEnglish: "Vietnamese",
      language: Language.Vietnamese),
];

extension LanguageExtension on Language {
  Locale get local {
    return Locale(languageCode);
  }

  String get languageCode {
    switch (this) {
      case Language.Arabic:
        return "ar";
      case Language.Chinese:
        return "zh-Hans";
      case Language.English:
        return "en";
      case Language.Danish:
        return "da";
      case Language.Dutch:
        return "nl";
      case Language.French:
        return "fr";
      case Language.German:
        return "de";
      case Language.Greek:
        return "el";
      case Language.Hindi:
        return "hi";
      case Language.Indonesian:
        return "id";
      case Language.Italian:
        return "it";
      case Language.Japanese:
        return "ja";
      case Language.Korean:
        return "ko";
      case Language.Norwegian:
        return "no";
      case Language.Polish:
        return "pl";
      case Language.Portuguese:
        return "pt";
      case Language.Russian:
        return "ru";
      case Language.Spanish:
        return "es";
      case Language.Swedish:
        return "sv";
      case Language.Thai:
        return "th";
      case Language.Turkish:
        return "tr";
      case Language.Vietnamese:
        return "vi";
    }
  }
}

class Lang {
  final String displayName;
  final String nameInEnglish;
  final Language language;

  Lang(
      {required this.displayName,
      required this.nameInEnglish,
      required this.language});
}
