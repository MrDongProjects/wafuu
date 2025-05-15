import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/search_history.dart';
import '../utils/word_utils.dart';

class WordDetailPage extends StatefulWidget {
  final SearchHistory word;

  const WordDetailPage({super.key, required this.word});

  @override
  State<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage>
    with SingleTickerProviderStateMixin {
  bool isFavorited = false;
  bool isExampleExpanded = false;
  int currentTabIndex = 0;
  late TabController _tabController;

  // 测试数据
  final testWord = "忘れる";
  final testReading = "わすれる";
  final testRomaji = "wasureru";
  final testType = "动词一段";
  final testLevel = "N5";
  final testMeaning = "忘记，遗忘，忘却";

  final List<Map<String, String>> testConjugations = [
    {"type": "ます形", "value": "忘れます"},
    {"type": "て形", "value": "忘れて"},
    {"type": "た形", "value": "忘れた"},
    {"type": "ない形", "value": "忘れない"},
    {"type": "命令形", "value": "忘れろ/忘れよ"},
    {"type": "意志形", "value": "忘れよう"},
    {"type": "可能形", "value": "忘れられる"},
    {"type": "被动形", "value": "忘れられる"},
    {"type": "使役形", "value": "忘れさせる"},
    {"type": "条件形", "value": "忘れれば"},
  ];

  final List<Map<String, dynamic>> testSentences = [
    {
      "japanese": "妻子を[わす]れる。",
      "chinese": "忘记妻子。",
      "audio": "sentence1.mp3",
      "isFavorite": false
    },
    {
      "japanese": "時間のたつのも[わす]れる。",
      "chinese": "忘记时间流逝。",
      "audio": "sentence2.mp3",
      "isFavorite": true
    },
    {
      "japanese": "おのずと[き]憶から[な]くなる。",
      "chinese": "不知不觉地从记忆中消失。",
      "audio": "sentence3.mp3",
      "isFavorite": false
    }
  ];

  final Map<String, List<String>> testRelatedWords = {
    "synonyms": ["忘却", "遗却", "忘失", "置き忘れる"],
    "antonyms": ["覚える", "思い出す"],
    "topics": ["思い出す・想起", "記憶・记忆", "失う・失去"]
  };

  final List<Map<String, String>> testKanjiBreakdown = [
    {"kanji": "忘", "reading": "ボウ", "meaning": "忘记"},
    {"kanji": "れる", "reading": "れる", "meaning": "自动词词尾"},
  ];

  final List<Map<String, String>> testMemoryTips = [
    {"title": "记忆口诀", "content": "\"心亡即忘\" - 心(忄)死亡(亡)就是忘记了"},
    {"title": "形象联想", "content": "忄(心)+ 亡(死亡) = 心里的事情死了 = 忘记"},
    {"title": "例句记忆", "content": "彼の名前を忘れてしまいました(我忘记了他的名字)"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.wasabiGreen;

    // 背景和文本颜色
    final backgroundColor = isDarkMode ? Colors.black : Colors.grey[50]!;
    final cardColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    final dividerColor = isDarkMode ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = AppTheme.wasabiGreen.withOpacity(0.15);

    // 判断是否有变形（动词、形容词等）
    final bool hasConjugations =
        testConjugations.isNotEmpty && testType.startsWith("动");

    // 选项卡标题
    final List<String> tabTitles =
        hasConjugations ? ["变形", "关联词", "汉字分解", "记忆法"] : ["关联词", "汉字分解", "记忆法"];

    return Scaffold(
      backgroundColor: cardColor, // 将整个背景设置为卡片颜色
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : textColor,
            ),
            onPressed: () => setState(() => isFavorited = !isFavorited),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {
              // TODO: 显示更多选项
            },
          ),
        ],
      ),
      // 使用SingleChildScrollView作为唯一的滚动容器
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 单词头部
            GestureDetector(
              onTap: () {
                // TODO: 播放单词发音
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          testWord,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "（$testReading）",
                          style: TextStyle(
                            fontSize: 18,
                            color: secondaryTextColor,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.volume_up,
                          color: primaryColor,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            testType,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          testRomaji,
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            testLevel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 释义部分
            Container(
              padding: const EdgeInsets.all(16),
              color: cardColor,
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "释义",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    testMeaning,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),

            // 分割线
            Divider(height: 1, thickness: 1, color: dividerColor),

            // 例句部分
            Container(
              margin: const EdgeInsets.only(bottom: 0),
              padding: const EdgeInsets.all(16),
              color: cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "例句",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isExampleExpanded = !isExampleExpanded;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              isExampleExpanded ? "收起" : "更多",
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                              ),
                            ),
                            AnimatedRotation(
                              turns: isExampleExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 例句列表
                  Column(
                    children: [
                      // 第一条例句
                      _buildSentenceItem(
                        testSentences[0],
                        isDarkMode,
                        primaryColor,
                        textColor,
                        secondaryTextColor,
                      ),

                      // 展开更多例句
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: isExampleExpanded
                            ? (testSentences.length > 1
                                ? (testSentences.length > 2 ? 160.0 : 80.0)
                                : 0)
                            : 0,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              // 第二条例句
                              if (testSentences.length > 1)
                                _buildSentenceItem(
                                  testSentences[1],
                                  isDarkMode,
                                  primaryColor,
                                  textColor,
                                  secondaryTextColor,
                                ),

                              // 第三条例句（移除分隔线）
                              if (testSentences.length > 2)
                                _buildSentenceItem(
                                  testSentences[2],
                                  isDarkMode,
                                  primaryColor,
                                  textColor,
                                  secondaryTextColor,
                                ),
                            ],
                          ),
                        ),
                      ),

                      // 查看全部按钮
                      if (isExampleExpanded && testSentences.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: InkWell(
                            onTap: () {
                              // 显示底部弹出框
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: cardColor,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (context) => _buildAllSentencesSheet(
                                  isDarkMode,
                                  primaryColor,
                                  textColor,
                                  secondaryTextColor,
                                  cardColor,
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.grey[800]!
                                      : Colors.grey[300]!,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "查看全部例句",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 分割线
            Divider(height: 1, thickness: 1, color: dividerColor),

            // 标签页部分
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 标签栏
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: primaryColor,
                    indicatorWeight: 3,
                    labelColor: primaryColor,
                    unselectedLabelColor: secondaryTextColor,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: tabTitles.map((title) => Tab(text: title)).toList(),
                  ),

                  // 标签内容
                  SizedBox(
                    height: 300, // 固定高度，可根据需要调整
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // 变形标签内容
                        _buildConjugationsTab(
                            isDarkMode,
                            textColor,
                            secondaryTextColor,
                            primaryColor,
                            cardColor,
                            dividerColor),

                        // 关联词标签内容
                        _buildRelatedWordsTab(
                            isDarkMode,
                            textColor,
                            secondaryTextColor,
                            primaryColor,
                            cardColor,
                            dividerColor),

                        // 汉字分解标签内容
                        _buildKanjiBreakdownTab(
                            isDarkMode,
                            textColor,
                            secondaryTextColor,
                            primaryColor,
                            cardColor,
                            dividerColor),

                        // 记忆法标签内容
                        _buildMemoryTipsTab(
                            isDarkMode,
                            textColor,
                            secondaryTextColor,
                            primaryColor,
                            cardColor,
                            dividerColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 变形选项卡
  Widget _buildConjugationsTab(
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color primaryColor,
      Color cardColor,
      Color dividerColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: testConjugations.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 0.5,
          color: dividerColor,
        ),
        itemBuilder: (context, index) {
          final conjugation = testConjugations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    conjugation["type"]!,
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    conjugation["value"]!,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 关联词选项卡
  Widget _buildRelatedWordsTab(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color cardColor,
    Color dividerColor,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (testRelatedWords["synonyms"]?.isNotEmpty ?? false)
            _buildRelatedWordCategory("同义词", testRelatedWords["synonyms"]!,
                textColor, secondaryTextColor, primaryColor, dividerColor),
          if (testRelatedWords["antonyms"]?.isNotEmpty ?? false)
            _buildRelatedWordCategory("反义词", testRelatedWords["antonyms"]!,
                textColor, secondaryTextColor, primaryColor, dividerColor),
          if (testRelatedWords["topics"]?.isNotEmpty ?? false)
            _buildRelatedWordCategory("相关主题", testRelatedWords["topics"]!,
                textColor, secondaryTextColor, primaryColor, dividerColor),
        ],
      ),
    );
  }

  Widget _buildRelatedWordCategory(
    String title,
    List<String> words,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color dividerColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.map((word) {
            return InkWell(
              onTap: () {
                // 跳转到对应单词详情
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSentenceItem(Map<String, dynamic> sentence, bool isDarkMode,
      Color primaryColor, Color textColor, Color secondaryTextColor) {
    bool isFavorite = sentence["isFavorite"] as bool;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 收藏按钮
        IconButton(
          constraints: const BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),
          padding: EdgeInsets.zero,
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite
                ? Colors.amber
                : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
            size: 18,
          ),
          onPressed: () {
            // TODO: 切换收藏状态
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 日语例句（带假名标注）
              InkWell(
                onTap: () {
                  // TODO: 播放例句音频
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        _buildRubyText(sentence["japanese"] as String),
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.volume_up,
                      color: primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              // 中文翻译
              Text(
                sentence["chinese"] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextSpan _buildRubyText(String text) {
    // 简单的假名标注解析，实际应用中可能需要更复杂的解析
    final RegExp regExp = RegExp(r'([^\[]+)\[([^\]]+)\]');
    final List<TextSpan> spans = [];

    int lastEnd = 0;
    for (final match in regExp.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }

      spans.add(
        TextSpan(
          children: [
            TextSpan(text: match.group(1)),
            WidgetSpan(
              alignment: PlaceholderAlignment.top,
              child: Text(
                match.group(2) ?? "",
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.wasabiGreen,
                ),
              ),
            ),
          ],
        ),
      );

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return TextSpan(children: spans);
  }

  // 构建全部例句的底部弹出sheet
  Widget _buildAllSentencesSheet(
    bool isDarkMode,
    Color primaryColor,
    Color textColor,
    Color secondaryTextColor,
    Color cardColor,
  ) {
    final dividerColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "全部例句",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: secondaryTextColor,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: testSentences.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 0.5,
                color: dividerColor,
                indent: 20,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          testSentences[index]["isFavorite"]
                              ? Icons.star
                              : Icons.star_border,
                          color: testSentences[index]["isFavorite"]
                              ? Colors.amber
                              : secondaryTextColor,
                          size: 18,
                        ),
                        onPressed: () {
                          // TODO: 切换收藏状态
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    _buildRubyText(testSentences[index]
                                        ["japanese"] as String),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.volume_up,
                                  color: primaryColor,
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              testSentences[index]["chinese"] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 构建汉字分解标签内容
  Widget _buildKanjiBreakdownTab(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color cardColor,
    Color dividerColor,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "汉字分解",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: testKanjiBreakdown.map((kanji) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${kanji["kanji"]} (${kanji["reading"]}): ${kanji["meaning"]}",
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Text(
            "笔顺",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          // 此处可添加笔顺动画或图片
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "笔顺动画将在此显示",
              style: TextStyle(
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建记忆法标签内容
  Widget _buildMemoryTipsTab(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color cardColor,
    Color dividerColor,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: testMemoryTips.map((tip) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tip["title"]!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  tip["content"]!,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
