import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A1_Animate extends StatefulWidget {
  const G3_L1_High_A1_Animate({super.key});

  @override
  State<G3_L1_High_A1_Animate> createState() => _G3_L1_High_A1_AnimateState();
}

class _G3_L1_High_A1_AnimateState extends State<G3_L1_High_A1_Animate> {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  int _playCount = 0;
  bool _isCorrectAnswerSelected = false;
  bool _isWrongAnswerSelected = false;
  String _selectedAnswer = '';

  String _currentSound = "අලියා";
  final List<String> _options = ["ඇතා", "අලියා", "ඉර", "එරබදු"];

  final List<Map<String, dynamic>> _tasks = [
    {
      "sound": "අලියා",
      "options": ["කලය", "අලියා", "ඇලය", "අලය"],
      "correctAnswer": "අලියා"
    },
    {
      "sound": "යතුර",
      "options": ["වතුර", "මිතුරා", "යතුර", "කතුර"],
      "correctAnswer": "යතුර"
    },
    {
      "sound": "කලය",
      "options": ["කලය", "මාලය", "සාලය", "ඇලය"],
      "correctAnswer": "කලය"
    },
    {
      "sound": "අම්මා",
      "options": ["තාත්තා", "අයියා", "අම්මා", "අක්කා"],
      "correctAnswer": "අම්මා"
    },
    {
      "sound": "නිවස",
      "options": ["නිවස", "මල්ලි", "සල්ලි", "කැලය"],
      "correctAnswer": "නිවස"
    },
  ];


  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playLetterSound();
  }

  Future<void> _playLetterSound() async {
    await _flutterTts.speak(_tasks[_taskIndex]["sound"]);
    setState(() {
      _playCount++;
    });
  }

  void _checkAnswer(String selectedLetter) {
    setState(() {
      _selectedAnswer = selectedLetter;
      if (selectedLetter == _tasks[_taskIndex]["correctAnswer"]) {
        _isCorrectAnswerSelected = true;
        _isWrongAnswerSelected = false;
      } else {
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = true;
      }
    });
  }

  void _resetActivity() {
    setState(() {
      _isCorrectAnswerSelected = false;
      _isWrongAnswerSelected = false;
      _playCount = 0;
      _selectedAnswer = '';
    });
    _playLetterSound();
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = false;
        _playLetterSound();
      } else {
        // After finishing all tasks, show "Next Activity"
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ශ්‍රේණිය 3 මට්ටම 1 ඉහළ අවදානම - පැවරුම 1"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "පැවරුම 1: ශබ්දයට සවන් දී, ගැළපෙන අකුර තට්ටු කරන්න..",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Display the current sound to play
            Text(
              "ශබ්දයට සවන් දෙන්න: ",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Add the Replay Sound button here, before the options
            ElevatedButton.icon(
              onPressed: _resetActivity,
              icon: const Icon(Icons.replay),
              label: const Text("ශබ්දය වාදනය කරන්න"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Display 3 large clickable letter options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: currentTask["options"].map<Widget>((letter) {
                Color backgroundColor;
                if (_isCorrectAnswerSelected && letter == currentTask["correctAnswer"]) {
                  backgroundColor = Colors.green; // Correct answer turns green
                } else if (_isWrongAnswerSelected && letter == _selectedAnswer) {
                  backgroundColor = Colors.red; // Incorrect answer turns red
                } else {
                  backgroundColor = Colors.blue.shade50; // Default color
                }

                return GestureDetector(
                  onTap: () => _checkAnswer(letter),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Show Next button after the correct answer is selected
            ElevatedButton(
              onPressed: _isCorrectAnswerSelected ? _nextTask : null,
              child: Text(_taskIndex < _tasks.length - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCorrectAnswerSelected ? Colors.blue : Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}