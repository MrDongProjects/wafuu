import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BookSelectionPage extends StatefulWidget {
  const BookSelectionPage({super.key});

  @override
  State<BookSelectionPage> createState() => _BookSelectionPageState();
}

class _BookSelectionPageState extends State<BookSelectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchBar(),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 实现自定义词本功能
            },
            child: const Text('自定义词本'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).hintColor,
          indicatorColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: '已学词本'),
            Tab(text: '自定义'),
            Tab(text: '常用词本'),
            Tab(text: '语法词书'),
            Tab(text: '最新上传'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookList('已学词本'),
                _buildBookList('自定义'),
                _buildBookList('常用词本'),
                _buildBookList('语法词书'),
                _buildBookList('最新上传'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索词本',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildBookList(String category) {
    // 示例书本数据
    final List<Map<String, dynamic>> books = [
      {
        'title': '系统入门教程',
        'subtitle': '基础入门课程',
        'wordCount': 1000,
        'color': Colors.orange,
      },
      {
        'title': '进阶学习教程',
        'subtitle': '进阶强化课程',
        'wordCount': 2000,
        'color': Colors.blue,
      },
      {
        'title': '高级提升教程',
        'subtitle': '高级提升课程',
        'wordCount': 1500,
        'color': Colors.green,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final book = books[index];
        return _buildBookItem(
          title: book['title'],
          subtitle: book['subtitle'],
          wordCount: book['wordCount'],
          color: book['color'],
        );
      },
    );
  }

  Widget _buildBookItem({
    required String title,
    required String subtitle,
    required int wordCount,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Center(
              child: Icon(
                Icons.book,
                color: color,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '共 $wordCount 词',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 实现学习功能
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('学习'),
          ),
        ],
      ),
    );
  }
}
