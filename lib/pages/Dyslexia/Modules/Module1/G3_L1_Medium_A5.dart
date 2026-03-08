import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MyTurnToReadActivity extends StatefulWidget {
  const MyTurnToReadActivity({Key? key}) : super(key: key);

  @override
  _MyTurnToReadActivityState createState() => _MyTurnToReadActivityState();
}

class _MyTurnToReadActivityState extends State<MyTurnToReadActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _storyIndex = 0;
  bool _isStoryPlaying = false;
  bool _isWordHighlighted = false;

  List<Map<String, String>> _stories = [
    {
      "story": "ඇයට පාසලට ගමනක් යාමයි.",
      "translation": "She is going to school."
    },
    {
      "story": "ඔහු ගෙදර ඉන්නෙයි.",
      "translation": "He is staying at home."
    },
    {
      "story": "ආදරණීය මල් තවත් මිතුරන්ට මිතුරියක් සේවය කරයි.",
      "translation": "The loving flower serves as a friend to others."
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

  // Function to play story with word-by-word highlight
  Future<void> _playStoryWithHighlight(String story) async {
    setState(() {
      _isStoryPlaying = true;
    });
    final words = story.split(" ");
    for (var word in words) {
      await _flutterTts.speak(word); // Plays each word one by one
      setState(() {
        _isWordHighlighted = true; // Highlight the word when it's being spoken
      });
      await Future.delayed(Duration(seconds: 1)); // Delay between words
      setState(() {
        _isWordHighlighted = false; // Remove highlight after word is spoken
      });
    }
    setState(() {
      _isStoryPlaying = false; // Story finished playing
    });
  }

  // Function to proceed to the next story
  void _nextStory() {
    setState(() {
      _storyIndex++;
      if (_storyIndex >= _stories.length) {
        Navigator.pop(context, true);// Reset to the first story if we reach the end
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = _stories[_storyIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Turn to Read'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Activity 5: My Turn to Read",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              // Instruction
              const Text(
                "Tap 'Play Story' to listen to the story with word-by-word highlight.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Story Display
              Text(
                currentStory["story"]!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _isWordHighlighted ? Colors.purple : Colors.black, // Highlight the word
                ),
              ),
              const SizedBox(height: 20),

              // Play Story Button
              ElevatedButton(
                onPressed: !_isStoryPlaying ? () => _playStoryWithHighlight(currentStory["story"]!) : null,
                child: const Text("Play Story"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Show Story Translation
              if (!_isStoryPlaying)
                Text(
                  "Translation: ${currentStory["translation"]}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

              const SizedBox(height: 20),

              // Next Story Button
              ElevatedButton(
                onPressed: _isStoryPlaying ? null : _nextStory,
                child: const Text("Next Story"),
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