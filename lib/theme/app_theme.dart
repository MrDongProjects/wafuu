import 'package:flutter/material.dart';

class AppTheme {
  // 主色调 - 寿司主题色系
  static const Color riceWhite = Color(0xFFF7F3E9); // 寿司米色
  static const Color noriBlack = Color(0xFF1A1A1A); // 海苔黑
  static const Color salmonPink = Color(0xFFFF8E71); // 三文鱼粉
  static const Color wasabiGreen = Color(0xFF7BAE37); // 芥末绿
  static const Color tunaRed = Color(0xFFD64D4D); // 金枪鱼红
  static const Color ginger = Color(0xFFFFE2D1); // 生姜粉

  // 功能色
  static const Color error = tunaRed;
  static const Color success = wasabiGreen;
  static const Color divider = Color(0xFFEEEEEE);

  // 文字颜色
  static const Color primaryText = noriBlack;
  static const Color secondaryText = Color(0xFF666666);
  static const Color hintText = Color(0xFF999999);

  // 装饰元素
  static const String sushiEmoji = '🍣';
  static const String onigiriEmoji = '🍙';
  static const String waveEmoji = '🌊';
  static const String sakuraEmoji = '🌸';
  static const String japanEmoji = '🗾';
  static const String lanternEmoji = '🏮';

  // Material Theme
  static ThemeData get theme => ThemeData(
        primaryColor: wasabiGreen,
        scaffoldBackgroundColor: riceWhite,
        cardColor: Colors.white,

        // AppBar主题
        appBarTheme: AppBarTheme(
          backgroundColor: riceWhite,
          foregroundColor: noriBlack,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: noriBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        // 底部导航栏主题
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: wasabiGreen,
          unselectedItemColor: noriBlack.withOpacity(0.5),
          type: BottomNavigationBarType.fixed,
          elevation: 16,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
        ),

        // 卡片主题
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shadowColor: noriBlack.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        ),

        // 文字主题
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          titleMedium: TextStyle(
            color: primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
          bodyLarge: TextStyle(
            color: primaryText,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            color: secondaryText,
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),

        // 输入框主题
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: wasabiGreen, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          hintStyle: TextStyle(
            color: noriBlack.withOpacity(0.4),
            fontSize: 14,
          ),
        ),

        // 按钮主题
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: wasabiGreen,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: wasabiGreen.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
      );

  // 亮色主题
  static ThemeData get lightTheme => theme;

  // 暗色主题
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: wasabiGreen,
        scaffoldBackgroundColor: noriBlack,
        cardColor: Colors.grey[900],

        // 图标主题
        iconTheme: IconThemeData(
          color: riceWhite,
        ),

        // 开关主题
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return wasabiGreen;
            }
            return null;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return wasabiGreen.withOpacity(0.5);
            }
            return null;
          }),
        ),

        // AppBar主题
        appBarTheme: AppBarTheme(
          backgroundColor: noriBlack,
          foregroundColor: riceWhite,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: riceWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        // 底部导航栏主题
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: noriBlack,
          selectedItemColor: wasabiGreen,
          unselectedItemColor: riceWhite.withOpacity(0.5),
          type: BottomNavigationBarType.fixed,
          elevation: 16,
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: riceWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          titleMedium: TextStyle(
            color: riceWhite,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
          bodyLarge: TextStyle(
            color: riceWhite,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            color: riceWhite.withOpacity(0.7),
            fontSize: 13,
            letterSpacing: 0.3,
          ),
        ),
      );
}
