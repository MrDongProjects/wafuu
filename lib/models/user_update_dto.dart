class UserUpdateDto {
  final String? nickname; // 昵称
  final String? email; // 邮箱

  UserUpdateDto({
    this.nickname,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        if (nickname != null) 'nickname': nickname,
        if (email != null) 'email': email,
      };
}
