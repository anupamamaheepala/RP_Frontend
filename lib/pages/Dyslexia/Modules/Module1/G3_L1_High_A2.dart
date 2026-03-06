import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A2_Repeat extends StatefulWidget {
  const G3_L1_High_A2_Repeat({super.key});

  @override
  State<G3_L1_High_A2_Repeat> createState() => _G3_L1_High_A2_RepeatState();
}

class _G3_L1_High_A2_RepeatState extends State<G3_L1_High_A2_Repeat> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0; // Tracks current word
  final int _totalTasks = 10; // Total number of tasks (words)
  String _status = "Press 'Play Sound' to hear the word"; // Feedback text
  String _currentWord = "අලියා"; // Sample word
  //String _exampleWord = "කපටය"; // Example word for the letter
  //String _letterName = "ක (ka)";
  //String _emoji = "🐦"; // Emoji representing the letter

  // Manually added 10 Sinhala words
  final List<Map<String, String>> _tasks = [
    {
      'word': 'අලියා',
      'example': 'අලියා is an elephant.',
    },
    {
      'word': 'ඇතා',
      'example': 'ඇතා is a horse.',
    },
    {
      'word': 'ඉර',
      'example': 'ඉර is the sun.',
    },
    {
      'word': 'එරබදු',
      'example': 'එරබදු is a rabbit.',
    },
    {
      'word': 'කපටය',
      'example': 'කපටය is a bird.',
    },
    {
      'word': 'මකර',
      'example': 'මකර is a crocodile.',
    },
    {
      'word': 'නේචු',
      'example': 'නේචු is a bear.',
    },
    {
      'word': 'තතු',
      'example': 'තතු is a fish.',
    },
    {
      'word': 'සංචාරකයා',
      'example': 'සංචාරකයා is a tourist.',
    },
    {
      'word': 'ඇල්පි',
      'example': 'ඇල්පි is a mountain.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playWordSound();
  }

  // Function to play the sound of the word
  Future<void> _playWordSound() async {
    await _flutterTts.speak(_tasks[_taskIndex]['word']!); // Use word from the task
    setState(() {
      _status = "වචනයට සවන් දී, සූදානම් වූ විට 'ඊළඟ පැවරුම' ඔබන්න.";
    });
  }

  // Function to proceed to the next word/task
  void _nextTask() {
    if (_taskIndex < _totalTasks - 1) {
      setState(() {
        _taskIndex++;
        _status = "වචනය ඇසීමට 'ශබ්දය වාදනය කරන්න' ඔබන්න.";
        _playWordSound();
      });
    } else {
      // Finished all tasks, go to the next activity
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ශ්‍රේණිය 3 මට්ටම 1 ඉහළ අවදානම - පැවරුම 2"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Letter and Example Word Display

            const SizedBox(height: 20),

            // Letter and Example Word
            Column(
              children: [
                Text(
                  currentTask['word']!,
                  style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
               // Text(_letterName, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 10),
               // Text(_exampleWord, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                //Text(_emoji, style: const TextStyle(fontSize: 40)),
              ],
            ),

            const SizedBox(height: 30),

            // Play Sound button
            ElevatedButton.icon(
              onPressed: _playWordSound,
              icon: const Icon(Icons.volume_up),
              label: const Text("ශබ්දය වාදනය කරන්න"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Status message
            Text(
              _status,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),

            const SizedBox(height: 20),

            // Next Activity button after listening to the word
            ElevatedButton(
              onPressed: _nextTask,
              child: Text(_taskIndex < _totalTasks - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම"),
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