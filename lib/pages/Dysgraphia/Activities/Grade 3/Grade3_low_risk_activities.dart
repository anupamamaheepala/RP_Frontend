// grade3_low_risk_activities.dart
// Grade 3 - Low Risk Learning Plan Activities
// Activities: Confusable Pairs, Beat Your Time, Sentence Completion, Spot and Fix

import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart' as mlkit;

// Grade 3 data
const List<Map<String, String>> _confusablePairs = [
  {'a': 'ත', 'b': 'ද'},
  {'a': 'ප', 'b': 'බ'},
  {'a': 'ල', 'b': 'ළ'},
  {'a': 'ම', 'b': 'ව'},
];

const List<String> _grade3Words = [
  'මල', 'ගස', 'පත', 'අත', 'අම්මා', 'තාත්තා'
];

const List<String> _grade3SentenceStarters = [
  'මම ', 'අපි ', 'මල ', 'බල්ලා ', 'අම්මා ',
];
const List<String> _grade3SentenceCompletions = [
  'අම්මා ❤️',
  'යනවා 🚶',
  'ලස්සනයි 🌸',
  'බුරයි 🐕',
  'ගෙදර යයි 🏠',
];

// Words with one wrong letter for Spot and Fix
const List<Map<String, dynamic>> _spotFixData = [
  {'correct': 'මල', 'wrong': 'මළ', 'wrongLetterIndex': 1},
  {'correct': 'ගස', 'wrong': 'ගස', 'wrongLetterIndex': -1}, // control — same
  {'correct': 'පත', 'wrong': 'බත', 'wrongLetterIndex': 0},
  {'correct': 'අම්මා', 'wrong': 'අම්ම', 'wrongLetterIndex': 4},
];

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY HUB
// ─────────────────────────────────────────────────────────────────────────────

class Grade3LowRiskPage extends StatelessWidget {
  const Grade3LowRiskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.cyan.shade50,
              Colors.teal.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.teal),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text(
                            'ලිවීම වැඩිදියුණු කරමු',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '3 ශ්‍රේණිය — ශක්තිමත් කිරීම',
                            style:
                            TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.teal.shade100,
                            Colors.cyan.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal.shade300),
                        ),
                        child: const Row(
                          children: [
                            Text('💪', style: TextStyle(fontSize: 32)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ඔබ ඉතා හොඳ! දිගටම ඉදිරියට!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Text(
                        'ක්‍රියාකාරකම් තෝරන්න:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      _buildCard(
                        context: context,
                        emoji: '🔄',
                        title: 'සමාන අකුරු',
                        subtitle: 'ත/ද, ප/බ — දෙකම ලිය ඉගෙනගමු',
                        color: Colors.teal,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConfusablePairsActivity(),
                          ),
                        ),
                      ),

                      _buildCard(
                        context: context,
                        emoji: '⏱️',
                        title: 'වේගය අභිෂ්ඨ',
                        subtitle: 'ඔබේම වේලාව ජය ගන්න',
                        color: Colors.indigo,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BeatYourTimeActivity(words: _grade3Words),
                          ),
                        ),
                      ),

                      _buildCard(
                        context: context,
                        emoji: '📝',
                        title: 'වාක්‍ය සම්පූර්ණ කිරීම',
                        subtitle: 'වාක්‍ය ආරම්භය දී ඇත — ඉතිරිය ලියන්න',
                        color: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SentenceCompletionActivity(),
                          ),
                        ),
                      ),

                      _buildCard(
                        context: context,
                        emoji: '🔎',
                        title: 'දෝෂ සොයා නිරාකරණය',
                        subtitle: 'වැරදි අකුර සොයා නිවැරදිව ලියන්න',
                        color: Colors.deepOrange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SpotAndFixActivity(),
                          ),
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
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.35)!, color],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9))),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 1 — CONFUSABLE PAIRS
// Show letter A → write. Show letter B → write. Show both → write both.
// Then tap quiz: which letter is this?
// ─────────────────────────────────────────────────────────────────────────────

class ConfusablePairsActivity extends StatefulWidget {
  const ConfusablePairsActivity({super.key});

  @override
  State<ConfusablePairsActivity> createState() =>
      _ConfusablePairsActivityState();
}

class _ConfusablePairsActivityState extends State<ConfusablePairsActivity> {
  int _pairIndex = 0;
  int _step = 0; // 0=write A, 1=write B, 2=write both, 3=quiz
  List<List<Offset>> _strokes = [];
  int? _quizAnswer;
  bool _quizAnswered = false;
  int _score = 0;
  bool _isRecognizing = false;
  bool? _isCorrect;
  final mlkit.DigitalInkRecognizer _recognizer1 =
  mlkit.DigitalInkRecognizer(languageCode: 'si');

  Map<String, String> get _pair => _confusablePairs[_pairIndex];

  String get _stepInstruction {
    switch (_step) {
      case 0:
        return '"${_pair['a']}" ලියන්න';
      case 1:
        return '"${_pair['b']}" ලියන්න';
      case 2:
        return '"${_pair['a']}" සහ "${_pair['b']}" දෙකම ලියන්න';
      case 3:
        return 'කොයි අකුරද?';
      default:
        return '';
    }
  }

  String get _displayLetter {
    switch (_step) {
      case 0:
        return _pair['a']!;
      case 1:
        return _pair['b']!;
      case 2:
        return '${_pair['a']}  ${_pair['b']}';
      default:
        return '';
    }
  }

  // For quiz: randomly show A or B
  late String _quizTarget;
  late int _correctQuizAnswer; // 0 = first option = A, 1 = second option = B

  void _initQuiz() {
    final showA = DateTime.now().millisecond % 2 == 0;
    _quizTarget = showA ? _pair['a']! : _pair['b']!;
    _correctQuizAnswer = showA ? 0 : 1;
    _quizAnswer = null;
    _quizAnswered = false;
  }

  @override
  void dispose() {
    _recognizer1.close();
    super.dispose();
  }

  Future<void> _submitWriting() async {
    if (_strokes.isEmpty) return;
    setState(() => _isRecognizing = true);
    try {
      final ink = mlkit.Ink();
      for (final stroke in _strokes) {
        final points = stroke.map((o) => mlkit.StrokePoint(
          x: o.dx, y: o.dy, t: DateTime.now().millisecondsSinceEpoch,
        )).toList();
        if (points.isNotEmpty) ink.strokes.add(mlkit.Stroke()..points.addAll(points));
      }
      final candidates = await _recognizer1.recognize(ink);
      final recognized = candidates.isNotEmpty ? candidates.first.text.trim() : '';
      final bool correct;
      if (_step == 2) {
        correct = recognized.contains(_pair['a']!) && recognized.contains(_pair['b']!);
      } else {
        correct = recognized == (_step == 0 ? _pair['a']! : _pair['b']!);
      }
      setState(() { _isCorrect = correct; _isRecognizing = false; });
      if (correct) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        setState(() {
          _strokes = [];
          _isCorrect = null;
          if (_step < 2) {
            _step++;
          } else {
            _step = 3;
            _initQuiz();
          }
        });
      }
    } catch (_) {
      setState(() { _isCorrect = null; _isRecognizing = false; });
    }
  }

  void _answerQuiz(int choice) {
    if (_quizAnswered) return;
    final correct = choice == _correctQuizAnswer;
    setState(() {
      _quizAnswer = choice;
      _quizAnswered = true;
      if (correct) _score++;
    });
    Future.delayed(const Duration(seconds: 2), _nextPair);
  }

  void _nextPair() {
    if (!mounted) return;
    if (_pairIndex < _confusablePairs.length - 1) {
      setState(() {
        _pairIndex++;
        _step = 0;
        _strokes = [];
        _quizAnswer = null;
        _quizAnswered = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _score >= _confusablePairs.length * 0.7 ? '🌟' : '💪',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 12),
            Text(
              'ප්‍රශ්නාගාරය: $_score / ${_confusablePairs.length} හරි!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('ඉවරයි',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress =
    ((_pairIndex * 4 + _step) / (_confusablePairs.length * 4))
        .clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.cyan.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.teal),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'සමාන අකුරු 🔄',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            '⭐ $_score',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.teal.shade100,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.teal),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Pair display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.teal.shade100,
                            Colors.cyan.shade100
                          ]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _pair['a']!,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: _step == 0
                                    ? Colors.teal
                                    : Colors.teal.shade200,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              'vs',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              _pair['b']!,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: _step == 1
                                    ? Colors.indigo
                                    : Colors.indigo.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Step chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.teal.shade300),
                        ),
                        child: Text(
                          'පියවර ${_step + 1}/4 — $_stepInstruction',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_step < 3) ...[
                        // Writing steps
                        if (_step < 3)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _displayLetter,
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.teal.shade300, width: 3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Listener(
                              onPointerDown: (e) => setState(
                                      () => _strokes.add([e.localPosition])),
                              onPointerMove: (e) => setState(
                                      () => _strokes.last.add(e.localPosition)),
                              child: Stack(
                                children: [
                                  CustomPaint(
                                      size: Size.infinite,
                                      painter: _StrokePainter(_strokes)),
                                  if (_strokes.isEmpty)
                                    Center(
                                      child: Text(
                                        '$_displayLetter ලියන්න ✍️',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (_isRecognizing)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.teal),
                                SizedBox(width: 12),
                                Text('පරීක්ෂා කරමින්...', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          )
                        else ...[
                          if (_isCorrect == true)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade300, width: 2),
                              ),
                              child: const Text('✅ නිවැරදියි!',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                            )
                          else if (_isCorrect == false)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade300, width: 2),
                              ),
                              child: Column(
                                children: [
                                  const Text('❌ වැරදියි! නැවත ලිවීමට උත්සාහ කරන්න.',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('හරි අකුර: $_displayLetter',
                                    style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      setState(() { _strokes = []; _isCorrect = null; }),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('මකන්න',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade400,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                  _strokes.isEmpty || _isRecognizing ? null : _submitWriting,
                                  icon: const Icon(Icons.arrow_forward),
                                  label: Text(
                                      _step < 2 ? 'ඊළඟ' : 'ප්‍රශ්නාගාරය',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ] else ...[
                        // Quiz step
                        const Text(
                          'මෙම අකුර:',
                          style: TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border:
                            Border.all(color: Colors.teal.shade200, width: 2),
                          ),
                          child: Text(
                            _quizTarget,
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [0, 1].map((choice) {
                            final letter =
                            choice == 0 ? _pair['a']! : _pair['b']!;
                            Color btnColor = Colors.white;
                            Color textColor = Colors.teal;
                            Color borderColor = Colors.teal.shade300;

                            if (_quizAnswered) {
                              if (choice == _correctQuizAnswer) {
                                btnColor = Colors.green.shade100;
                                textColor = Colors.green.shade800;
                                borderColor = Colors.green;
                              } else if (choice == _quizAnswer) {
                                btnColor = Colors.red.shade100;
                                textColor = Colors.red.shade800;
                                borderColor = Colors.red;
                              }
                            }

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _answerQuiz(choice),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.only(
                                      right: choice == 0 ? 8 : 0),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: btnColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: borderColor, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: borderColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    letter,
                                    style: TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        if (_quizAnswered) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _quizAnswer == _correctQuizAnswer
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _quizAnswer == _correctQuizAnswer
                                    ? Colors.green.shade300
                                    : Colors.orange.shade300,
                              ),
                            ),
                            child: Text(
                              _quizAnswer == _correctQuizAnswer
                                  ? '🎉 නිවැරදියි! ශාබාස!'
                                  : '💡 හරි අකුර: $_quizTarget',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _quizAnswer == _correctQuizAnswer
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 2 — BEAT YOUR TIME
// Child writes a word. Time recorded silently. On 2nd attempt,
// shows personal comparison only — never shows a benchmark.
// ─────────────────────────────────────────────────────────────────────────────

class BeatYourTimeActivity extends StatefulWidget {
  final List<String> words;
  const BeatYourTimeActivity({super.key, required this.words});

  @override
  State<BeatYourTimeActivity> createState() => _BeatYourTimeActivityState();
}

class _BeatYourTimeActivityState extends State<BeatYourTimeActivity> {
  int _currentIndex = 0;
  int _attempt = 0; // 0 = first try, 1 = second try
  List<List<Offset>> _strokes = [];
  double? _firstTime;
  double? _secondTime;
  DateTime? _startTime;
  bool _showResult = false;
  bool _isRecognizing2 = false;
  bool? _isCorrect2;
  final mlkit.DigitalInkRecognizer _recognizer2 =
  mlkit.DigitalInkRecognizer(languageCode: 'si');

  String get _currentWord => widget.words[_currentIndex];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _recognizer2.close();
    super.dispose();
  }

  void _clearCanvas() => setState(() { _strokes = []; _isCorrect2 = null; });

  Future<void> _submit() async {
    if (_strokes.isEmpty) return;
    final elapsed =
        DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    setState(() => _isRecognizing2 = true);
    try {
      final ink = mlkit.Ink();
      for (final stroke in _strokes) {
        final points = stroke.map((o) => mlkit.StrokePoint(
          x: o.dx, y: o.dy, t: DateTime.now().millisecondsSinceEpoch,
        )).toList();
        if (points.isNotEmpty) ink.strokes.add(mlkit.Stroke()..points.addAll(points));
      }
      final candidates = await _recognizer2.recognize(ink);
      final recognized = candidates.isNotEmpty ? candidates.first.text.trim() : '';
      final correct = recognized == _currentWord;
      setState(() { _isCorrect2 = correct; _isRecognizing2 = false; });
      if (correct) {
        setState(() {
          if (_attempt == 0) {
            _firstTime = elapsed;
            _strokes = [];
            _isCorrect2 = null;
            _attempt = 1;
            _startTime = DateTime.now();
          } else {
            _secondTime = elapsed;
            _showResult = true;
          }
        });
      }
    } catch (_) {
      setState(() { _isCorrect2 = null; _isRecognizing2 = false; });
      setState(() {
        if (_attempt == 0) {
          _firstTime = elapsed;
          _strokes = [];
          _attempt = 1;
          _startTime = DateTime.now();
        } else {
          _secondTime = elapsed;
          _showResult = true;
        }
      });
    }
  }

  void _nextWord() {
    if (_currentIndex < widget.words.length - 1) {
      setState(() {
        _currentIndex++;
        _attempt = 0;
        _strokes = [];
        _firstTime = null;
        _secondTime = null;
        _showResult = false;
        _startTime = DateTime.now();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('🏅', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'ඔබ සියලු වචන ලිවූමෙ!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('ඉවරයි',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex / widget.words.length).clamp(0.0, 1.0);
    final faster = _firstTime != null &&
        _secondTime != null &&
        _secondTime! < _firstTime!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.indigo),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'වේගය අභිෂ්ඨ ⏱️',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.indigo.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.indigo),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Word to write
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.indigo.shade100,
                            Colors.blue.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _attempt == 0
                                  ? 'මෙම වචනය ලියන්න:'
                                  : 'නැවත ලියන්න — වේගවත්ව!',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentWord,
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'උත්සාහය ${_attempt + 1} / 2',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Show result after 2nd attempt
                      if (_showResult) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: faster
                                ? [Colors.green.shade50, Colors.teal.shade50]
                                : [Colors.blue.shade50, Colors.indigo.shade50]),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: faster
                                  ? Colors.green.shade300
                                  : Colors.blue.shade300,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                faster ? '🚀 වේගවත් වුණා!' : '💪 ගොඩ!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: faster ? Colors.green : Colors.indigo,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildTimeChip(
                                      '1 වන', _firstTime!, Colors.grey),
                                  const Icon(Icons.arrow_forward,
                                      color: Colors.grey),
                                  _buildTimeChip(
                                      '2 වන',
                                      _secondTime!,
                                      faster ? Colors.green : Colors.indigo),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _nextWord,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('ඊළඟ වචනය',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Drawing canvas
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.indigo.shade300, width: 3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Listener(
                              onPointerDown: (e) => setState(
                                      () => _strokes.add([e.localPosition])),
                              onPointerMove: (e) => setState(
                                      () => _strokes.last.add(e.localPosition)),
                              child: Stack(
                                children: [
                                  CustomPaint(
                                      size: Size.infinite,
                                      painter: _StrokePainter(_strokes)),
                                  if (_strokes.isEmpty)
                                    Center(
                                      child: Text(
                                        '"$_currentWord" ලියන්න ✍️',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (_isRecognizing2)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.indigo),
                                SizedBox(width: 12),
                                Text('පරීක්ෂා කරමින්...', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          )
                        else ...[
                          if (_isCorrect2 == false)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade300, width: 2),
                              ),
                              child: Column(
                                children: [
                                  const Text('❌ වැරදියි! නැවත ලිවීමට උත්සාහ කරන්න.',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('හරි වඩනය: $_currentWord',
                                    style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _clearCanvas,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('මකන්න',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade400,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _strokes.isEmpty || _isRecognizing2 ? null : _submit,
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text('හරි!',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, double time, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Text(
            '${time.toStringAsFixed(1)}s',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 3 — SENTENCE COMPLETION
// First word of a Grade 3 sentence shown. Child writes the rest.
// ─────────────────────────────────────────────────────────────────────────────

class SentenceCompletionActivity extends StatefulWidget {
  const SentenceCompletionActivity({super.key});

  @override
  State<SentenceCompletionActivity> createState() =>
      _SentenceCompletionActivityState();
}

class _SentenceCompletionActivityState
    extends State<SentenceCompletionActivity> {
  int _currentIndex = 0;
  List<List<Offset>> _strokes = [];
  bool _submitted = false;
  bool _showHint = false;
  bool _isRecognizing3 = false;
  bool? _isCorrect3;
  final mlkit.DigitalInkRecognizer _recognizer3 =
  mlkit.DigitalInkRecognizer(languageCode: 'si');

  String get _starter => _grade3SentenceStarters[_currentIndex];
  String get _completion => _grade3SentenceCompletions[_currentIndex];

  @override
  void dispose() {
    _recognizer3.close();
    super.dispose();
  }

  void _clearCanvas() => setState(() { _strokes = []; _isCorrect3 = null; });

  Future<void> _submit() async {
    if (_strokes.isEmpty) return;
    setState(() => _isRecognizing3 = true);
    try {
      final ink = mlkit.Ink();
      for (final stroke in _strokes) {
        final points = stroke.map((o) => mlkit.StrokePoint(
          x: o.dx, y: o.dy, t: DateTime.now().millisecondsSinceEpoch,
        )).toList();
        if (points.isNotEmpty) ink.strokes.add(mlkit.Stroke()..points.addAll(points));
      }
      final candidates = await _recognizer3.recognize(ink);
      final recognized = candidates.isNotEmpty ? candidates.first.text.trim() : '';
      // The child writes only the completion part
      final correct = recognized.contains(_completion.replaceAll(RegExp(r'[^\u0D80-\u0DFF]'), '').trim());
      setState(() { _isCorrect3 = correct; _isRecognizing3 = false; });
      if (correct) setState(() => _submitted = true);
    } catch (_) {
      setState(() { _isCorrect3 = null; _isRecognizing3 = false; });
      setState(() => _submitted = true);
    }
  }

  void _next() {
    if (_currentIndex < _grade3SentenceStarters.length - 1) {
      setState(() {
        _currentIndex++;
        _strokes = [];
        _submitted = false;
        _showHint = false;
        _isCorrect3 = null;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('📝', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'සියලු වාක්‍ය ලිවීමෙ!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('ඉවරයි',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress =
    (_currentIndex / _grade3SentenceStarters.length).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.pink.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.purple),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'වාක්‍ය සම්පූර්ණ කිරීම 📝',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.purple.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.purple),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Sentence starter display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.purple.shade100,
                            Colors.pink.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.purple.shade300, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'වාක්‍ය ආරම්භය:',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  _starter,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                Text(
                                  '___________',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Hint toggle
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _showHint = !_showHint),
                        icon: Icon(
                          _showHint
                              ? Icons.visibility_off
                              : Icons.lightbulb_outline,
                          color: Colors.amber,
                          size: 18,
                        ),
                        label: Text(
                          _showHint ? 'ඉඟිය සඟවන්න' : 'ඉඟිය දකින්න',
                          style: const TextStyle(
                              color: Colors.amber, fontSize: 14),
                        ),
                      ),

                      if (_showHint)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Text(
                            '💡 ${"$_starter$_completion"}',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.amber,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Canvas
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.purple.shade300, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.purple.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Listener(
                            onPointerDown: (e) =>
                                setState(() => _strokes.add([e.localPosition])),
                            onPointerMove: (e) => setState(
                                    () => _strokes.last.add(e.localPosition)),
                            child: Stack(
                              children: [
                                CustomPaint(
                                    size: Size.infinite,
                                    painter: _MultilineBaselinePainter()),
                                CustomPaint(
                                    size: Size.infinite,
                                    painter: _StrokePainter(_strokes)),
                                if (_strokes.isEmpty)
                                  Center(
                                    child: Text(
                                      '$_starter ........ ✍️',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_submitted)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                Border.all(color: Colors.green.shade300),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'ලස්සනයි! ශාබාස!',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _next,
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('ඊළඟ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            if (_isRecognizing3)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: Colors.purple),
                                    SizedBox(width: 12),
                                    Text('පරීක්ෂා කරමින්...', style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              )
                            else ...[
                              if (_isCorrect3 == false)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.shade300, width: 2),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('❌ වැරදියි! නැවත ලිවීමට උත්සාහ කරන්න.',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text('හරි: \$_starter\$_completion',
                                        style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _clearCanvas,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('මකන්න',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange.shade400,
                                        foregroundColor: Colors.white,
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _strokes.isEmpty || _isRecognizing3 ? null : _submit,
                                      icon: const Icon(Icons.check_circle),
                                      label: const Text('හරි!',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        foregroundColor: Colors.white,
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 4 — SPOT AND FIX
// Show word with underlined "wrong" letter. Child taps it, then rewrites word.
// ─────────────────────────────────────────────────────────────────────────────

class SpotAndFixActivity extends StatefulWidget {
  const SpotAndFixActivity({super.key});

  @override
  State<SpotAndFixActivity> createState() => _SpotAndFixActivityState();
}

class _SpotAndFixActivityState extends State<SpotAndFixActivity> {
  int _currentIndex = 0;
  int _phase = 0; // 0=tap wrong letter, 1=write correct word
  int? _tappedLetterIndex;
  List<List<Offset>> _strokes = [];
  bool _submitted = false;
  int _score = 0;
  bool _isRecognizing4 = false;
  bool? _isCorrect4;
  final mlkit.DigitalInkRecognizer _recognizer4 =
  mlkit.DigitalInkRecognizer(languageCode: 'si');

  Map<String, dynamic> get _current => _spotFixData[_currentIndex];
  String get _wrongWord => _current['wrong'] as String;
  String get _correctWord => _current['correct'] as String;
  int get _wrongLetterIndex => _current['wrongLetterIndex'] as int;

  // Split word into tappable grapheme-like characters (simplified)
  List<String> _splitToChars(String word) {
    final chars = <String>[];
    for (int i = 0; i < word.length; i++) {
      chars.add(word[i]);
    }
    return chars;
  }

  void _tapLetter(int index) {
    if (_phase != 0) return;
    setState(() => _tappedLetterIndex = index);

    final isCorrect = index == _wrongLetterIndex ||
        (_wrongLetterIndex == -1); // -1 = no error, correct control word

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (isCorrect) {
        setState(() {
          _score++;
          _phase = 1;
        });
      } else {
        // Wrong tap — show correct, still proceed
        setState(() => _phase = 1);
      }
    });
  }

  @override
  void dispose() {
    _recognizer4.close();
    super.dispose();
  }

  Future<void> _submitWriting() async {
    if (_strokes.isEmpty) return;
    setState(() => _isRecognizing4 = true);
    try {
      final ink = mlkit.Ink();
      for (final stroke in _strokes) {
        final points = stroke.map((o) => mlkit.StrokePoint(
          x: o.dx, y: o.dy, t: DateTime.now().millisecondsSinceEpoch,
        )).toList();
        if (points.isNotEmpty) ink.strokes.add(mlkit.Stroke()..points.addAll(points));
      }
      final candidates = await _recognizer4.recognize(ink);
      final recognized = candidates.isNotEmpty ? candidates.first.text.trim() : '';
      final correct = recognized == _correctWord;
      setState(() { _isCorrect4 = correct; _isRecognizing4 = false; });
      if (correct) {
        setState(() => _submitted = true);
        Future.delayed(const Duration(milliseconds: 800), _next);
      }
    } catch (_) {
      setState(() { _isCorrect4 = null; _isRecognizing4 = false; });
      setState(() => _submitted = true);
      Future.delayed(const Duration(milliseconds: 800), _next);
    }
  }

  void _next() {
    if (!mounted) return;
    if (_currentIndex < _spotFixData.length - 1) {
      setState(() {
        _currentIndex++;
        _phase = 0;
        _tappedLetterIndex = null;
        _strokes = [];
        _submitted = false;
        _isCorrect4 = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔎', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              'ඔබ $_score / ${_spotFixData.length} හරි!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            child: const Text('ඉවරයි',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex / _spotFixData.length).clamp(0.0, 1.0);
    final chars = _splitToChars(_wrongWord);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepOrange.shade50, Colors.orange.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.deepOrange),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'දෝෂ සොයා නිරාකරණය 🔎',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            '⭐ $_score',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.orange.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.deepOrange),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_phase == 0) ...[
                        // Phase 1: Tap the wrong letter
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade300),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.touch_app, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'වැරදි අකුර ස්පර්ශ කරන්න:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Word with tappable letters
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(chars.length, (i) {
                            final isTapped = _tappedLetterIndex == i;
                            final isWrong = i == _wrongLetterIndex;
                            Color bg = Colors.white;
                            Color border = Colors.grey.shade300;

                            if (isTapped) {
                              bg = isWrong
                                  ? Colors.green.shade100
                                  : Colors.red.shade100;
                              border = isWrong ? Colors.green : Colors.red;
                            }

                            return GestureDetector(
                              onTap: () => _tapLetter(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                                width: 54,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                  Border.all(color: border, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: border.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    chars[i],
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: isTapped
                                          ? (isWrong
                                          ? Colors.green.shade700
                                          : Colors.red.shade700)
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 16),

                        // Underline hint for the wrong letter
                        if (_wrongLetterIndex >= 0)
                          Text(
                            '(${_wrongLetterIndex + 1} වන අකුරෙහි දෝෂයක් ඇත)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ] else ...[
                        // Phase 2: Write the correct word
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    'දැන් නිවැරදිව ලියන්න:',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _correctWord,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.green.shade300, width: 3),
                          ),
                          child: _submitted
                              ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('✅',
                                  style: TextStyle(fontSize: 56)),
                              Text(
                                'ශාබාස!',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Listener(
                              onPointerDown: (e) => setState(
                                      () => _strokes.add([e.localPosition])),
                              onPointerMove: (e) => setState(() =>
                                  _strokes.last.add(e.localPosition)),
                              child: Stack(
                                children: [
                                  CustomPaint(
                                      size: Size.infinite,
                                      painter: _BaselinePainter()),
                                  CustomPaint(
                                      size: Size.infinite,
                                      painter:
                                      _StrokePainter(_strokes)),
                                  if (_strokes.isEmpty)
                                    Center(
                                      child: Text(
                                        '"$_correctWord" ලියන්න ✍️',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (!_submitted)
                          Column(
                            children: [
                              if (_isRecognizing4)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(color: Colors.green),
                                      SizedBox(width: 12),
                                      Text('පරීක්ෂා කරමින්...', style: TextStyle(fontSize: 15)),
                                    ],
                                  ),
                                )
                              else ...[
                                if (_isCorrect4 == false)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red.shade300, width: 2),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text('❌ වැරදියි! නැවත ලිවීමට උත්සාහ කරන්න.',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text('හරි වචනය: \$_correctWord',
                                          style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            setState(() { _strokes = []; _isCorrect4 = null; }),
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('මකන්න',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange.shade400,
                                          foregroundColor: Colors.white,
                                          padding:
                                          const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(14)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed:
                                        _strokes.isEmpty || _isRecognizing4 ? null : _submitWriting,
                                        icon: const Icon(Icons.check_circle),
                                        label: const Text('හරි!',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding:
                                          const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(14)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                      ],
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// SHARED PAINTERS
// ─────────────────────────────────────────────────────────────────────────────

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _StrokePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade700
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    for (final path in strokes) {
      if (path.length < 2) continue;
      final p = Path();
      p.moveTo(path[0].dx, path[0].dy);
      for (int i = 1; i < path.length; i++) {
        p.lineTo(path[i].dx, path[i].dy);
      }
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}

class _BaselinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 5.0;
    final y = size.height / 2;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _MultilineBaselinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.15)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 5.0;
    const lines = 3;
    final spacing = size.height / (lines + 1);

    for (int l = 1; l <= lines; l++) {
      final y = spacing * l;
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
        x += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}