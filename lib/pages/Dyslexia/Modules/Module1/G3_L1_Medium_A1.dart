import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_Medium_A1 extends StatefulWidget {
  final List<String> sentences;

  const G3_L1_Medium_A1({super.key, required this.sentences});

  @override
  _G3_L1_Medium_A1State createState() => _G3_L1_Medium_A1State();
}

class _G3_L1_Medium_A1State extends State<G3_L1_Medium_A1> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isTtsPlaying = false;
  int _currentRound = 0; // Round index

  @override
  void initState() {
    super.initState();

    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.85); // Slow speech rate
    _flutterTts.setVolume(1.0);
  }

  Future<void> _playSentence() async {
    await _flutterTts.speak(widget.sentences[_currentRound]);
  }

  void _nextRound() {
    if (_currentRound < widget.sentences.length - 1) {
      setState(() {
        _currentRound++;
      });
    } else {
      Navigator.pop(context, true); // Finished the activity
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 1 - Listen First"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Round ${_currentRound + 1}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/word_image.png'),  // Display word image

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isTtsPlaying ? null : () async {
                setState(() {
                  _isTtsPlaying = true;
                });
                await _playSentence();
                setState(() {
                  _isTtsPlaying = false;
                });
              },
              child: Text(_isTtsPlaying ? "Playing..." : "Play Word"),
            ),

            const SizedBox(height: 20),

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