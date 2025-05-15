import 'package:flutter/material.dart';
import 'package:wafu_bunpo/theme/app_theme.dart';
import 'package:wafu_bunpo/widgets/pressable_button.dart';
import 'package:wafu_bunpo/pages/grammar/grammar_practice_page.dart';
import 'package:wafu_bunpo/pages/auth/login_page.dart';
import 'package:wafu_bunpo/services/auth_service.dart';

class GrammarLearningPage extends StatefulWidget {
  final String level;
  final int dailyCount;

  const GrammarLearningPage({
    super.key,
    required this.level,
    required this.dailyCount,
  });

  @override
  State<GrammarLearningPage> createState() => _GrammarLearningPageState();
}

class _GrammarLearningPageState extends State<GrammarLearningPage> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  final PageController _pageController = PageController();
  bool _isFavorite = false;
  bool _isLastPage = false;
  bool _isShowingDialog = false;
  final _authService = AuthService();

  // 模拟数据，之后从API获取
  final List<Map<String, dynamic>> _grammarPoints = [
    {
      'title': 'は',
      'explanation': '表示主题，用于标记句子的主语。',
      'examples': [
        {
          'japanese': '私は学生です。',
          'romaji': 'Watashi wa gakusei desu.',
          'chinese': '我是学生。',
        },
        {
          'japanese': '東京は大きい都市です。',
          'romaji': 'Tokyo wa ookii toshi desu.',
          'chinese': '东京是一个大城市。',
        },
      ],
      'notes': '与が的区别：は标记已知信息，が标记新信息。',
    },
    {
      'title': 'です',
      'explanation': '表示"是"的判断助动词，用于礼貌语体。',
      'examples': [
        {
          'japanese': 'これは本です。',
          'romaji': 'Kore wa hon desu.',
          'chinese': '这是书。',
        },
        {
          'japanese': '彼は先生です。',
          'romaji': 'Kare wa sensei desu.',
          'chinese': '他是老师。',
        },
      ],
    },
    {
      'title': 'が',
      'explanation': '表示主语，用于引入新信息或强调。',
      'examples': [
        {
          'japanese': '雨が降っています。',
          'romaji': 'Ame ga futteimasu.',
          'chinese': '在下雨。',
        },
        {
          'japanese': '誰が来ましたか。',
          'romaji': 'Dare ga kimashita ka.',
          'chinese': '谁来了？',
        },
      ],
      'notes': '与は的区别：が用于引入新信息或回答疑问句。',
    },
    {
      'title': 'を',
      'explanation': '表示动作的对象，标记宾语。',
      'examples': [
        {
          'japanese': '本を読みます。',
          'romaji': 'Hon wo yomimasu.',
          'chinese': '读书。',
        },
        {
          'japanese': '水を飲みます。',
          'romaji': 'Mizu wo nomimasu.',
          'chinese': '喝水。',
        },
      ],
    },
    {
      'title': 'に',
      'explanation': '表示时间、场所、目标等。',
      'examples': [
        {
          'japanese': '学校に行きます。',
          'romaji': 'Gakkou ni ikimasu.',
          'chinese': '去学校。',
        },
        {
          'japanese': '7時に起きます。',
          'romaji': 'Shichi-ji ni okimasu.',
          'chinese': '7点起床。',
        },
      ],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            Text('${widget.level}语法学习'),
          ],
        ),
        actions: [
          _buildProgressIndicator(),
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => _showAnswer = !_showAnswer),
        onHorizontalDragEnd: (details) async {
          if (!mounted) return;
          if (_isLastPage &&
              details.primaryVelocity! < 0 && // 向左滑动
              !_isShowingDialog) {
            setState(() => _isShowingDialog = true);
            try {
              final result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: Row(
                      children: [
                        Text(AppTheme.lanternEmoji),
                        const SizedBox(width: 8),
                        const Text('完成学习'),
                      ],
                    ),
                    content: const Text('恭喜完成今日语法学习！是否开始练习？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('稍后练习'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.wasabiGreen,
                        ),
                        child: const Text('开始练习'),
                      ),
                    ],
                  ),
                ),
              );

              if (!mounted) return;

              if (result == true) {
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GrammarPracticePage(
                      level: widget.level,
                      studiedGrammar: _grammarPoints,
                    ),
                  ),
                );
              } else if (result == false) {
                Navigator.pop(context);
              }
            } finally {
              if (mounted) {
                setState(() => _isShowingDialog = false);
              }
            }
          }
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.dailyCount,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              _showAnswer = false;
              _isLastPage = index == widget.dailyCount - 1;
            });
          },
          itemBuilder: (context, index) => _buildGrammarPage(index),
        ),
      ),
    );
  }

  Widget _buildGrammarPage(int index) {
    final grammarIndex = index % _grammarPoints.length;
    final grammar = _grammarPoints[grammarIndex];
    return Container(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildGrammarCard(grammar),
      ),
    );
  }

  Widget _buildGrammarCard(Map<String, dynamic> grammar) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.wasabiGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'N5',
                  style: TextStyle(
                    color: AppTheme.wasabiGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: AppTheme.wasabiGreen,
                    ),
                    onPressed: () {
                      // TODO: 播放语法读音
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                      // TODO: 保存收藏状态
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              grammar['title'],
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.wasabiGreen,
              ),
            ),
          ),
          if (!_showAnswer) ...[
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '点击查看解释',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_showAnswer) ...[
            const SizedBox(height: 24),
            Text(
              '解释',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              grammar['explanation'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (grammar['notes'] != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.wasabiGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.wasabiGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        grammar['notes'],
                        style: TextStyle(
                          color: AppTheme.wasabiGreen,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            _buildExamplesSection(grammar['examples']),
          ],
        ],
      ),
    );
  }

  Widget _buildExamplesSection(List examples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '例句',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...examples.map((example) => _buildExampleCard(example)),
      ],
    );
  }

  Widget _buildExampleCard(Map<String, String> example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  example['japanese']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: AppTheme.wasabiGreen,
                  size: 20,
                ),
                onPressed: () {
                  // TODO: 播放例句读音
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            example['romaji']!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example['chinese']!,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.wasabiGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${_currentIndex + 1}/${widget.dailyCount}',
        style: TextStyle(
          color: AppTheme.wasabiGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExplanationCard(Map<String, dynamic> grammar) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '解释',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            grammar['explanation'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (grammar['notes'] != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.wasabiGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.wasabiGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      grammar['notes'],
                      style: TextStyle(
                        color: AppTheme.wasabiGreen,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExamplesCard(Map<String, dynamic> grammar) {
    final examples = grammar['examples'] as List;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '例句',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...examples.map((example) => _buildExampleItem(example)),
        ],
      ),
    );
  }

  Widget _buildExampleItem(Map<String, String> example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example['japanese']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example['romaji']!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example['chinese']!,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _handleSessionExpired() {
    if (!mounted) return;

    // 清除登录状态
    _authService.logout();

    // 显示提示并跳转到登录页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('登录已过期，请重新登录')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => route.isFirst, // 保留第一个路由（HomePage）
    );
  }

  Future<void> _checkAuthStatus() async {
    if (!await _authService.isAuthenticated()) {
      _handleSessionExpired();
      return;
    }
    // 如果已经认证，继续加载数据
    if (mounted) {
      // TODO: 加载语法数据
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkAuthStatus());
  }
}
