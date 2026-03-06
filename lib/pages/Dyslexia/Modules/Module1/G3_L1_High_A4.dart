import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A4_RealOrNot extends StatefulWidget {
  const G3_L1_High_A4_RealOrNot({super.key});

  @override
  State<G3_L1_High_A4_RealOrNot> createState() =>
      _G3_L1_High_A4_RealOrNotState();
}

class _G3_L1_High_A4_RealOrNotState extends State<G3_L1_High_A4_RealOrNot> {
  final FlutterTts _flutterTts = FlutterTts();

  int _currentTaskIndex = 0;
  bool? _selectedAnswer; // true = yes, false = no
  bool _isAnswered = false;

  final List<Map<String, dynamic>> _tasks = [
    {'syllable': 'කා', 'isReal': true, 'explanation': "'කා' is a valid Sinhala syllable."},
    {'syllable': 'කැ', 'isReal': true, 'explanation': "'කැ' is a valid Sinhala syllable."},
    {'syllable': 'කියා', 'isReal': true, 'explanation': "'කියා' is a valid Sinhala syllable."},
    {'syllable': 'කබ', 'isReal': false, 'explanation': "'කබ' is not a valid Sinhala syllable."},
    {'syllable': 'හෙ', 'isReal': true, 'explanation': "'හෙ' is a valid Sinhala syllable."},
    {'syllable': 'හො', 'isReal': true, 'explanation': "'හො' is a valid Sinhala syllable."},
    {'syllable': 'ඔ', 'isReal': false, 'explanation': "'ඔ' is not a valid Sinhala syllable."},
    {'syllable': 'ඖ', 'isReal': true, 'explanation': "'ඖ' is a valid Sinhala syllable."},
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _playSyllableSound();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playSyllableSound() async {
    await _flutterTts.speak(_tasks[_currentTaskIndex]['syllable']);
  }

  void _checkAnswer(bool answer) {
    if (_isAnswered) return;
    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });
  }

  void _nextTask() {
    if (_currentTaskIndex < _tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
      _playSyllableSound();
    } else {
      Navigator.pop(context, true);
    }
  }

  bool get _isCorrect =>
      _isAnswered &&
          _selectedAnswer == _tasks[_currentTaskIndex]['isReal'];

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_currentTaskIndex];
    final double progress = (_currentTaskIndex + 1) / _tasks.length;

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
                _buildBadge("High Risk", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("Grade 3 · Level 1", const Color(0xFF4A90D9), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("Module 2", const Color(0xFF7B61FF), Colors.white),
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
                "Module 2 — Syllable Blending",
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
                    "${_currentTaskIndex + 1} of ${_tasks.length}",
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
              const SizedBox(height: 24),

              // Instruction
              Row(
                children: const [
                  Text(
                    "Is this a real Sinhala syllable?",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("😊", style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),

              // Syllable card — yellow/cream
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFD96A), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD96A).withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    children: [
                      // Big syllable
                      Text(
                        currentTask['syllable'] as String,
                        style: const TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A5F),
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Hear it button
                      GestureDetector(
                        onTap: _playSyllableSound,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFF7B61FF), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("🔊", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 4),
                              Text("🎵", style: TextStyle(fontSize: 14)),
                              SizedBox(width: 8),
                              Text(
                                "Hear it",
                                style: TextStyle(
                                  fontSize: 14,
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
              const SizedBox(height: 24),

              // Yes / No buttons
              Row(
                children: [
                  // Yes button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _checkAnswer(true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: _isAnswered && _selectedAnswer == true
                              ? (_isCorrect
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444))
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isAnswered && _selectedAnswer == true
                                ? (_isCorrect
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626))
                                : const Color(0xFF22C55E),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_box_rounded,
                              color: _isAnswered && _selectedAnswer == true
                                  ? Colors.white
                                  : const Color(0xFF22C55E),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Yes, it's real!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _isAnswered && _selectedAnswer == true
                                    ? Colors.white
                                    : const Color(0xFF16A34A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // No button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _checkAnswer(false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: _isAnswered && _selectedAnswer == false
                              ? (_isCorrect
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444))
                              : const Color(0xFFFFF1F1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isAnswered && _selectedAnswer == false
                                ? (_isCorrect
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626))
                                : const Color(0xFFEF4444),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_rounded,
                              color: _isAnswered && _selectedAnswer == false
                                  ? Colors.white
                                  : const Color(0xFFEF4444),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "No, it's not!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _isAnswered && _selectedAnswer == false
                                    ? Colors.white
                                    : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Feedback banner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isAnswered
                    ? Container(
                  key: ValueKey(_currentTaskIndex),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? const Color(0xFFF0FDF4)
                        : const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCorrect
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFCA5A5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect ? "🎉" : "❌",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isCorrect
                              ? "Correct! ${currentTask['explanation']}"
                              : "Not quite! ${currentTask['explanation']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isCorrect
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),

              const SizedBox(height: 16),

              // Next button — only visible after answering
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isAnswered
                    ? SizedBox(
                  key: const ValueKey('next'),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor:
                      const Color(0xFF4A90D9).withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentTaskIndex < _tasks.length - 1
                              ? "Next"
                              : "Next Activity",
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
                )
                    : const SizedBox.shrink(key: ValueKey('hidden')),
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