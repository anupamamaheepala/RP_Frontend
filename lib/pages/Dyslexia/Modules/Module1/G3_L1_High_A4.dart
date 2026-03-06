import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A4_RealOrNot extends StatefulWidget {
  const G3_L1_High_A4_RealOrNot({super.key});

  @override
  State<G3_L1_High_A4_RealOrNot> createState() => _G3_L1_High_A4_RealOrNotState();
}

class _G3_L1_High_A4_RealOrNotState extends State<G3_L1_High_A4_RealOrNot> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0; // Tracks current word
  final int _totalTasks = 10;

  // List of syllables and their validity (real or not)
  List<Map<String, dynamic>> _tasks = [
    {
      'syllable': 'කැ',
      'isReal': true,
      'explanation': "This is a valid syllable in Sinhala."
    },
    {
      'syllable': 'කියා',
      'isReal': true,
      'explanation': "This is a valid syllable in Sinhala."
    },
    {
      'syllable': 'කා',
      'isReal': true,
      'explanation': "This is a valid syllable in Sinhala."
    },
    {
      'syllable': 'කබ',
      'isReal': false,
      'explanation': "This is not a valid Sinhala syllable."
    },
    {
      'syllable': 'හෙ',
      'isReal': true,
      'explanation': "This is a valid syllable in Sinhala."
    },
    {
      'syllable': 'හො',
      'isReal': true,
      'explanation': "This is a valid syllable in Sinhala."
    },
    {
      'syllable': 'ඔ',
      'isReal': false,
      'explanation': "This is not a valid Sinhala syllable."
    },
    {
      'syllable': 'ඖ',
      'isReal': true,
      'explanation': "This is a valid syllable in Sinhala."
    },
  ];

  int _currentTaskIndex = 0; // Track the current task
  String _status = "Press 'Yes' or 'No' to identify the syllable"; // Status text

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playSyllableSound();
  }

  // Play syllable sound
  Future<void> _playSyllableSound() async {
    await _flutterTts.speak(_tasks[_currentTaskIndex]['syllable']);
  }

  // Handle answer tap (Yes or No)
  void _checkAnswer(bool answer) {
    if (answer == _tasks[_currentTaskIndex]['isReal']) {
      setState(() {
        _status = "Correct! '${_tasks[_currentTaskIndex]['syllable']}' is a valid Sinhala syllable.";
      });
    } else {
      setState(() {
        _status = "Incorrect! '${_tasks[_currentTaskIndex]['syllable']}' is not a valid syllable.";
      });
    }
  }

  // Move to the next task
  void _nextTask() {
    setState(() {
      if (_currentTaskIndex < _tasks.length - 1) {
        _currentTaskIndex++;
        _status = "Press 'Yes' or 'No' to identify the syllable";
        _playSyllableSound(); // Play sound for the next task
      } else {
        // Finished all tasks, go to the next activity
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_currentTaskIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 4: Real or Not?"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Is this a real Sinhala syllable?",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display syllable
            Text(
              currentTask['syllable'],
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Buttons for answer choices
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _checkAnswer(true); // Answer is real
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Yes, it's real"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _checkAnswer(false); // Answer is not real
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("No, it's not"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Display explanation
            Text(
              _status,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Button to move to next task
            ElevatedButton(
              onPressed: _nextTask,
              child: Text(_currentTaskIndex < _tasks.length - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම"),
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