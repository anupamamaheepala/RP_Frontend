// lib/adhd/grade7/grade7_success_page.dart
import 'dart:async';
import 'package:flutter/material.dart';

class Grade7SuccessPage extends StatefulWidget {
  final String taskNumber;
  final Widget nextPage;

  const Grade7SuccessPage({
    super.key,
    required this.taskNumber,
    required this.nextPage,
  });

  @override
  State<Grade7SuccessPage> createState() => _Grade7SuccessPageState();
}

class _Grade7SuccessPageState extends State<Grade7SuccessPage> {
  int _countdown = 5;
  Timer? _timer;

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color color60BG = Color(0xFFF8FAFF);
  static const Color color30Secondary = Color(0xFF6741D9);
  static const Color color10Accent = Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        _navigateToNext();
      }
    });
  }

  void _navigateToNext() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => widget.nextPage),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60BG,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ජයග්‍රාහී පදක්කම (Medal Icon)
                // [Image of a modern minimalist digital achievement badge with a star and glowing edges]
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color30Secondary.withOpacity(0.15),
                        blurRadius: 40,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, size: 100, color: color10Accent),
                ),
                const SizedBox(height: 40),

                // ප්‍රධාන පණිවිඩය (Fixed Grammar)
                const Text(
                  'ඉතා විශිෂ්ටයි!',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: color30Secondary,
                      letterSpacing: 1.1
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'ඔබ ${widget.taskNumber} වන පියවර සාර්ථකව අවසන් කළා.',
                  style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // කාල ගණක වෘත්තය (UX Optimized)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: _countdown / 5,
                        strokeWidth: 8,
                        backgroundColor: color30Secondary.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(color30Secondary),
                      ),
                    ),
                    Text(
                      '$_countdown',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color30Secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'ඊළඟ අදියරට සූදානම් වන්න...',
                  style: TextStyle(fontSize: 15, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                ),

                const SizedBox(height: 60),

                // Manual Navigation Button (UX Boost for impatience)
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _navigateToNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color10Accent,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ඉදිරියට යමු',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios_rounded, size: 20),
                      ],
                    ),
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