import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../widgets/settings_section.dart';
import '../../models/user_settings.dart';
import '../../services/auth_service.dart';

class StudySettingsPage extends StatefulWidget {
  const StudySettingsPage({super.key});

  @override
  State<StudySettingsPage> createState() => _StudySettingsPageState();
}

class _StudySettingsPageState extends State<StudySettingsPage> {
  // 学习设置状态
  int _newWordsPerDay = 20;
  int _reviewWordsPerDay = 50;
  bool _autoPlayWord = true;
  bool _autoPlaySentence = true;
  bool _showRomaji = true;
  bool _showHiragana = true;

  // SharedPreferences 键值
  static const String keyNewWords = 'new_words_per_day';
  static const String keyReviewWords = 'review_words_per_day';
  static const String keyAutoPlayWord = 'auto_play_word';
  static const String keyAutoPlaySentence = 'auto_play_sentence';
  static const String keyShowRomaji = 'show_romaji';
  static const String keyShowHiragana = 'show_hiragana';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final authService = AuthService();
      final settings = await authService.getUserSettings();
      if (settings != null) {
        setState(() {
          _newWordsPerDay = settings.newWordsPerDay;
          _reviewWordsPerDay = settings.reviewWordsPerDay;
          _autoPlayWord = settings.autoPlayWord;
          _autoPlaySentence = settings.autoPlaySentence;
          _showRomaji = settings.showRomaji;
          _showHiragana = settings.showHiragana;
        });
      }
    } catch (e) {
      print('加载设置失败: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final settings = UserSettings(
        newWordsPerDay: _newWordsPerDay,
        reviewWordsPerDay: _reviewWordsPerDay,
        autoPlayWord: _autoPlayWord,
        autoPlaySentence: _autoPlaySentence,
        showRomaji: _showRomaji,
        showHiragana: _showHiragana,
      );

      final authService = AuthService();
      await authService.updateUserSettings(settings);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存设置失败: $e')),
        );
      }
    }
  }

  // 更新值时同时保存到服务器
  void _updateValue(String key, dynamic value) {
    setState(() {
      switch (key) {
        case keyNewWords:
          _newWordsPerDay = value;
          break;
        case keyReviewWords:
          _reviewWordsPerDay = value;
          break;
        case keyAutoPlayWord:
          _autoPlayWord = value;
          break;
        case keyAutoPlaySentence:
          _autoPlaySentence = value;
          break;
        case keyShowRomaji:
          _showRomaji = value;
          break;
        case keyShowHiragana:
          _showHiragana = value;
          break;
      }
    });
    _saveSettings(); // 保存到服务器
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习计划'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            SettingsSection(
              title: '每日学习目标',
              children: [
                _buildNumberSetting(
                  title: '新词学习量',
                  subtitle: '每天学习 $_newWordsPerDay 个新单词',
                  value: _newWordsPerDay,
                  min: 5,
                  max: 100,
                  step: 5,
                  onChanged: (value) => _updateValue(keyNewWords, value),
                ),
                _buildNumberSetting(
                  title: '复习单词量',
                  subtitle: '每天复习 $_reviewWordsPerDay 个单词',
                  value: _reviewWordsPerDay,
                  min: 10,
                  max: 200,
                  step: 10,
                  onChanged: (value) => _updateValue(keyReviewWords, value),
                ),
              ],
            ),
            SettingsSection(
              title: '学习辅助设置',
              children: [
                _buildSwitchSetting(
                  icon: Icons.volume_up,
                  title: '单词自动发音',
                  subtitle: '显示单词时自动播放发音',
                  value: _autoPlayWord,
                  onChanged: (value) => _updateValue(keyAutoPlayWord, value),
                ),
                _buildSwitchSetting(
                  icon: Icons.record_voice_over,
                  title: '例句自动发音',
                  subtitle: '显示例句时自动播放发音',
                  value: _autoPlaySentence,
                  onChanged: (value) =>
                      _updateValue(keyAutoPlaySentence, value),
                ),
              ],
            ),
            SettingsSection(
              title: '显示设置',
              children: [
                _buildSwitchSetting(
                  icon: Icons.abc,
                  title: '显示罗马音',
                  subtitle: '在假名上方显示罗马音标注',
                  value: _showRomaji,
                  onChanged: (value) => _updateValue(keyShowRomaji, value),
                ),
                _buildSwitchSetting(
                  icon: Icons.translate,
                  title: '显示平假名',
                  subtitle: '在汉字上方显示假名注音',
                  value: _showHiragana,
                  onChanged: (value) => _updateValue(keyShowHiragana, value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberSetting({
    required String title,
    required String subtitle,
    required int value,
    required int min,
    required int max,
    required int step,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: value > min ? () => onChanged(value - step) : null,
              ),
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: (max - min) ~/ step,
                  label: value.toString(),
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: value < max ? () => onChanged(value + step) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
