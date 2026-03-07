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