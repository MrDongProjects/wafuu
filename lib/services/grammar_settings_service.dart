import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grammar_settings.dart';
import 'auth_service.dart';
import 'api_service.dart';

class GrammarSettingsService {
  static const String _settingsKey = 'grammar_settings';
  final _apiService = ApiService();
  final _authService = AuthService();

  // 单例模式
  static final GrammarSettingsService _instance =
      GrammarSettingsService._internal();
  factory GrammarSettingsService() => _instance;
  GrammarSettingsService._internal();

  Future<GrammarSettings?> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = _authService.currentUser;
      if (user == null) return null;

      // 先从本地获取
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        return GrammarSettings.fromJson(jsonDecode(settingsJson));
      }

      // 尝试从服务器获取最新设置
      try {
        final response = await _apiService.get('/settings');
        if (response['code'] == 200) {
          final settings = GrammarSettings.fromJson(response['data']);
          return settings;
        } else {
          print('Failed to sync settings to server: ${response['message']}');
          throw Exception(response['message']);
        }
      } catch (e) {
        print('Failed to fetch settings from server: $e');
      }

      // 如果没有任何设置，返回null让用户进行设置
      return null;
    } catch (e) {
      print('Error loading grammar settings: $e');
      return null;
    }
  }

  Future<bool> saveSettings(GrammarSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 保存到本地
      await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));

      // 同步到服务器
      try {
        final response = await _apiService.post(
          '/grammar/settings',
          body: settings.toJson(),
        );

        if (response['code'] != 200) {
          print('Failed to sync settings to server: ${response['message']}');
        }
      } catch (e) {
        print('Error syncing settings to server: $e');
        // 即使服务器同步失败，本地保存成功也返回true
      }

      return true;
    } catch (e) {
      print('Error saving grammar settings: $e');
      return false;
    }
  }

  Future<bool> updateProgress({
    required String grammarId,
    required bool completed,
  }) async {
    try {
      final settings = await loadSettings();
      if (settings == null) return false;

      final updatedIds = List<String>.from(settings.completedGrammarIds);
      if (completed && !updatedIds.contains(grammarId)) {
        updatedIds.add(grammarId);
      } else if (!completed && updatedIds.contains(grammarId)) {
        updatedIds.remove(grammarId);
      }

      final newSettings = GrammarSettings(
        userId: settings.userId,
        level: settings.level,
        dailyCount: settings.dailyCount,
        lastStudyDate: DateTime.now(),
        todayCompletedCount:
            settings.todayCompletedCount + (completed ? 1 : -1),
        completedGrammarIds: updatedIds,
      );

      return saveSettings(newSettings);
    } catch (e) {
      print('Error updating grammar progress: $e');
      return false;
    }
  }

  Future<void> resetDailyProgress() async {
    try {
      final settings = await loadSettings();
      if (settings == null) return;

      final lastStudyDate = settings.lastStudyDate;
      final now = DateTime.now();

      // 如果不是同一天，重置每日进度
      if (lastStudyDate.day != now.day ||
          lastStudyDate.month != now.month ||
          lastStudyDate.year != now.year) {
        final newSettings = GrammarSettings(
          userId: settings.userId,
          level: settings.level,
          dailyCount: settings.dailyCount,
          lastStudyDate: now,
          todayCompletedCount: 0,
          completedGrammarIds: settings.completedGrammarIds,
        );

        await saveSettings(newSettings);
      }
    } catch (e) {
      print('Error resetting daily progress: $e');
    }
  }
}
