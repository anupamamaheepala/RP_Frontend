import 'package:flutter/material.dart';

class G3_L1_High_A3_MissingLetter extends StatefulWidget {
  const G3_L1_High_A3_MissingLetter({super.key});

  @override
  State<G3_L1_High_A3_MissingLetter> createState() =>
      _G3_L1_High_A3_MissingLetterState();
}

class _G3_L1_High_A3_MissingLetterState
    extends State<G3_L1_High_A3_MissingLetter> {
  int _taskIndex = 0;
  bool _isCorrectAnswerSelected = false;
  bool _isWrongAnswerSelected = false;
  String _selectedAnswer = '';
  String _status = 'Please choose the missing letter!';

  final List<Map<String, dynamic>> _tasks = [
    {
      'word': '_ලියා', // Missing letter represented as "_"
      'emoji': '🐘', // Emoji related to the word
      'meaning': 'Elephant', // Meaning of the word
      'correctAnswer': 'අ', // Correct letter
      'options': ['අ', 'ඉ', 'ආ'], // Options for this word
    },
    {
      'word': 'සිංහයා',
      'emoji': '🦁',
      'meaning': 'Lion',
      'correctAnswer': 'හ',
      'options': ['හ', 'ඞ', 'ග'], // Options for this word
    },
    {
      'word': 'ආ_තය',
      'emoji': '🐅',
      'meaning': 'Tiger',
      'correctAnswer': 'ආ',
      'options': ['ආ', 'ඇ', 'අ'], // Options for this word
    },
    {
      'word': 'ඇ_ත',
      'emoji': '🐵',
      'meaning': 'Monkey',
      'correctAnswer': 'ඇ',
      'options': ['ඇ', 'ඉ', 'ඔ'], // Options for this word
    },
    {
      'word': 'ම_යා',
      'emoji': '🦉',
      'meaning': 'Owl',
      'correctAnswer': 'ය',
      'options': ['ය', 'ර', 'ක'], // Options for this word
    },
    {
      'word': 'ප_ක',
      'emoji': '🐦',
      'meaning': 'Bird',
      'correctAnswer': 'ත',
      'options': ['ත', 'න', 'ච'], // Options for this word
    },
    {
      'word': '_ගහ',
      'emoji': '🌳',
      'meaning': 'Tree',
      'correctAnswer': 'ක',
      'options': ['ක', 'ම', 'න'], // Options for this word
    },
    {
      'word': 'ස_ය',
      'emoji': '🐢',
      'meaning': 'Turtle',
      'correctAnswer': 'ි',
      'options': ['ි', 'ු', '්'], // Options for this word
    },
    {
      'word': '_පටය',
      'emoji': '🦓',
      'meaning': 'Zebra',
      'correctAnswer': 'ස',
      'options': ['ස', 'ම', 'අ'], // Options for this word
    },
    {
      'word': 'ප_ල',
      'emoji': '🐶',
      'meaning': 'Dog',
      'correctAnswer': 'ෙ',
      'options': ['ෙ', 'ැ', 'ි'], // Options for this word
    },
  ];

  // Check if the selected answer is correct
  void _checkAnswer(String selectedLetter) {
    setState(() {
      _selectedAnswer = selectedLetter;
      if (selectedLetter == _tasks[_taskIndex]['correctAnswer']) {
        _isCorrectAnswerSelected = true;
        _isWrongAnswerSelected = false;
        _status = 'Correct! The word is "${_tasks[_taskIndex]["word"].replaceAll('_', selectedLetter)}"';
      } else {
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = true;
        _status = 'Incorrect! Please try again.';
      }
    });
  }

  // Function to move to the next task
  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = false;
        _status = 'Please choose the missing letter!';
      } else {
        Navigator.pop(context, true); // Move to next activity after the last task
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 3: Missing Letter"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header text
            Text(
              "Which letter is missing in the word?",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Emoji and meaning
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentTask['emoji'], // Show Emoji
                  style: const TextStyle(fontSize: 50),
                ),
                const SizedBox(width: 10),
                Text(
                  currentTask['meaning'], // Meaning of the word
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Word with missing letter
            Text(
              currentTask['word'],
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Options for the missing letter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: currentTask['options'].map<Widget>((letter) {
                Color backgroundColor;
                if (_isCorrectAnswerSelected && letter == currentTask['correctAnswer']) {
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
                      borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Status text
            Text(
              _status,
              style: TextStyle(fontSize: 16, color: _isWrongAnswerSelected ? Colors.red : Colors.green),
            ),

            const SizedBox(height: 30),

            // Next button
            ElevatedButton(
              onPressed: _isCorrectAnswerSelected ? _nextTask : null,
              child: const Text("Next"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}