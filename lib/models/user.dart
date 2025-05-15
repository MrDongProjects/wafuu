import 'dart:convert';

class User {
  final int id;
  final String username;
  final String? nickname;
  final String? avatarUrl;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? vip;
  final String? vipEndTime;
  final String? avatar;

  User({
    required this.id,
    required this.username,
    this.nickname,
    this.avatarUrl,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.vip,
    this.vipEndTime,
    this.avatar,
  });

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      username: map['username'] as String,
      nickname: map['nickname'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      vip: map['vip'] as int?,
      vipEndTime: map['vipEndTime'] as String?,
      avatar: map['avatar'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "nickname": nickname,
        "avatarUrl": avatarUrl,
        "email": email,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "vip": vip,
        "vipEndTime": vipEndTime,
        "avatar": avatar,
      };
}
