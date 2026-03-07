import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A5 extends StatefulWidget {
  const G3_L2_MEDIUM_A5({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A5> createState() => _G3_L2_MEDIUM_A5State();
}

class _G3_L2_MEDIUM_A5State extends State<G3_L2_MEDIUM_A5> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  bool _isCorrect = false;
  bool _isPhaseOneComplete = false;
  List<String> _currentWordLetters = [];
  List<String> _scrambledLetters = [];
  List<String> _selectedLetters = [];
  String _feedbackMessage = '';
  List<Map<String, dynamic>> _words = [
    {
      "word": "වතුර",
      "syllables": ["ව", "තු", "ර"],
      "usageSentence": "ඉස්සර වතුර බොනවා — I drink water every day.",
    },
    {
      "word": "අලමාරය",
      "syllables": ["අ", "ල", "මා", "ර", "ය"],
      "usageSentence": "මෙම අලමාරයේ — The book is in the cupboard.",
    },
    // Add more words here
  ];

  // Function to check if the selected category is correct
  void _checkAnswer() {
    setState(() {
      _isCorrect = _selectedLetters.join('') == _words[_taskIndex]["word"];
    });

    // Play the usage sentence after answering
    if (_isCorrect) {
      _flutterTts.speak(_words[_taskIndex]["usageSentence"]);
    } else {
      _flutterTts.speak("Wrong! Try again.");
    }
  }

  // Function to reset the activity state for each word
  void _resetGame() {
    setState(() {
      _isCorrect = false;
      _isPhaseOneComplete = false;
      _selectedLetters = [];
      _feedbackMessage = '';
    });
  }

  // Function to play the word when it's tapped in Phase 1
  Future<void> _playWord() async {
    await _flutterTts.speak(_words[_taskIndex]["word"]);
    setState(() {
      _isPhaseOneComplete = true;
      _currentWordLetters = List.from(_words[_taskIndex]["syllables"]);
      _scrambledLetters = List.from(_currentWordLetters);
      _scrambledLetters.shuffle();
    });
  }

  // Function to move to the next word after completion
  void _nextTask() {
    setState(() {
      if (_taskIndex < _words.length - 1) {
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

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
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
      appBar: AppBar(title: const Text('Syllable Smash Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Play word button to replay the word anytime
            ElevatedButton(
              onPressed: _playWord,
              child: Text('Play Word Again'),
            ),
            SizedBox(height: 20),

            // Phase 1 - SMASH (tap to segment the word into syllables)
            if (!_isPhaseOneComplete)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phase 1 - SMASH: Tap the word to segment into syllables", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  // Display the word with an option to tap to segment
                  GestureDetector(
                    onTap: _playWord,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text("Tap here to hear the word", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),

            // Phase 2 - BUILD (tap the syllables in the correct order)
            if (_isPhaseOneComplete)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phase 2 - BUILD: Tap the letters in the correct order", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),

                  // Display the empty spaces for the letters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(currentTask["syllables"].length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _selectedLetters.length > index
                            ? Center(child: Text(_selectedLetters[index], style: TextStyle(fontSize: 24)))
                            : null,
                      );
                    }),
                  ),
                  SizedBox(height: 20),

                  // Display the scrambled letters (tappable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _scrambledLetters.map<Widget>((letter) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // If the user selects the wrong letter, give feedback and do not add it to selectedLetters
                            if (_selectedLetters.length < currentTask["syllables"].length) {
                              if (letter == currentTask["syllables"][_selectedLetters.length]) {
                                _selectedLetters.add(letter);
                                _feedbackMessage = ''; // Clear feedback message
                              } else {
                               // _feedbackMessage = 'Wrong! Try again.'; // Show wrong message
                                _flutterTts.speak("Wrong! Try again.");
                              }
                            }
                          });

                          if (_selectedLetters.length == currentTask["syllables"].length) {
                            _checkAnswer();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(letter, style: TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

            // Show feedback message if the user clicked wrong letter
            if (_feedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _feedbackMessage,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),

            SizedBox(height: 20),

            // Feedback on the selection
            if (_isCorrect)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Correct!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _nextTask,
                    child: Text("Next Word"),
                  ),
                ],
              ),

            // Incorrect feedback will be displayed if necessary
            if (!_isCorrect)
              Row(
                children: [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Wrong! Try again.", style: TextStyle(fontSize: 18, color: Colors.red)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: G3_L2_MEDIUM_A5(),
  ));
}