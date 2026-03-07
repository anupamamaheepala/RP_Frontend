import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordPickerActivity extends StatefulWidget {
  const WordPickerActivity({Key? key}) : super(key: key);

  @override
  State<WordPickerActivity> createState() => _WordPickerActivityState();
}

class _WordPickerActivityState extends State<WordPickerActivity> {
  final FlutterTts _flutterTts = FlutterTts();

  String _selectedAnswer = '';
  bool _isCorrectAnswerSelected = false;
  int _taskIndex = 0;

  final List<Map<String, dynamic>> _tasks = [
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

  // Function to check the answer
  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      _isCorrectAnswerSelected = selectedAnswer == _tasks[_taskIndex]["correctAnswer"];
    });
  }

  // Function to play the word
  Future<void> _playWord() async {
    await _flutterTts.speak(_tasks[_taskIndex]["correctAnswer"]);
  }

  // Function to move to the next task
  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _selectedAnswer = '';
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
    final currentTask = _tasks[_taskIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Word Picker Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select the correct word:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            // Displaying the options
            Row(
              children: currentTask["options"].map<Widget>((option) {
                return _buildOption(option);
              }).toList(),
            ),
            SizedBox(height: 20),
            // Display result
            if (_selectedAnswer.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      _isCorrectAnswerSelected
                          ? 'Correct! 🎉'
                          : 'Try again! ❌',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Syllable Breakdown: ${currentTask["syllableBreakdown"]}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Usage Sentence: ${currentTask["usageSentence"]}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            SizedBox(height: 20),
            // Play Word Button
            ElevatedButton(
              onPressed: _playWord,
              child: Text('Play Word'),
            ),
            SizedBox(height: 20),
            // Next button
            ElevatedButton(
              onPressed: _isCorrectAnswerSelected ? _nextTask : null,
              child: Text(_taskIndex < _tasks.length - 1 ? 'Next' : 'Finish'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each word option
  Widget _buildOption(String option) {
    bool isSelected = _selectedAnswer == option;
    return Expanded(
      child: GestureDetector(
        onTap: () => _checkAnswer(option),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? (_isCorrectAnswerSelected
                ? Colors.green.shade100
                : Colors.red.shade100)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? (_isCorrectAnswerSelected
                  ? Colors.green
                  : Colors.red)
                  : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(option, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WordPickerActivity(),
  ));
}