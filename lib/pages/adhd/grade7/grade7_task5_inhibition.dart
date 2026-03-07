// lib/adhd/grade7/grade7_task5_inhibition.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade7_success_page.dart';
import 'grade7_task6_distraction.dart';

class Grade7Task5Inhibition extends StatefulWidget {
  const Grade7Task5Inhibition({super.key});

  @override
  _Grade7Task5InhibitionState createState() => _Grade7Task5InhibitionState();
}

class _Grade7Task5InhibitionState extends State<Grade7Task5Inhibition> {
  Timer? _trialTimer;
  bool isGo = true;
  int falseAlarms = 0;
  int correctGo = 0;
  int trials = 0;
  final int maxTrials = 150;

  @override
  void initState() {
    super.initState();
    _nextTrial();
  }

  void _nextTrial() {
    if (trials >= maxTrials) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade7SuccessPage(
            taskNumber: '5',
            nextPage: Grade7Task6Distraction(),
          ),
        ),
      );
      return;
    }

    trials++;
    isGo = Random().nextDouble() < 0.7; // 70% Go
    setState(() {});
    _trialTimer = Timer(const Duration(milliseconds: 1200), _nextTrial);
  }

  void _onTap() {
    if (isGo) {
      correctGo++;
    } else {
      falseAlarms++;
    }
  }

  @override
  void dispose() {
    _trialTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 5: Go/No-Go')),
      body: GestureDetector(
        onTap: _onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isGo ? 'TAP (Green)' : 'DO NOT TAP (Red)',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isGo ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text('Trial $trials / $maxTrials'),
            ],
          ),
        ),
      ),
    );
  }
}