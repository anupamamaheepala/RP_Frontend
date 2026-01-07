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
  int timeLeft = 30; // තත්පර 30 ක අභියෝගයක්
  Timer? _timer;
  bool fingerDown = false;
  int breaks = 0;

  // 60-30-10 වර්ණ
  static const Color color60BG = Color(0xFFF8FAFC);
  static const Color color30Secondary = Color(0xFF0288D1);
  static const Color color10Accent = Color(0xFFFF9800);

  @override
  void initState() {
    super.initState();
    // කාල ගණනය ආරම්භ වන්නේ ඇඟිල්ල තැබූ විට පමණි (Complexity boost)
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (fingerDown) {
        setState(() {
          timeLeft--;
        });
      }
      if (timeLeft <= 0) {
        timer.cancel();
        _completeTask();
      }
    });
  }

  void _completeTask() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Grade5SuccessPage(
          taskNumber: '3',
          nextPage: Grade5Task4SwitchGo(), // මෙහි පන්තියේ නම නිවැරදි දැයි බලන්න
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'පියවර 3: සන්සුන්ව සිටින්න',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ප්‍රගති තීරුව (30% Element)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (30 - timeLeft) / 30,
                    backgroundColor: color30Secondary.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(color30Secondary),
                    minHeight: 12,
                  ),
                  const SizedBox(height: 10),
                  Text('ඉතිරි කාලය: $timeLeft තත්පර',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const Spacer(),

            const Text(
              'ඔබේ ඇඟිල්ල රවුම මත නිසලව තබා ගන්න!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              fingerDown ? 'හොඳයි! සෙලවෙන්න එපා...' : 'ඇඟිල්ල රවුම මත තබන්න',
              style: TextStyle(color: fingerDown ? Colors.green : Colors.redAccent, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),



            // ස්පර්ශක ප්‍රදේශය
            GestureDetector(
              onPanDown: (_) {
                setState(() {
                  fingerDown = true;
                });
                if (_timer == null || !_timer!.isActive) {
                  _startTimer();
                }
              },
              onPanEnd: (_) {
                setState(() {
                  fingerDown = false;
                  breaks++;
                });
              },
              onPanCancel: () {
                setState(() {
                  fingerDown = false;
                  breaks++;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fingerDown ? Colors.green.withOpacity(0.2) : Colors.white,
                  border: Border.all(
                    color: fingerDown ? Colors.green : color10Accent,
                    width: 6,
                  ),
                  boxShadow: fingerDown
                      ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 30, spreadRadius: 10)]
                      : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Center(
                  child: Icon(
                    fingerDown ? Icons.touch_app : Icons.fingerprint,
                    size: 80,
                    color: fingerDown ? Colors.green : color10Accent,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // ලකුණු පුවරුව
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color30Secondary.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 10),
                  Text(
                    'ඇඟිල්ල එසවූ වාර ගණන: $breaks',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}