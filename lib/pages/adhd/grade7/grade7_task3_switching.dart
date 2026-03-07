// lib/adhd/grade7/grade7_task3_switching.dart
import 'package:flutter/material.dart';
import 'grade7_success_page.dart';
import 'grade7_task4_divided.dart';

class Grade7Task3Switching extends StatefulWidget {
  const Grade7Task3Switching({super.key});

  @override
  _Grade7Task3SwitchingState createState() => _Grade7Task3SwitchingState();
}

class _Grade7Task3SwitchingState extends State<Grade7Task3Switching> {
  final int maxTrials = 60;
  int currentTrial = 0;
  bool isColorRule = true; // Start with color rule
  int switchInterval = 8; // Switch every 8 trials
  int correct = 0;
  int errors = 0;

  @override
  void initState() {
    super.initState();
    _nextTrial();
  }

  void _nextTrial() {
    currentTrial++;
    if (currentTrial % switchInterval == 0) isColorRule = !isColorRule;

    // Simulate stimulus
    // In real app, show colored shape and ask if it matches rule
    setState(() {});
  }

  void _handleTap(bool tappedMatch) {
    bool isCorrect = (isColorRule && tappedMatch) || (!isColorRule && !tappedMatch);
    if (isCorrect) {
      correct++;
    } else {
      errors++;
    }

    if (currentTrial >= maxTrials) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade7SuccessPage(
            taskNumber: '3',
            nextPage: Grade7Task4Divided(),
          ),
        ),
      );
    } else {
      _nextTrial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 3: Rule Switching')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Rule: ${isColorRule ? "COLOR" : "SHAPE"}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Simulated stimulus
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleTap(true),
                  child: const Text('Matches Rule'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _handleTap(false),
                  child: const Text('Does NOT Match'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Trial $currentTrial / $maxTrials'),
          ],
        ),
      ),
    );
  }
}