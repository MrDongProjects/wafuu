import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../study/study_page.dart';
import '../kana/kana_page.dart';
import '../profile/profile_page.dart';
import '../../theme/app_theme.dart';
import '../../services/storage_service.dart';
import '../../services/favorite_service.dart';
import '../../models/search_history.dart';
import '../../models/favorite_word.dart';
import '../word_detail_page.dart';
import '../grammar/grammar_learning_page.dart';
import '../grammar/grammar_settings_page.dart';
import '../../services/grammar_settings_service.dart';
import 'search_page.dart';
import 'book_selection_page.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _settingsService = GrammarSettingsService();

  final List<Widget> _pages = [
    const MainPage(),
    const StudyPage(),
    const KanaPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '学习',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: '假名',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }

  void _navigateToGrammarLearning() async {
    final settings = await _settingsService.loadSettings();

    if (!mounted) return;

    if (settings != null) {
      // 如果已有设置，直接进入学习页面
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GrammarLearningPage(
            level: settings.level,
            dailyCount: settings.dailyCount,
          ),
        ),
      );
    } else {
      // 如果没有设置，进入设置页面
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GrammarSettingsPage(),
        ),
      );
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StorageService _storageService;
  late FavoriteService _favoriteService;
  List<SearchHistory> _searchHistory = [];
  List<FavoriteWord> _favorites = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  Map<String, bool> _expandedItems = {};

  // 定义渐变色
  final List<List<Color>> gradients = [
    [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)], // 红色系
    [const Color(0xFF4ECDC4), const Color(0xFF45B7AF)], // 青色系
    [const Color(0xFFFFBE0B), const Color(0xFFFFAB0B)], // 黄色系
  ];

  void _toggleExpanded(String key) {
    setState(() {
      _expandedItems[key] = !(_expandedItems[key] ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    _storageService = StorageService(prefs);
    _favoriteService = ApiFavoriteService(baseUrl: 'YOUR_API_BASE_URL');
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final history = await _storageService.getSearchHistory();
      final favorites = await _favoriteService.getFavorites();
      setState(() {
        _searchHistory = history;
        _favorites = favorites;
      });
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSearch(String keyword) async {
    if (keyword.trim().isEmpty) return;

    try {
      // TODO: 这里应该调用API获取单词信息
      // 模拟API返回数据
      final searchResult = SearchHistory(
        keyword: keyword,
        romaji: 'romaji', // 这里应该是API返回的数据
        meaning: '这里是单词的解释', // 这里应该是API返回的数据
        timestamp: DateTime.now(),
      );

      await _storageService.addSearchHistory(searchResult);
      await _loadData(); // 重新加载搜索历史
      _searchController.clear(); // 清空搜索框
    } catch (e) {
      print('Error handling search: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 搜索框
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth - 32,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).shadowColor.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${AppTheme.sakuraEmoji} 搜索日语单词、语法...',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 每日学习模块
              _buildDailyWordsSection(),
              const SizedBox(height: 24),

              // 热门语法推荐
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '热门语法',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildGrammarCard(
                            context,
                            title: 'て形的用法',
                            description: '表示动作的连续、原因、方式等',
                            level: 'N5',
                          ),
                          _buildGrammarCard(
                            context,
                            title: 'た形变化',
                            description: '表示过去时态和完成态',
                            level: 'N5',
                          ),
                          _buildGrammarCard(
                            context,
                            title: '敬语',
                            description: '尊敬语和谦逊语的使用',
                            level: 'N3',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 学习资源
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '学习资源',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildResourceCard(
                      context,
                      icon: Icons.book,
                      title: '语法手册',
                      description: '系统性的日语语法学习指南',
                    ),
                    const SizedBox(height: 12),
                    _buildResourceCard(
                      context,
                      icon: Icons.school,
                      title: '考试对策',
                      description: 'JLPT各级别考试重点整理',
                    ),
                    const SizedBox(height: 12),
                    _buildResourceCard(
                      context,
                      icon: Icons.headphones,
                      title: '听力练习',
                      description: '日常会话和考试听力训练',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyWordsSection() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        // 从学习计划中获取设置的数据
        final newWordsPerDay = snapshot.data?.getInt('new_words_per_day') ?? 20;
        final reviewWordsPerDay =
            snapshot.data?.getInt('review_words_per_day') ?? 50;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // 顶部标题栏保持不变
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '每日单词',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    _buildBookSelector(),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 修改后的学习进度显示
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 待复习单词进度
                    _buildProgressItem(
                      icon: Icons.refresh,
                      title: '待复习单词',
                      current: 0, // 这里需要从实际数据获取
                      total: reviewWordsPerDay,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    // 待学习单词进度
                    _buildProgressItem(
                      icon: Icons.school,
                      title: '今日新词',
                      current: 0, // 这里需要从实际数据获取
                      total: newWordsPerDay,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              // 当前词书信息部分保持不变
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.book,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '大家的日本语初级1',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '已学习 120/1127 词',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 实现开始学习功能
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('开始学习'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required String title,
    required int current,
    required int total,
    required Color color,
  }) {
    final progress = total > 0 ? current / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Text(
              '$current/$total',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildBookSelector() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookSelectionPage()),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '切换词书',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrammarCard(
    BuildContext context, {
    required String title,
    required String description,
    required String level,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppTheme.waveEmoji,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppTheme.noriBlack.withOpacity(0.6),
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isSearchHistory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                isSearchHistory ? AppTheme.onigiriEmoji : AppTheme.sushiEmoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          if (isSearchHistory && _searchHistory.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                await _storageService.clearSearchHistory();
                await _loadData();
              },
              icon: const Icon(Icons.delete_sweep, size: 20),
              label: Text(
                '清空',
                style: TextStyle(
                  color: AppTheme.tunaRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchHistory.length,
      itemBuilder: (context, index) {
        final history = _searchHistory[index];
        final itemKey = history.keyword + history.timestamp.toString();
        final isExpanded = _expandedItems[itemKey] ?? false;

        return Dismissible(
          key: Key(itemKey),
          background: Container(
            color: AppTheme.error.withOpacity(0.2),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: AppTheme.error),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await _storageService.removeSearchHistory(history.keyword);
            await _loadData();
          },
          child: Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordDetailPage(word: history),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          history.keyword,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          history.romaji ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          _formatTimestamp(history.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.hintText,
                          ),
                        ),
                      ],
                    ),
                    if (history.meaning != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        history.meaning!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordDetails(SearchHistory history) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // 假名和读音
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.wasabiGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  history.keyword,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.wasabiGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (history.romaji != null) ...[
                const SizedBox(width: 12),
                Text(
                  history.romaji!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // 词性标签
          Wrap(
            spacing: 8,
            children: [
              _buildTag('名词'),
              _buildTag('N5'),
            ],
          ),
          const SizedBox(height: 16),
          // 释义
          Text(
            '释义',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            history.meaning ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          // 例句
          Text(
            '例句',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildExampleSentence(
            japanese: '私は${history.keyword}です。',
            romaji: 'Watashi wa ${history.romaji} desu.',
            meaning: '我是${history.keyword}。',
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.ginger,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.noriBlack.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildExampleSentence({
    required String japanese,
    required String romaji,
    required String meaning,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.riceWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            japanese,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            romaji,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.noriBlack.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            meaning,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final favorite = _favorites[index];
        return Dismissible(
          key: ValueKey(favorite.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('确认删除'),
                content: const Text('确定要删除这个收藏吗？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('删除'),
                  ),
                ],
              ),
            );
            return confirmed ?? false;
          },
          onDismissed: (direction) {
            final removedItem = _favorites[index];
            setState(() {
              _favorites.removeAt(index);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('已删除收藏'),
                action: SnackBarAction(
                  label: '撤销',
                  onPressed: () {
                    setState(() {
                      _favorites.insert(index, removedItem);
                    });
                    _favoriteService.addFavorite(removedItem);
                  },
                ),
              ),
            );

            _favoriteService.removeFavorite(removedItem.id);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text(favorite.word),
              subtitle: Text(favorite.meaning ?? ''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordDetailPage(
                      word: favorite.toSearchHistory(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}

// 搜索框组件
class SearchBox extends StatelessWidget {
  final double screenWidth;
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBox({
    super.key,
    required this.screenWidth,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: screenWidth - 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isDark ? Colors.black : AppTheme.noriBlack).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: '${AppTheme.sakuraEmoji} 搜索日语单词、语法...',
          hintStyle: TextStyle(
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark
                ? Theme.of(context).colorScheme.primary
                : AppTheme.wasabiGreen,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.4),
            ),
            onPressed: () {
              controller.clear();
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onSubmitted: onSearch,
      ),
    );
  }
}
