// lib/adhd/grade5/grade5_task3_stillness.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'grade5_success_page.dart';
import 'grade5_task4_switch_go.dart';

class Grade5Task3Stillness extends StatefulWidget {
  const Grade5Task3Stillness({super.key});

  @override
  _Grade5Task3StillnessState createState() => _Grade5Task3StillnessState();
}

class _Grade5Task3StillnessState extends State<Grade5Task3Stillness> {
  int timeLeft = 30; // seconds
  Timer? _timer;
  bool fingerDown = false;
  int breaks = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      if (timeLeft <= 0) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Grade5SuccessPage(
              taskNumber: '3',
              nextPage: Grade5Task4SwitchGo(),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 3: Stay Still')),
      body: GestureDetector(
        onTapDown: (_) => setState(() => fingerDown = true),
        onTapUp: (_) {
          setState(() {
            fingerDown = false;
            breaks++;
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Keep your finger inside the circle!', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 40),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fingerDown ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text('Time left: $timeLeft seconds'),
              Text('Breaks: $breaks'),
            ],
          ),
        ),
      ),
    );
  }
}