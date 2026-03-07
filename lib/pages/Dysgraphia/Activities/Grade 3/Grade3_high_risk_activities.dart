// grade3_high_risk_activities.dart
// Grade 3 - High Risk Learning Plan Activities
// Activities: Ghost Trace, Dot-to-Dot, Which One is Right, Watch and Copy

import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT — Hub page shown to High Risk Grade 3 students
// ─────────────────────────────────────────────────────────────────────────────

class Grade3HighRiskPage extends StatelessWidget {
  const Grade3HighRiskPage({super.key});

  // Grade 3 vowels only — start with the simplest letters
  static const List<String> _vowels = ['අ', 'ඇ', 'ඉ', 'උ', 'එ', 'ඔ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.orange.shade50, Colors.yellow.shade50],
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
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Text(
                            'අකුරු ඉගෙනීම',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '3 ශ්‍රේණිය — විශේෂ පුහුණුව',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
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
                      // Encouragement banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.amber.shade100, Colors.orange.shade100],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          children: [
                            const Text('🌟', style: TextStyle(fontSize: 32)),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'ඔබට පුළුවන්! එක් එක් අකුරු ඉගෙන ගමු.',
                                style: TextStyle(
                                  fontSize: 16,
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

                      _buildActivityCard(
                        context: context,
                        emoji: '👻',
                        title: 'අකුරු සොයා ගමු',
                        subtitle: 'රේඛා හරහා ඇඳීම',
                        color: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GhostTraceActivity(letters: _vowels),
                          ),
                        ),
                      ),

                      _buildActivityCard(
                        context: context,
                        emoji: '🔢',
                        title: 'ලප සම්බන්ධ කරමු',
                        subtitle: 'අංක අනුව ලප එකට සම්බන්ධ කරන්න',
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DotToDotActivity(letters: _vowels),
                          ),
                        ),
                      ),

                      _buildActivityCard(
                        context: context,
                        emoji: '🔍',
                        title: 'හරි අකුර කුමක්ද?',
                        subtitle: 'නිවැරදි අකුර තෝරන්න',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WhichOneIsRightActivity(letters: _vowels),
                          ),
                        ),
                      ),

                      _buildActivityCard(
                        context: context,
                        emoji: '👁️',
                        title: 'බලා ලියමු',
                        subtitle: 'අකුර බලා ඉගෙන ලියන්න',
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WatchAndCopyActivity(letters: _vowels),
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

  Widget _buildActivityCard({
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
          colors: [
            Color.lerp(color, Colors.white, 0.35)!,
            color,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 36)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 1 — GHOST TRACE
// Child traces over a faded ghost letter. Letter fills with colour as they draw.
// ─────────────────────────────────────────────────────────────────────────────

class GhostTraceActivity extends StatefulWidget {
  final List<String> letters;
  const GhostTraceActivity({super.key, required this.letters});

  @override
  State<GhostTraceActivity> createState() => _GhostTraceActivityState();
}

class _GhostTraceActivityState extends State<GhostTraceActivity>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<List<Offset>> _strokes = [];
  bool _isDrawing = false;
  bool _showCelebration = false;
  late AnimationController _celebrationController;
  late Animation<double> _celebrationScale;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _celebrationScale = CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  String get _currentLetter =>
      _currentIndex < widget.letters.length ? widget.letters[_currentIndex] : '';

  void _onPanStart(DragStartDetails d) {
    setState(() {
      _isDrawing = true;
      _strokes.add([d.localPosition]);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_isDrawing) return;
    setState(() => _strokes.last.add(d.localPosition));
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() => _isDrawing = false);
  }

  void _clearCanvas() {
    setState(() => _strokes = []);
  }

  void _submitTrace() {
    if (_strokes.isEmpty) return;

    setState(() => _showCelebration = true);
    _celebrationController.forward().then((_) {
      _celebrationController.reset();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        if (_currentIndex < widget.letters.length - 1) {
          setState(() {
            _currentIndex++;
            _strokes = [];
            _showCelebration = false;
          });
        } else {
          _showCompletionDialog();
        }
      });
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
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'ඔබ සියලු අකුරු ලියා ඉවර කළා!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ඉතා හොඳින් කළා! 🌟',
              style: TextStyle(fontSize: 16, color: Colors.amber.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ඉවරයි', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _strokes = [];
                _showCelebration = false;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('නැවත කරමු',
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
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                            'අකුරු සොයා ගමු 👻',
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
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.purple.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.purple),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_currentIndex + 1}/${widget.letters.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Instruction
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'රූ රේඛාව හරහා ඔබේ ඇඟිල්ල ගෙන යන්න',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Celebration overlay or canvas
                      if (_showCelebration)
                        ScaleTransition(
                          scale: _celebrationScale,
                          child: Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade100,
                                  Colors.orange.shade100
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🎉', style: TextStyle(fontSize: 72)),
                                SizedBox(height: 12),
                                Text(
                                  'ඉතා හොඳ!',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                      // Drawing canvas with ghost letter
                        Container(
                          width: double.infinity,
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.purple.shade300, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Listener(
                              onPointerDown: (e) => _onPanStart(
                                  DragStartDetails(
                                      localPosition: e.localPosition,
                                      globalPosition: e.position)),
                              onPointerMove: (e) => _onPanUpdate(
                                  DragUpdateDetails(
                                      localPosition: e.localPosition,
                                      globalPosition: e.position,
                                      delta: e.delta)),
                              onPointerUp: (_) => _onPanEnd(DragEndDetails()),
                              child: Stack(
                                children: [
                                  // Ghost letter background
                                  Center(
                                    child: Text(
                                      _currentLetter,
                                      style: TextStyle(
                                        fontSize: 160,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple.withOpacity(0.12),
                                      ),
                                    ),
                                  ),
                                  // User strokes
                                  CustomPaint(
                                    size: Size.infinite,
                                    painter: _GhostStrokePainter(_strokes),
                                  ),
                                  // Hint text when empty
                                  if (_strokes.isEmpty)
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 200),
                                          Text(
                                            'ඇඟිල්ල ගෙන යන්න ✍️',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400,
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

                      const SizedBox(height: 20),

                      // Letter label
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple.shade200),
                        ),
                        child: Text(
                          'අකුර: $_currentLetter',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _clearCanvas,
                              icon: const Icon(Icons.refresh),
                              label: const Text('මකන්න',
                                  style: TextStyle(
                                      fontSize: 16,
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
                              onPressed: _strokes.isEmpty ? null : _submitTrace,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('හරි!',
                                  style: TextStyle(
                                      fontSize: 16,
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

class _GhostStrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _GhostStrokePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade600
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0
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

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 2 — DOT TO DOT
// Numbered dots form the letter. Child taps dots in order.
// ─────────────────────────────────────────────────────────────────────────────

class DotToDotActivity extends StatefulWidget {
  final List<String> letters;
  const DotToDotActivity({super.key, required this.letters});

  @override
  State<DotToDotActivity> createState() => _DotToDotActivityState();
}

class _DotToDotActivityState extends State<DotToDotActivity> {
  int _currentIndex = 0;
  int _nextDot = 0;
  bool _showCelebration = false;
  List<Offset> _connectedPath = [];

  // Pre-defined dot positions for each vowel (normalized 0.0–1.0, scaled to canvas)
  // Each letter has key points that roughly form its shape
  static const Map<String, List<Offset>> _dotPositions = {
    'අ': [
      Offset(0.5, 0.15), Offset(0.7, 0.3), Offset(0.6, 0.5),
      Offset(0.4, 0.5),  Offset(0.3, 0.65), Offset(0.5, 0.8),
      Offset(0.7, 0.65),
    ],
    'ඇ': [
      Offset(0.5, 0.15), Offset(0.7, 0.3), Offset(0.6, 0.5),
      Offset(0.4, 0.5),  Offset(0.3, 0.65), Offset(0.5, 0.8),
      Offset(0.7, 0.65), Offset(0.75, 0.45),
    ],
    'ඉ': [
      Offset(0.5, 0.15), Offset(0.5, 0.4),
      Offset(0.35, 0.6), Offset(0.5, 0.75), Offset(0.65, 0.6),
    ],
    'උ': [
      Offset(0.35, 0.2), Offset(0.35, 0.55),
      Offset(0.5, 0.75), Offset(0.65, 0.55), Offset(0.65, 0.3),
    ],
    'එ': [
      Offset(0.65, 0.2), Offset(0.4, 0.2),
      Offset(0.35, 0.5), Offset(0.5, 0.7), Offset(0.7, 0.55),
    ],
    'ඔ': [
      Offset(0.5, 0.15), Offset(0.7, 0.35), Offset(0.7, 0.6),
      Offset(0.5, 0.8),  Offset(0.3, 0.6),  Offset(0.3, 0.35),
      Offset(0.5, 0.15),
    ],
  };

  String get _currentLetter => widget.letters[_currentIndex];

  List<Offset> get _scaledDots {
    const canvasW = 280.0;
    const canvasH = 280.0;
    final raw = _dotPositions[_currentLetter] ??
        [
          Offset(0.5, 0.2), Offset(0.7, 0.5), Offset(0.5, 0.8), Offset(0.3, 0.5)
        ];
    return raw
        .map((o) => Offset(o.dx * canvasW, o.dy * canvasH))
        .toList();
  }

  void _tapDot(int dotIndex) {
    if (dotIndex != _nextDot) return; // Must tap in order
    final dots = _scaledDots;
    setState(() {
      if (_connectedPath.isEmpty) {
        _connectedPath.add(dots[dotIndex]);
      } else {
        _connectedPath.add(dots[dotIndex]);
      }
      _nextDot++;

      if (_nextDot >= dots.length) {
        // All dots connected
        _showCelebration = true;
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          if (_currentIndex < widget.letters.length - 1) {
            setState(() {
              _currentIndex++;
              _nextDot = 0;
              _connectedPath = [];
              _showCelebration = false;
            });
          } else {
            _showCompletionDialog();
          }
        });
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
          children: [
            const Text('🌈', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'ලස්සනයි! සියලු අකුරු ලියා ඉවර!',
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
    final dots = _scaledDots;
    final progress = (_currentIndex / widget.letters.length).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.cyan.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
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
                              color: Colors.blue),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'ලප සම්බන්ධ කරමු 🔢',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.blue.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_currentIndex + 1}/${widget.letters.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Instruction
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.touch_app,
                                color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '1 සිට ${dots.length} දක්වා ලප අනුපිළිවෙලට ස්පර්ශ කරන්න',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Letter label
                      Text(
                        'අකුර: $_currentLetter',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Dot canvas
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                          Border.all(color: Colors.blue.shade300, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _showCelebration
                            ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🎉',
                                style: TextStyle(fontSize: 72)),
                            Text(
                              'ලස්සනයි!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                            : Stack(
                          children: [
                            // Ghost letter hint — IgnorePointer so it never blocks taps
                            IgnorePointer(
                              child: Center(
                                child: Text(
                                  _currentLetter,
                                  style: TextStyle(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.withOpacity(0.07),
                                  ),
                                ),
                              ),
                            ),
                            // Connected lines — IgnorePointer so paint never blocks taps
                            IgnorePointer(
                              child: CustomPaint(
                                size: const Size(300, 300),
                                painter: _DotLinePainter(_connectedPath),
                              ),
                            ),
                            // Dots — last in Stack so they sit on top and receive taps
                            ...List.generate(dots.length, (i) {
                              final isConnected = i < _nextDot;
                              final isNext = i == _nextDot;
                              return Positioned(
                                left: dots[i].dx - 20,
                                top: dots[i].dy - 20,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _tapDot(i),
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 300),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isConnected
                                          ? Colors.green
                                          : isNext
                                          ? Colors.blue
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isNext
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      boxShadow: isNext
                                          ? [
                                        BoxShadow(
                                          color: Colors.blue
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isConnected || isNext
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Reset button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _nextDot = 0;
                              _connectedPath = [];
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('නැවත උත්සාහ කරන්න',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
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
}

class _DotLinePainter extends CustomPainter {
  final List<Offset> path;
  _DotLinePainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2) return;
    final paint = Paint()
      ..color = Colors.green.shade400
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final p = Path();
    p.moveTo(path[0].dx, path[0].dy);
    for (int i = 1; i < path.length; i++) {
      p.lineTo(path[i].dx, path[i].dy);
    }
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 3 — WHICH ONE IS RIGHT?
// Three versions shown, child taps the correct one. No drawing.
// ─────────────────────────────────────────────────────────────────────────────

class WhichOneIsRightActivity extends StatefulWidget {
  final List<String> letters;
  const WhichOneIsRightActivity({super.key, required this.letters});

  @override
  State<WhichOneIsRightActivity> createState() =>
      _WhichOneIsRightActivityState();
}

class _WhichOneIsRightActivityState extends State<WhichOneIsRightActivity>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _score = 0;
  late AnimationController _shakeController;

  // Distorted versions for each vowel (wrong options shown alongside correct)
  static const Map<String, List<String>> _options = {
    'අ': ['ආ', 'අ', 'ඇ'],
    'ඇ': ['ඈ', 'ඇ', 'ඉ'],
    'ඉ': ['ඊ', 'උ', 'ඉ'],
    'උ': ['ඌ', 'උ', 'ඉ'],
    'එ': ['ඒ', 'ඔ', 'එ'],
    'ඔ': ['ඕ', 'ඔ', 'ඇ'],
  };

  // Correct answer index for each letter
  static const Map<String, int> _correctIndex = {
    'අ': 1, 'ඇ': 1, 'ඉ': 2, 'උ': 1, 'එ': 2, 'ඔ': 1,
  };

  String get _currentLetter => widget.letters[_currentIndex];

  List<String> get _currentOptions =>
      _options[_currentLetter] ?? [_currentLetter, 'ආ', 'ඈ'];

  int get _correctAnswerIndex => _correctIndex[_currentLetter] ?? 0;

  void _selectOption(int index) {
    if (_answered) return;
    final isCorrect = index == _correctAnswerIndex;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (isCorrect) _score++;
    });

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 1200), _nextQuestion);
    } else {
      // Shake animation or just delay then reveal correct
      Future.delayed(const Duration(milliseconds: 1800), _nextQuestion);
    }
  }

  void _nextQuestion() {
    if (!mounted) return;
    if (_currentIndex < widget.letters.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
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
              _score >= widget.letters.length * 0.7 ? '🌟' : '💪',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 12),
            Text(
              'ඔබ $_score / ${widget.letters.length} හරි!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _score >= widget.letters.length * 0.7
                  ? 'ඉතා හොඳ! ඔබ දිනාගත්තා!'
                  : 'නැවත උත්සාහ කරමු!',
              style: TextStyle(
                fontSize: 15,
                color: _score >= widget.letters.length * 0.7
                    ? Colors.green
                    : Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ඉවරයි', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _selectedIndex = null;
                _answered = false;
                _score = 0;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('නැවත කරමු',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = _currentOptions;
    final progress = (_currentIndex / widget.letters.length).clamp(0.0, 1.0);

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
              // Header
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
                              color: Colors.green),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'හරි අකුර කුමක්ද? 🔍',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '⭐ $_score',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.green.shade100,
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Question
                      const Text(
                        'හරි "_currentLetter_" අකුර කොයිද?',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"$_currentLetter" — කොයි අකුරද හරි?',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Three option cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (i) {
                          Color cardColor = Colors.white;
                          Color borderColor = Colors.grey.shade300;
                          Color textColor = Colors.black87;

                          if (_answered) {
                            if (i == _correctAnswerIndex) {
                              cardColor = Colors.green.shade100;
                              borderColor = Colors.green;
                              textColor = Colors.green.shade800;
                            } else if (i == _selectedIndex &&
                                i != _correctAnswerIndex) {
                              cardColor = Colors.red.shade100;
                              borderColor = Colors.red;
                              textColor = Colors.red.shade800;
                            }
                          } else if (_selectedIndex == i) {
                            cardColor = Colors.blue.shade100;
                            borderColor = Colors.blue;
                          }

                          return GestureDetector(
                            onTap: () => _selectOption(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 90,
                              height: 110,
                              decoration: BoxDecoration(
                                color: cardColor,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    options[i],
                                    style: TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  if (_answered &&
                                      i == _correctAnswerIndex)
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 20),
                                  if (_answered &&
                                      i == _selectedIndex &&
                                      i != _correctAnswerIndex)
                                    const Icon(Icons.cancel,
                                        color: Colors.red, size: 20),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 32),

                      if (_answered)
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _selectedIndex == _correctAnswerIndex
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedIndex == _correctAnswerIndex
                                    ? Colors.green.shade300
                                    : Colors.orange.shade300,
                              ),
                            ),
                            child: Text(
                              _selectedIndex == _correctAnswerIndex
                                  ? '🎉 නිවැරදියි! ඉතා හොඳ!'
                                  : '💡 හරි අකුර: $_currentLetter — ශ්‍රේණිය ${_correctAnswerIndex + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedIndex == _correctAnswerIndex
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                              textAlign: TextAlign.center,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY 4 — WATCH AND COPY
// Animated stroke-by-stroke demo, then child draws from memory.
// ─────────────────────────────────────────────────────────────────────────────

class WatchAndCopyActivity extends StatefulWidget {
  final List<String> letters;
  const WatchAndCopyActivity({super.key, required this.letters});

  @override
  State<WatchAndCopyActivity> createState() => _WatchAndCopyActivityState();
}

class _WatchAndCopyActivityState extends State<WatchAndCopyActivity>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isWatching = true; // true = watch animation, false = draw
  bool _animationPlaying = false;
  List<List<Offset>> _strokes = [];
  bool _showCelebration = false;

  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String get _currentLetter => widget.letters[_currentIndex];

  void _playAnimation() {
    setState(() => _animationPlaying = true);
    _progressController.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() => _animationPlaying = false);
    });
  }

  void _switchToDrawing() {
    setState(() {
      _isWatching = false;
      _strokes = [];
    });
  }

  void _clearCanvas() => setState(() => _strokes = []);

  void _submitDrawing() {
    if (_strokes.isEmpty) return;
    setState(() => _showCelebration = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_currentIndex < widget.letters.length - 1) {
        setState(() {
          _currentIndex++;
          _isWatching = true;
          _strokes = [];
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
            Text('🏆', style: TextStyle(fontSize: 64)),
            SizedBox(height: 12),
            Text(
              'ඔබ සියලු අකුරු ඉගෙන ගත්තා!',
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
              // Header
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
                              color: Colors.orange),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'බලා ලියමු 👁️',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.orange.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.orange),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_currentIndex + 1}/${widget.letters.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Step indicator
                      Row(
                        children: [
                          _buildStepChip(
                              '1. බලන්න', _isWatching, Colors.orange),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward,
                              color: Colors.grey, size: 16),
                          const SizedBox(width: 8),
                          _buildStepChip(
                              '2. ලියන්න', !_isWatching, Colors.green),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (_isWatching) ...[
                        // Watch phase
                        const Text(
                          'මේ අකුර හොඳින් බලන්න:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 16),

                        // Letter display with animation hint
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.orange.shade300, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                _currentLetter,
                                style: TextStyle(
                                  fontSize: 160,
                                  fontWeight: FontWeight.bold,
                                  color: _animationPlaying
                                      ? Colors.orange.shade300
                                      : Colors.orange.shade700,
                                ),
                              ),
                              if (_animationPlaying)
                                AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (_, __) => Container(
                                    width: 280,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(17),
                                      gradient: SweepGradient(
                                        startAngle: -math.pi / 2,
                                        endAngle:
                                        -math.pi / 2 + 2 * math.pi,
                                        colors: [
                                          Colors.orange.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                        stops: [
                                          _progressController.value,
                                          _progressController.value,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                _animationPlaying ? null : _playAnimation,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('නැවත බලන්න',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
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
                                onPressed: _switchToDrawing,
                                icon: const Icon(Icons.edit),
                                label: const Text('ලිව්වාට සූදානම්!',
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
                      ] else ...[
                        // Draw phase
                        const Text(
                          'දැන් ඔබ ලියන්න — අකුර බලන්නේ නැතිව:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 16),

                        // Drawing canvas
                        Container(
                          width: double.infinity,
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.green.shade300, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: _showCelebration
                              ? const Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text('⭐',
                                  style: TextStyle(fontSize: 72)),
                              Text(
                                'ඉතා හොඳ!',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Listener(
                              onPointerDown: (e) {
                                setState(() {
                                  _strokes
                                      .add([e.localPosition]);
                                });
                              },
                              onPointerMove: (e) {
                                setState(() {
                                  _strokes.last
                                      .add(e.localPosition);
                                });
                              },
                              child: Stack(
                                children: [
                                  CustomPaint(
                                    size: Size.infinite,
                                    painter:
                                    _GhostStrokePainter(_strokes),
                                  ),
                                  if (_strokes.isEmpty)
                                    const Center(
                                      child: Text(
                                        'මෙහි ලියන්න ✍️',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

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
                                      borderRadius:
                                      BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                _strokes.isEmpty ? null : _submitDrawing,
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

                        const SizedBox(height: 12),

                        // Peek button
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _isWatching = true),
                          icon: const Icon(Icons.visibility,
                              color: Colors.orange),
                          label: const Text(
                            'අකුර නැවත බලන්න',
                            style: TextStyle(
                                color: Colors.orange, fontSize: 15),
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

  Widget _buildStepChip(String label, bool active, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? color : Colors.grey.shade300,
        ),
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