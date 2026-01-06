// lib/adhd/grade7/grade7_task6_distraction.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade7_results_page.dart';

class Grade7Task6Distraction extends StatefulWidget {
  const Grade7Task6Distraction({super.key});

  @override
  State<Grade7Task6Distraction> createState() => _Grade7Task6DistractionState();
}

class _Grade7Task6DistractionState extends State<Grade7Task6Distraction> {
  int correctTaps = 0;
  int distractionTaps = 0;
  int misses = 0;
  bool showTarget = false;
  bool showDistraction = false;

  Timer? _targetTimer;
  Timer? _distractionTimer;
  Timer? _taskTimer;
  int _secondsRemaining = 60; // 60-second task duration

  // 60-30-10 Color Theme
  final Color color60BG = const Color(0xFFF8FAFF);
  final Color color30Secondary = const Color(0xFF6741D9);
  final Color color10Accent = const Color(0xFFFFB300);

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startTargetTask();
    _startDistractionTask();
    _startCountdown();
  }

  void _startCountdown() {
    _taskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _secondsRemaining--;
      });

      if (_secondsRemaining <= 0) {
        _endTask();
      }
    });
  }

  void _startTargetTask() {
    // Target appears every 3 seconds, stays for 1.2 seconds
    _targetTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || _secondsRemaining <= 0) return;

      setState(() {
        showTarget = true;
      });

      // Auto-hide after 1200ms → miss if not tapped
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (showTarget) {
          setState(() {
            showTarget = false;
            misses++;
          });
        }
      });
    });
  }

  void _startDistractionTask() {
    // Distractions appear more frequently (every 8 seconds on average)
    _distractionTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted || _secondsRemaining <= 0) return;

      setState(() {
        showDistraction = true;
      });

      // Auto-hide after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          showDistraction = false;
        });
      });
    });
  }

  void _onTargetTap() {
    if (showTarget) {
      setState(() {
        correctTaps++;
        showTarget = false;
      });
    }
  }

  void _onDistractionTap() {
    if (showDistraction) {
      setState(() {
        distractionTaps++;
        showDistraction = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('අවධානය යොමු කරන්න! බාධාකාරී රූප ස්පර්ශ නොකරන්න.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  void _endTask() {
    // Cancel all timers to prevent further actions
    _targetTimer?.cancel();
    _distractionTimer?.cancel();
    _taskTimer?.cancel();

    // Navigate to results only once
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade7ResultsPage(taskNumber: '6'),
        ),
      );
    }
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
          'පියවර 6: බාහිර බාධා පාලනය',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),

                // Progress & Timer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _secondsRemaining / 60,
                        backgroundColor: color30Secondary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color30Secondary),
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ඉතිරි කාලය: $_secondsRemaining තත්පර',
                        style: TextStyle(fontWeight: FontWeight.bold, color: color30Secondary),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'කොළ පැහැති රවුම දිස්වන විට පමණක් තට්ටු කරන්න.\nඅනෙකුත් බාධාකාරී රූප නොසලකා හරින්න.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Main Target Circle
                GestureDetector(
                  onTap: _onTargetTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: showTarget ? Colors.green : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: showTarget ? Colors.white : color30Secondary.withOpacity(0.1),
                        width: 6,
                      ),
                      boxShadow: showTarget
                          ? [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        showTarget ? 'දැන්!' : 'බලා සිටින්න',
                        style: TextStyle(
                          color: showTarget ? Colors.white : Colors.grey.shade600,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: color30Secondary.withOpacity(0.1)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('නිවැරදි', correctTaps, Colors.green),
                      _statItem('වැරදි', distractionTaps, Colors.redAccent),
                      _statItem('මඟහැරුණු', misses, color10Accent),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

            // Distraction Pop-ups
            if (showDistraction)
              Positioned(
                top: 150 + _random.nextInt(300).toDouble(),
                left: 30 + _random.nextInt(200).toDouble(),
                child: GestureDetector(
                  onTap: _onDistractionTap,
                  child: AnimatedOpacity(
                    opacity: showDistraction ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: color10Accent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: color10Accent.withOpacity(0.5), blurRadius: 15),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.warning_amber_rounded, size: 50, color: Colors.white),
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

  Widget _statItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 5),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}