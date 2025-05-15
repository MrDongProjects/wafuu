import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wafu_bunpo/models/study_stats.dart';
import 'package:wafu_bunpo/services/study_stats_service.dart';
import 'package:wafu_bunpo/theme/app_theme.dart';
import 'package:wafu_bunpo/widgets/pressable_button.dart';
import 'package:wafu_bunpo/services/auth_service.dart';
import 'package:wafu_bunpo/pages/auth/login_page.dart';

class StudyStatsPage extends StatefulWidget {
  const StudyStatsPage({super.key});

  @override
  State<StudyStatsPage> createState() => _StudyStatsPageState();
}

class _StudyStatsPageState extends State<StudyStatsPage>
    with SingleTickerProviderStateMixin {
  final _studyStatsService = StudyStatsService();
  final _authService = AuthService();
  List<StudyStats> _studyStats = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = false;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _checkLoginAndLoadStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginAndLoadStats() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (!isLoggedIn) {
      if (!mounted) return;
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      if (result == true && mounted) {
        _loadStudyStats();
      } else {
        if (mounted) Navigator.pop(context);
      }
      return;
    }

    _loadStudyStats();
  }

  Future<void> _loadStudyStats() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _studyStatsService.getStudyStats(
          date: _selectedDay!.toIso8601String().split('T')[0]);
      setState(() => _studyStats = stats);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：$e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<StudyStats> _getEventsForDay(DateTime day) {
    return _studyStats.where((stat) {
      final eventDate = DateTime(
        stat.studyDate.year,
        stat.studyDate.month,
        stat.studyDate.day,
      );
      final selectedDate = DateTime(
        day.year,
        day.month,
        day.day,
      );
      return eventDate == selectedDate;
    }).toList();
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '$hours小时${remainingMinutes > 0 ? '$remainingMinutes分钟' : ''}';
    } else {
      return '$minutes分钟';
    }
  }

  // 计算特定类型的学习时间
  String _formatTypeStudyTime(List<StudyStats> stats, String type) {
    final typeStats = stats.where((stat) => stat.studyType == type).toList();
    final totalMinutes = typeStats.fold<int>(
      0,
      (sum, stat) => sum + stat.timeSpent,
    );

    final hours = totalMinutes ~/ 60;
    final remainingMinutes = totalMinutes % 60;

    if (hours > 0) {
      return '$hours小时${remainingMinutes > 0 ? '$remainingMinutes分钟' : ''}';
    } else {
      return '${totalMinutes}分钟';
    }
  }

  // 获取学习类型的表情符号
  String _getStudyTypeEmoji(String type) {
    switch (type) {
      case 'words':
        return '📚';
      case 'grammar':
        return '📝';
      case 'listening':
        return '🎧';
      case 'reading':
        return '📖';
      default:
        return '📓';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('学习统计')),
      body: Column(
        children: [
          // 日历部分
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay ?? DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarStyle: CalendarStyle(
              // 日式风格通常使用圆形选择器
              defaultTextStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.wasabiGreen,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.wasabiGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              markersMaxCount: 3,
              markersAlignment: Alignment.bottomCenter,
              markerDecoration: BoxDecoration(
                color: AppTheme.wasabiGreen,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
              outsideDaysVisible: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekHeight: 20,
            locale: 'ja_JP',
          ),

          // 数据展示部分
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _studyStats.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              '暂无学习记录',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '选择其他日期或开始新的学习',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // 总学习时间卡片
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Text('⏱️',
                                          style: TextStyle(fontSize: 32)),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('总学习时间',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium),
                                            SizedBox(height: 8),
                                            Text(
                                              _formatTotalDuration(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.wasabiGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // 2x2学习类型网格
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.5, // 调整卡片宽高比
                                children: [
                                  _buildStudyTypeCard(
                                      'words', '单词学习', _studyStats),
                                  _buildStudyTypeCard(
                                      'grammar', '语法学习', _studyStats),
                                  _buildStudyTypeCard(
                                      'listening', '听力练习', _studyStats),
                                  _buildStudyTypeCard(
                                      'reading', '阅读练习', _studyStats),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyTypeCard(
      String type, String title, List<StudyStats> stats) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_getStudyTypeEmoji(type), style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _formatTypeStudyTime(stats, type),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.wasabiGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 计算总学习时间
  String _formatTotalDuration() {
    final totalMinutes = _studyStats.fold<int>(
      0,
      (sum, stat) => sum + stat.timeSpent,
    );

    final hours = totalMinutes ~/ 60;
    final remainingMinutes = totalMinutes % 60;

    if (hours > 0) {
      return '$hours小时${remainingMinutes > 0 ? '$remainingMinutes分钟' : ''}';
    } else {
      return '$totalMinutes分钟';
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (mounted) {
      setState(() {
        _selectedDay = selectedDay;
        _studyStats = []; // 清空旧数据
      });
    }
    _loadStudyStats();
  }
}
