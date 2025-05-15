import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/audio_service.dart';
import 'kana_page.dart'; // 导入假名页面以使用 KanaItem 和 hiraganaList
import '../../widgets/pressable_button.dart'; // 修改导入路径

class HiraganaPage extends StatefulWidget {
  const HiraganaPage({super.key});

  @override
  State<HiraganaPage> createState() => _HiraganaPageState();
}

class _HiraganaPageState extends State<HiraganaPage> {
  final _audioService = AudioService();

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _playSound(String reading) async {
    final soundPath = 'sounds/hiragana/$reading.mp3';
    await _audioService.playSound(soundPath);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? AppTheme.noriBlack : AppTheme.riceWhite,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: hiraganaList.length,
        itemBuilder: (context, index) {
          final kana = hiraganaList[index];
          return PressableButton(
            onTap: () => _playSound(kana.romaji),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            backgroundColor: isDarkMode ? AppTheme.noriBlack : Colors.white,
            pressedColor: AppTheme.wasabiGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kana.kana,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kana.romaji,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDarkMode ? Colors.grey[400] : AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
