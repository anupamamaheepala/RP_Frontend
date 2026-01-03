// lib/adhd/grade4/grade4_task2_stop_go_signals.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade4_success_page.dart';
import 'grade4_task3_follow_card.dart';

class Grade4Task2StopGoSignals extends StatefulWidget {
  const Grade4Task2StopGoSignals({super.key});

  @override
  _Grade4Task2StopGoSignalsState createState() => _Grade4Task2StopGoSignalsState();
}

class _Grade4Task2StopGoSignalsState extends State<Grade4Task2StopGoSignals> {
  String currentSignal = 'wait'; // Initial neutral state
  Timer? _signalTimer;
  Timer? _taskTimer;

  int correctTaps = 0;     // Taps on green → good response
  int falseAlarms = 0;     // Taps on red/yellow → inhibition error (key ADHD marker)
  int misses = 0;          // Green appeared but no tap
  bool isActive = false;   // Is a signal currently shown?

  final Duration trialDuration = const Duration(milliseconds: 1200); // Signal stays 1.2s
  final Duration totalTaskDuration = const Duration(minutes: 1, seconds: 30); // 2:30 total

  @override
  void initState() {
    super.initState();
    _startNextTrial();
    _taskTimer = Timer(totalTaskDuration, _endTask);
  }

  void _startNextTrial() {
    // Random delay between trials (1.5–3 seconds) for natural pacing
    final interTrialDelay = 1500 + Random().nextInt(1500);
    Timer(Duration(milliseconds: interTrialDelay), () {
      if (!mounted) return;

      setState(() {
        // 70% Go (green), 30% No-Go (red or yellow)
        final rand = Random().nextDouble();
        if (rand < 0.7) {
          currentSignal = 'green';
        } else if (rand < 0.85) {
          currentSignal = 'red';
        } else {
          currentSignal = 'yellow';
        }
        isActive = true;
      });

      // Signal disappears after 1.2 seconds
      _signalTimer = Timer(trialDuration, () {
        if (!mounted) return;
        setState(() {
          isActive = false;
          currentSignal = 'wait';
        });

        // If green was shown and no tap → miss
        if (currentSignal == 'green') {
          misses++;
        }

        // Start next trial
        _startNextTrial();
      });
    });
  }

  void _onTap() {
    if (!isActive) return; // Ignore taps between trials

    setState(() {
      isActive = false; // Immediate response — clear signal
    });
    _signalTimer?.cancel();

    if (currentSignal == 'green') {
      correctTaps++;
    } else {
      falseAlarms++; // Key diagnostic metric: poor inhibition
    }

    // Go to next trial faster after response
    _startNextTrial();
  }

  void _endTask() {
    _signalTimer?.cancel();
    _taskTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Grade4SuccessPage(
          taskNumber: '2',
          nextPage: Grade4Task3FollowCard(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signalTimer?.cancel();
    _taskTimer?.cancel();
    super.dispose();
  }

  Color _getSignalColor() {
    if (!isActive) return Colors.grey.shade300;
    switch (currentSignal) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Task 2: Stop–Go Signals',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: _onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tap ONLY when you see GREEN!\nDo NOT tap on red or yellow!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getSignalColor(),
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: isActive
                      ? [const BoxShadow(color: Colors.black26, blurRadius: 20)]
                      : null,
                ),
                child: Center(
                  child: Text(
                    isActive
                        ? (currentSignal == 'green' ? 'GO!' : 'STOP!')
                        : 'Ready...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Live feedback (optional — helps keep kids engaged)
              Text(
                'Correct: $correctTaps | Errors: $falseAlarms | Misses: $misses',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}