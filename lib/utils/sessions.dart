import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static String? userId;
  static String? username;
  static int?    grade;

  // Call this once after login — loads from SharedPreferences into memory
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    userId   = prefs.getString('user_id');
    username = prefs.getString('username');
    grade    = prefs.getInt('grade');
  }

  static void clear() {
    userId   = null;
    username = null;
    grade    = null;
  }
}