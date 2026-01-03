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

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdown--;
      });

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, size: 120, color: Colors.yellow),
            const SizedBox(height: 20),
            Text(
              'හොඳින් කළා! Task ${widget.taskNumber} ඉවරයි!',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'ඊළඟ ක්‍රියාකාරකම ආරම්භ වෙන්නේ... $_countdown තත්පරයකින්',
              style: const TextStyle(fontSize: 20, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}