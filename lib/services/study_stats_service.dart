import 'package:wafu_bunpo/models/study_stats.dart';
import 'package:wafu_bunpo/models/study_record_dto.dart';
import 'package:wafu_bunpo/services/api_service.dart';
import 'package:wafu_bunpo/services/auth_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:wafu_bunpo/config/app_config.dart';
import 'package:get/get.dart';
import '../models/study_stats.dart';
import '../services/api_service.dart';

class StudyStatsService extends GetxService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  // 获取学习统计列表，支持可选的日期参数
  Future<List<StudyStats>> getStudyStats({String? date}) async {
    try {
      print('正在获取学习统计数据${date != null ? "，日期：$date" : ""}');

      // 获取当前用户
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        print('未找到用户信息');
        return [];
      }

      final response = await _apiService.get(
        '/api/study-stats/stats',
        queryParameters: {
          'userId': currentUser.id.toString(),
          if (date != null) 'date': date,
        },
      );

      print('API响应数据: $response');

      if (response['code'] == 200 && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((item) => StudyStats.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      print('获取学习统计失败: $e');
      return [];
    }
  }

  // 记录学习时间
  Future<StudyStats> recordStudyTime(String studyType) async {
    final userId = _authService.currentUser?.id;
    if (userId == null) throw Exception('用户未登录');

    final dto = StudyRecordDto(
      userId: userId,
      studyType: studyType,
      recordTime: DateTime.now(),
    );

    final response = await _apiService.post(
      '/api/study-stats/record',
      body: dto.toJson(),
      baseUrl: baseUrl,
    );

    if (response['code'] == 200 && response['data'] != null) {
      final data = response['data'] as Map<String, dynamic>;
      return StudyStats(
        id: data['id'],
        userId: data['userId'],
        studyType: data['studyType'] ?? 'unknown',
        studyDate: DateTime.now(),
        timeSpent: data['timeSpent'],
        startTime: DateTime.now(),
        endTime: DateTime.now(),
      );
    } else {
      throw Exception(response['message']);
    }
  }
}
