// lib/adhd/grade5/grade5_results_page.dart
import 'package:flutter/material.dart';
import '../adhd_level_page.dart'; // Import correctly

class Grade5ResultsPage extends StatelessWidget {
  const Grade5ResultsPage({super.key});

  static const Color color60BG = Color(0xFFF8FAFF);
  static const Color color30Secondary = Color(0xFF6741D9);
  static const Color color10Accent = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60BG,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(Icons.emoji_events_rounded, size: 120, color: color10Accent),
              const SizedBox(height: 20),
              const Text(
                'ඉතා විශිෂ්ටයි!',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: color30Secondary),
              ),
              const SizedBox(height: 40),

              // මුල් පිටුවට (Level Page) යන බොත්තම
              SizedBox(
                width: 250,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // ඔබ ඉල්ලා සිටි පරිදි ADHDLevelPage වෙත සෘජුවම යෑම
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const ADHDLevelPage(grade: 5)),
                          (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color30Secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_rounded),
                      SizedBox(width: 10),
                      Text('මුල් පිටුවට', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}