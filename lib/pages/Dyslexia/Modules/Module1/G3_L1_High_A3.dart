import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A3_MissingLetter extends StatefulWidget {
  const G3_L1_High_A3_MissingLetter({super.key});

  @override
  State<G3_L1_High_A3_MissingLetter> createState() =>
      _G3_L1_High_A3_MissingLetterState();
}

class _G3_L1_High_A3_MissingLetterState
    extends State<G3_L1_High_A3_MissingLetter> {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  bool _isCorrectAnswerSelected = false;
  bool _isWrongAnswerSelected = false;
  String _selectedAnswer = '';

  final List<Map<String, dynamic>> _tasks = [
    {
      'word': '_ලියා',
      'realword':'අලියා',
      'emoji': '🐘',
      'meaning': 'Elephant',
      'correctAnswer': 'අ',
      'options': ['අ', 'ඉ', 'ආ'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': 'සිං_යා',
      'realword':'සිංහයා',
      'emoji': '🦁',
      'meaning': 'Lion',
      'correctAnswer': 'හ',
      'options': ['හ', 'ඞ', 'ග'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_ටියා',
      'realword': 'කොටියා',
      'emoji': '🐅',
      'meaning': 'Tiger',
      'correctAnswer': 'කො',
      'options': ['කෙ', 'කැ', 'කො'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_ලය',
      'realword': 'කැලය',
      'emoji': '🌳',
      'meaning': 'Jungle',
      'correctAnswer': 'කැ',
      'options': ['ක', 'කැ', 'කෑ'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': 'අන්_',
      'realword': 'අන්ධ',
      'emoji': '👨‍🦯',
      'meaning': 'Blind',
      'correctAnswer': 'ධ',
      'options': ['ත', 'ද', 'ධ'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_ඩය',
      'realword': 'කුඩය',
      'emoji': '☂️',
      'meaning': 'Umbrella',
      'correctAnswer': 'කු',
      'options': ['කු', 'ක', 'කූ'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_ලය',
      'realword': 'මාලය',
      'emoji': '📿',
      'meaning': 'necklace',
      'correctAnswer': 'මා',
      'options': ['මා', 'ම', 'මු'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_යා',
      'realword': 'සීයා',
      'emoji': '👴🏻',
      'meaning': 'Grand Father',
      'correctAnswer': 'සී',
      'options': ['සි' , 'සු' , 'සී' ],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_ළය',
      'realword': 'කොළය',
      'emoji': '🍃',
      'meaning': 'Zebra',
      'correctAnswer': 'කො',
      'options': ['කෙ', 'කො', 'කෝ'],
      'optionEmojis': ['', '', ''],
    },
    {
      'word': '_ඩය',
      'realword': 'කූඩය',
      'emoji': '🧺',
      'meaning': 'basket',
      'correctAnswer': 'කූ',
      'options': ['කු', 'ක', 'කූ'],
      'optionEmojis': ['', '', ''],
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

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakWord() async {
    final word = _tasks[_taskIndex]['realword'] as String;
    await _flutterTts.speak(word.replaceAll('_', ''));
  }

  void _checkAnswer(String selectedLetter) {
    if (_isCorrectAnswerSelected) return;
    setState(() {
      _selectedAnswer = selectedLetter;
      if (selectedLetter == _tasks[_taskIndex]['correctAnswer']) {
        _isCorrectAnswerSelected = true;
        _isWrongAnswerSelected = false;
      } else {
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = true;
      }
    });
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = false;
        _selectedAnswer = '';
      } else {
        Navigator.pop(context, true);
      }
    });
  }

  /// Splits the word into segments around '_' for tile rendering
  List<String> _getWordParts(String word) {
    // Split into individual characters, replacing '_' with a special marker
    return word.split('');
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];
    final String word = currentTask['word'] as String;
    final double progress = (_taskIndex + 1) / _tasks.length;
    //final List<String> chars = word.split('');
    final List<String> chars = word.characters.toList();
    final String correctAnswer = currentTask['correctAnswer'] as String;
    final List<String> options = List<String>.from(currentTask['options']);

    // Build completed word for success banner
    // final String completedWord = word.replaceAll('_', _isCorrectAnswerSelected ? correctAnswer : '?');

    final String completedWord = _isCorrectAnswerSelected
        ? word.characters.map((c) => c == '_' ? correctAnswer : c).join()
        : word.replaceAll('_', '?');

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
                _buildBadge("ඉහළ අවදානම", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFF4A90D9), Colors.white),
                // const SizedBox(width: 6),
                // _buildBadge("පැවරුම 3", const Color(0xFF7B61FF), Colors.white),
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
                "පැවරුම 3 — Letter & Sound Recognition",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 14),

              // Progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "වචන ${_tasks.length} න් ${_taskIndex + 1} වන වචනය",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${(progress * 100).round()}%",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B61FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 20),

              // Instruction
              Row(
                children: const [
                  Text(
                    "මොන අකුරද නැතිවෙලා තියෙන්නේ?",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("🔍", style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 14),

              // Main card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                  child: Column(
                    children: [
                      // Emoji + meaning
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentTask['emoji'] as String,
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            currentTask['meaning'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Word tiles row
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: chars.map((ch) {
                          final bool isMissing = ch == '_';

                          if (isMissing) {
                            // Missing letter tile — dashed red border with "?"
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: _isCorrectAnswerSelected
                                    ? const Color(0xFFF0FDF4)
                                    : const Color(0xFFFFF5F5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _isCorrectAnswerSelected
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFEF4444),
                                  width: 2,
                                  // Dashed border via CustomPainter is complex;
                                  // using solid with red for missing, green when filled
                                ),
                              ),
                              child: Center(
                                child: _isCorrectAnswerSelected
                                    ? Text(
                                  correctAnswer,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF16A34A),
                                  ),
                                )
                                    : const Text(
                                  "?",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            );
                          }

                          // Normal letter tile
                          return Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF93C5FD),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                ch,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Hear word button
                      GestureDetector(
                        onTap: _speakWord,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EDFF),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFF7B61FF), width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("🔊", style: TextStyle(fontSize: 15)),
                              SizedBox(width: 6),
                              Text(
                                "වචනය අසන්න",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7B61FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Answer option tiles
              Row(
                children: List.generate(options.length, (i) {
                  final letter = options[i];
                  final bool isCorrect =
                      _isCorrectAnswerSelected && letter == correctAnswer;
                  final bool isWrong =
                      _isWrongAnswerSelected && letter == _selectedAnswer;

                  Color bgColor = Colors.white;
                  Color borderColor = const Color(0xFFBAE6FD);
                  Color textColor = const Color(0xFF0369A1);

                  if (isCorrect) {
                    bgColor = const Color(0xFFF0FDF4);
                    borderColor = const Color(0xFF22C55E);
                    textColor = const Color(0xFF16A34A);
                  } else if (isWrong) {
                    bgColor = const Color(0xFFFFF1F1);
                    borderColor = const Color(0xFFEF4444);
                    textColor = const Color(0xFFDC2626);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _checkAnswer(letter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.only(
                          left: i == 0 ? 0 : 8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              letter,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Small visual hint dot
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: borderColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Feedback banner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isCorrectAnswerSelected
                    ? Container(
                  key: const ValueKey('correct'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text("🎉", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'හරි! වචනය "$completedWord"',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : _isWrongAnswerSelected
                    ? Container(
                  key: const ValueKey('wrong'),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFFCA5A5), width: 1.5),
                  ),
                  child: Row(
                    children: const [
                      Text("❌", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "හරියටම නැහැ — නැවත උත්සාහ කරන්න!",
                          style: TextStyle(
                            fontSize: 14,
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

              // Next button
              SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isCorrectAnswerSelected ? 1.0 : 0.45,
                  child: ElevatedButton(
                    onPressed: _isCorrectAnswerSelected ? _nextTask : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF9CA3AF),
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: _isCorrectAnswerSelected ? 4 : 0,
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
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
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

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}