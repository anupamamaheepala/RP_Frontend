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
  String currentSignal = 'wait';
  Timer? _signalTimer;
  Timer? _taskTimer;

  int correctTaps = 0;
  int falseAlarms = 0;
  int misses = 0;
  bool isActive = false;

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color colorBG = Color(0xFFF8FAFC);      // 60%
  static const Color colorFrame = Color(0xFF1E293B);   // 30%
  static const Color colorAccent = Color(0xFFF59E0B);  // 10%

  // සංකීර්ණතාවය සඳහා කාලය (මිලි තත්පර වලින්)
  int currentTrialDuration = 1200;
  final Duration totalTaskDuration = const Duration(minutes: 1, seconds: 0);

  @override
  void initState() {
    super.initState();
    _startNextTrial();
    _taskTimer = Timer(totalTaskDuration, _endTask);
  }

  void _startNextTrial() {
    final interTrialDelay = 1000 + Random().nextInt(2000);
    Timer(Duration(milliseconds: interTrialDelay), () {
      if (!mounted) return;

      setState(() {
        final rand = Random().nextDouble();
        if (rand < 0.6) {
          currentSignal = 'green';
        } else if (rand < 0.8) {
          currentSignal = 'red';
        } else {
          currentSignal = 'yellow';
        }
        isActive = true;
      });

      _signalTimer = Timer(Duration(milliseconds: currentTrialDuration), () {
        if (!mounted) return;

        if (isActive && currentSignal == 'green') {
          setState(() => misses++);
        }

        setState(() {
          isActive = false;
          currentSignal = 'wait';
        });

        _startNextTrial();
      });
    });
  }

  void _onTap() {
    if (!isActive) return;

    setState(() {
      isActive = false;
    });
    _signalTimer?.cancel();

    if (currentSignal == 'green') {
      correctTaps++;
      // සංකීර්ණතාවය වැඩි කිරීම: නිවැරදි වන විට වේගය වැඩි වේ
      if (currentTrialDuration > 600) {
        currentTrialDuration -= 40;
      }
    } else {
      falseAlarms++;
      // වැරදුනහොත් වේගය මඳක් අඩු වේ (දරුවා අධෛර්යමත් වීම වැළැක්වීමට)
      currentTrialDuration += 20;
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'පියවර 2: රථවාහන සංඥා ක්‍රීඩාව',
          style: TextStyle(color: colorFrame, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'කොළ පාට පෙනෙන විට පමණක් ඉක්මනින් තට්ටු කරන්න! රතු හෝ කහ පාටට තට්ටු කරන්න එපා.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),

            // රථවාහන සංඥා කුටිය (Visualizing the traffic light)

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorFrame,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  _buildLight(Colors.red, currentSignal == 'red' && isActive),
                  const SizedBox(height: 15),
                  _buildLight(Colors.yellow, currentSignal == 'yellow' && isActive),
                  const SizedBox(height: 15),
                  _buildLight(Colors.green, currentSignal == 'green' && isActive),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Text(
              !isActive ? 'සූදානම් වන්න...' : (currentSignal == 'green' ? 'දැන් තට්ටු කරන්න!' : 'නවතින්න!'),
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: currentSignal == 'green' && isActive ? Colors.green : colorFrame
              ),
            ),

            const Spacer(),

            // ලකුණු පුවරුව
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorFrame.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _scoreItem('නිවැරදි', correctTaps, Colors.green),
                  _scoreItem('වැරදි', falseAlarms, Colors.red),
                  _scoreItem('මඟහැරුණු', misses, Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLight(Color color, bool isOn) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? color : color.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
        boxShadow: isOn ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)] : [],
      ),
    );
  }

  Widget _scoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}