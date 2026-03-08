import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordChainActivity extends StatefulWidget {
  const WordChainActivity({Key? key}) : super(key: key);

  @override
  _WordChainActivityState createState() => _WordChainActivityState();
}

class _WordChainActivityState extends State<WordChainActivity> {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  int _wordIndex = 0;
  List<String> sentenceParts = [];
  bool _isCorrectAnswerSelected = false;
  bool _isWrongAnswerSelected = false;

  final List<Map<String, dynamic>> _tasks = [
    {
      "startingWord": "අලියා", // Elephant
      "options": ["අරක්ක", "මිතුරා", "අයියා", "තාරකා"], // options (action, etc.)
      "correctAnswer": "අරක්ක", // Eats
      "exampleSentence": "අලියා අරක්ක",
    },
    {
      "startingWord": "නිවස", // House
      "options": ["ගෙදර", "පනස්", "අලුත්", "කවිය"],
      "correctAnswer": "ගෙදර", // House
      "exampleSentence": "නිවස ගෙදර",
    },
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future<void> _playWordSound(String word) async {
    await _flutterTts.speak(word);
  }

  void _checkAnswer(String selectedWord) {
    if (selectedWord == _tasks[_taskIndex]["correctAnswer"]) {
      setState(() {
        _isCorrectAnswerSelected = true;
        _isWrongAnswerSelected = false;
        sentenceParts.add(selectedWord);
      });
      if (_wordIndex < _tasks[_taskIndex]["options"].length - 1) {
        _wordIndex++;
      }
    } else {
      setState(() {
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = true;
      });
    }
  }

  void _nextSentence() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _wordIndex = 0;
        sentenceParts.clear();
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = false;
      }else{
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];
    final progress = (_taskIndex + 1) / _tasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Word Chain Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Word Chain - Build the Sentence",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                minHeight: 8,
              ),
              const SizedBox(height: 20),

              // Display current word to start the chain
              Row(
                children: [
                  Text(
                    "Start with: ${currentTask['startingWord']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Word Options
              Wrap(
                spacing: 10,
                children: List.generate(currentTask["options"].length, (index) {
                  final option = currentTask["options"][index];

                  return ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    child: Text(option),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        _isCorrectAnswerSelected && option == currentTask["correctAnswer"]
                            ? Colors.green
                            : _isWrongAnswerSelected && option != currentTask["correctAnswer"]
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Feedback
              if (_isCorrectAnswerSelected)
                Text(
                  "Correct! Sentence: ${sentenceParts.join(' ')}",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              if (_isWrongAnswerSelected)
                const Text(
                  "Incorrect! Try again.",
                  style: TextStyle(color: Colors.red),
                ),

              // Next Button
              if (_isCorrectAnswerSelected)
                ElevatedButton(
                  onPressed: _nextSentence,
                  child: const Text("Next Sentence"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}