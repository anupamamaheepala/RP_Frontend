import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordPickerActivity extends StatefulWidget {
  const WordPickerActivity({Key? key}) : super(key: key);

  @override
  State<WordPickerActivity> createState() => _WordPickerActivityState();
}

class _WordPickerActivityState extends State<WordPickerActivity> {
  final FlutterTts _flutterTts = FlutterTts();

  String _selectedAnswer = '';
  bool _isCorrectAnswerSelected = false;
  bool _isWrongAnswerSelected = false;
  int _taskIndex = 0;
  int _playCount = 0;

  final List<Map<String, dynamic>> _tasks = [
    {
      "word": "පාසල",
      "correctAnswer": "පාසල",
      "options": ["පාසල", "සාලය", "ගාසල"],
      "emoji": "🏫",
      "meaning": "school",
      "syllableBreakdown": "පා | ස | ල",
      "usageSentence": "මෙය මගේ පාසලයි.",
    },
    {
      "word": "යතුර",
      "correctAnswer": "යතුර",
      "options": ["යතුර", "සාලය", "මිතුරා"],
      "emoji": "🔑",
      "meaning": "key",
      "syllableBreakdown": "ය | තු | ර",
      "usageSentence": "මෙය මගේ යතුරයි.",
    },
    {
      "word": "වතුර",
      "correctAnswer": "වතුර",
      "options": ["වතුර", "ජලය", "අල්මාරය"],
      "emoji": "💧",
      "meaning": "water",
      "syllableBreakdown": "ව | තු | ර",
      "usageSentence": "වතුර බොනවා.",
    },
    {
      "word": "මල්",
      "correctAnswer": "මල්",
      "options": ["මල්", "අල්මාරය", "මල්ලි"],
      "emoji": "🌸",
      "meaning": "flower",
      "syllableBreakdown": "ම | ල්",
      "usageSentence": "මල් ලස්සනයි.",
    },
    {
      "word": "අලියා",
      "correctAnswer": "අලියා",
      "options": ["අලියා", "ගරියා", "ආලය"],
      "emoji": "🐘",
      "meaning": "elephant",
      "syllableBreakdown": "අ | ලි | යා",
      "usageSentence": "අලියා විශාල සතෙකි.",
    },
  ];

  Future<void> _playWord() async {
    setState(() => _playCount++);
    await _flutterTts.speak(_tasks[_taskIndex]["correctAnswer"]);
  }

  void _checkAnswer(String selectedAnswer) {
    if (_isCorrectAnswerSelected) return;
    setState(() {
      _selectedAnswer = selectedAnswer;
      _isCorrectAnswerSelected =
          selectedAnswer == _tasks[_taskIndex]["correctAnswer"];
      _isWrongAnswerSelected = !_isCorrectAnswerSelected;
    });
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = false;
        _selectedAnswer = '';
        _playCount = 0;
      } else {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playWord();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_taskIndex];
    final List<String> options = List<String>.from(task["options"]);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _buildBadge(
                    "මධ්‍යම අවදානම", const Color(0xFFFBBF24), const Color(0xFF92400E)),
                const SizedBox(width: 6),
                _buildBadge(
                    "ශ්‍රේණිය 3 · මට්ටම 2", const Color(0xFF22C55E), Colors.white),
                // const SizedBox(width: 6),
                // _buildBadge("පැවරුම 1", const Color(0xFF4A90D9), Colors.white),
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
                "පැවරුම 1 — බහු-අක්ෂර වචන හඳුනාගැනීම",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("💡", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "වචනයට සවන් දී නිවැරදි එක තට්ටු කරන්න!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Sound card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFBAE6FD), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        task["emoji"] as String,
                        style: const TextStyle(fontSize: 56),
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   task["meaning"] as String,
                      //   style: const TextStyle(
                      //     fontSize: 15,
                      //     color: Color(0xFF4B5563),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      // Play Word button
                      GestureDetector(
                        onTap: _playWord,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 13),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B6B3A),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B6B3A)
                                    .withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.volume_up_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Play Word",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Text(
                      //   _playCount <= 1
                      //       ? "Played 1× — replay anytime!"
                      //       : "Played $_playCount× — replay anytime!",
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Color(0xFF6B7280),
                      //     fontStyle: FontStyle.italic,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Answer option tiles (vertical stack)
              ...options.asMap().entries.map((entry) {
                final letter = entry.value;
                final bool isSelected = _selectedAnswer == letter;
                final bool isCorrect =
                    _isCorrectAnswerSelected && letter == task["correctAnswer"];
                final bool isWrong =
                    _isWrongAnswerSelected && letter == _selectedAnswer;

                Color borderColor = const Color(0xFFD1D5DB);
                Color bgColor = Colors.white;
                Color textColor = const Color(0xFF1A1A2E);
                Widget? trailingIcon;

                if (isCorrect) {
                  borderColor = const Color(0xFF22C55E);
                  bgColor = const Color(0xFFF0FDF4);
                  textColor = const Color(0xFF15803D);
                  trailingIcon = const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF22C55E), size: 22);
                } else if (isWrong) {
                  borderColor = const Color(0xFFEF4444);
                  bgColor = const Color(0xFFFFF1F1);
                  textColor = const Color(0xFFDC2626);
                  trailingIcon = const Icon(Icons.cancel_rounded,
                      color: Color(0xFFEF4444), size: 22);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _checkAnswer(letter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (trailingIcon != null) trailingIcon,
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              // Feedback banner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isCorrectAnswerSelected
                    ? Container(
                  key: const ValueKey('correct'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text("🎉",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8),
                          Text(
                            "හරි! හොඳින් කළා!",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "අක්ෂර: ${task['syllableBreakdown']}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task['usageSentence'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
                    : _isWrongAnswerSelected
                    ? Container(
                  key: const ValueKey('wrong'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
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
                child: ElevatedButton(
                  onPressed: _isCorrectAnswerSelected ? _nextTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
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
                        _taskIndex < _tasks.length - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම",
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
        // Top row — first half of segments
        Row(
          children: List.generate(total, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                height: 7,
                decoration: BoxDecoration(
                  color: i < filled
                      ? const Color(0xFF4A90D9)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        // Bottom row — teal accent bar
        Row(
          children: List.generate(total, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                height: 5,
                decoration: BoxDecoration(
                  color: i < filled
                      ? const Color(0xFF06B6D4)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
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