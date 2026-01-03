import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'grade3_success_page.dart';
import 'grade3_task3_match_drag.dart';

class Grade3Task2SequenceTap extends StatefulWidget {
  const Grade3Task2SequenceTap({super.key});

  @override
  _Grade3Task2SequenceTapState createState() => _Grade3Task2SequenceTapState();
}

class _Grade3Task2SequenceTapState extends State<Grade3Task2SequenceTap> {
  final int maxTrials = 5;
  int currentTrial = 0;
  List<int> sequence = [];
  List<int> userSequence = [];

  // රෝග විනිශ්චය දත්ත (Diagnostic Parameters)
  int correctTaps = 0;
  int wrongTaps = 0;

  // UI Theme Colors (ඔබේ මුල් වර්ණ එලෙසමයි)
  final Color primaryBg = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _shuffleSequence();
  }

  void _shuffleSequence() {
    setState(() {
      sequence = [1, 2, 3, 4];
      sequence.shuffle(Random());
      userSequence = [];
    });
  }

  void _handleTap(int number) {
    // දැනටමත් ටැප් කර ඇත්නම් නැවත ප්‍රතිචාර නොදක්වයි
    if (userSequence.contains(number)) return;

    if (userSequence.length < sequence.length && number == userSequence.length + 1) {
      HapticFeedback.lightImpact();
      setState(() {
        correctTaps++;
        userSequence.add(number);
      });
      if (userSequence.length == sequence.length) {
        _onCorrectSequence();
      }
    } else {
      // වැරදුණු වාර ගණන
      wrongTaps++;
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 800),
          content: Text('වැරදියි! කුඩාම අංකයේ සිට විශාල අංකයට ස්පර්ශ කරන්න.'),
        ),
      );
    }
  }

  void _onCorrectSequence() {
    if (currentTrial < maxTrials - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        _shuffleSequence();
        setState(() {
          currentTrial++;
        });
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Grade3SuccessPage(
            taskNumber: '2',
            stats: {
              'correct': correctTaps,
              'premature': 0,
              'wrong': wrongTaps,
            },
            nextPage: const Grade3Task3MatchDrag(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: secondaryPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'පියවර 2: අනුපිළිවෙලට තබන්න',
          style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentTrial + 1) / maxTrials,
            backgroundColor: Colors.grey[200],
            color: accentAmber,
            minHeight: 8,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'කුඩාම අංකයේ සිට විශාල අංකය දක්වා පිළිවෙලින් ස්පර්ශ කරන්න',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: secondaryPurple,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'වටය ${currentTrial + 1} / $maxTrials',
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const Spacer(),

          // අංක බොත්තම් සහිත කොටස
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              // මෙහිදී බොත්තම් සජීවීව ලැයිස්තුවෙන් නිර්මාණය වේ
              children: sequence.map((num) => _buildNumberButton(num)).toList(),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    bool isTapped = userSequence.contains(number);
    return GestureDetector(
      onTap: () => _handleTap(number),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 85,
        height: 85,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isTapped ? Colors.green[100] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isTapped ? Colors.green : Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isTapped ? Colors.transparent : secondaryPurple.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: isTapped ? Colors.green : secondaryPurple,
            ),
          ),
        ),
      ),
    );
  }
}