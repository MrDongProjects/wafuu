import 'package:wafu_bunpo/models/search_history.dart';

class FavoriteWord {
  final String id;
  final String word;
  final String reading;
  final String meaning;

  FavoriteWord({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaning,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'reading': reading,
      'meaning': meaning,
    };
  }

  factory FavoriteWord.fromJson(Map<String, dynamic> json) {
    return FavoriteWord(
      id: json['id'] as String,
      word: json['word'] as String,
      reading: json['reading'] as String,
      meaning: json['meaning'] as String,
    );
  }

  SearchHistory toSearchHistory() {
    return SearchHistory(
      keyword: word,
      romaji: reading,
      meaning: meaning,
      type: '',
      level: '',
      conjugations: const {},
      timestamp: DateTime.now(),
    );
  }
}
