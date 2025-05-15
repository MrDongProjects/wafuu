class StudyStats {
  final int id;
  final int userId;
  final String studyType;
  final DateTime studyDate;
  final int timeSpent;
  final DateTime? startTime;
  final DateTime? endTime;

  StudyStats({
    required this.id,
    required this.userId,
    required this.studyType,
    required this.studyDate,
    required this.timeSpent,
    this.startTime,
    this.endTime,
  });

  String get studyTypeDisplay {
    switch (studyType) {
      case 'words':
        return '单词学习';
      case 'grammar':
        return '语法学习';
      case 'listening':
        return '听力练习';
      case 'reading':
        return '阅读练习';
      default:
        return studyType;
    }
  }

  String get formattedTimeRange {
    return '${startTime?.hour}:${startTime?.minute.toString().padLeft(2, '0')} - '
        '${endTime?.hour}:${endTime?.minute.toString().padLeft(2, '0')}';
  }

  factory StudyStats.fromJson(Map<String, dynamic> json) {
    return StudyStats(
      id: json['id']?.toInt() ?? 0,
      userId: json['userId']?.toInt() ?? 0,
      studyType: json['studyType'] as String? ?? '',
      studyDate: json['studyDate'] != null
          ? DateTime.parse(json['studyDate'] as String)
          : DateTime.now(),
      timeSpent: json['timeSpent']?.toInt() ?? 0,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'studyType': studyType,
      'studyDate': studyDate.toIso8601String().split('T')[0],
      'timeSpent': timeSpent,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  DateTime get calendarDate => DateTime(
        studyDate.year,
        studyDate.month,
        studyDate.day,
      );
}
