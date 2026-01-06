// lib/adhd/grade5/grade5_success_page.dart
import 'dart:async';
import 'package:flutter/material.dart';

class Grade5SuccessPage extends StatefulWidget {
  final String taskNumber;
  final Widget nextPage;

  const Grade5SuccessPage({
    super.key,
    required this.taskNumber,
    required this.nextPage,
  });

  @override
  State<Grade5SuccessPage> createState() => _Grade5SuccessPageState();
}

class _Grade5SuccessPageState extends State<Grade5SuccessPage> {
  int _countdown = 5;
  Timer? _timer;

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color color60BG = Color(0xFFF8FAFC);
  static const Color color30Secondary = Color(0xFF0288D1);
  static const Color color10Accent = Color(0xFFFF9800);

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
                // ජයග්‍රාහී සලකුණ
                //
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color30Secondary.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: const Icon(Icons.stars_rounded, size: 120, color: Colors.amber),
                ),
                const SizedBox(height: 40),

                // ප්‍රධාන ජයග්‍රාහී පණිවිඩය (Grammar Fixed)
                const Text(
                  'ඉතා විශිෂ්ටයි!',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: color30Secondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'ඔබ ${widget.taskNumber} වන පියවර සාර්ථකව අවසන් කළා.',
                  style: const TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // කාලය ගණනය කරන වෘත්තය (UX Boost)
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
                        valueColor: const AlwaysStoppedAnimation<Color>(color10Accent),
                      ),
                    ),
                    Text(
                      '$_countdown',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color30Secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'ඊළඟ පියවර ආරම්භ වෙමින් පවතී...',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                ),

                const SizedBox(height: 60),

                // ඉවසීම අඩු දරුවන්ට වහාම යාමට බොත්තමක් (UX Boost)
                SizedBox(
                  width: 220,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _navigateToNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color10Accent,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'දැන්ම යමු',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, size: 24),
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