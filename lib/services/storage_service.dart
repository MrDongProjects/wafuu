import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_history.dart';

class StorageService {
  final SharedPreferences _prefs;
  static const String _searchHistoryKey = 'search_history';

  StorageService(this._prefs);

  Future<List<SearchHistory>> getSearchHistory() async {
    final String? historyJson = _prefs.getString(_searchHistoryKey);
    if (historyJson == null) return [];

    final List<dynamic> decoded = json.decode(historyJson);
    return decoded
        .map((item) => SearchHistory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addSearchHistory(SearchHistory history) async {
    final currentHistory = await getSearchHistory();

    // 移除相同关键词的旧记录
    currentHistory.removeWhere((item) => item.keyword == history.keyword);

    // 添加新记录到开头
    currentHistory.insert(0, history);

    // 只保留最近20条记录
    if (currentHistory.length > 20) {
      currentHistory.removeLast();
    }

    final encodedHistory = json.encode(
      currentHistory.map((h) => h.toJson()).toList(),
    );
    await _prefs.setString(_searchHistoryKey, encodedHistory);
  }

  Future<void> removeSearchHistory(String keyword) async {
    final currentHistory = await getSearchHistory();
    currentHistory.removeWhere((item) => item.keyword == keyword);

    final encodedHistory = json.encode(
      currentHistory.map((h) => h.toJson()).toList(),
    );
    await _prefs.setString(_searchHistoryKey, encodedHistory);
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove(_searchHistoryKey);
  }
}
