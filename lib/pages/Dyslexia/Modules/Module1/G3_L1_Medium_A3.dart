import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PictureSentenceMatchActivity extends StatefulWidget {
  const PictureSentenceMatchActivity({Key? key}) : super(key: key);

  @override
  _PictureSentenceMatchActivityState createState() =>
      _PictureSentenceMatchActivityState();
}

class _PictureSentenceMatchActivityState
    extends State<PictureSentenceMatchActivity> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  int _pageIndex = 0; // Track the page number
  bool _isSceneSelected = false;
  bool _isMatched = false;
  String _selectedScene = '';
  String _selectedSentence = '';

  // Each page contains 3 tasks
  List<List<Map<String, dynamic>>> _pages = [
    [ // Page 1
      {"emoji": "👦", "sentence": "ලමයා පාසලට ගියා", "matched": false},
      {"emoji": "🏠", "sentence": "නිවස අලංකාරයි", "matched": false},
      {"emoji": "🚗", "sentence": "ගමනේ යන වාහන", "matched": false},
    ],
    [ // Page 2
      {"emoji": "🌳", "sentence": "ගස් වනයේ ඇත", "matched": false},
      {"emoji": "🐶", "sentence": "අවයාගේ පැටවෙනවා", "matched": false},
      {"emoji": "🎒", "sentence": "මට පාසලේ බෑගය තියෙනවා", "matched": false},
    ],
    [ // Page 3
      {"emoji": "🍎", "sentence": "ආපල් පළතුරු එකතු කරන්න", "matched": false},
      {"emoji": "🍔", "sentence": "ඉස්සරක් හොඳම හම්බර්ගර්", "matched": false},
      {"emoji": "🍕", "sentence": "පිට්සා අලුත්ම රස", "matched": false},
    ]
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  // Function to play sentence sound
  Future<void> _playSentence(String sentence) async {
    await _flutterTts.speak(sentence);
  }

  // Function to handle scene selection
  void _selectScene(String sceneEmoji, String sceneSentence) {
    setState(() {
      _isSceneSelected = true;
      _selectedScene = sceneEmoji;
      _selectedSentence = sceneSentence;
    });
    _playSentence(sceneSentence); // Play the selected scene sentence
  }

  // Function to handle sentence chip matching
  void _matchSentence(String sentence) {
    setState(() {
      if (sentence == _selectedSentence) {
        _isMatched = true;
        _updateMatchedStatus(sentence);
      } else {
        _isMatched = false;
      }
    });
  }

  // Function to update matched status
  void _updateMatchedStatus(String sentence) {
    for (var scene in _pages[_pageIndex]) {
      if (scene["sentence"] == sentence) {
        scene["matched"] = true;
      }
    }
  }

  // Function to check if all pairs are matched on the current page
  bool _checkAllMatched() {
    return _pages[_pageIndex].every((scene) => scene["matched"]);
  }

  // Function to navigate to the next page or module_activity_page if third page is done
  void _nextPage() {
    setState(() {
      if (_pageIndex < _pages.length - 1) {
        _pageIndex++;
        _taskIndex = 0; // Reset task index for the new page
      } else {
        // All tasks completed, navigate to the module_activity_page
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _pages[_pageIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Picture-Sentence Match Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Activity 3: Picture–Sentence Match",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              // Instruction
              const Text(
                "Tap a scene emoji first, then tap the matching sentence below. Listen carefully to the sentence played!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Scene Emoji Cards (Left Side)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var scene in currentPage)
                    GestureDetector(
                      onTap: () {
                        if (!scene["matched"]) {
                          _selectScene(scene["emoji"], scene["sentence"]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: scene["matched"] ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          scene["emoji"],
                          style: const TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 30),

              // Guide Strip after selecting scene
              if (_isSceneSelected)
                Row(
                  children: [
                    const Text(
                      "You selected: ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _selectedScene,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.purple),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              // Sentence Chips (Right Side)
              Column(
                children: currentPage.map((scene) {
                  if (!scene["matched"]) {
                    return GestureDetector(
                      onTap: () => _matchSentence(scene["sentence"]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              scene["sentence"],
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                              onPressed: () => _playSentence(scene["sentence"]),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink(); // If the sentence is matched, skip it.
                  }
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Feedback
              if (_isMatched)
                const Text(
                  "Correct! Well done.",
                  style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                ),
              if (!_isMatched && _isSceneSelected)
                const Text(
                  "Incorrect. Try again.",
                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),
                ),

              const SizedBox(height: 20),

              // Next Page Button
              if (_checkAllMatched())
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text("Next Page"),
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