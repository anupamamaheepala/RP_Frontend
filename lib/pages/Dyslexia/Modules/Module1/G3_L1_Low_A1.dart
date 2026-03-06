import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_Low_A1 extends StatefulWidget {
  final List<String> sentences;

  const G3_L1_Low_A1({super.key, required this.sentences});

  @override
  State<G3_L1_Low_A1> createState() => _Activity1State();
}

class _Activity1State extends State<G3_L1_Low_A1> {
  final FlutterTts _flutterTts = FlutterTts();

  int _currentRound = 0; // 0–4
  bool _roundCompleted = false;

  late List<String> _words;
  late List<bool> _highlightedWords;

  @override
  void initState() {
    super.initState();

    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);

    _loadSentence();
  }

  void _loadSentence() {
    String sentence = widget.sentences[_currentRound];
    _words = sentence.split(" ");
    _highlightedWords = List.generate(_words.length, (_) => false);
    _roundCompleted = false;
    setState(() {});
  }

  Future<void> _playSentence() async {
    await _flutterTts.speak(widget.sentences[_currentRound]);
  }

  Future<void> _highlightWords() async {
    for (int i = 0; i < _words.length; i++) {
      await _flutterTts.speak(_words[i]);

      setState(() {
        _highlightedWords[i] = true;
      });

      await Future.delayed(const Duration(milliseconds: 400));
    }

    setState(() {
      _roundCompleted = true;
    });
  }

  void _nextRound() {
    if (_currentRound < 4) {
      setState(() {
        _currentRound++;
      });
      _loadSentence();
    } else {
      // Finished all 5 rounds
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 1 - Highlight Practice"),
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
              alignment: WrapAlignment.center,
              children: List.generate(_words.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    _words[index],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _highlightedWords[index]
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _playSentence,
              child: const Text("Play Sentence"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _highlightWords,
              child: const Text("Start Highlighting"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _roundCompleted ? _nextRound : null,
              child: const Text("Next Round"),
            ),
          ],
        ),
      ),
    );
  }
}