// lib/adhd/grade4/grade4_task4_stay_complete.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade4_success_page.dart';
import 'grade4_results_page.dart';

class Grade4Task4StayComplete extends StatefulWidget {
  const Grade4Task4StayComplete({super.key});

  @override
  _Grade4Task4StayCompleteState createState() => _Grade4Task4StayCompleteState();
}

class _Grade4Task4StayCompleteState extends State<Grade4Task4StayComplete> {
  // පරීක්ෂණ සඳහා ප්‍රශ්න ගණන 5ක් කර ඇත. පසුව මෙය 20 දක්වා වැඩි කරන්න.
  final int totalItems = 5;
  int completedItems = 0;
  int errors = 0;

  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  List<int> currentChoices = []; // පිළිතුරු තේරීම් ගබඩා කිරීමට

  Stopwatch stopwatch = Stopwatch();
  Timer? _timer;

  final Random random = Random();

  // 60-30-10 වර්ණ තේමාව
  static const Color color60 = Color(0xFFF0F4F8); // පසුබිම
  static const Color color30 = Color(0xFF37474F); // පෙළ/රාමු
  static const Color color10 = Color(0xFFFF9800); // බොත්තම්

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
    _generateNewProblem();
  }

  void _generateNewProblem() {
    setState(() {
      num1 = random.nextInt(20) + 1;
      num2 = random.nextInt(15) + 1;
      correctAnswer = num1 + num2;

      // පිළිතුරු තේරීම් මෙහිදී ජනනය කර ස්ථාවරව තබා ගනී
      Set<int> choices = {correctAnswer};
      while (choices.length < 5) {
        int offset = random.nextInt(10) - 5;
        int option = correctAnswer + offset;
        if (option > 0) choices.add(option);
      }
      currentChoices = choices.toList()..shuffle();
    });
  }

  void _checkAnswer(int selected) {
    if (selected == correctAnswer) {
      setState(() => completedItems++);

      if (completedItems >= totalItems) {
        stopwatch.stop();
        _timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Grade4SuccessPage(
              taskNumber: '4',
              nextPage: Grade4ResultsPage(),
            ),
          ),
        );
      } else {
        _generateNewProblem();
      }
    } else {
      setState(() => errors++);
      // වැරදි පණිවිඩය පෙන්වීම
      ScaffoldMessenger.of(context).clearSnackBars(); // පැරණි ඒවා ඉවත් කරයි
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('නැවත උත්සාහ කරන්න! 🤔', style: TextStyle(fontFamily: 'Sinhala')),
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = stopwatch.elapsed.inSeconds;
    final minutes = (elapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsed % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: color60,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'පියවර 4: අවධානයෙන් ගණන් හදමු',
          style: TextStyle(color: color30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Text(
                'ගැටලු $totalItems ම නිවැරදිව විසඳන්න.\nඅවසානය තෙක් අවධානයෙන් සිටින්න!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // ප්‍රගති තීරුව
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ප්‍රගතිය: $completedItems / $totalItems', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('කාලය: $minutes:$seconds', style: const TextStyle(color: Colors.blueGrey)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completedItems / totalItems,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(color10),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ප්‍රශ්නය පෙන්වන කාඩ්පත

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: color30.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '$num1 + $num2 = ?',
                      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: color30),
                    ),
                    const SizedBox(height: 10),
                    const Text('නිවැරදි පිළිතුර තෝරන්න', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // පිළිතුරු බොත්තම්
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: currentChoices.map((option) {
                  return SizedBox(
                    width: 100,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: color30,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: color10, width: 2),
                        ),
                      ),
                      onPressed: () => _checkAnswer(option),
                      child: Text(
                        '$option',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              if (errors > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'වැරදි ප්‍රමාණය: $errors',
                    style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}