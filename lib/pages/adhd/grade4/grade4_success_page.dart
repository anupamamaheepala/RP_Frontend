// lib/adhd/grade4/grade4_success_page.dart
import 'dart:async';
import 'package:flutter/material.dart';

class Grade4SuccessPage extends StatefulWidget {
  final String taskNumber;
  final Widget nextPage;

  const Grade4SuccessPage({
    super.key,
    required this.taskNumber,
    required this.nextPage,
  });

  @override
  State<Grade4SuccessPage> createState() => _Grade4SuccessPageState();
}

class _Grade4SuccessPageState extends State<Grade4SuccessPage> {
  int _countdown = 5;
  Timer? _timer;

  static const Color color60 = Color(0xFFF1F5F9);
  static const Color color30 = Color(0xFF0288D1);
  static const Color color10 = Color(0xFFFF9800);

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
      backgroundColor: color60,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Star icon in circular container
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color30.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 100,
                    color: Colors.amber,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'ඉතා විශිෂ්ටයි!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: color30,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  'ඔබ පියවර ${widget.taskNumber} සාර්ථකව අවසන් කළා.',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // Countdown circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: _countdown / 5,
                        strokeWidth: 8,
                        backgroundColor: color30.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(color10),
                      ),
                    ),
                    Text(
                      '$_countdown',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'ඊළඟ පියවර ආරම්භ වෙමින් පවතී...',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),

                const SizedBox(height: 60),

                // Manual next button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _navigateToNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: color30,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: color30, width: 2),
                      ),
                    ),
                    child: const Text(
                      'දැන්ම යමු ➔',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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