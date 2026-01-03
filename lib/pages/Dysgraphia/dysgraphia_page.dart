import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dysgraphia_data.dart';
import 'package:rp_frontend/config.dart';

class DysgraphiaPage extends StatefulWidget {
  final String activityType;
  final int grade;

  const DysgraphiaPage({
    super.key,
    required this.activityType,
    required this.grade,
  });

  @override
  State<DysgraphiaPage> createState() => _DysgraphiaPageState();
}

class _DysgraphiaPageState extends State<DysgraphiaPage> with SingleTickerProviderStateMixin {
  late List<String> _prompts;
  int _currentIndex = 0;
  int _attemptsCompleted = 0;
  bool _isDrawing = false;
  List<List<Offset>> _currentStrokes = [];
  final List<List<List<Offset>>> _allStrokes = [];
  final List<double> _timesTaken = [];
  DateTime? _startTime; // FIXED: Added missing declaration
  String? _error;
  int _stars = 0;
  late AnimationController _celebrationController;
  final ScrollController _scrollController = ScrollController();
  bool _canScroll = true; // Control scroll behavior

  @override
  void initState() {
    super.initState();
    _initializePrompts();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startPrompt();
  }

  void _initializePrompts() {
    _prompts = DysgraphiaData.getPrompts(widget.grade, widget.activityType);
    if (_prompts.isEmpty) {
      _prompts = ['දෝෂයක්'];
    }
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLetter(String prompt) => prompt.length <= 2;
  bool _isWord(String prompt) => prompt.length > 2 && prompt.length <= 15;
  bool _isSentence(String prompt) => prompt.length > 15;
  int _maxAttempts() => 1;

  String _getTitle() {
    switch (widget.activityType) {
      case 'letters':
        return 'අකුරු ඉගෙනීම - ශ්‍රේණිය ${widget.grade}';
      case 'words':
        return 'වචන ලිවීම - ශ්‍රේණිය ${widget.grade}';
      case 'sentences':
        return 'වාක්‍ය ලිවීම - ශ්‍රේණිය ${widget.grade}';
      default:
        return 'ලිවීමේ වැඩහුළුව';
    }
  }

  String _getTip() {
    final prompt = _prompts[_currentIndex];
    if (_isLetter(prompt)) return 'මෙම අකුර පැහැදිලිව ලියන්න';
    if (_isWord(prompt)) return 'අකුරු අතර සමාන පරතරයක් තබන්න';
    return 'වාක්‍යය පැහැදිලිව හා සුමටව ලියන්න';
  }

  void _startPrompt() {
    if (_currentIndex >= _prompts.length) {
      _uploadAllData();
      return;
    }
    setState(() {
      _currentStrokes = [];
      _attemptsCompleted = 0;
      _startTime = DateTime.now();
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _canScroll = false; // Disable scrolling when drawing starts
      _currentStrokes.add([details.localPosition]);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;
    setState(() {
      _currentStrokes.last.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
      _canScroll = true; // Re-enable scrolling when drawing ends
    });
  }

  void _clearCanvas() {
    setState(() {
      _currentStrokes = [];
    });
  }

  void _submitAttempt() {
    if (_startTime == null || _currentStrokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('කරුණාකර පළමුව ලියන්න!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final timeTaken = DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    setState(() {
      _timesTaken.add(timeTaken);
      _allStrokes.add(List.from(_currentStrokes));
      _attemptsCompleted++;
      _currentStrokes = [];
      _startTime = DateTime.now(); // FIXED: Reset _startTime for next attempt

      if (_attemptsCompleted % _maxAttempts() == 0) {
        _stars++;
        _celebrationController.forward().then((_) => _celebrationController.reset());
        _currentIndex++;
        Future.delayed(const Duration(milliseconds: 600), _startPrompt);
      }
    });
  }

  Future<void> _uploadAllData() async {
    if (_allStrokes.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('ප්‍රතිඵල සැකසෙමින්...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );

    // FIXED: Loop over actual completed prompts to avoid index out of bounds (RangeError)
    final numCompleted = _allStrokes.length;
    final promptsData = <Map<String, dynamic>>[];
    for (int i = 0; i < numCompleted; i++) {
      promptsData.add({
        'prompt': _prompts[i], // Assumes _prompts[i] matches the i-th completed
        // FIXED: Wrap strokes in {'points': [...]} to match backend Stroke model
        'strokes': _allStrokes[i].map((path) => {
          'points': path.map((offset) => {
            'x': offset.dx.toDouble(), // Ensure double/float
            'y': offset.dy.toDouble(),
          }).toList(),
        }).toList(),
        'time_taken': _timesTaken[i],
      });
    }

    final data = {
      'grade': widget.grade,
      'activity_type': widget.activityType,
      'prompts_data': promptsData,
    };

    try {
      // Use Config.baseUrl for dynamic backend URL
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/dysgraphia/submit-writing'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print('Status: ${response.statusCode}');  // Add this
      print('Body: ${response.body}');  // Add this - shows validation errors
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['ok'] == true) {
          _error = null;
          _showResults();
        } else {
          setState(() => _error = responseBody['error'] ?? 'උඩුගත කිරීම අසාර්ථකයි');
        }
      } else {
        setState(() => _error = 'උඩුගත කිරීම අසාර්ථකයි (${response.statusCode})');
      }
    } catch (e) {
      Navigator.pop(context);
      setState(() => _error = 'දෝෂය: $e');
    }
  }

  void _showResults() {
    // FIXED: Guard against empty _timesTaken to avoid divide by zero
    final totalTime = _timesTaken.fold(0.0, (a, b) => a + b);
    final avgTime = _timesTaken.isNotEmpty ? (totalTime / _timesTaken.length) : 0.0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade100, Colors.blue.shade100],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'සුභ පැතුම්! 🎉',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'ඔබ වැඩ ${_prompts.length} ක් සම්පූර්ණ කළා!',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'ශ්‍රේණිය ${widget.grade} - ${_getActivityName()}',
                style: TextStyle(fontSize: 16, color: Colors.purple.shade700, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) => Icon(
                        i < _stars ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      )),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'සමස්ත කාලය: ${totalTime.toStringAsFixed(1)} තත්පර',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'සාමාන්‍ය කාලය: ${avgTime.toStringAsFixed(1)} තත්පර',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle),
                label: const Text('හරි', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getActivityName() {
    switch (widget.activityType) {
      case 'letters':
        return 'අකුරු ඉගෙනීම';
      case 'words':
        return 'වචන ලිවීම';
      case 'sentences':
        return 'වාක්‍ය ලිවීම';
      default:
        return '';
    }
  }

  Widget _buildDrawingArea() {
    final currentPrompt = _prompts[_currentIndex];
    final isLetter = _isLetter(currentPrompt);
    final isSentence = _isSentence(currentPrompt);

    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = MediaQuery.of(context).size.width;

    double canvasWidth;
    double canvasHeight;

    // Increased canvas heights for better writing space
    if (orientation == Orientation.landscape) {
      canvasWidth = screenWidth - 100;
      canvasHeight = isLetter ? 180 : (isSentence ? 450 : 250);
    } else {
      canvasWidth = screenWidth - 48;
      canvasHeight = isLetter ? 200 : (isSentence ? 600 : 320);
    }

    final canvasSize = Size(canvasWidth, canvasHeight);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if ((isSentence || _isWord(currentPrompt)) && orientation == Orientation.portrait)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.screen_rotation, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'තිරය කරකවා වැඩි ඉඩක් ලබා ගන්න',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (isLetter)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.blue.shade100],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade300, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'මෙම අකුර ලියන්න:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPrompt,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.blue.shade100],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade300, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'මෙය ලියන්න:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPrompt,
                    style: TextStyle(
                      fontSize: isSentence ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Drawing Canvas - Now with increased height
          Container(
            width: canvasSize.width,
            height: canvasSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.shade300, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Listener(
                onPointerDown: (details) {
                  _onPanStart(DragStartDetails(
                    localPosition: details.localPosition,
                    globalPosition: details.position,
                  ));
                },
                onPointerMove: (details) {
                  _onPanUpdate(DragUpdateDetails(
                    localPosition: details.localPosition,
                    globalPosition: details.position,
                    delta: details.delta,
                  ));
                },
                onPointerUp: (details) {
                  _onPanEnd(DragEndDetails());
                },
                child: Stack(
                  children: [
                    CustomPaint(
                      size: canvasSize,
                      painter: _BaselinePainter(
                        canvasSize,
                        isLetter ? 'letter' : _isWord(currentPrompt) ? 'word' : 'sentence',
                      ),
                    ),
                    CustomPaint(
                      size: canvasSize,
                      painter: _StrokePainter(_currentStrokes, canvasSize),
                    ),
                    if (_currentStrokes.isEmpty)
                      Center(
                        child: Text(
                          'මෙහි ලියන්න ✍️',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Clamp progress to 0.0-1.0 to avoid RangeError in LinearProgressIndicator
    final progress = (_currentIndex / _prompts.length).clamp(0.0, 1.0);

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
              Container(
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            _getTitle(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                                (i) => AnimatedScale(
                              scale: i < _stars ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                i < _stars ? Icons.star : Icons.star_border,
                                color: i < _stars ? Colors.amber : Colors.grey.shade300,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.purple.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                              minHeight: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_currentIndex/${_prompts.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // WRAPPED IN SingleChildScrollView for scrolling
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _canScroll ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade100, Colors.purple.shade100],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _getTip(), // FIXED: Now properly accessible
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      _buildDrawingArea(),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _clearCanvas,
                              icon: const Icon(Icons.refresh, size: 22),
                              label: const Text(
                                'මකන්න',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _submitAttempt,
                              icon: const Icon(Icons.check_circle, size: 22),
                              label: Text(
                                _attemptsCompleted < _maxAttempts() - 1 ? 'ඊළඟ' : 'හරි',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
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

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Size canvasSize;

  _StrokePainter(this.strokes, this.canvasSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade700
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    for (final path in strokes) {
      if (path.length < 2) continue;
      final pathPoints = Path();
      pathPoints.moveTo(path[0].dx, path[0].dy);
      for (int i = 1; i < path.length; i++) {
        pathPoints.lineTo(path[i].dx, path[i].dy);
      }
      canvas.drawPath(pathPoints, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BaselinePainter extends CustomPainter {
  final Size canvasSize;
  final String type;

  _BaselinePainter(this.canvasSize, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (type == 'letter' || type == 'word') {
      final y = canvasSize.height / 2;
      _drawDashedLine(canvas, dashPaint, Offset(0, y), Offset(canvasSize.width, y));
    } else {
      // More lines for sentences to guide writing
      final spacing = canvasSize.height / 5;
      for (int i = 1; i < 5; i++) {
        _drawDashedLine(
          canvas,
          dashPaint,
          Offset(0, spacing * i),
          Offset(canvasSize.width, spacing * i),
        );
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    const dashWidth = 8.0;
    const dashSpace = 5.0;
    double distance = (end - start).distance;
    double dashCount = (distance / (dashWidth + dashSpace)).floorToDouble();

    for (int i = 0; i < dashCount; i++) {
      double startX = start.dx + (end.dx - start.dx) * (i * (dashWidth + dashSpace) / distance);
      double startY = start.dy + (end.dy - start.dy) * (i * (dashWidth + dashSpace) / distance);
      double endX = start.dx + (end.dx - start.dx) * ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      double endY = start.dy + (end.dy - start.dy) * ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}