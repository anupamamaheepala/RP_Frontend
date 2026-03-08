import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SentenceRepairActivity extends StatefulWidget {
  const SentenceRepairActivity({Key? key}) : super(key: key);

  @override
  _SentenceRepairActivityState createState() => _SentenceRepairActivityState();
}

class _SentenceRepairActivityState extends State<SentenceRepairActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  bool _isBlankFilled = false;
  bool _isCorrectAnswer = false;
  String _selectedAnswer = '';
  String _blankAnswer = '';
  String _translatedSentence = '';
  List<Map<String, dynamic>> _tasks = [
    {
      "sentence": "අයියා _____ පාසලට ගියා.",
      "blankPosition": "middle",
      "options": ["ඔහු", "ඇය", "ඔබ"],
      "correctAnswer": "ඔහු",
      "semanticClue": "He went to school",
      "fullSentence": "අයියා ඔහු පාසලට ගියා.",
      "translation": "Brother went to school."
    },
    {
      "sentence": "_____ අයියා කුඩා දරුවෙක්.",
      "blankPosition": "start",
      "options": ["ඇය", "ඔහු", "ඔබ"],
      "correctAnswer": "ඔහු",
      "semanticClue": "He is a small child",
      "fullSentence": "ඔහු අයියා කුඩා දරුවෙක්.",
      "translation": "He is a little child."
    },
    {
      "sentence": "ඔහු පාසලට _____ ගියා.",
      "blankPosition": "end",
      "options": ["ගියා", "යන්න", "ගෙවී"],
      "correctAnswer": "ගියා",
      "semanticClue": "He went",
      "fullSentence": "ඔහු පාසලට ගියා.",
      "translation": "He went to school."
    },
    {
      "sentence": "_____ කුඩා ගෙදරක්.",
      "blankPosition": "middle",
      "options": ["නිවස", "මානවය", "ඉඩම්"],
      "correctAnswer": "නිවස",
      "semanticClue": "It is a house",
      "fullSentence": "නිවස කුඩා ගෙදරක්.",
      "translation": "It is a small house."
    },
    {
      "sentence": "මෙම _____ පෝෂණය.",
      "blankPosition": "middle",
      "options": ["කඳ", "උස", "මල්"],
      "correctAnswer": "මල්",
      "semanticClue": "This is a flower",
      "fullSentence": "මෙම මල් පෝෂණය.",
      "translation": "This is a flower."
    },
    {
      "sentence": "ඔහු _____ අලුත් පාට.",
      "blankPosition": "end",
      "options": ["පැළඳූ", "පැළඳෙන්න", "ගන්න"],
      "correctAnswer": "පැළඳූ",
      "semanticClue": "He wore new clothes",
      "fullSentence": "ඔහු පැළඳූ අලුත් පාට.",
      "translation": "He wore new clothes."
    }
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playSentence();
  }

  // Function to play sentence sound
  Future<void> _playSentence() async {
    await _flutterTts.speak(_tasks[_taskIndex]["sentence"]);
  }

  // Function to handle filling the blank
  void _fillBlank(String selectedAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      _isBlankFilled = true;
      if (_selectedAnswer == _tasks[_taskIndex]["correctAnswer"]) {
        _isCorrectAnswer = true;
      } else {
        _isCorrectAnswer = false;
      }
    });
  }

  // Function to show full sentence
  void _showFullSentence() {
    setState(() {
      _blankAnswer = _tasks[_taskIndex]["fullSentence"];
      _translatedSentence = _tasks[_taskIndex]["translation"];
    });
    _flutterTts.speak(_blankAnswer); // Play the full sentence with the correct answer
  }

  // Function to proceed to the next task
  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isBlankFilled = false;
        _isCorrectAnswer = false;
        _selectedAnswer = '';
        _blankAnswer = '';
        _translatedSentence = '';
        _playSentence();
      } else {
        // End of activity or reset to start
        _taskIndex = 0;
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sentence Repair Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Activity 4: Sentence Repair",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              // Sentence with blank
              Text(
                currentTask["sentence"],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Sentence options
              Column(
                children: List.generate(currentTask["options"].length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _fillBlank(currentTask["options"][index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: _isBlankFilled && currentTask["options"][index] == _selectedAnswer
                            ? (_isCorrectAnswer ? Colors.green : Colors.red)
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            currentTask["options"][index],
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                            onPressed: () => _flutterTts.speak(currentTask["options"][index]),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Feedback
              if (_isBlankFilled)
                Text(
                  _isCorrectAnswer ? "Correct! Well done." : "Incorrect, try again.",
                  style: TextStyle(
                    fontSize: 16,
                    color: _isCorrectAnswer ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 16),

              // Show full sentence with translation
              if (_isCorrectAnswer)
                Column(
                  children: [
                    Text(
                      _blankAnswer,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _translatedSentence,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // Next Task Button
              ElevatedButton(
                onPressed: _isCorrectAnswer ? _nextTask : null,
                child: const Text("Next Task"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}