// lib/adhd/grade7/grade7_task1_vigilance.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade7_success_page.dart';
import 'grade7_task3_switching.dart';

class Grade7Task1Vigilance extends StatefulWidget {
  const Grade7Task1Vigilance({super.key});

  @override
  State<Grade7Task1Vigilance> createState() => _Grade7Task1VigilanceState();
}

class _Grade7Task1VigilanceState extends State<Grade7Task1Vigilance> {
  Timer? _stimulusTimer;
  bool isTargetVisible = false;
  int correctHits = 0;
  int misses = 0;
  int falseAlarms = 0;
  final int totalTrials = 15; // Increased to 15 trials for Grade 7
  int currentTrial = 0;

  // 60-30-10 Color Theme
  final Color color60BG = const Color(0xFFF8FAFF);
  final Color color30Secondary = const Color(0xFF6741D9);
  final Color color10Accent = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _startTrial();
  }

  void _startTrial() {
    if (!mounted) return;

    if (currentTrial >= totalTrials) {
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

    // 30% target probability for increased complexity
    bool isTarget = Random().nextDouble() < 0.3;

    setState(() {
      isTargetVisible = isTarget;
    });

    // Faster stimulus duration: 1.2s to 2.2s
    int delayMs = 1200 + Random().nextInt(1000);
    _stimulusTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;

      if (isTargetVisible) {
        misses++; // Missed if target disappeared without tap
      }

      setState(() {
        isTargetVisible = false;
      });

      // Short break before next trial
      Future.delayed(const Duration(milliseconds: 500), _startTrial);
    });
  }

  void _onTap() {
    if (!mounted) return;

    if (isTargetVisible) {
      correctHits++;
      _stimulusTimer?.cancel();
      setState(() => isTargetVisible = false);
      // Immediate next trial on correct hit
      Future.delayed(const Duration(milliseconds: 300), _startTrial);
    } else {
      falseAlarms++;
      // Visual feedback for false alarm
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('පරෙස්සම් වන්න! රතු රවුමට පමණක් තට්ටු කරන්න.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 800),
        ),
      );
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
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: color30Secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'පියවර 1: අවධානය පරීක්ෂාව',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentTrial / totalTrials,
                      backgroundColor: color30Secondary.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color30Secondary),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'වටය: $currentTrial / $totalTrials',
                    style: TextStyle(fontWeight: FontWeight.bold, color: color30Secondary),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'රතු පැහැති රවුම දිස්වන විට පමණක් ඉක්මනින් තට්ටු කරන්න!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // Stimulus Area
            Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: isTargetVisible ? 1.0 : 0.0,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Score Board
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color30Secondary.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _scoreItem('නිවැරදි', correctHits, Colors.green),
                  _scoreItem('මඟහැරුණු', misses, color10Accent),
                  _scoreItem('වැරදි', falseAlarms, Colors.redAccent),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _scoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}