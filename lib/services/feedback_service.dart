import '../models/feedback.dart';
import 'api_service.dart';
import 'auth_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class FeedbackService {
  static String get baseUrl => AppConfig.feedbackApiUrl;

  final _apiService = ApiService();
  final _authService = AuthService();

  Future<void> submitFeedback({
    required String content,
    String? contact,
  }) async {
    final userId = _authService.currentUser?.id;
    print('userId: $userId');
    if (userId == null) {
      throw Exception('请先登录');
    }

    // 直接使用完整的 URL，不依赖 ApiService 的 baseUrl
    final response = await _apiService.post(
      '/submit', // 只需要路径部分
      body: {
        'content': content,
        'contact': contact,
      },
      queryParameters: {
        'userId': userId.toString(),
      },
      baseUrl: baseUrl, // 传入完整的基础 URL
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }
}
