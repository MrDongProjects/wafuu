class SearchHistory {
  final String keyword;
  final String? romaji;
  final String? meaning;
  final String type;
  final String level;
  final Map<String, String> conjugations;
  final DateTime timestamp;

  SearchHistory({
    required this.keyword,
    this.romaji,
    this.meaning,
    this.type = '',
    this.level = '',
    this.conjugations = const {},
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'romaji': romaji,
      'meaning': meaning,
      'type': type,
      'level': level,
      'conjugations': conjugations,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      keyword: json['keyword'] as String,
      romaji: json['romaji'] as String?,
      meaning: json['meaning'] as String?,
      type: json['type'] as String? ?? '',
      level: json['level'] as String? ?? '',
      conjugations:
          Map<String, String>.from(json['conjugations'] as Map? ?? {}),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
