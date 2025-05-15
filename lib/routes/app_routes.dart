import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/study/study_page.dart';
import '../pages/vocabulary_page.dart';
import '../pages/practice_page.dart';
import '../pages/profile/profile_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String study = '/study';
  static const String vocabulary = '/vocabulary';
  static const String practice = '/practice';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    study: (context) => const StudyPage(),
    vocabulary: (context) => const VocabularyPage(),
    practice: (context) => const PracticePage(),
    profile: (context) => const ProfilePage(),
  };
}
