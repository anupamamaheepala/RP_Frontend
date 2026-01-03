// lib/adhd/grade7/grade7_task1_vigilance.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade7_success_page.dart';
//import 'grade7_task2_selective.dart';
import 'grade7_task3_switching.dart';

class Grade7Task1Vigilance extends StatefulWidget {
  const Grade7Task1Vigilance({super.key});

  @override
  _Grade7Task1VigilanceState createState() => _Grade7Task1VigilanceState();
}

class _Grade7Task1VigilanceState extends State<Grade7Task1Vigilance> {
  Timer? _stimulusTimer;
  bool isTargetVisible = false;
  int correctHits = 0;
  int misses = 0;
  int falseAlarms = 0;
  final int totalTrials = 10;
  int currentTrial = 0;

  @override
  void initState() {
    super.initState();
    _startTrial();
  }

  void _startTrial() {
    if (currentTrial >= totalTrials) {
      // Done → success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade7SuccessPage(
            taskNumber: '1',
            nextPage: Grade7Task3Switching(),
          ),
        ),
      );
      return;
    }

    currentTrial++;
    bool isTarget = Random().nextDouble() < 0.2; // 20% targets
    setState(() => isTargetVisible = isTarget);

    // Random interval 1.5–2.5 sec
    int delayMs = 1500 + Random().nextInt(1000);
    _stimulusTimer = Timer(Duration(milliseconds: delayMs), () {
      setState(() => isTargetVisible = false);
      if (isTarget) misses++; // Missed target
      Future.delayed(const Duration(milliseconds: 10), _startTrial);
    });
  }

  void _onTap() {
    if (isTargetVisible) {
      correctHits++;
      setState(() => isTargetVisible = false);
    } else {
      falseAlarms++;
    }
  }

  @override
  void dispose() {
    _stimulusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        title: const Text('Task 1: Vigilance'),
      ),
      body: GestureDetector(
        onTap: _onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tap only when you see the RED CIRCLE!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              if (isTargetVisible)
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Trial $currentTrial / $totalTrials',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}