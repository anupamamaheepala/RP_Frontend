// grade3_medium_risk_activities.dart
// Grade 3 - Medium Risk Learning Plan Activities
// Activities: Free Copy, Word in Context, My Best One, Drag and Build

import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart' as mlkit;

// Grade 3 data
const List<String> _grade3Letters = ['ක', 'ග', 'ත', 'ද', 'ප', 'බ', 'ම', 'ය'];
const List<String> _grade3Words   = ['මල', 'ගස', 'පත', 'අත', 'අම්මා', 'තාත්තා'];

// Simple illustrations mapped to words (emoji stand-ins — replace with assets)
const Map<String, String> _wordEmojis = {
  'මල':     '🌸',
  'ගස':     '🌳',
  'පත':     '📄',
  'අත':     '🤚',
  'අම්මා':  '👩',
  'තාත්තා': '👨',
};

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY HUB
// ─────────────────────────────────────────────────────────────────────────────

class Grade3MediumRiskPage extends StatelessWidget {
  const Grade3MediumRiskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.yellow.shade50,
              Colors.green.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                          color: Colors.orange),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text(
                            'අකුරු පුහුණුව',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '3 ශ්‍රේණිය — මාධ්‍යම මට්ටම',
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
                      // Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.orange.shade100,
                            Colors.yellow.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: const Row(
                          children: [
                            Text('✏️', style: TextStyle(fontSize: 32)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'ලියන්න, ඉගෙන ගන්න, ශක්තිමත් වන්න!',
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildCard(
                        context: context,
                        emoji: '✍️',
                        title: 'අකුරු ලිවීම',
                        subtitle: 'අකුර බලා නිදහසේ ලියන්න',
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FreeCopyActivity(letters: _grade3Letters),
                          ),
                        ),
                      ),
                      _buildCard(
                        context: context,
                        emoji: '🖼️',
                        title: 'පින්තූරයෙන් ලිවීම',
                        subtitle: 'රූපය බලා වචනය ලියන්න',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WordInContextActivity(words: _grade3Words),
                          ),
                        ),
                      ),
                      _buildCard(
                        context: context,
                        emoji: '⭐',
                        title: 'හොඳම ලිවීම',
                        subtitle: '3 වාරයක් ලියා හොඳම එක තෝරන්න',
                        color: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MyBestOneActivity(
                                letters: _grade3Letters,
                                words: _grade3Words),
                          ),
                        ),
                      ),
                      _buildCard(
                        context: context,
                        emoji: '🧩',
                        title: 'වචන සාදමු',
                        subtitle: 'කොටස් ගෙනවිත් වචනය සාදන්න',
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DragAndBuildActivity(words: _grade3Words),
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
              offset: const Offset(0, 6)),
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
// ACTIVITY 1 — FREE COPY
// Letter shown at top, child writes below freely. No ghost.
// After submission, original stays alongside attempt.
// ─────────────────────────────────────────────────────────────────────────────

class FreeCopyActivity extends StatefulWidget {
  final List<String> letters;
  const FreeCopyActivity({super.key, required this.letters});

  @override
  State<FreeCopyActivity> createState() => _FreeCopyActivityState();
}

class _FreeCopyActivityState extends State<FreeCopyActivity> {
  int _currentIndex = 0;
  List<List<Offset>> _strokes = [];
  bool _submitted = false;
  bool _showCelebration = false;
  bool _isRecognizing = false;
  bool? _isCorrect;   // null = not checked yet, true = correct, false = wrong

  // ML Kit
  final mlkit.DigitalInkRecognizer _recognizer =
  mlkit.DigitalInkRecognizer(languageCode: 'si');

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }

  String get _currentLetter => widget.letters[_currentIndex];

  void _clearCanvas() {
    setState(() {
      _strokes = [];
      _isCorrect = null;
      _submitted = false;
    });
  }

  Future<void> _submit() async {
    if (_strokes.isEmpty) return;
    setState(() {
      _isRecognizing = true;
      _submitted = true;
    });

    try {
      final ink = mlkit.Ink();
      for (final stroke in _strokes) {
        final points = stroke
            .map((o) => mlkit.StrokePoint(
          x: o.dx,
          y: o.dy,
          t: DateTime.now().millisecondsSinceEpoch,
        ))
            .toList();
        if (points.isNotEmpty) ink.strokes.add(mlkit.Stroke()..points.addAll(points));
      }

      final candidates = await _recognizer.recognize(ink);
      final recognized = candidates.isNotEmpty
          ? candidates.first.text.trim()
          : '';

      setState(() {
        _isCorrect = recognized == _currentLetter;
        _isRecognizing = false;
      });
    } catch (_) {
      // If ML Kit fails, fall back to manual comparison
      setState(() {
        _isCorrect = null;
        _isRecognizing = false;
      });
    }
  }

  void _nextLetter({bool tryAgain = false}) {
    if (tryAgain) {
      setState(() {
        _strokes = [];
        _submitted = false;
        _isCorrect = null;
      });
      return;
    }

    setState(() => _showCelebration = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_currentIndex < widget.letters.length - 1) {
        setState(() {
          _currentIndex++;
          _strokes = [];
          _submitted = false;
          _showCelebration = false;
        });
      } else {
        _showCompletionDialog();
      }
    });
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
            Text('🎊', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'සියලු අකුරු ලිවීමෙ!',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('ඉවරයි',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex / widget.letters.length).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.amber.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(
                  context, 'අකුරු ලිවීම ✍️', Colors.orange, progress,
                  widget.letters.length),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Reference letter (always visible)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.orange.shade100,
                            Colors.amber.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(16),
                          border:
                          Border.all(color: Colors.orange.shade300, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'මේ අකුර ලියන්න:',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentLetter,
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Drawing canvas
                      if (_showCelebration)
                        Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.amber.shade300, width: 3),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🌟', style: TextStyle(fontSize: 64)),
                              Text(
                                'ඉතා හොඳ!',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.orange.shade300, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                                    painter: _StrokePainter(_strokes),
                                  ),
                                  if (_strokes.isEmpty)
                                    const Center(
                                      child: Text(
                                        'මෙහි ලියන්න ✍️',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // After submission — ML Kit result feedback
                      if (_submitted && !_showCelebration) ...[
                        if (_isRecognizing)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 12),
                                Text('පරීක්ෂා කරමින්...', style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          )
                        else ...[
                          // Result banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isCorrect == true
                                  ? Colors.green.shade50
                                  : _isCorrect == false
                                  ? Colors.red.shade50
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isCorrect == true
                                    ? Colors.green.shade300
                                    : _isCorrect == false
                                    ? Colors.red.shade300
                                    : Colors.blue.shade200,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _isCorrect == true
                                      ? '🎉 නිවැරදියි!'
                                      : _isCorrect == false
                                      ? '💪 නැවත උත්සාහ කරන්න!'
                                      : '👀 සසඳා බලන්න',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: _isCorrect == true
                                        ? Colors.green.shade700
                                        : _isCorrect == false
                                        ? Colors.red.shade700
                                        : Colors.blue.shade700,
                                  ),
                                ),
                                if (_isCorrect == false) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'හරි අකුර: $_currentLetter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _nextLetter(tryAgain: true),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('නැවත ලිය',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isCorrect == true ? () => _nextLetter() : null,
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('ඊළඟ අකුර',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey.shade300,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ] else if (!_showCelebration) ...[
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
                                onPressed: _strokes.isEmpty || _isRecognizing ? null : _submit,
                                icon: const Icon(Icons.check_circle),
                                label: const Text('ඉදිරිපත් කරන්න',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
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
// ACTIVITY 2 — WORD IN CONTEXT
// Picture shown + word below. Child copies the word.
// On completion, the picture animates as reward.
// ─────────────────────────────────────────────────────────────────────────────

class WordInContextActivity extends StatefulWidget {
  final List<String> words;
  const WordInContextActivity({super.key, required this.words});

  @override
  State<WordInContextActivity> createState() => _WordInContextActivityState();
}

class _WordInContextActivityState extends State<WordInContextActivity>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<List<Offset>> _strokes = [];
  bool _showReward = false;
  bool _isRecognizing2 = false;
  bool? _isCorrect2;
  final mlkit.DigitalInkRecognizer _recognizer2 =
  mlkit.DigitalInkRecognizer(languageCode: 'si');
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation =
        CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _recognizer2.close();
    super.dispose();
  }

  String get _currentWord => widget.words[_currentIndex];
  String get _currentEmoji => _wordEmojis[_currentWord] ?? '📝';

  void _clearCanvas() => setState(() { _strokes = []; _isCorrect2 = null; });

  Future<void> _submit() async {
    if (_strokes.isEmpty) return;
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
      setState(() {
        _isCorrect2 = recognized == _currentWord;
        _isRecognizing2 = false;
      });
      if (_isCorrect2 == true) {
        setState(() => _showReward = true);
        _bounceController.forward(from: 0);
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          if (_currentIndex < widget.words.length - 1) {
            setState(() {
              _currentIndex++;
              _strokes = [];
              _showReward = false;
              _isCorrect2 = null;
            });
            _bounceController.reset();
          } else {
            _showCompletionDialog();
          }
        });
      }
    } catch (_) {
      setState(() { _isCorrect2 = null; _isRecognizing2 = false; });
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
            Text('🌈', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'ඔබ සියලු වචන ලිවීමෙ!',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.teal.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(
                  context, 'පින්තූරයෙන් ලිවීම 🖼️', Colors.green, progress,
                  widget.words.length),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Picture + word card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.green.shade100,
                            Colors.teal.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(20),
                          border:
                          Border.all(color: Colors.green.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ScaleTransition(
                              scale: _showReward
                                  ? _bounceAnimation
                                  : const AlwaysStoppedAnimation(1.0),
                              child: Text(
                                _currentEmoji,
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _currentWord,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'මෙම වචනය ලියන්න',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Canvas
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                          Border.all(color: Colors.green.shade300, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _showReward
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('⭐', style: TextStyle(fontSize: 56)),
                            Text(
                              'ලස්සනයි!',
                              style: TextStyle(
                                  fontSize: 22,
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
                                // Guideline
                                CustomPaint(
                                  size: Size.infinite,
                                  painter: _BaselinePainter(),
                                ),
                                CustomPaint(
                                  size: Size.infinite,
                                  painter: _StrokePainter(_strokes),
                                ),
                                if (_strokes.isEmpty)
                                  const Center(
                                    child: Text(
                                      'වචනය මෙහි ලියන්න ✍️',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (!_showReward) ...[
                        if (_isRecognizing2)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
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
                                  Text('හරි වචනය: $_currentWord',
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
                                    backgroundColor: Colors.green,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 3 — MY BEST ONE
// Child writes same letter/word 3 times in 3 boxes.
// Taps the one they think looks best. Gets a star saved.
// ─────────────────────────────────────────────────────────────────────────────

class MyBestOneActivity extends StatefulWidget {
  final List<String> letters;
  final List<String> words;
  const MyBestOneActivity(
      {super.key, required this.letters, required this.words});

  @override
  State<MyBestOneActivity> createState() => _MyBestOneActivityState();
}

class _MyBestOneActivityState extends State<MyBestOneActivity> {
  int _currentIndex = 0;
  bool _useLetters = true; // alternates between letters and words
  int _activeBox = 0; // which of the 3 boxes is active
  List<List<List<Offset>>> _boxStrokes = [[], [], []]; // strokes per box
  int? _selectedBest;
  bool _submitted = false;
  int _starsEarned = 0;

  List<String> get _items =>
      _useLetters ? widget.letters : widget.words;
  String get _currentItem => _items[_currentIndex];

  void _clearBox(int box) {
    setState(() {
      _boxStrokes[box] = [];
      if (_submitted) {
        _submitted = false;
        _selectedBest = null;
      }
    });
  }

  void _selectBest(int box) {
    if (_boxStrokes[box].isEmpty) return;
    setState(() {
      _selectedBest = box;
      _submitted = true;
      _starsEarned++;
    });
    Future.delayed(const Duration(seconds: 2), _nextItem);
  }

  void _nextItem() {
    if (!mounted) return;
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _activeBox = 0;
        _boxStrokes = [[], [], []];
        _selectedBest = null;
        _submitted = false;
      });
    } else if (_useLetters) {
      // Switch to words
      setState(() {
        _useLetters = false;
        _currentIndex = 0;
        _activeBox = 0;
        _boxStrokes = [[], [], []];
        _selectedBest = null;
        _submitted = false;
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
          children: [
            const Text('🏅', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              'ඔබ ⭐ $_starsEarned ලකුණු ලබා ගත්තා!',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
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
    final totalItems = widget.letters.length + widget.words.length;
    final completedItems =
        (_useLetters ? 0 : widget.letters.length) + _currentIndex;
    final progress = (completedItems / totalItems).clamp(0.0, 1.0);

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
                            'හොඳම ලිවීම ⭐',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            '⭐ $_starsEarned',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Prompt
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.purple.shade100,
                            Colors.pink.shade100,
                          ]),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _useLetters ? 'මෙම අකුර 3 වාරයක් ලියන්න:' : 'මෙම වචනය 3 වාරයක් ලියන්න:',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _currentItem,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (!_submitted)
                        const Text(
                          'ලියා ඉවර වූ පසු, ඔබේ හොඳම ලිවීම ස්පර්ශ කරන්න',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      if (_submitted)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: const Text(
                            '🌟 ඔබේ හොඳම ලිවීමට ⭐ ලැබුණා!',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const SizedBox(height: 12),

                      // 3 writing boxes side by side
                      Row(
                        children: List.generate(3, (boxIndex) {
                          final isActive = _activeBox == boxIndex;
                          final isBest = _selectedBest == boxIndex;
                          final hasStrokes =
                              _boxStrokes[boxIndex].isNotEmpty;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_submitted) {
                                  setState(() => _activeBox = boxIndex);
                                } else if (hasStrokes) {
                                  _selectBest(boxIndex);
                                }
                              },
                              child: Container(
                                margin:
                                EdgeInsets.only(right: boxIndex < 2 ? 8 : 0),
                                height: 160,
                                decoration: BoxDecoration(
                                  color: isBest
                                      ? Colors.amber.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isBest
                                        ? Colors.amber
                                        : isActive
                                        ? Colors.purple
                                        : Colors.grey.shade300,
                                    width: isBest || isActive ? 3 : 2,
                                  ),
                                  boxShadow: [
                                    if (isActive || isBest)
                                      BoxShadow(
                                        color: isBest
                                            ? Colors.amber.withOpacity(0.3)
                                            : Colors.purple.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Listener(
                                        onPointerDown: (e) {
                                          if (_submitted) return;
                                          setState(() {
                                            _activeBox = boxIndex;
                                            _boxStrokes[boxIndex]
                                                .add([e.localPosition]);
                                          });
                                        },
                                        onPointerMove: (e) {
                                          if (_submitted) return;
                                          if (_activeBox != boxIndex) return;
                                          setState(() {
                                            _boxStrokes[boxIndex]
                                                .last
                                                .add(e.localPosition);
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            CustomPaint(
                                              size: Size.infinite,
                                              painter: _StrokePainter(
                                                  _boxStrokes[boxIndex]),
                                            ),
                                            if (_boxStrokes[boxIndex]
                                                .isEmpty)
                                              Center(
                                                child: Text(
                                                  '${boxIndex + 1}',
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    color: Colors.grey.shade300,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isBest)
                                      const Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Text('⭐',
                                            style:
                                            TextStyle(fontSize: 20)),
                                      ),
                                    if (!_submitted && hasStrokes)
                                      Positioned(
                                        bottom: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () =>
                                              _clearBox(boxIndex),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                                Icons.refresh,
                                                size: 16,
                                                color: Colors.grey),
                                          ),
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

                      if (!_submitted) ...[
                        const Text(
                          'ලිවීම ඉවර වූ පසු — හොඳම කොටුව ස්පර්ශ කරන්න',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _boxStrokes.any((b) => b.isNotEmpty)
                                ? () {
                              // Find first non-empty box and select as best
                              final firstFilled = _boxStrokes
                                  .indexWhere((b) => b.isNotEmpty);
                              if (firstFilled >= 0) {
                                _selectBest(firstFilled);
                              }
                            }
                                : null,
                            icon: const Icon(Icons.star),
                            label: const Text('හොඳම ලිවීම තෝරන්න',
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
// ACTIVITY 4 — DRAG AND BUILD
// Syllable tiles dragged to form the word, then child writes it.
// ─────────────────────────────────────────────────────────────────────────────

class DragAndBuildActivity extends StatefulWidget {
  final List<String> words;
  const DragAndBuildActivity({super.key, required this.words});

  @override
  State<DragAndBuildActivity> createState() => _DragAndBuildActivityState();
}

class _DragAndBuildActivityState extends State<DragAndBuildActivity> {
  int _currentIndex = 0;
  List<String?> _dropZones = [];
  List<String> _availableParts = [];
  bool _wordBuilt = false;
  bool _isWrongOrder = false;
  bool _writingPhase = false;
  List<List<Offset>> _strokes = [];
  bool _showFinalReward = false;
  bool _isWritingRecognizing = false;
  bool? _isWritingCorrect;
  final mlkit.DigitalInkRecognizer _writingRecognizer =
  mlkit.DigitalInkRecognizer(languageCode: 'si');

  // Split words into individual characters as "parts"
  static List<String> _splitWord(String word) {
    // Split Sinhala grapheme clusters simply by codepoints for now
    final chars = <String>[];
    for (int i = 0; i < word.length; i++) {
      chars.add(word[i]);
    }
    // Merge virama+following char into a single cluster (basic)
    final merged = <String>[];
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && (chars[i - 1] == '්' || chars[i].codeUnitAt(0) >= 0x0DCA)) {
        if (merged.isNotEmpty) merged.last = merged.last + chars[i];
      } else {
        merged.add(chars[i]);
      }
    }
    return merged.length >= 2 ? merged : [word, ''];
  }

  @override
  void initState() {
    super.initState();
    _initWord();
  }

  void _initWord() {
    final parts = _splitWord(widget.words[_currentIndex]);
    _availableParts = List.from(parts)..shuffle();
    _dropZones = List.filled(parts.length, null);
    _wordBuilt = false;
    _isWrongOrder = false;
    _writingPhase = false;
    _strokes = [];
    _showFinalReward = false;
    _isWritingCorrect = null;
  }

  @override
  void dispose() {
    _writingRecognizer.close();
    super.dispose();
  }

  bool get _isWordComplete =>
      _dropZones.every((z) => z != null) && !_dropZones.contains(null);

  bool get _isArrangementCorrect {
    final correct = _splitWord(widget.words[_currentIndex]);
    if (_dropZones.length != correct.length) return false;
    for (int i = 0; i < correct.length; i++) {
      if (_dropZones[i] != correct[i]) return false;
    }
    return true;
  }

  void _dropPart(String part, int zoneIndex) {
    // Return previous occupant to available
    final current = _dropZones[zoneIndex];
    setState(() {
      if (current != null) _availableParts.add(current);
      _availableParts.remove(part);
      _dropZones[zoneIndex] = part;
      if (_isWordComplete) {
        _wordBuilt = true;
        _isWrongOrder = !_isArrangementCorrect;
      }
    });
  }

  void _removePart(int zoneIndex) {
    final part = _dropZones[zoneIndex];
    if (part == null) return;
    setState(() {
      _availableParts.add(part);
      _dropZones[zoneIndex] = null;
      _wordBuilt = false;
      _isWrongOrder = false;
    });
  }

  Future<void> _submitWriting() async {
    if (_strokes.isEmpty) return;
    final correctWord = widget.words[_currentIndex];
    setState(() => _isWritingRecognizing = true);
    try {
      final ink = mlkit.Ink();
      for (final stroke in _strokes) {
        final points = stroke.map((o) => mlkit.StrokePoint(
          x: o.dx, y: o.dy, t: DateTime.now().millisecondsSinceEpoch,
        )).toList();
        if (points.isNotEmpty) ink.strokes.add(mlkit.Stroke()..points.addAll(points));
      }
      final candidates = await _writingRecognizer.recognize(ink);
      final recognized = candidates.isNotEmpty ? candidates.first.text.trim() : '';
      setState(() {
        _isWritingCorrect = recognized == correctWord;
        _isWritingRecognizing = false;
      });
      if (_isWritingCorrect == true) {
        setState(() => _showFinalReward = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          if (_currentIndex < widget.words.length - 1) {
            setState(() { _currentIndex++; _initWord(); });
          } else {
            _showCompletionDialog();
          }
        });
      }
    } catch (_) {
      setState(() { _isWritingCorrect = null; _isWritingRecognizing = false; });
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
            Text('🧩', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'සියලු වචන සාදා ලිවීමෙ!',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
    final correctWord = widget.words[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.indigo.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(
                  context, 'වචන සාදමු 🧩', Colors.blue, progress, widget.words.length),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Step indicator
                      Row(
                        children: [
                          _buildStepChip('1. සාදන්න',
                              !_writingPhase, Colors.blue),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              color: Colors.grey, size: 16),
                          const SizedBox(width: 8),
                          _buildStepChip('2. ලියන්න',
                              _writingPhase, Colors.green),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (!_writingPhase) ...[
                        // Build phase
                        const Text(
                          'කොටස් ඔබා වචනය සාදන්න:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Drop zones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_dropZones.length, (i) {
                            return DragTarget<String>(
                              onAccept: (part) => _dropPart(part, i),
                              builder: (ctx, candidates, rejected) {
                                final hasPart = _dropZones[i] != null;
                                return GestureDetector(
                                  onTap: hasPart ? () => _removePart(i) : null,
                                  child: Container(
                                    width: 60,
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: candidates.isNotEmpty
                                          ? Colors.blue.shade50
                                          : hasPart
                                          ? Colors.blue.shade100
                                          : Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      border: Border.all(
                                        color: candidates.isNotEmpty
                                            ? Colors.blue
                                            : hasPart
                                            ? Colors.blue.shade400
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _dropZones[i] ?? '',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: hasPart
                                              ? Colors.blue.shade700
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // Available draggable parts
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: _availableParts.map((part) {
                            return Draggable<String>(
                              data: part,
                              feedback: Material(
                                elevation: 6,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      part,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey.shade300,
                                      style: BorderStyle.values[1]),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.blue.shade300, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    part,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        if (_wordBuilt) ...[
                          if (_isWrongOrder) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade300, width: 2),
                              ),
                              child: Column(
                                children: [
                                  const Text('❌ අකුරු පිළිවෙල වැරදියි! නැවත සාදන්න.',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('හරි වචනය: $correctWord',
                                    style: TextStyle(fontSize: 14, color: Colors.red.shade700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => setState(() => _initWord()),
                                icon: const Icon(Icons.refresh),
                                label: const Text('නැවත සාදන්න',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    '"$correctWord" — ශාබාස!',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    setState(() => _writingPhase = true),
                                icon: const Icon(Icons.edit),
                                label: const Text('දැන් ලිවීමට',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ] else ...[
                        // Writing phase
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            'දැන් "$correctWord" ලියන්න:',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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
                                color: Colors.green.shade300, width: 3),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.green.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4)),
                            ],
                          ),
                          child: _showFinalReward
                              ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🧩',
                                  style: TextStyle(fontSize: 64)),
                              Text(
                                'ලස්සනයි!',
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
                                      painter:
                                      _BaselinePainter()),
                                  CustomPaint(
                                      size: Size.infinite,
                                      painter:
                                      _StrokePainter(_strokes)),
                                  if (_strokes.isEmpty)
                                    Center(
                                      child: Text(
                                        '"$correctWord" ලියන්න ✍️',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (!_showFinalReward) ...[
                          if (_isWritingRecognizing)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 12),
                                  Text('පරීක්ෂා කරමින්...', style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            )
                          else ...[
                            if (_isWritingCorrect == false)
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
                                    Text('හරි වචනය: ${widget.words[_currentIndex]}',
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
                                        setState(() { _strokes = []; _isWritingCorrect = null; }),
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
                                    _strokes.isEmpty || _isWritingRecognizing ? null : _submitWriting,
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

  Widget _buildStepChip(String label, bool active, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? color : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: active ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED HELPERS
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildHeader(
    BuildContext context, String title, Color color, double progress, int total) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: Colors.white,
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: color),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    ),
  );
}

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