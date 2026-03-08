import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SyllableTapActivity extends StatefulWidget {
  const SyllableTapActivity({Key? key}) : super(key: key);

  @override
  _SyllableTapActivityState createState() => _SyllableTapActivityState();
}

class _SyllableTapActivityState extends State<SyllableTapActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  String _consonant = "ක"; // Example consonant
  String _vowel = "ා"; // Example vowel
  bool _isConsonantTapped = false;
  bool _isVowelTapped = false;
  bool _isJoinVisible = false;
  bool _isWordPlayed = false;
  String _combinedSyllable = '';

  final List<Map<String, dynamic>> _tasks = [
    {
      "consonant": "ක",
      "vowel": "ා",
      "correctSyllable": "කා",
    },
    {
      "consonant": "ග",
      "vowel": "ි",
      "correctSyllable": "ගි",
    },
    {
      "consonant": "බ",
      "vowel": "ු",
      "correctSyllable": "බු",
    },
    {
      "consonant": "ම",
      "vowel": "ෙ",
      "correctSyllable": "මෙ",
    },
    {
      "consonant": "ධ",
      "vowel": "ි",
      "correctSyllable": "ධි",
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

  // Function to play consonant or vowel sound
  Future<void> _playSound(String sound) async {
    await _flutterTts.speak(sound);
  }

  // Function to handle Join action
  void _joinSyllable() async {
    setState(() {
      _isJoinVisible = false;
      _combinedSyllable = _consonant + _vowel;
    });
    await _flutterTts.speak(_combinedSyllable); // Play the combined syllable sound
  }

  // Function to move to the next task
  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isConsonantTapped = false;
        _isVowelTapped = false;
        _isJoinVisible = false;
        _isWordPlayed = false;
        _combinedSyllable = '';
      }else{
        Navigator.pop(context, true);
      }
    });
  }

  // Function to allow the user to replay the combined syllable
  void _playWordAgain() {
    if (_combinedSyllable.isNotEmpty) {
      _flutterTts.speak(_combinedSyllable); // Replay the syllable sound
    }
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
        title: const Text('Syllable Tap Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Activity 2: Syllable Tap",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              // Instruction
              const Text(
                "Tap each tile to hear the sound. After tapping both, press JOIN to form the syllable!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Consonant and Vowel Tiles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!_isConsonantTapped) {
                        _playSound(currentTask["consonant"]);
                        setState(() {
                          _isConsonantTapped = true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                      decoration: BoxDecoration(
                        color: _isConsonantTapped ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentTask["consonant"],
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      if (!_isVowelTapped) {
                        _playSound(currentTask["vowel"]);
                        setState(() {
                          _isVowelTapped = true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                      decoration: BoxDecoration(
                        color: _isVowelTapped ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentTask["vowel"],
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Combined Syllable Display
              if (_isConsonantTapped && _isVowelTapped)
                Text(
                  "Combined Syllable: $_combinedSyllable",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.purple),
                ),

              const SizedBox(height: 30),

              // Join Button
              if (_isConsonantTapped && _isVowelTapped)
                AnimatedOpacity(
                  opacity: _isJoinVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _joinSyllable,
                    child: const Text("JOIN"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Play Word Button
              if (_combinedSyllable.isNotEmpty)
                ElevatedButton(
                  onPressed: _playWordAgain,
                  child: const Text("Play Word Again"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Next Button
              ElevatedButton(
                onPressed: (_isConsonantTapped && _isVowelTapped)
                    ? _nextTask
                    : null, // Disable the button until both tiles are tapped
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