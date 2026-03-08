// lib/adhd/grade7/grade7_task6_distraction.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade7_results_page.dart';
import 'grade7_success_page.dart'; // Adjust path as needed

class Grade7Task6Distraction extends StatefulWidget {
  const Grade7Task6Distraction({super.key});

  @override
  _Grade7Task6DistractionState createState() => _Grade7Task6DistractionState();
}

class _Grade7Task6DistractionState extends State<Grade7Task6Distraction> {
  int correctTaps = 0;
  int distractionTaps = 0; // Errors: tapping on distraction
  int misses = 0;
  bool showTarget = false;
  bool showDistraction = false;

  Timer? _targetTimer;
  Timer? _distractionTimer;
  Timer? _taskTimer;

  @override
  void initState() {
    super.initState();
    _startTargetTask();
    _startDistractionTask();
    _taskTimer = Timer(const Duration(minutes: 3), _endTask); // 3 minutes total
  }

  void _startTargetTask() {
    _targetTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        showTarget = true;
      });
      // Target disappears after 1.2 seconds if not tapped (miss)
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted && showTarget) {
          setState(() => showTarget = false);
          misses++;
        }
      });
    });
  }

  void _startDistractionTask() {
    _distractionTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() => showDistraction = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => showDistraction = false);
      });
    });
  }

  void _onTap(bool isDistraction) {
    if (isDistraction) {
      // Tapped on distraction → error
      setState(() {
        distractionTaps++;
        showDistraction = false; // Hide it immediately
      });
    } else if (showTarget) {
      // Correct tap on target
      setState(() {
        correctTaps++;
        showTarget = false;
      });
    }
  }

  void _endTask() {
    _targetTimer?.cancel();
    _distractionTimer?.cancel();
    _taskTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Grade7ResultsPage(taskNumber: '6'),
      ),
    );
  }

  @override
  void dispose() {
    _targetTimer?.cancel();
    _distractionTimer?.cancel();
    _taskTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 6: Ignore Distractions')),
      body: GestureDetector(
        onTap: () => _onTap(showDistraction), // Whole screen tappable
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Tap the GREEN circle when it appears!\nIGNORE the yellow pop-ups!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: showTarget ? Colors.green : Colors.blueGrey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        showTarget ? 'TAP!' : 'Watch',
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Correct: $correctTaps | Errors: $distractionTaps | Misses: $misses',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            // Distraction pop-up
            if (showDistraction)
              Positioned(
                top: 80 + Random().nextInt(200).toDouble(),
                left: 50 + Random().nextInt(200).toDouble(),
                child: GestureDetector(
                  onTap: () => _onTap(true), // Separate tap detection for distraction
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'IGNORE ME!',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}