class StudyRecordDto {
  final int userId;
  final String studyType;
  final DateTime recordTime;

  StudyRecordDto({
    required this.userId,
    required this.studyType,
    required this.recordTime,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'studyType': studyType,
        'recordTime': recordTime.toIso8601String(),
      };
}
