import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'G3_L1_Low_A3.dart';  // For Text-to-Speech functionality

class Activity2 extends StatefulWidget {
  final String text;  // Text to be read out loud

  const Activity2({super.key, required this.text});

  @override
  _Activity2State createState() => _Activity2State();
}

class _Activity2State extends State<Activity2> {
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
  }

  // Function to start TTS on word tap
  Future<void> _startTts(String word) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.speak(word);  // Speak the tapped word
  }

  @override
  Widget build(BuildContext context) {
    // Split the text into words
    List<String> words = widget.text.split(" ");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 2 - TTS on Word Tap'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display each word as a tappable button
            Wrap(
              children: words.map((word) {
                return GestureDetector(
                  onTap: () => _startTts(word),  // Play TTS for tapped word
                  child: Chip(label: Text(word)),  // Display the word in a Chip widget
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Next button to go to the next activity
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Activity3(text: widget.text),  // Navigate to next activity
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