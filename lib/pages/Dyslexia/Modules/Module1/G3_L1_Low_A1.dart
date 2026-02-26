import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'G3_L1_Low_A2.dart'; // For Text-to-Speech functionality

class Activity1 extends StatefulWidget {
  final String text; // Sinhala text to be read out loud

  const Activity1({super.key, required this.text});

  @override
  _Activity1State createState() => _Activity1State();
}

class _Activity1State extends State<Activity1> {
  late FlutterTts _flutterTts;
  bool _isTtsPlaying = false;
  int _round = 1; // Track the current round
  List<String> _words = [];
  List<bool> _highlightedWords = []; // Track highlighted words

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();

    // Split Sinhala text into words and initialize highlight tracking
    _words = widget.text.split(' ');
    _highlightedWords = List.generate(_words.length, (index) => false);

    // Setting up TTS for Sinhala
    _flutterTts.setLanguage("si-LK");  // Set language to Sinhala (Sri Lanka)
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
  }

  // Start TTS for the whole text
  Future<void> _startTts() async {
    if (!_isTtsPlaying) {
      await _flutterTts.speak(widget.text);  // Speak the Sinhala text
      setState(() {
        _isTtsPlaying = true;
      });
    } else {
      await _flutterTts.stop();
      setState(() {
        _isTtsPlaying = false;
      });
    }
  }

  // Function to reset highlighting when a new round starts
  void _resetHighlighting() {
    setState(() {
      _highlightedWords = List.generate(_words.length, (index) => false); // Reset all words
    });
  }

  // Build the UI for word-by-word highlighting
  Widget _buildTextWithHighlighting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _words.map((word) {
        int index = _words.indexOf(word);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            word,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _highlightedWords[index] ? Colors.blue : Colors.black, // Highlight color
            ),
          ),
        );
      }).toList(),
    );
  }

  // Handle TTS events to highlight words
  Future<void> _highlightWords() async {
    for (int i = 0; i < _words.length; i++) {
      await _flutterTts.speak(_words[i]);
      setState(() {
        _highlightedWords[i] = true; // Highlight this word
      });

      // Wait for the word to finish before highlighting the next one
      await Future.delayed(Duration(milliseconds: 500));  // Adjust this delay to match word length and speech speed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 1 - Full TTS'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display current round
            Text(
              'Round $_round',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display the text with highlighting
            _buildTextWithHighlighting(),

            const SizedBox(height: 20),

            // Button to play or stop TTS
            ElevatedButton(
              onPressed: _startTts,
              child: Text(_isTtsPlaying ? "Stop TTS" : "Play TTS"),
            ),
            const SizedBox(height: 20),

            // Button to start word highlighting
            ElevatedButton(
              onPressed: () {
                _highlightWords(); // Start highlighting words one by one
              },
              child: const Text("Start Highlighting"),
            ),
            const SizedBox(height: 20),

            // Next button to go to the next activity
            ElevatedButton(
              onPressed: () {
                _resetHighlighting(); // Reset highlighting before moving to next activity
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Activity2(text: widget.text), // Navigate to Activity2
                  ),
                );
              },
              child: const Text("Next Activity"),
            ),
          ],
        ),
      ),
    );
  }
}