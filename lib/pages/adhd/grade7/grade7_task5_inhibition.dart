// lib/adhd/grade7/grade7_task5_inhibition.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../grade5/grade5_success_page.dart';
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
  // පරීක්ෂණ සඳහා වට ගණන 20ක් කර ඇත. පසුව මෙය 150 දක්වා වැඩි කරන්න.
  final int maxTrials = 20;

  // 60-30-10 වර්ණ තේමාව
  final Color color60BG = const Color(0xFFF8FAFF);
  final Color color30Secondary = const Color(0xFF6741D9);
  final Color color10Accent = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _nextTrial();
  }

  void _nextTrial() {
    if (!mounted) return;

    if (trials >= maxTrials) {
      _trialTimer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade5SuccessPage( // Using reusable success page
            taskNumber: '5',
            nextPage: Grade7Task6Distraction(),
          ),
        ),
      );
      return;
    }

    setState(() {
      trials++;
      // 70% Go සම්භාවිතාව (දරුවාව වේගවත් තට්ටු කිරීමකට හුරු කරවා හදිසියේ නතර කිරීම පරීක්ෂා කෙරේ)
      isGo = Random().nextDouble() < 0.7;
    });

    // අහඹු කාල පරාසය (800ms - 1300ms) - Complexity increase
    int duration = 800 + Random().nextInt(500);
    _trialTimer = Timer(Duration(milliseconds: duration), _nextTrial);
  }

  void _onTap() {
    setState(() {
      if (isGo) {
        correctGo++;
      } else {
        falseAlarms++;
        // වැරදුණු විට දෘශ්‍ය ප්‍රතිචාරයක්
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('නැවතෙන්න! රතු පැහැති විට තට්ටු කිරීමෙන් වළකින්න.'),
            backgroundColor: Colors.redAccent,
            duration: Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _trialTimer?.cancel();
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
        title: Text(
          'පියවර 5: ස්වයං පාලනය',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ප්‍රගති තීරුව (30% Element)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: trials / maxTrials,
                        backgroundColor: color30Secondary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color30Secondary),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'වටය: $trials / $maxTrials',
                      style: TextStyle(fontWeight: FontWeight.bold, color: color30Secondary),
                    ),
                  ],
                ),
              ),

              const Spacer(),



              // සංඥා පුවරුව
              Text(
                isGo ? 'තට්ටු කරන්න!' : 'නතර වන්න!',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: isGo ? Colors.green : Colors.redAccent,
                    letterSpacing: 1.2
                ),
              ),
              const SizedBox(height: 40),

              // ප්‍රධාන උත්තේජකය (Stimulus)
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isGo ? Colors.green : Colors.redAccent,
                  boxShadow: [
                    BoxShadow(
                      color: (isGo ? Colors.green : Colors.redAccent).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                  border: Border.all(color: Colors.white, width: 8),
                ),
                child: const Center(
                  child: Icon(Icons.touch_app_rounded, size: 80, color: Colors.white),
                ),
              ),

              const Spacer(),

              // ලකුණු පුවරුව (10% Accent Context)
              Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: color30Secondary.withOpacity(0.1)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _scoreItem('නිවැරදි Go', correctGo, Colors.green),
                    _scoreItem('වැරදි (False)', falseAlarms, Colors.redAccent),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}