import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A4 extends StatefulWidget {
  const G3_L2_MEDIUM_A4({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A4> createState() => _G3_L2_MEDIUM_A4State();
}

class _G3_L2_MEDIUM_A4State extends State<G3_L2_MEDIUM_A4> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  bool _isCorrect = false;
  String _selectedWord = '';
  String _usageSentence = '';
  List<Map<String, dynamic>> _words = [
    {
      "word": "අලමාරය",
      "correctAnswer": "අලමාරය",
      "options": ["අලමාරය", "අල්මාරය", "අලමාරය"],
      "syllableBreakdown": "අ | ල | මා | ර | ය",
      "usageSentence": "මෙම අලමාරයේ — The book is in the cupboard."
    },
    {
      "word": "යතුර",
      "correctAnswer": "යතුර",
      "options": ["යතුර", "සාලය", "මිතුරා"],
      "syllableBreakdown": "ය | තු | ර",
      "usageSentence": "මෙය මගේ යතුරයි — This is my key."
    },
    {
      "word": "වතුර",
      "correctAnswer": "වතුර",
      "options": ["වතුර", "ජලය", "අල්මාරය"],
      "syllableBreakdown": "ව | තු | ර",
      "usageSentence": "ඉස්සර වතුර බොනවා — I drink water every day."
    },
    {
      "word": "මල්",
      "correctAnswer": "මල්",
      "options": ["මල්", "අල්මාරය", "මල්ලි"],
      "syllableBreakdown": "ම |ල්",
      "usageSentence": "මල් වාසනාවට කැපීමට පටන් ගෙන ඇත — The flowers have started to bloom."
    },
    {
      "word": "අලියා",
      "correctAnswer": "අලියා",
      "options": ["අලියා", "ගරියා", "අළමාරය"],
      "syllableBreakdown": "අ | ලි | යා",
      "usageSentence": "අලියා විශාල සතුන් වෙයි — Elephants are large animals."
    }
  ];

  // Function to check if the selected category is correct
  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _selectedWord = selectedAnswer;
      _isCorrect = selectedAnswer == _words[_taskIndex]["correctAnswer"];
      _usageSentence = _words[_taskIndex]["usageSentence"];
    });

    // Play the usage sentence after answering
    if (_isCorrect) {
      _flutterTts.speak(_usageSentence);
    }
  }

  // Function to move to the next word
  void _nextTask() {
    setState(() {
      if (_taskIndex < _words.length - 1) {
        _taskIndex++;
        _isCorrect = false;
        _selectedWord = '';
        _usageSentence = ''; // Clear the usage sentence for next task
      } else {
        // End of activity
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Well done! You completed all tasks!')),
        );
      }
    });
  }

  // Function to play the word when it's tapped
  Future<void> _playWord() async {
    await _flutterTts.speak(_words[_taskIndex]["word"]);
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
      appBar: AppBar(title: const Text('Distractors Activity')),
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

            // Displaying the word and instructions
            Text("What word do you hear?", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),

            // Displaying the word options
            Column(
              children: [
                _buildOption(currentTask["correctAnswer"]!, true),
                _buildOption(currentTask["options"][1]!, false),
                _buildOption(currentTask["options"][2]!, false),
              ],
            ),
            SizedBox(height: 20),

            // Feedback on the selection
            if (_selectedWord.isNotEmpty)
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

            // Display the usage sentence after correct selection
            if (_isCorrect && _usageSentence.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Usage Sentence:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(_usageSentence, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                ],
              ),

            // "Next Word" button to proceed to the next word
            ElevatedButton(
              onPressed: _isCorrect ? _nextTask : null,
              child: Text("Next Word"),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each word option
  Widget _buildOption(String option, bool isCorrect) {
    return GestureDetector(
      onTap: () => _checkAnswer(option),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          color: _selectedWord == option
              ? (isCorrect ? Colors.green.shade100 : Colors.red.shade100)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _selectedWord == option ? (isCorrect ? Colors.green : Colors.red) : Colors.grey, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(option, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: G3_L2_MEDIUM_A4(),
  ));
}