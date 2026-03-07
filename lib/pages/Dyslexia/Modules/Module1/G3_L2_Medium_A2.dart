import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A2 extends StatefulWidget {
  const G3_L2_MEDIUM_A2({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A2> createState() => _G3_L2_MEDIUM_A2State();
}

class _G3_L2_MEDIUM_A2State extends State<G3_L2_MEDIUM_A2> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  int _syllableIndex = 0;
  double _progress = 0.0;
  bool _isCorrect = false;
  String _selectedSyllable = '';
  List<String> _syllables = [];
  List<String> _correctOrder = [];

  final List<Map<String, dynamic>> _tasks = [
    {
      "word": "පාසල",
      "syllables": ["පා", "ස", "ල"],
      "image": "assets/school_image.png",  // Image path for this word
    },
    {
      "word": "ගුරුවිය",
      "syllables": ["ගු", "රු", "ව", "ි", "ය"],
      "image": "assets/teacher_image.png",  // Image path for this word
    },
    // Add more words here
  ];

  // Function to reset the game state for each task
  void _resetGame() {
    setState(() {
      _syllableIndex = 0;
      _progress = 0.0;
      _selectedSyllable = '';
      _isCorrect = false;
      _syllables = List.from(_tasks[_taskIndex]["syllables"]);
      _correctOrder = List.from(_syllables);
    });
  }

  // Function to check if the tapped syllable is correct
  void _checkSyllable(String tappedSyllable) {
    setState(() {
      _selectedSyllable = tappedSyllable;

      // If the tapped syllable is correct
      if (tappedSyllable == _syllables[_syllableIndex]) {
        _syllableIndex++;
        _progress = _syllableIndex / _syllables.length;
        _isCorrect = true;

        // If all syllables are tapped correctly
        if (_syllableIndex == _syllables.length) {
          _flutterTts.speak(_tasks[_taskIndex]["word"]);  // Speak the full word
        }
      } else {
        _isCorrect = false;
        _flutterTts.speak(_syllables[_syllableIndex]); // Play the expected syllable as a hint
      }
    });
  }

  // Function to move to the next task
  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _resetGame();
      } else {
        // End of activity
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Well done! You completed all tasks!')),
        );
      }
    });
  }

  // Function to play the word again
  Future<void> _playWord() async {
    await _flutterTts.speak(_tasks[_taskIndex]["word"]);
  }

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _resetGame();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Syllable Tapping Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the word image
            Image.asset(currentTask["image"], height: 150, width: 150),
            SizedBox(height: 20),

            // Displaying the word and progress bar
            Text(currentTask["word"], style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(value: _progress),
            SizedBox(height: 20),

            // Displaying the syllable tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _syllables.map<Widget>((syllable) {
                return GestureDetector(
                  onTap: () => _checkSyllable(syllable),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: _selectedSyllable == syllable
                          ? (_isCorrect ? Colors.green : Colors.red)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedSyllable == syllable
                            ? (_isCorrect ? Colors.green : Colors.red)
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(syllable, style: TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Play word button to replay the word anytime
            ElevatedButton(
              onPressed: _playWord,
              child: Text('Play Word Again'),
            ),
            SizedBox(height: 20),

            // Feedback and "Next Word" button
            if (_isCorrect)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instead of saying "Well done! You got it!" we just speak the word
                  Text("You got it!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _nextTask,
                    child: Text(
                      _taskIndex < _tasks.length - 1
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
            SizedBox(height: 20),

            // Hint (incorrect syllable tapped)
            if (!_isCorrect && _selectedSyllable.isNotEmpty)
              Text("Try again! Expected syllable: ${_syllables[_syllableIndex]}", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: G3_L2_MEDIUM_A2(),
  ));
}