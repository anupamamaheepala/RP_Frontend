import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A3 extends StatefulWidget {
  const G3_L2_MEDIUM_A3({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A3> createState() => _G3_L2_MEDIUM_A3State();
}

class _G3_L2_MEDIUM_A3State extends State<G3_L2_MEDIUM_A3> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  bool _isCorrect = false;
  String _selectedWord = '';
  String _selectedCategory = '';
  List<Map<String, String>> _words = [
    {"word": "පාසල", "category": "school"},
    {"word": "ගුරුවිය", "category": "people"},
    // Add more words here
  ];

  // Function to check if the selected category is correct
  void _checkAnswer(String category) {
    setState(() {
      _selectedCategory = category;
      _isCorrect = category == _words[_taskIndex]["category"];
    });
  }

  // Function to play the word when it's tapped
  Future<void> _playWord() async {
    await _flutterTts.speak(_words[_taskIndex]["word"]!);
  }

  // Function to move to the next word
  void _nextTask() {
    setState(() {
      if (_taskIndex < _words.length - 1) {
        _taskIndex++;
        _isCorrect = false;
        _selectedCategory = '';
      } else {
        // End of activity
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Well done! You completed all tasks!')),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playWord();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _words[_taskIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Word Family Sort')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the word chip
            Center(
              child: Chip(
                label: Text(currentTask["word"]!),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: Colors.blueAccent,
                labelStyle: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Instructions to sort the word
            Text("Sort the word into the correct category:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            // Displaying the two category buckets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    _checkAnswer("school");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.purple[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.school, size: 40, color: Colors.white),
                        SizedBox(height: 10),
                        Text("🏫 School", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _checkAnswer("people");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.people, size: 40, color: Colors.white),
                        SizedBox(height: 10),
                        Text("👨‍👩‍👧 People", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Feedback on selection
            if (_selectedCategory.isNotEmpty)
              _isCorrect
                  ? Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Correct!", style: TextStyle(fontSize: 18, color: Colors.green)),
                ],
              )
                  : Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Wrong! Try again.", style: TextStyle(fontSize: 18, color: Colors.red)),
                ],
              ),
            SizedBox(height: 20),

            // Play word button to replay the word anytime
            ElevatedButton(
              onPressed: _playWord,
              child: Text('Play Word Again'),
            ),
            SizedBox(height: 20),

            // "Next Set" button to proceed to the next word
            ElevatedButton(
              onPressed: _isCorrect ? _nextTask : null,
              child: Text(
                _taskIndex < _words.length - 1
                    ? "ඊළඟ"
                    : "ඊළඟ පැවරුම",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: G3_L2_MEDIUM_A3(),
  ));
}