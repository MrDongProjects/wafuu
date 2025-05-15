import 'package:flutter/material.dart';
import 'package:wafu_bunpo/theme/app_theme.dart'; // 导入主题

class HiraganaButton extends StatefulWidget {
  final String hiragana;
  final String romaji;
  final VoidCallback onPressed;

  const HiraganaButton({
    super.key,
    required this.hiragana,
    required this.romaji,
    required this.onPressed,
  });

  @override
  State<HiraganaButton> createState() => _HiraganaButtonState();
}

class _HiraganaButtonState extends State<HiraganaButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 按钮背景色：暗色模式下使用深色，亮色模式下使用浅色
    final buttonColor = isDarkMode
        ? const Color(0xFF2C2C2C) // 深灰色背景
        : Colors.white; // 白色背景

    // 文字颜色：暗色模式下使用白色，亮色模式下使用黑色
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    // 阴影颜色和强度
    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.1);

    // 点击高亮颜色
    final highlightColor = isDarkMode
        ? AppTheme.wasabiGreen.withOpacity(0.15)
        : AppTheme.wasabiGreen.withOpacity(0.1);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 1.0 : 0.0, 0.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: AppTheme.wasabiGreen.withOpacity(0.2),
            highlightColor: highlightColor,
            child: Ink(
              decoration: BoxDecoration(
                color: _isPressed
                    ? buttonColor.withOpacity(isDarkMode ? 0.8 : 0.9)
                    : buttonColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    offset: Offset(0, _isPressed ? 2 : 4),
                    blurRadius: _isPressed ? 4 : 8,
                    spreadRadius: _isPressed ? 1 : 2,
                  ),
                  if (!isDarkMode)
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: const Offset(-1, -1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.hiragana,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.romaji,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
