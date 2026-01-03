import 'dart:async';
import 'package:flutter/material.dart';
import './task_stats.dart'; // Ensure this import matches your path

class Grade3SuccessPage extends StatefulWidget {
  final String taskNumber;
  final Widget nextPage;
  final Map<String, int> stats;

  const Grade3SuccessPage({
    super.key,
    required this.taskNumber,
    required this.nextPage,
    required this.stats,
  });

  @override
  State<Grade3SuccessPage> createState() => _Grade3SuccessPageState();
}

class _Grade3SuccessPageState extends State<Grade3SuccessPage> {
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update global diagnostic stats as soon as the task is finished
    TaskStats.addStats(widget.stats);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => widget.nextPage),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, size: 120, color: Color(0xFFFFB300)),
            const SizedBox(height: 30),
            Text(
              'නියමයි! ${widget.taskNumber} පියවර අවසන්!',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6741D9)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100, height: 100,
                  child: CircularProgressIndicator(
                    value: _countdown / 5,
                    strokeWidth: 8,
                    color: const Color(0xFFFFB300),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                Text('$_countdown', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}