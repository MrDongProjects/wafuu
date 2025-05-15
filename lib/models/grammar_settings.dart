class GrammarSettings {
  final String userId;
  final String level;
  final int dailyCount;
  final DateTime lastStudyDate;
  final int todayCompletedCount;
  final List<String> completedGrammarIds;

  GrammarSettings({
    required this.userId,
    required this.level,
    required this.dailyCount,
    required this.lastStudyDate,
    this.todayCompletedCount = 0,
    this.completedGrammarIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'level': level,
        'dailyCount': dailyCount,
        'lastStudyDate': lastStudyDate.toIso8601String(),
        'todayCompletedCount': todayCompletedCount,
        'completedGrammarIds': completedGrammarIds,
      };

  factory GrammarSettings.fromJson(Map<String, dynamic> json) =>
      GrammarSettings(
        userId: json['userId'],
        level: json['level'],
        dailyCount: json['dailyCount'],
        lastStudyDate: DateTime.parse(json['lastStudyDate']),
        todayCompletedCount: json['todayCompletedCount'],
        completedGrammarIds: List<String>.from(json['completedGrammarIds']),
      );
}
