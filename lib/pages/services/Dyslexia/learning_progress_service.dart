import 'package:shared_preferences/shared_preferences.dart';

class LearningProgressService {
  static const String _keyPrefix = "learning_progress_";

  static String _buildKey(int grade, int level) =>
      "$_keyPrefix$grade-$level";

  // Save completed modules
  static Future<void> markModuleCompleted(
      int grade, int level, String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _buildKey(grade, level);

    final current = prefs.getStringList(key) ?? [];

    if (!current.contains(moduleId)) {
      current.add(moduleId);
      await prefs.setStringList(key, current);
    }
  }

  static Future<List<String>> getCompletedModules(
      int grade, int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_buildKey(grade, level)) ?? [];
  }

  static Future<void> resetProgress(int grade, int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_buildKey(grade, level));
  }
}