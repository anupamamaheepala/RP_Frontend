import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config.dart';
import '../../../../utils/sessions.dart';

class TaskAttentionGrid extends StatefulWidget {
  final int difficulty;
  final int sessionNumber;
  const TaskAttentionGrid(
      {super.key, required this.difficulty, required this.sessionNumber});

  @override
  State<TaskAttentionGrid> createState() => _TaskAttentionGridState();
}

class _TaskAttentionGridState extends State<TaskAttentionGrid> {
  List<String> _symbols = [];
  bool _isLoading = true;

  late int _gridSize;
  late int _timerSeconds;
  late String _targetSymbol;
  late List<String> _grid;

  int _hits = 0;
  int _misses = 0;
  int _falseAlarms = 0;
  int _totalTargets = 0;
  int _timeLeft = 0;
  bool _gameActive = false;
  bool _taskDone = false;
  Set<int> _tapped = {};

  // ✅ Added: response time tracking
  final List<int> _rts = [];
  DateTime? _gameStartTime;

  Timer? _timer;
  final Color secondaryPurple = const Color(0xFF6741D9);

  @override
  void initState() {
    super.initState();
    _gridSize = widget.difficulty == 1
        ? 3
        : widget.difficulty == 2
        ? 4
        : 5;
    _timerSeconds = widget.difficulty == 1
        ? 30
        : widget.difficulty == 2
        ? 25
        : 20;
    _loadSymbols();
  }

  Future<void> _loadSymbols() async {
    try {
      final String response = await rootBundle
          .loadString('assets/tasks_adhd/attention_grid_symbols.json');
      final data = await json.decode(response);
      setState(() {
        _symbols = List<String>.from(data['symbols']);
        _isLoading = false;
      });
      _buildGrid();
    } catch (e) {
      debugPrint("සංකේත පැටවීමේ දෝෂයකි: $e");
      setState(() {
        _symbols = ['⭐', '🔴', '🔵', '🟡', '🟢'];
        _isLoading = false;
      });
      _buildGrid();
    }
  }

  void _buildGrid() {
    if (_symbols.isEmpty) return;
    final rng = Random();
    _targetSymbol = _symbols[rng.nextInt(_symbols.length)];
    final others =
    _symbols.where((s) => s != _targetSymbol).toList();
    final total = _gridSize * _gridSize;
    _totalTargets = (total * 0.3).round();
    final cells = [
      ...List.filled(_totalTargets, _targetSymbol),
      ...List.generate(total - _totalTargets,
              (_) => others[rng.nextInt(others.length)]),
    ]..shuffle(rng);

    setState(() {
      _grid = cells;
      _tapped = {};
      _timeLeft = _timerSeconds;
      _gameActive = false;
      _hits = 0;
      _misses = 0;
      _falseAlarms = 0;
    });
  }

  void _startGame() {
    // ✅ Added: record game start time for RT calculation
    _gameStartTime = DateTime.now();
    setState(() => _gameActive = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 0) {
        t.cancel();
        _finishTask();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _handleCellTap(int index) {
    if (!_gameActive || _tapped.contains(index)) return;

    // ✅ Added: record response time from game start to this tap
    if (_gameStartTime != null) {
      _rts.add(
          DateTime.now().difference(_gameStartTime!).inMilliseconds);
    }

    HapticFeedback.selectionClick();
    setState(() => _tapped.add(index));

    if (_grid[index] == _targetSymbol) {
      _hits++;
    } else {
      _falseAlarms++;
    }
  }

  Future<void> _finishTask() async {
    if (_taskDone) return;
    _timer?.cancel();
    setState(() {
      _taskDone = true;
      _gameActive = false;
      _misses = _totalTargets - _hits; // targets the child never tapped
    });

    final url =
    Uri.parse("${Config.baseUrl}/learning-tasks/submit-result");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id":          Session.userId ?? "unknown",
          "grade":             Session.grade  ?? 3,
          "task_id":           "attention_grid",
          "difficulty":        widget.difficulty,
          "correct":           _hits,
          "wrong":             _falseAlarms,
          "premature":         _misses,       // ✅ Fixed: missed targets = inattention proxy
          "total_trials":      _totalTargets,
          "response_times_ms": _rts,          // ✅ Fixed: actual per-tap response times
          "session_number":    widget.sessionNumber,
        }),
      );
      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        _showResult(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showResult(Map<String, dynamic> data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('කාර්යය අවසන්! 🎉',
            textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ලකුණු: ${data['score_percent']}%',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(data['encouragement'] as String,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                'නිවැරදි: $_hits | මගහැරුණු: $_misses | වැරදි: $_falseAlarms',
                style:
                const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ආපසු යන්න'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('අවධාන පරීක්ෂාව — මට්ටම ${widget.difficulty}',
            style: TextStyle(
                color: secondaryPurple, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Timer + target
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('සෙවිය යුතු රූපය:',
                        style: TextStyle(color: Colors.grey)),
                    Text(_targetSymbol,
                        style: const TextStyle(fontSize: 40)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _timeLeft <= 5
                        ? Colors.red.withOpacity(0.1)
                        : secondaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'තත්පර $_timeLeft',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 5 ? Colors.red : secondaryPurple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridSize,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _grid.length,
                itemBuilder: (_, index) {
                  final isTapped = _tapped.contains(index);
                  final isTarget = _grid[index] == _targetSymbol;
                  Color? bg;
                  if (isTapped) {
                    bg = isTarget
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3);
                  }
                  return GestureDetector(
                    onTap: () => _handleCellTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bg ?? Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: secondaryPurple.withOpacity(0.15)),
                        boxShadow: [
                          BoxShadow(
                              color: secondaryPurple.withOpacity(0.05),
                              blurRadius: 4)
                        ],
                      ),
                      child: Center(
                        child: Text(_grid[index],
                            style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            if (!_gameActive && !_taskDone)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('ආරම්භ කරන්න',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chip('✅ $_hits', Colors.green),
                _chip('❌ $_falseAlarms', Colors.red),
                _chip('⏭️ $_misses', Colors.orange),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: 13)),
    );
  }
}