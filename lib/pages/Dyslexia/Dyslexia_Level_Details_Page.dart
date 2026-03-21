import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'dyslexia_read_session_page.dart';
import 'learning_paths_page.dart';

class DyslexiaLevelDetailsPage extends StatelessWidget {
  final int grade;
  final int level;
  final String tier;
  final Map<String, dynamic> sessionPayload;

  const DyslexiaLevelDetailsPage({
    super.key,
    required this.grade,
    required this.level,
    required this.tier,
    required this.sessionPayload,
  });

  // Add this function inside _DyslexiaLevelDetailsPageState or your Stateless helper
  // Future<void> _handleDetectDyslexia(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('user_id') ?? "";
  //
  //   // Show Loading
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) => const Center(child: CircularProgressIndicator())
  //   );
  //
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "${Config.baseUrl}/dyslexia/check-task-lock?user_id=$userId&grade=$grade&level=$level"
  //     ));
  //     final data = jsonDecode(response.body);
  //
  //     Navigator.pop(context); // Close loading
  //
  //     if (data["is_locked"] == true) {
  //       // SHOW ALERT: Must finish Learning Path first
  //       _showLockedDialog(context);
  //     } else {
  //       // PROCEED: Navigate to the task
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => DyslexiaReadSessionPage(grade: grade, level: level,sessionType: "detection",),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     // Handle error...
  //   }
  // }
  Future<void> _handleDetectDyslexia(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? "";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1️⃣ Check lock status
      final lockRes = await http.get(Uri.parse(
          "${Config.baseUrl}/dyslexia/check-task-lock?user_id=$userId&grade=$grade&level=$level"
      ));

      final lockData = jsonDecode(lockRes.body);

      if (lockData["is_locked"] == true) {
        Navigator.pop(context);
        _showLockedDialog(context);
        return;
      }

      // 2️⃣ Check if already attempted before
      final attemptRes = await http.get(Uri.parse(
          "${Config.baseUrl}/dyslexia/has-attempt?user_id=$userId&grade=$grade&level=$level"
      ));

      final attemptData = jsonDecode(attemptRes.body);

      Navigator.pop(context);

      // ⭐ Decide session type here
      final String sessionType =
      attemptData["has_attempt"] == true ? "improvement" : "detection";

      // 3️⃣ Navigate with correct type
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DyslexiaReadSessionPage(
            grade: grade,
            level: level,
            sessionType: sessionType,
          ),
        ),
      );

    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("කාර්යය අගුළු දමා ඇත", textAlign: TextAlign.center),
        content: const Text(
          "මෙම මට්ටම සඳහා පවරා ඇති සියලුම ඉගෙනුම් ක්‍රියාකාරකම් ඔබ අවසන් කළ යුතුය. ඉන්පසු ඔබට නැවත පරීක්ෂණයක් කළ හැකිය.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("හරි"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFF8),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF7B6FA0),
          ),
        ),
        title: Text(
          'ශ්‍රේණිය $grade – මට්ටම $level',
          style: TextStyle(
            color: Color(0xFF9C7EC4),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFECEAF8),
              Color(0xFFE8EEF8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Text(
                  'එක් විකල්පයක් තෝරන්න',
                  style: TextStyle(
                    color: Color(0xFF7B6FA0),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Select one option',
                  style: TextStyle(
                    color: Color(0xFFADA3C8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Tasks Card - Purple to Blue gradient
                Center(
                  // child: _OptionCard(
                  //   sinhalaText: 'කියවීමේ දුෂ්කරතා හඳුනාගැනීම',
                  //   englishText: 'Detect Dyslexia',
                  //   icon: Icons.task_alt_rounded,
                  //   gradient: const LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: [
                  //       Color(0xFF9B7FD4),
                  //       Color(0xFF7B9FE8),
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) => DyslexiaReadSessionPage(
                  //           grade: grade,
                  //           level: level,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  child:_OptionCard(
                    sinhalaText: 'කියවීමේ දුෂ්කරතා හඳුනාගැනීම',
                    englishText: 'Detect Dyslexia',
                    icon: Icons.task_alt_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF9B7FD4),
                        Color(0xFF7B9FE8),
                      ],
                    ),
                    onTap: () {
                      _handleDetectDyslexia(context);
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Learning Paths Card - Orange to Red gradient
                Center(
                  child: _OptionCard(
                    sinhalaText: 'කියවීමේ හැකියාවන් දියුණු කිරීම',
                    englishText: 'Improve Reading Skills',
                    icon: Icons.trending_up_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF5A855),
                        Color(0xFFEF6B6B),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LearningPathsPage(
                            grade: grade,
                            level: level,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _OptionCard extends StatelessWidget {
  final String sinhalaText;
  final String englishText;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _OptionCard({
    required this.sinhalaText,
    required this.englishText,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // White circular icon background
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            // Sinhala text
            Text(
              sinhalaText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // English subtitle
            Text(
              englishText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}