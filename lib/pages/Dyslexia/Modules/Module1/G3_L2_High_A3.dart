import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:collection/collection.dart';

class WordPuzzleBuilderActivity extends StatefulWidget {
  const WordPuzzleBuilderActivity({super.key});

  @override
  _WordPuzzleBuilderActivityState createState() => _WordPuzzleBuilderActivityState();
}

class _WordPuzzleBuilderActivityState extends State<WordPuzzleBuilderActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  List<String> _slots = ['', '', '']; // To track what syllables are placed in each slot
  bool _isPuzzleCompleted = false;
  String _playedWord = '';

  final List<Map<String, dynamic>> _tasks = [
    {
      "originalWord": "ගෙදර", // Sinhala word meaning "house"
      "syllables": ["ගෙ", "ද", "ර"],
      "correctOrder": [0, 1, 2],
      "optionEmojis": ["🏠", "🏡", "🍃"],
    },
    {
      "originalWord": "පොත", // Sinhala word meaning "book"
      "syllables": ["ප", "ො", "ත"],
      "correctOrder": [0, 1, 2],
      "optionEmojis": ["📚", "📖", "🖊️"],
    },
    {
      "originalWord": "අලියා", // Sinhala word meaning "elephant"
      "syllables": ["අ", "ල", "ි", "ය", "ා"],
      "correctOrder": [0, 1, 2, 3, 4],
      "optionEmojis": ["🐘", "🦁", "🐅", "🦓"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future<void> _playWordSound(String word) async {
    await _flutterTts.speak(word);
    setState(() {
      _playedWord = word;
    });
  }

  void _checkPuzzle() {
    // Check if the user has placed syllables in the correct order
    List<int> selectedOrder = [];
    for (var i = 0; i < 3; i++) {
      selectedOrder.add(_getSyllableIndex(_slots[i]));
    }

    setState(() {
      _isPuzzleCompleted = ListEquality().equals(selectedOrder, _tasks[_taskIndex]["correctOrder"]);
    });
  }

  int _getSyllableIndex(String syllable) {
    // Get the index of the syllable in the original syllable list
    return _tasks[_taskIndex]["syllables"].indexOf(syllable);
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isPuzzleCompleted = false;
        _slots = ['', '', '']; // Reset the slots for the next word
        _playedWord = ''; // Reset the played word for the next task
      }else{
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];
    final syllables = currentTask["syllables"] as List<String>;
    final totalTasks = _tasks.length;
    final progress = (_taskIndex + 1) / totalTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Word Puzzle Builder Activity",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task title
              const Text(
                "Activity 3: Word Puzzle Builder",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Word ${_taskIndex + 1} of $totalTasks",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                  Text(
                    "${(progress * 100).round()}%",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF7B61FF)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                minHeight: 8,
              ),
              const SizedBox(height: 30),

              // "Hear the word" button
              ElevatedButton(
                onPressed: () async {
                  await _playWordSound(currentTask["originalWord"]);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Hear the word"),
              ),
              const SizedBox(height: 20),

              // Word puzzle slots (3 slots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                    ),
                    child: Text(
                      _slots[index].isEmpty ? 'Slot ${index + 1}' : _slots[index],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Syllables to be assembled
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(syllables.length, (index) {
                  final syllable = syllables[index];
                  double width = 100 + (index * 40).toDouble(); // Making wider syllables bigger
                  return GestureDetector(
                    onTap: () {
                      // Place the tapped syllable into the first empty slot
                      setState(() {
                        if (_slots.contains('')) {
                          _slots[_slots.indexOf('')] = syllable;
                        }
                      });
                    },
                    child: Container(
                      width: width,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          syllable,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Check if the puzzle is completed
              if (_slots.every((slot) => slot.isNotEmpty))
                ElevatedButton(
                  onPressed: _checkPuzzle,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Check Puzzle"),
                ),

              // Show feedback and the changed word
              if (_isPuzzleCompleted)
                Column(
                  children: [
                    Text(
                      "Puzzle Completed!",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Correct Word: ${currentTask["originalWord"]}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

              // Next word button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isPuzzleCompleted ? 1.0 : 0.4,
                  child: ElevatedButton(
                    onPressed: _isPuzzleCompleted ? _nextTask : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF4A90D9),
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Next Word",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
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