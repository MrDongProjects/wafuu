import 'package:flutter/material.dart';
import 'package:wafu_bunpo/theme/app_theme.dart';
import 'package:wafu_bunpo/widgets/pressable_button.dart';
import 'package:wafu_bunpo/pages/grammar/grammar_learning_page.dart';
import 'package:wafu_bunpo/services/grammar_settings_service.dart';
import 'package:wafu_bunpo/services/auth_service.dart';
import 'package:wafu_bunpo/models/grammar_settings.dart';

class GrammarSettingsPage extends StatefulWidget {
  const GrammarSettingsPage({super.key});

  @override
  State<GrammarSettingsPage> createState() => _GrammarSettingsPageState();
}

class _GrammarSettingsPageState extends State<GrammarSettingsPage> {
  String _selectedLevel = 'N5';
  int _dailyCount = 5;
  final _settingsService = GrammarSettingsService();
  final _authService = AuthService();

  // 模拟的语法数据，之后会从数据库获取
  final Map<String, List<Map<String, String>>> _grammarPreview = {
    'N5': [
      {'title': 'は', 'desc': '表示主题，标记主语'},
      {'title': 'です', 'desc': '是，表示判断'},
      {'title': 'ます', 'desc': '动词礼貌形式'},
    ],
    'N4': [
      {'title': 'て形', 'desc': '动词连接形式'},
      {'title': 'たい', 'desc': '表示愿望'},
      {'title': 'なければならない', 'desc': '必须~'},
    ],
    // ... 其他级别的语法预览
  };

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    final settings = await _settingsService.loadSettings();
    if (settings != null) {
      setState(() {
        _selectedLevel = settings.level;
        _dailyCount = settings.dailyCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTheme.lanternEmoji),
            const SizedBox(width: 8),
            const Text('语法学习设置'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).cardColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLevelSection(context),
                    const SizedBox(height: 24),
                    _buildCountSection(context),
                    const SizedBox(height: 24),
                    _buildGrammarPreview(context),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '选择语法级别',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_selectedLevel}文法',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.wasabiGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLevelSelector(),
      ],
    );
  }

  Widget _buildCountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '每日学习数量',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.wasabiGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_dailyCount个/天',
                style: TextStyle(
                  color: AppTheme.wasabiGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCountSelector(),
      ],
    );
  }

  Widget _buildGrammarPreview(BuildContext context) {
    final grammarList = _grammarPreview[_selectedLevel] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '语法预览',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              '(部分示例)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...grammarList.map((grammar) => _buildGrammarItem(context, grammar)),
      ],
    );
  }

  Widget _buildGrammarItem(BuildContext context, Map<String, String> grammar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.wasabiGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              grammar['title'] ?? '',
              style: TextStyle(
                color: AppTheme.wasabiGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              grammar['desc'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.wasabiGreen,
              Color(0xFF8BBF4D),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.wasabiGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _saveSettings,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '開始',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppTheme.sakuraEmoji,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先登录')),
      );
      return;
    }

    final settings = GrammarSettings(
      userId: user.id.toString(),
      level: _selectedLevel,
      dailyCount: _dailyCount,
      lastStudyDate: DateTime.now(),
    );

    final success = await _settingsService.saveSettings(settings);
    if (!success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存设置失败')),
      );
      return;
    }

    // 导航到学习页面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GrammarLearningPage(
          level: _selectedLevel,
          dailyCount: _dailyCount,
        ),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['N5', 'N4', 'N3', 'N2', 'N1'].map((level) {
              final isSelected = level == _selectedLevel;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedLevel = level),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.wasabiGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.wasabiGreen
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      level,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCountSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Slider(
            value: _dailyCount.toDouble(),
            min: 1,
            max: 20,
            divisions: 19,
            activeColor: AppTheme.wasabiGreen,
            onChanged: (value) {
              setState(() {
                _dailyCount = value.round();
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1个', style: Theme.of(context).textTheme.bodySmall),
              Text('20个', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
