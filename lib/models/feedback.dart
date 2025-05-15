class Feedback {
  final int? id;
  final int? userId;
  final String content;
  final String? contact;
  final int status;
  final DateTime createdAt;

  Feedback({
    this.id,
    this.userId,
    required this.content,
    this.contact,
    this.status = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'content': content,
        'contact': contact,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        id: json['id'] as int?,
        userId: json['userId'] as int?,
        content: json['content'] as String,
        contact: json['contact'] as String?,
        status: json['status'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
