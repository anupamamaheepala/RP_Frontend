import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_LOW_A2 extends StatefulWidget {
  const G3_L1_LOW_A2({Key? key}) : super(key: key);

  @override
  _G3_L1_LOW_A2State createState() => _G3_L1_LOW_A2State();
}

class _G3_L1_LOW_A2State extends State<G3_L1_LOW_A2> {
  final FlutterTts _flutterTts = FlutterTts();
  int _currentCaseIndex = 0;
  bool _isCorrectAnswer = false;
  bool _isAnswerChecked = false;
  String _selectedAnswer = '';
  int _playCount = 0;

  // ── Original content unchanged ────────────────────────────
  final List<Map<String, dynamic>> _tasks = [
    {
      "sentence": "අම්මා පොතක් කනවා.",
      "wrongWord": "කටව",
      "correctAnswer": "කියවනවා",
      "options": ["කටව", "කියවනවා", "කනවා"],
      "clue": "ඔයා කෑම කනවා 🍚 — නමුත් පොතක් අරන් මොකද කරන්නේ 📚?",
      "fixedSentence": "අම්මා පොතක් කියවනවා",
      "fixedTranslation": "Mother Read the book.",
      "emoji": "📚",
    },
    {
      "sentence": "ලමයා 🏊 නෙළම් පොකුණේ ගැවා.",
      "wrongWord": "ගැවා",
      "correctAnswer": "නෑවා",
      "options": ["ගැවා", "නෑවා", "ගියා"],
      "clue": "පොකුණක 🏊 — ඔයා පීනනවද, තීන්ත ගානවද, නැත්නම් නිකම්ම යනවද?",
      "fixedSentence": "ලමයා නෙළම් පොකුණේ නෑවා.",
      "fixedTranslation": "The child swam in the lotus pond.",
      "emoji": "🏊",
    },
    {
      "sentence": "අයියා බත් ගිය.",
      "wrongWord": "ගිය",
      "correctAnswer": "කනවා",
      "options": ["එනවා", "යනවා", "කනවා"],
      "clue": "අපිට බත් තියෙද්දි අපි මොකද කරන්නේ? 🍚",
      "fixedSentence": "අයියා ගමනක් ගියෙ.",
      "fixedTranslation": "Brother went on a journey.",
      "emoji": "🍚",
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

  void _playSentence() async {
    setState(() => _playCount++);
    await _flutterTts.speak(_tasks[_currentCaseIndex]["sentence"]);
  }

  void _checkAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _isCorrectAnswer =
          answer == _tasks[_currentCaseIndex]["correctAnswer"];
      _isAnswerChecked = true;
    });
  }

  void _nextCase() {
    setState(() {
      if (_currentCaseIndex < _tasks.length - 1) {
        _currentCaseIndex++;
        _isAnswerChecked = false;
        _isCorrectAnswer = false;
        _selectedAnswer  = '';
        _playCount       = 0;
      } else {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = _tasks[_currentCaseIndex];
    final String wrongWord     = task["wrongWord"] as String;
    final String sentence      = task["sentence"]  as String;
    final List<String> options = List<String>.from(task["options"]);

    // Split sentence around the wrong word for inline rendering
    final parts = sentence.split(wrongWord);

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
            child: Row(children: [
              _badge("අවම අවදානම",          const Color(0xFF22C55E), Colors.white),
              const SizedBox(width: 6),
              _badge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFFF97316), Colors.white),
              // const SizedBox(width: 6),
              // _outlinedBadge("පැවරුම 2"),
            ]),
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
                "පැවරුම 2- අවබෝධයෙන් කියවීම",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E), letterSpacing: -0.3),
              ),
              const SizedBox(height: 10),

              // Sub-label row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [
                    Text("🔍", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text("වාක්‍ය පරීක්ෂක",
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280))),
                  ]),
                  // const Text("Activity 2 of 4",
                  //     style: TextStyle(fontSize: 13,
                  //         fontWeight: FontWeight.w500,
                  //         color: Color(0xFF6B7280))),
                ],
              ),
              const SizedBox(height: 8),

              _segmentedProgress(),
              const SizedBox(height: 14),

              Text(
                "Case ${_currentCaseIndex + 1} of ${_tasks.length}",
                style: const TextStyle(fontSize: 13,
                    color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              // ── Sentence card ─────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFDDB0), width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.orange.withOpacity(0.08),
                        blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Red pill
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          Text("📍", style: TextStyle(fontSize: 14)),
                          SizedBox(width: 6),
                          Text("වැරදි වචනය සොයා ගන්න!",
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Sentence with wrong word highlighted
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        if (parts.isNotEmpty && parts[0].isNotEmpty)
                          Text(parts[0].trim(),
                              style: const TextStyle(fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E))),
                        // Wrong word box
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFEF4444),
                                    width: 2,
                                    style: BorderStyle.solid),
                              ),
                              child: Text(wrongWord,
                                  style: const TextStyle(fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFDC2626))),
                            ),
                            // "?" badge top-right
                            Positioned(
                              top: -8,
                              right: -8,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text("?",
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (parts.length > 1 && parts[1].isNotEmpty)
                          Text(parts[1].trim(),
                              style: const TextStyle(fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A2E))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Clue pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFD1FAE5), width: 1.5),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Text("💡", style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            "ඉඟිය: ${task['clue']}",
                            style: const TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF065F46)),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 14),

                    // Listen button
                    GestureDetector(
                      onTap: _playSentence,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA580C),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFEA580C).withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("🔊", style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text("කැඩුණු වාක්‍යයට සවන් දෙන්න.",
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        "${_playCount}× වන වතාව",
                        style: const TextStyle(fontSize: 11,
                            color: Color(0xFF9CA3AF),
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Replace label ─────────────────────────────
              Row(children: const [
                Text("↘", style: TextStyle(fontSize: 14,
                    color: Color(0xFF6B7280))),
                SizedBox(width: 6),
                Text("රතු වචනය ආදේශ කරන්න:",
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E))),
              ]),
              const SizedBox(height: 12),

              // ── Option tiles ──────────────────────────────
              ...options.asMap().entries.map((entry) {
                final option = entry.value;
                final bool isSelected = _selectedAnswer == option;
                final bool isCorrectOption =
                    option == task["correctAnswer"];
                final bool isCorrectSelected =
                    isSelected && _isCorrectAnswer;
                final bool isWrongSelected =
                    isSelected && !_isCorrectAnswer;

                Color bgColor    = Colors.white;
                Color border     = const Color(0xFFE5E7EB);
                Color textColor  = const Color(0xFF1A1A2E);
                Widget? trailing;

                if (_isAnswerChecked) {
                  if (isCorrectSelected) {
                    bgColor   = const Color(0xFFF0FDF4);
                    border    = const Color(0xFF22C55E);
                    textColor = const Color(0xFF15803D);
                    trailing  = const Icon(Icons.check_rounded,
                        color: Color(0xFF22C55E), size: 22);
                  } else if (isWrongSelected) {
                    bgColor   = const Color(0xFFFFF1F1);
                    border    = const Color(0xFFEF4444);
                    textColor = const Color(0xFFDC2626);
                    trailing  = const Icon(Icons.close_rounded,
                        color: Color(0xFFEF4444), size: 22);
                  } else if (!isCorrectOption) {
                    // Unselected wrong options — dimmed
                    textColor = const Color(0xFFD1D5DB);
                    border    = const Color(0xFFF3F4F6);
                    bgColor   = const Color(0xFFFAFAFA);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: _isAnswerChecked && _isCorrectAnswer
                        ? null
                        : () => _checkAnswer(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04),
                              blurRadius: 5, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Text(option,
                              style: TextStyle(fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: textColor)),
                        ),
                        // Speaker buttons
                        Row(children: [
                          _iconBtn(Icons.volume_up_rounded,
                                  () => _flutterTts.speak(option),
                              dimmed: _isAnswerChecked && !isSelected && !isCorrectOption),
                          const SizedBox(width: 6),
                          _iconBtn(Icons.replay_rounded,
                                  () => _flutterTts.speak(option),
                              dimmed: _isAnswerChecked && !isSelected && !isCorrectOption),
                          if (trailing != null) ...[
                            const SizedBox(width: 8),
                            trailing,
                          ],
                        ]),
                      ]),
                    ),
                  ),
                );
              }).toList(),

              // ── Feedback card ─────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                child: _isAnswerChecked
                    ? Container(
                  key: const ValueKey('feedback'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _isCorrectAnswer
                        ? const Color(0xFFF0FDF4)
                        : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isCorrectAnswer
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFDE68A),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(children: [
                        Text(_isCorrectAnswer ? "✅" : "✗",
                            style: TextStyle(
                                fontSize: 16,
                                color: _isCorrectAnswer
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFD97706))),
                        const SizedBox(width: 8),
                        Text(
                          _isCorrectAnswer
                              ? "නියම වැඩක්! නිවැරදි වාක්‍යය:"
                              : "වැරදියි! නිවැරදි වාක්‍යය:",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _isCorrectAnswer
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFD97706)),
                        ),
                      ]),
                      const SizedBox(height: 12),

                      // Fixed sentence
                      Text(task["fixedSentence"] as String,
                          style: const TextStyle(fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 4),

                      // English translation
                      // Text(task["fixedTranslation"] as String,
                      //     style: const TextStyle(fontSize: 13,
                      //         color: Color(0xFF6B7280),
                      //         fontStyle: FontStyle.italic)),
                      const SizedBox(height: 8),

                      // Clue reminder
                      Text(task["clue"] as String,
                          style: const TextStyle(fontSize: 12,
                              color: Color(0xFF9CA3AF))),
                      const SizedBox(height: 14),

                      // Hear correct sentence button
                      GestureDetector(
                        onTap: () => _flutterTts
                            .speak(task["fixedSentence"]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFF22C55E),
                                width: 1.5),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("🔊",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(width: 4),
                                Text("🎧",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(width: 8),
                                Text("නිවැරදි වාක්‍ය අසන්න",
                                    style: TextStyle(fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF16A34A))),
                              ]),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('none')),
              ),
              const SizedBox(height: 16),

              // ── Next Case button ──────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAnswerChecked ? _nextCase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: _isAnswerChecked ? 4 : 0,
                    shadowColor: const Color(0xFFEC4899).withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentCaseIndex < _tasks.length - 1
                            ? "ඊළඟ"
                            : "ඊළඟ පැවරුම",
                        style: const TextStyle(fontSize: 17,
                            fontWeight: FontWeight.w700),
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

  Widget _iconBtn(IconData icon, VoidCallback onTap,
      {bool dimmed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: dimmed ? const Color(0xFFF9FAFB) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: dimmed
                  ? const Color(0xFFF3F4F6)
                  : const Color(0xFFE5E7EB)),
        ),
        child: Icon(icon,
            size: 15,
            color: dimmed
                ? const Color(0xFFE5E7EB)
                : const Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _segmentedProgress() {
    final int total  = _tasks.length;
    final int filled = _currentCaseIndex + 1;
    return Column(children: [
      Row(
        children: List.generate(total, (i) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: 7,
            decoration: BoxDecoration(
              color: i < filled
                  ? const Color(0xFF22C55E)
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
                  ? const Color(0xFFA3E635)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )),
      ),
    ]);
  }

  Widget _badge(String label, Color bg, Color fg) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(
            color: fg,
            fontSize: 11,
            fontWeight: FontWeight.w700)),
  );

  Widget _outlinedBadge(String label) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border:
      Border.all(color: const Color(0xFF6B7280), width: 1.5),
    ),
    child: Text(label,
        style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 11,
            fontWeight: FontWeight.w700)),
  );
}