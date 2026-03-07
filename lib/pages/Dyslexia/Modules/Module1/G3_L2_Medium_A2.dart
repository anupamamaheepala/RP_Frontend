import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A2 extends StatefulWidget {
  const G3_L2_MEDIUM_A2({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A2> createState() => _G3_L2_MEDIUM_A2State();
}

class _G3_L2_MEDIUM_A2State extends State<G3_L2_MEDIUM_A2> {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  int _syllableIndex = 0; // how many tapped correctly so far
  String _lastTapped = '';
  bool _lastWasCorrect = false;
  bool _wordComplete = false;

  final List<Map<String, dynamic>> _tasks = [
    {
      "word": "පාසල",
      "meaning": "school",
      "emoji": "🏫",
      "syllables": ["පා", "ස", "ල"],
    },
    {
      "word": "ගුරුවිය",
      "meaning": "teacher",
      "emoji": "👩‍🏫",
      "syllables": ["ගු", "රු", "වි", "ය"],
    },
    {
      "word": "අලියා",
      "meaning": "elephant",
      "emoji": "🐘",
      "syllables": ["අ", "ලි", "යා"],
    },
    {
      "word": "වතුර",
      "meaning": "water",
      "emoji": "💧",
      "syllables": ["ව", "තු", "ර"],
    },
  ];

  List<String> get _currentSyllables =>
      List<String>.from(_tasks[_taskIndex]["syllables"]);

  void _resetGame() {
    setState(() {
      _syllableIndex = 0;
      _lastTapped = '';
      _lastWasCorrect = false;
      _wordComplete = false;
    });
  }

  void _checkSyllable(String tapped, int tileIndex) {
    final syllables = _currentSyllables;
    setState(() {
      _lastTapped = tapped;
      if (tileIndex == _syllableIndex) {
        // Correct next syllable
        _lastWasCorrect = true;
        _syllableIndex++;
        _flutterTts.speak(tapped);
        if (_syllableIndex == syllables.length) {
          _wordComplete = true;
          Future.delayed(const Duration(milliseconds: 400), () {
            _flutterTts.speak(_tasks[_taskIndex]["word"]);
          });
        }
      } else {
        _lastWasCorrect = false;
        _flutterTts.speak(syllables[_syllableIndex]); // hint: play expected
      }
    });
  }

  void _nextTask() {
    if (_taskIndex < _tasks.length - 1) {
      setState(() => _taskIndex++);
      _resetGame();
    } else {
      Navigator.pop(context, true);
    }
  }

  Future<void> _playWord() async {
    await _flutterTts.speak(_tasks[_taskIndex]["word"]);
  }

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_taskIndex];
    final syllables = _currentSyllables;
    final int total = syllables.length;
    final double syllableProgress = _syllableIndex / total;

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
                // _buildOutlinedBadge("පැවරුම 2"),
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
                "පැවරුම 2 — බහු-අක්ෂර වචන හඳුනාගැනීම",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),

              // Double segmented progress bar
              _buildSegmentedProgress(),
              const SizedBox(height: 14),

              // Word counter
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Text(
                      "වමේ සිට දකුණට අනුපිළිවෙලින් අක්ෂර තට්ටු කරන්න!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("👆", style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),

              // Word card with gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB2F0E8), Color(0xFFF0FFF4), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFAFECE0), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    children: [
                      // Emoji
                      Text(task["emoji"] as String,
                          style: const TextStyle(fontSize: 52)),
                      const SizedBox(height: 10),

                      // Big word
                      Text(
                        task["word"] as String,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A2E),
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),

                      // Meaning
                      // Text(
                      //   task["meaning"] as String,
                      //   style: const TextStyle(
                      //     fontSize: 14,
                      //     color: Color(0xFF6B7280),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      const SizedBox(height: 16),

                      // Syllable progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: syllableProgress,
                          backgroundColor: const Color(0xFFD1FAE5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF0D9488)),
                          minHeight: 7,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // "X of Y syllables tapped"
                      Text(
                        _wordComplete
                            ? "✅ හැම අක්ෂරයක්ම තට්ටු කළා!"
                            : "$total න් අක්ෂර $_syllableIndex ක් තට්ටු කළා!",
                        style: TextStyle(
                          fontSize: 12,
                          color: _wordComplete
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF9CA3AF),
                          fontStyle: FontStyle.italic,
                          fontWeight: _wordComplete
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Syllable tiles row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: syllables.asMap().entries.map((entry) {
                  final i = entry.key;
                  final syl = entry.value;

                  final bool isAlreadyTapped = i < _syllableIndex;
                  final bool isNext = i == _syllableIndex && !_wordComplete;
                  final bool isWrongTap = _lastTapped == syl &&
                      !_lastWasCorrect &&
                      i != _syllableIndex - 1;

                  Color bgColor = Colors.white;
                  Color borderColor = const Color(0xFFD1D5DB);
                  Color textColor = const Color(0xFF9CA3AF);
                  String? label;

                  if (isAlreadyTapped) {
                    bgColor = const Color(0xFFF0FDF4);
                    borderColor = const Color(0xFF0D9488);
                    textColor = const Color(0xFF0D9488);
                  } else if (isNext) {
                    bgColor = const Color(0xFFE6FAF8);
                    borderColor = const Color(0xFF0D9488);
                    textColor = const Color(0xFF0D9488);
                    label = "tap";
                  } else if (!_wordComplete) {
                    // future tiles — muted
                    bgColor = Colors.white;
                    borderColor = const Color(0xFFE5E7EB);
                    textColor = const Color(0xFFD1D5DB);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: _wordComplete ? null : () => _checkSyllable(syl, i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: EdgeInsets.only(
                          left: i == 0 ? 0 : 8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: isNext
                              ? [
                            BoxShadow(
                              color: const Color(0xFF0D9488).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Text(
                              syl,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (label != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ],
                            if (isAlreadyTapped) ...[
                              const SizedBox(height: 4),
                              const Icon(Icons.check_rounded,
                                  color: Color(0xFF0D9488), size: 14),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Wrong tap feedback
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: (!_lastWasCorrect &&
                    _lastTapped.isNotEmpty &&
                    !_wordComplete)
                    ? Container(
                  key: const ValueKey('wrong'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFFFCA5A5), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text("💡", style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      Text(
                        "ඊළඟට මුලින්ම උද්දීපනය කළ අක්ෂර මාලාව උත්සාහ කරන්න!",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                )
                    : _wordComplete
                    ? Container(
                  key: const ValueKey('done'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text("🎉", style: TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "නියමයි! ඔයා හැම අකුරක්ම තට්ටු කළා - \"${task['word']}\"!",
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
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              const SizedBox(height: 16),

              // Hear word again button
              Center(
                child: GestureDetector(
                  onTap: _playWord,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: const Color(0xFF0D9488), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.volume_up_rounded,
                            color: Color(0xFF0D9488), size: 18),
                        SizedBox(width: 6),
                        Text(
                          "අසන්න",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Next Word button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _wordComplete ? _nextTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: _wordComplete ? 4 : 0,
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

  Widget _buildSegmentedProgress() {
    final int total = _tasks.length;
    final int filled = _taskIndex + 1;
    return Column(
      children: [
        Row(
          children: List.generate(total, (i) => Expanded(
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
          )),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(total, (i) => Expanded(
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
          )),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
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