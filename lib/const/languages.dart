class Languages {
  static final languages_list = ["English", "Telugu", "Hindi", "Tamil"];

  static final languagesTitles = ['English', 'తెలుగు', 'हिंदी', 'பெயர்'];

  static final languageFirstLetter = ["E", "తె", "हिं", 'பெ'];

  static Map<String, String> applyLanguageText = {
    'en': 'Apply Language',
    'hi': 'भाषा लागू करें',
    'te': 'భాషను వర్తించండి',
    'ta': 'மொழி பயன்படுத்து'
  };

  static String getApplyLanguageText(String languageCode) {
    return applyLanguageText[languageCode] ?? 'Apply Language';
  }
}
