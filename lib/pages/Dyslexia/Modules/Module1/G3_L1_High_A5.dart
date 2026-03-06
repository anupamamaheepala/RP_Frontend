import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_SyllableBlending_A5 extends StatefulWidget {
  const G3_L1_SyllableBlending_A5({super.key});

  @override
  _G3_L1_SyllableBlending_A5State createState() =>
      _G3_L1_SyllableBlending_A5State();
}

class _G3_L1_SyllableBlending_A5State extends State<G3_L1_SyllableBlending_A5> {
  int _replayCount = 0;
  int _currentTaskIndex = 0;
  bool _isBaseLetterTapped = false;
  bool _isVowelTapped = false;
  bool _isBlendTapped = false;
  bool _isAudioPlayed = false;

  // List of tasks with base letter, vowel sign, and combined syllable
  final List<Map<String, String>> _tasks = [
    {'baseLetter': 'ක', 'vowelSign': 'ා', 'combinedSyllable': 'කා'},
    {'baseLetter': 'ග', 'vowelSign': 'ී', 'combinedSyllable': 'ගී'},
    {'baseLetter': 'ච', 'vowelSign': 'ු', 'combinedSyllable': 'චු'},
    {'baseLetter': 'ට', 'vowelSign': 'ෙ', 'combinedSyllable': 'ටෙ'},
    {'baseLetter': 'ත', 'vowelSign': 'ේ', 'combinedSyllable': 'තේ'},
    {'baseLetter': 'ධ', 'vowelSign': 'ි', 'combinedSyllable': 'ධි'},
    {'baseLetter': 'න', 'vowelSign': 'ෝ', 'combinedSyllable': 'නෝ'},
    {'baseLetter': 'ම', 'vowelSign': 'ෞ', 'combinedSyllable': 'මෞ'}
  ];

  final FlutterTts _flutterTts = FlutterTts();

  // Function to handle playing sound for each step
  void _playSound(String sound) {
    print("Playing sound: $sound");
    setState(() {
      _replayCount++;
    });
    _flutterTts.speak(sound);
  }

  // Function to handle the three steps
  void _handleBaseLetterTap() {
    setState(() {
      _isBaseLetterTapped = true;
    });
    _playSound(_tasks[_currentTaskIndex]['baseLetter']!);
  }

  void _handleVowelTap() {
    setState(() {
      _isVowelTapped = true;
    });
    _playSound(_tasks[_currentTaskIndex]['vowelSign']!);
  }

  void _handleBlendTap() {
    setState(() {
      _isBlendTapped = true;
    });
    _playSound(_tasks[_currentTaskIndex]['combinedSyllable']!);
  }

  void _handlePlayAudio() {
    setState(() {
      _isAudioPlayed = true;
    });
    _playSound(_tasks[_currentTaskIndex]['combinedSyllable']!);
  }

  // Move to the next task
  void _nextTask() {
    setState(() {
      if (_currentTaskIndex < _tasks.length - 1) {
        _currentTaskIndex++;
        _isBaseLetterTapped = false;
        _isVowelTapped = false;
        _isBlendTapped = false;
        _isAudioPlayed = false;
      } else {
        // After completing all tasks, show a completion message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("All Tasks Completed"),
              content: const Text("You have completed all tasks for this activity!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); // Navigate back after completion
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
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
  Widget build(BuildContext context) {
    final currentTask = _tasks[_currentTaskIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 5: Tap to Blend"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Tap to Blend",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Step 1: Tap the base letter
            GestureDetector(
              onTap: _isBaseLetterTapped ? null : _handleBaseLetterTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isBaseLetterTapped ? Colors.green : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentTask['baseLetter']!,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Step 2: Tap the vowel sign
            GestureDetector(
              onTap: _isVowelTapped ? null : _handleVowelTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isVowelTapped ? Colors.green : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentTask['vowelSign']!,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Step 3: Tap BLEND
            GestureDetector(
              onTap: (_isBaseLetterTapped && _isVowelTapped) && !_isBlendTapped
                  ? _handleBlendTap
                  : null,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isBlendTapped ? Colors.green : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "BLEND",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Show the combined syllable after BLEND
            if (_isBlendTapped) ...[
              const SizedBox(height: 20),
              Text(
                "Combined Syllable: ${currentTask['combinedSyllable']}",
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ],

            // Show the replay counter
            const SizedBox(height: 20),
            Text(
              "Replays: $_replayCount",
              style: const TextStyle(fontSize: 18),
            ),

            // Play Audio button (enabled after blend)
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isBlendTapped ? _handlePlayAudio : null, // Only enable when blend is tapped
              child: const Text("Play Audio"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            // Show Next button (only enabled after completing all steps)
            const SizedBox(height: 20),
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