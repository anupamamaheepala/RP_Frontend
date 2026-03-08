import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L2_MEDIUM_A4 extends StatefulWidget {
  const G3_L2_MEDIUM_A4({Key? key}) : super(key: key);

  @override
  State<G3_L2_MEDIUM_A4> createState() => _G3_L2_MEDIUM_A4State();
}

class _G3_L2_MEDIUM_A4State extends State<G3_L2_MEDIUM_A4> {
  final FlutterTts _flutterTts = FlutterTts();
  int _taskIndex = 0;
  int _playCount = 0;
  bool _isCorrect = false;
  bool _isWrong = false;
  String _selectedWord = '';

  final List<Map<String, dynamic>> _words = [
    {
      "word": "ගෙදර",
      "emoji": "🏠",
      "correctAnswer": "ගෙදර",
      "options": ["ගෙදර", "ගෙතර", "ගේදර"],
      "syllables": ["ගෙ", "ද", "ර"],
      "usageSentence": "මම ගෙදර ගියා",
      "usageTranslation": "I went home",
    },
    {
      "word": "අලමාරය",
      "emoji": "🗄️",
      "correctAnswer": "අලමාරය",
      "options": ["අලමාරය", "අල්මාරය", "අළමාරය"],
      "syllables": ["අ", "ල", "මා", "ර", "ය"],
      "usageSentence": "පොත අලමාරයේ තිබේ",
      "usageTranslation": "The book is in the cupboard",
    },
    {
      "word": "යතුර",
      "emoji": "🔑",
      "correctAnswer": "යතුර",
      "options": ["යතුර", "සාලය", "මිතුරා"],
      "syllables": ["ය", "තු", "ර"],
      "usageSentence": "මෙය මගේ යතුරයි",
      "usageTranslation": "This is my key",
    },
    {
      "word": "වතුර",
      "emoji": "💧",
      "correctAnswer": "වතුර",
      "options": ["වතුර", "ජලය", "අල්මාරය"],
      "syllables": ["ව", "තු", "ර"],
      "usageSentence": "ඉස්සර වතුර බොනවා",
      "usageTranslation": "I drink water every day",
    },
    {
      "word": "අලියා",
      "emoji": "🐘",
      "correctAnswer": "අලියා",
      "options": ["අලියා", "ගරියා", "අළමාරය"],
      "syllables": ["අ", "ලි", "යා"],
      "usageSentence": "අලියා විශාල සතෙකි",
      "usageTranslation": "An elephant is a large animal",
    },
    {
      "word": "පාසල",
      "emoji": "🏫",
      "correctAnswer": "පාසල",
      "options": ["පාසල", "සාලය", "ගාසල"],
      "syllables": ["පා", "ස", "ල"],
      "usageSentence": "දරුවා පාසල යනවා",
      "usageTranslation": "The child goes to school",
    },
  ];

  Future<void> _playWord() async {
    setState(() => _playCount++);
    await _flutterTts.speak(_words[_taskIndex]["word"]);
  }

  Future<void> _playSentence() async {
    await _flutterTts.speak(_words[_taskIndex]["usageSentence"]);
  }

  void _checkAnswer(String selected) {
    if (_isCorrect) return;
    setState(() {
      _selectedWord = selected;
      _isCorrect = selected == _words[_taskIndex]["correctAnswer"];
      _isWrong = !_isCorrect;
    });
    if (_isCorrect) {
      Future.delayed(const Duration(milliseconds: 300), _playWord);
    }
  }

  void _nextTask() {
    if (_taskIndex < _words.length - 1) {
      setState(() {
        _taskIndex++;
        _isCorrect = false;
        _isWrong = false;
        _selectedWord = '';
        _playCount = 0;
      });
      _playWord();
    } else {
      Navigator.pop(context, true);
    }
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
    final task = _words[_taskIndex];
    final List<String> options = List<String>.from(task["options"]);
    final List<String> syllables = List<String>.from(task["syllables"]);

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
                // _buildOutlinedBadge("Module 1 of 4"),
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
                "පැවරුම 4 - බහු-අක්ෂර වචන විකේතනය කිරීම",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              // Word Radar row + Activity label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text("🎯", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Text(
                        "වචන රේඩාර්",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "Activity 1 of 4",
                  //   style: const TextStyle(
                  //     fontSize: 13,
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xFF6B7280),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),

              // Double-row segmented progress
              _buildSegmentedProgress(),
              const SizedBox(height: 14),

              // Round counter
              Text(
                "වචන ${_words.length} න් ${_taskIndex + 1} වන වචනය",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Sound card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDFF3FF), Color(0xFFF0F8FF), Color(0xFFFFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    children: [
                      Text(task["emoji"] as String,
                          style: const TextStyle(fontSize: 52)),
                      const SizedBox(height: 10),
                      const Text(
                        "ඔබට ඇසෙන්නේ කුමන වචනයද?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Play Word button
                      GestureDetector(
                        onTap: _playWord,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4F46E5).withOpacity(0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.headphones_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 10),
                              Text(
                                "වචනය වාදනය කරන්න",
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
                      Text(
                        " ${_playCount} වන වතාව — ඔබට ඕනෑම වේලාවක නැවත වාදනය කළ හැකිය!",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6366F1),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Answer option tiles
              ...options.asMap().entries.map((entry) {
                final i = entry.key;
                final option = entry.value;
                final bool isSelected = _selectedWord == option;
                final bool isCorrectOption =
                    option == task["correctAnswer"];
                final bool isCorrectSelected = isSelected && _isCorrect;
                final bool isWrongSelected = isSelected && _isWrong;

                Color borderColor = const Color(0xFFE5E7EB);
                Color bgColor = Colors.white;
                Color textColor = const Color(0xFF1A1A2E);

                if (isCorrectSelected) {
                  borderColor = const Color(0xFF22C55E);
                  bgColor = const Color(0xFFF0FDF4);
                  textColor = const Color(0xFF15803D);
                } else if (_isCorrect && !isCorrectOption) {
                  // After correct answer — dim other options
                  textColor = const Color(0xFFD1D5DB);
                  borderColor = const Color(0xFFF3F4F6);
                  bgColor = const Color(0xFFFAFAFA);
                } else if (isWrongSelected) {
                  borderColor = const Color(0xFFEF4444);
                  bgColor = const Color(0xFFFFF1F1);
                  textColor = const Color(0xFFDC2626);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: _isCorrect ? null : () => _checkAnswer(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Word text
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                          // Speaker buttons on right
                          if (!(_isCorrect && !isCorrectOption))
                            Row(
                              children: [
                                _iconBtn(Icons.volume_up_rounded,
                                        () => _flutterTts.speak(option)),
                                const SizedBox(width: 6),
                                _iconBtn(Icons.replay_rounded,
                                        () => _flutterTts.speak(option)),
                                if (isCorrectSelected) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.check_rounded,
                                      color: Color(0xFF22C55E), size: 22),
                                ],
                              ],
                            )
                          else
                          // Keep speaker buttons but dimmed for wrong options after answer
                            Row(
                              children: [
                                _iconBtn(Icons.volume_up_rounded,
                                        () => _flutterTts.speak(option),
                                    dimmed: true),
                                const SizedBox(width: 6),
                                _iconBtn(Icons.replay_rounded,
                                        () => _flutterTts.speak(option),
                                    dimmed: true),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              // Syllable breakdown card — shown after correct
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _isCorrect
                    ? Container(
                  key: const ValueKey('breakdown'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFE5E7EB), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      const Text(
                        "අක්ෂර බිඳවැටීම",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Syllable chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: syllables.map((syl) {
                          return GestureDetector(
                            onTap: () => _flutterTts.speak(syl),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F0FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF7C3AED),
                                    width: 1.5),
                              ),
                              child: Text(
                                syl,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF5B21B6),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Sinhala sentence
                      Text(
                        task["usageSentence"] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // English translation
                      // Text(
                      //   task["usageTranslation"] as String,
                      //   style: const TextStyle(
                      //     fontSize: 13,
                      //     color: Color(0xFF6B7280),
                      //     fontStyle: FontStyle.italic,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 14),

                      // Hear sentence button
                      GestureDetector(
                        onTap: _playSentence,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFFD1D5DB),
                                width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("🔊",
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(width: 4),
                              Text("🎵",
                                  style: TextStyle(fontSize: 13)),
                              SizedBox(width: 8),
                              Text(
                                "අසන්න",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ],
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
                        color: const Color(0xFFFCA5A5), width: 1.5),
                  ),
                  child: Row(
                    children: const [
                      Text("❌", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "වැරදියි — නැවත සවන් දී උත්සාහ කරන්න!",
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

              // Next Word button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCorrect ? _nextTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: _isCorrect ? 4 : 0,
                    shadowColor: const Color(0xFF7C3AED).withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _taskIndex < _words.length - 1
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

  Widget _iconBtn(IconData icon, VoidCallback onTap, {bool dimmed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: dimmed
              ? const Color(0xFFF9FAFB)
              : const Color(0xFFF3F4F6),
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

  Widget _buildSegmentedProgress() {
    final int total = _words.length;
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