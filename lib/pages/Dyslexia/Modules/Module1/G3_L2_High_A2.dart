import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SoundSwapActivity extends StatefulWidget {
  const SoundSwapActivity({super.key});

  @override
  _SoundSwapActivityState createState() => _SoundSwapActivityState();
}

class _SoundSwapActivityState extends State<SoundSwapActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  bool _isCorrectAnswerSelected = false;
  String _selectedAnswer = '';
  String _playedWord = ''; // To store the played word for confirmation

  final List<Map<String, dynamic>> _tasks = [
    {
      "originalWord": "ගෙදර", // Sinhala word meaning "house"
      "syllables": ["ගෙ", "ද", "ර"],
      "changedWord": "ගතර",
      "correctAnswer": "middle",
      "optionEmojis": ["🏠", "🏡", "🏡", "🍃"],
    },
    {
      "originalWord": "පොත", // Sinhala word meaning "book"
      "syllables": ["ප", "ො", "ත"],
      "changedWord": "පිත",
      "correctAnswer": "first",
      "optionEmojis": ["📚", "📖", "🖊️", "✏️"],
    },
    {
      "originalWord": "අලියා", // Sinhala word meaning "elephant"
      "syllables": ["අ", "ල", "ි", "ය", "ා"],
      "changedWord": "අලීයා",
      "correctAnswer": "last",
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
      _playedWord = word; // Store the played word for user confirmation
    });
  }

  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      if (selectedAnswer == _tasks[_taskIndex]["correctAnswer"]) {
        _isCorrectAnswerSelected = true;
      } else {
        _isCorrectAnswerSelected = false;
      }
    });
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _selectedAnswer = '';
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
          "Sound Swap Activity",
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
                "Activity 2: Sound Swap",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Round ${_taskIndex + 1} of $totalTasks",
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

              // Original word display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(syllables.length, (index) {
                  final syllable = syllables[index];
                  return GestureDetector(
                    onTap: () async {
                      await _playWordSound(syllable);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                      ),
                      child: Text(
                        syllable,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Play Changed Word Button (Visible at all times)
              ElevatedButton(
                onPressed: () async {
                  await _playWordSound(currentTask["changedWord"]);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Play Changed Word"),
              ),
              const SizedBox(height: 20),

              // Caption: What has changed
              const Text(
                "What part of the word changed in the audio? Select first, middle, or last syllable.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Identify changed syllable options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnswerOption("first"),
                  _buildAnswerOption("middle"),
                  _buildAnswerOption("last"),
                ],
              ),
              const SizedBox(height: 20),

              // Show the played word after selection
              if (_playedWord.isNotEmpty && _isCorrectAnswerSelected)
                Column(
                  children: [
                    Text(
                      "You selected: $_selectedAnswer",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Played word: $_playedWord",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

              // Correct or Wrong Feedback
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _isCorrectAnswerSelected
                    ? _buildCorrectBanner(currentTask)
                    : const SizedBox.shrink(),
              ),

              // Next button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isCorrectAnswerSelected ? 1.0 : 0.4,
                  child: ElevatedButton(
                    onPressed: _isCorrectAnswerSelected ? _nextTask : null,
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

  Widget _buildAnswerOption(String option) {
    return GestureDetector(
      onTap: () {
        _checkAnswer(option);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        ),
        child: Text(
          option,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCorrectBanner(Map<String, dynamic> currentTask) {
    return Container(
      key: const ValueKey('correct'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Row(
        children: [
          const Text("🎉", style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Correct! The syllable changed was: ${currentTask['correctAnswer']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF16A34A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}