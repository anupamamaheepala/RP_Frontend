// lib/adhd/grade4/grade4_task4_stay_complete.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Optional: for sound feedback
import 'grade4_success_page.dart';
import 'grade4_results_page.dart';

class Grade4Task4StayComplete extends StatefulWidget {
  const Grade4Task4StayComplete({super.key});

  @override
  _Grade4Task4StayCompleteState createState() => _Grade4Task4StayCompleteState();
}

class _Grade4Task4StayCompleteState extends State<Grade4Task4StayComplete> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Optional sound

  final int totalItems = 20;
  int completedItems = 0;
  int errors = 0;

  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;

  Stopwatch stopwatch = Stopwatch();

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    _generateNewProblem();
  }

  void _generateNewProblem() {
    setState(() {
      num1 = random.nextInt(10) + 1; // 1–10
      num2 = random.nextInt(10) + 1; // 1–10
      correctAnswer = num1 + num2;
    });
  }

  void _checkAnswer(int selected) async {
    if (selected == correctAnswer) {
      // Correct!
      setState(() => completedItems++);

      // Optional positive sound
      // await _audioPlayer.play(AssetSource('sounds/correct.mp3'));

      if (completedItems >= totalItems) {
        stopwatch.stop();
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
      // Wrong answer
      setState(() => errors++);

      // Optional error sound
      // await _audioPlayer.play(AssetSource('sounds/error.mp3'));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    stopwatch.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = stopwatch.elapsed.inSeconds;
    final minutes = (elapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsed % 60).toString().padLeft(2, '0');

    // Generate 5 answer choices around the correct answer
    List<int> choices = [];
    for (int i = -2; i <= 2; i++) {
      int option = correctAnswer + i;
      if (option >= 0 && option <= 20) {
        choices.add(option);
      }
    }
    choices.shuffle(random); // Randomize order

    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Task 4: Stay & Complete',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Complete all 20 math problems.\nStay focused until the end!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                'Progress: $completedItems / $totalItems',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                'Time: $minutes:$seconds',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Errors: $errors',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 50),
              // Current problem
              Text(
                '$num1 + $num2 = ?',
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              // Answer buttons (5 choices)
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: choices.map((option) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.purple.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _checkAnswer(option),
                    child: Text(
                      '$option',
                      style: const TextStyle(fontSize: 32, color: Colors.black87),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}