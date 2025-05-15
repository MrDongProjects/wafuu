class UserSettings {
  final int newWordsPerDay;
  final int reviewWordsPerDay;
  final bool autoPlayWord;
  final bool autoPlaySentence;
  final bool showRomaji;
  final bool showHiragana;

  UserSettings({
    required this.newWordsPerDay,
    required this.reviewWordsPerDay,
    required this.autoPlayWord,
    required this.autoPlaySentence,
    required this.showRomaji,
    required this.showHiragana,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      newWordsPerDay: json['newWordsPerDay'] as int,
      reviewWordsPerDay: json['reviewWordsPerDay'] as int,
      autoPlayWord: json['autoPlayWord'] as bool,
      autoPlaySentence: json['autoPlaySentence'] as bool,
      showRomaji: json['showRomaji'] as bool,
      showHiragana: json['showHiragana'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'newWordsPerDay': newWordsPerDay,
        'reviewWordsPerDay': reviewWordsPerDay,
        'autoPlayWord': autoPlayWord,
        'autoPlaySentence': autoPlaySentence,
        'showRomaji': showRomaji,
        'showHiragana': showHiragana,
      };
}
