import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A3 extends StatefulWidget {
  const G3_L2_MEDIUM_A3({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A3> createState() => _G3_L2_MEDIUM_A3State();
}

class _G3_L2_MEDIUM_A3State extends State<G3_L2_MEDIUM_A3> {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  bool _isCorrect = false;
  bool _isWrong = false;
  String _selectedCategory = '';

  // Each task has a word and a list of words to sort into categories
  // "set" = one round where the user sorts one word
  final List<Map<String, dynamic>> _tasks = [
    {
      "word": "පාසල",
      "meaning": "school",
      "emoji": "🏫",
      "correctCategory": "ස්ථාන",
    },
    {
      "word": "ගුරැවරිය",
      "meaning": "teacher",
      "emoji": "👩‍🏫",
      "correctCategory": "මිනිස්සු",
    },
    {
      "word": "පන්සල",
      "meaning": "book",
      "emoji": "🛕",
      "correctCategory": "ස්ථාන",
    },
    {
      "word": "අලියා",
      "meaning": "elephant",
      "emoji": "🐘",
      "correctCategory": "සතෙක්",
    },
    {
      "word": "ළමයා",
      "meaning": "child",
      "emoji": "👦",
      "correctCategory": "මිනිස්සු",
    },
    {
      "word": "මයිනා",
      "meaning": "tree",
      "emoji": "🌳",
      "correctCategory": "සතෙක්",
    },
  ];

  // Categories with their display info
  final List<Map<String, dynamic>> _categories = [
    {
      "key": "ස්ථාන",
      "label": "ස්ථාන",
      "emoji": "🏫",
      "color": const Color(0xFFEDE9FE),
      "borderColor": const Color(0xFF7C3AED),
      "labelColor": const Color(0xFF6D28D9),
    },
    {
      "key": "මිනිස්සු",
      "label": "මිනිස්සු",
      "emoji": "👥",
      "color": const Color(0xFFE0F2FE),
      "borderColor": const Color(0xFF0284C7),
      "labelColor": const Color(0xFF0369A1),
    },
    {
      "key": "සතෙක්",
      "label": "සතෙක්",
      "emoji": "🐾",
      "color": const Color(0xFFFEF3C7),
      "borderColor": const Color(0xFFD97706),
      "labelColor": const Color(0xFFB45309),
    },

  ];

  // Get the 2 categories relevant for the current task
  List<Map<String, dynamic>> get _currentCategories {
    final correct = _tasks[_taskIndex]["correctCategory"] as String;
    final all = List<Map<String, dynamic>>.from(_categories);
    final correctCat = all.firstWhere((c) => c["key"] == correct);
    all.remove(correctCat);
    all.shuffle();
    final distractor = all.first;
    final pair = [correctCat, distractor]..shuffle();
    return pair;
  }

  late List<Map<String, dynamic>> _shownCategories;

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _shownCategories = _currentCategories;
    _playWord();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playWord() async {
    await _flutterTts.speak(_tasks[_taskIndex]["word"]);
  }

  void _checkAnswer(String category) {
    if (_isCorrect) return;
    setState(() {
      _selectedCategory = category;
      _isCorrect = category == _tasks[_taskIndex]["correctCategory"];
      _isWrong = !_isCorrect;
    });
    if (_isCorrect) {
      _flutterTts.speak(_tasks[_taskIndex]["word"]);
    }
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrect = false;
        _isWrong = false;
        _selectedCategory = '';
        _shownCategories = _currentCategories;
      } else {
        Navigator.pop(context, true);
      }
    });
    _playWord();
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_taskIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _buildBadge("මධ්‍යම අවදානම", const Color(0xFFFBBF24), const Color(0xFF92400E)),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 2", const Color(0xFF0D9488), Colors.white),
                // const SizedBox(width: 6),
                // _buildOutlinedBadge("පැවරුම 3"),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "පැවරුම 3 — බහු-අක්ෂර වචන හඳුනාගැනීම",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),

              // Double-row segmented progress bar
              _buildSegmentedProgress(),
              const SizedBox(height: 14),

              // Set counter
              Text(
                "වචන ${_tasks.length} න් ${_taskIndex + 1} වන වචනය",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),

              // Instruction
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      "සෑම වචනයක්ම නිවැරදි කාණ්ඩයට වර්ග කරන්න!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("🗂️", style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),

              // Category bucket cards
              Row(
                children: _shownCategories.asMap().entries.map((entry) {
                  final i = entry.key;
                  final cat = entry.value;
                  final String catKey = cat["key"] as String;
                  final bool isSelected = _selectedCategory == catKey;
                  final bool isCorrectBucket =
                      catKey == task["correctCategory"];
                  final bool isWrongBucket = isSelected && _isWrong;
                  final bool isCorrectSelected = isSelected && _isCorrect;

                  Color bgColor = cat["color"] as Color;
                  Color borderColor = isSelected
                      ? (isCorrectSelected
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444))
                      : cat["borderColor"] as Color;

                  // After correct answer, highlight correct bucket
                  if (_isCorrect && isCorrectBucket) {
                    borderColor = const Color(0xFF22C55E);
                    bgColor = const Color(0xFFF0FDF4);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: _isCorrect ? null : () => _checkAnswer(catKey),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        margin: EdgeInsets.only(right: i == 0 ? 10 : 0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 12),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: (cat["borderColor"] as Color)
                                  .withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Icon + label row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cat["emoji"] as String,
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 6),
                                Text(
                                  cat["label"] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _isCorrect && isCorrectBucket
                                        ? const Color(0xFF16A34A)
                                        : cat["labelColor"] as Color,
                                  ),
                                ),
                                if (_isCorrect && isCorrectBucket) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF22C55E), size: 16),
                                ],
                                if (isWrongBucket) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.cancel_rounded,
                                      color: Color(0xFFEF4444), size: 16),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),

                            // "Tap to sort here" or word placed
                            if (_isCorrect && isCorrectBucket)
                              _buildPlacedWordMini(task)
                            else
                              Text(
                                "මෙහි වර්ග කිරීමට තට්ටු කරන්න",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (cat["labelColor"] as Color)
                                      .withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // "Where does this word belong?" label
              const Center(
                child: Text(
                  "මේ වචනය අයිති කොහෙද?",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Word card (teal gradient, centered)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _isCorrect ? 0.45 : 1.0,
                child: Center(
                  child: GestureDetector(
                    onTap: _playWord,
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB2F0E8), Color(0xFFE0FAF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF5EEAD4), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color:
                            const Color(0xFF0D9488).withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(task["emoji"] as String,
                              style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 10),
                          Text(
                            task["word"] as String,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF134E4A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            task["meaning"] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0F766E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.volume_up_rounded,
                                    size: 13, color: Color(0xFF0D9488)),
                                SizedBox(width: 4),
                                Text(
                                  "ඇසීමට තට්ටු කරන්න",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF0D9488),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Feedback banner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isCorrect
                    ? Container(
                  key: const ValueKey('correct'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text("🎉",
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "නිවැරදියි! \"${task['word']}\" අයත් වන්නේ ${task['correctCategory']}!",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : _isWrong
                    ? Container(
                  key: const ValueKey('wrong'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFFCA5A5),
                        width: 1.5),
                  ),
                  child: Row(
                    children: const [
                      Text("❌",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "වැරදියි — අනෙක් කාණ්ඩය උත්සාහ කරන්න!",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('none')),
              ),
              const SizedBox(height: 16),

              // Next Set button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCorrect ? _nextTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: _isCorrect ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _taskIndex < _tasks.length - 1
                            ? "ඊළඟ"
                            : "ඊළඟ පැවරුම",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Mini word chip shown inside the correct bucket after sorting
  Widget _buildPlacedWordMini(Map<String, dynamic> task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Column(
        children: [
          Text(task["emoji"] as String,
              style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            task["word"] as String,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedProgress() {
    final int total = _tasks.length;
    final int filled = _taskIndex + 1;
    return Column(
      children: [
        Row(
          children: List.generate(
            total,
                (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                height: 7,
                decoration: BoxDecoration(
                  color: i < filled
                      ? const Color(0xFF0D9488)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(
            total,
                (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                height: 5,
                decoration: BoxDecoration(
                  color: i < filled
                      ? const Color(0xFF5EEAD4)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildOutlinedBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6B7280), width: 1.5),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 11,
              fontWeight: FontWeight.w700)),
    );
  }
}