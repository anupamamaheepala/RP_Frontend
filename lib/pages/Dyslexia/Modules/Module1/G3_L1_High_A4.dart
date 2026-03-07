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
    {'syllable': 'කාලය', 'isReal': true, 'explanation': "'කාලය' වලංගු සිංහල වචනයකි.", 'correctWord': 'කාලය'},
    {'syllable': 'කැලිය', 'isReal': false, 'explanation': "'කැලිය' වලංගු සිංහල වචනයක් නොවේ. 'කැලය' වලංගු සිංහල වචනයකි.", 'correctWord': 'කැලය'},
    {'syllable': 'වේගය', 'isReal': true, 'explanation': "'වේගය' වලංගු සිංහල වචනයකි.", 'correctWord': 'වේගය'},
    {'syllable': 'අලය', 'isReal': false, 'explanation': "'අලය' වලංගු සිංහල වචනයක් නොවේ.'ආලය' වලංගු සිංහල වචනයකි.", 'correctWord': 'ආලය'},
    {'syllable': 'අරදර', 'isReal': false, 'explanation': "'අරදර' වලංගු සිංහල වචනයක් නොවේ.'කරදර' වලංගු සිංහල වචනයකි.", 'correctWord': 'කරදර'},
    {'syllable': 'කමත', 'isReal': true, 'explanation': "'කමත' වලංගු සිංහල වචනයකි.", 'correctWord': 'කමත'},
    {'syllable': 'කලාව', 'isReal': true, 'explanation': "'කලාව' වලංගු සිංහල වචනයකි.", 'correctWord': 'කලාව'},
    {'syllable': 'සමහර', 'isReal': true, 'explanation': "'සමහර' වලංගු සිංහල වචනයකි.", 'correctWord': 'සමහර'},
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.3);
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

  Future<void> _playCorrectWordSound() async {
    final correctWord = _tasks[_currentTaskIndex]['correctWord'] ?? _tasks[_currentTaskIndex]['syllable'];
    await _flutterTts.speak(correctWord);
  }

  void _checkAnswer(bool answer) {
    if (_isAnswered) return;
    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
    });
    // Optional: speak syllable immediately on selection
    _playSyllableSound();
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
      _isAnswered && _selectedAnswer == _tasks[_currentTaskIndex]['isReal'];

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
                _buildBadge("ඉහළ අවදානම", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFF4A90D9), Colors.white),
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
              const Text(
                "පැවරුම 4 — අක්ෂර මිශ්‍ර කිරීම",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_tasks.length} න් ${_currentTaskIndex + 1}",
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
              Row(
                children: const [
                  Text(
                    "මේක ඇත්තටම සිංහල අක්ෂර මාලාවක්ද?",
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
                      GestureDetector(
                        onTap: _playSyllableSound,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF7B61FF), width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("🔊", style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Text(
                                "අසන්න",
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
              Row(
                children: [
                  _buildAnswerButton(true, "ඔව්, ඒක ඇත්ත!", const Color(0xFF22C55E)),
                  const SizedBox(width: 12),
                  _buildAnswerButton(false, "නැහැ, ඒක නෙවෙයි!", const Color(0xFFEF4444)),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isAnswered
                    ? Container(
                  key: ValueKey(_currentTaskIndex),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: _isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCorrect ? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_isCorrect ? "🎉" : "❌", style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isCorrect
                                  ? "නිවැරදියි! ${currentTask['explanation']}"
                                  : "සම්පූර්ණයෙන්ම නොවේ! ${currentTask['explanation']}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _playCorrectWordSound,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("🔊", style: TextStyle(fontSize: 12)),
                                    const SizedBox(width: 6),
                                    Text(
                                      "නිවැරදි වචනය අසන්න",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              if (_isAnswered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_currentTaskIndex < _tasks.length - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම"),
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

  Widget _buildAnswerButton(bool value, String label, Color baseColor) {
    bool isSelected = _isAnswered && _selectedAnswer == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => _checkAnswer(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? (_isCorrect ? const Color(0xFF22C55E) : const Color(0xFFEF4444)) : baseColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? Colors.transparent : baseColor, width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : baseColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}