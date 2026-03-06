import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_Low_A2 extends StatefulWidget {
  final List<String> sentences;

  const G3_L1_Low_A2({super.key, required this.sentences});

  @override
  State<G3_L1_Low_A2> createState() => _Activity2State();
}

class _Activity2State extends State<G3_L1_Low_A2> {
  final FlutterTts _flutterTts = FlutterTts();

  int _currentRound = 0;

  late List<String> _words;

  @override
  void initState() {
    super.initState();

    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.5);

    _loadSentence();
  }

  void _loadSentence() {
    String sentence = widget.sentences[_currentRound];
    _words = sentence.split(" ");
    setState(() {});
  }

  Future<void> _speakWord(String word) async {
    await _flutterTts.speak(word);
  }

  void _nextRound() {
    if (_currentRound < 4) {
      setState(() {
        _currentRound++;
      });
      _loadSentence();
    } else {
      // Finished 5 rounds
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 2 - Word Tap Practice"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Round ${_currentRound + 1} / 5",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Wrap(
              children: _words.map((word) {
                return GestureDetector(
                  onTap: () => _speakWord(word),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Chip(label: Text(word)),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _nextRound,
              child: const Text("Next Round"),
            ),
          ],
        ),
      ),
    );
  }
}