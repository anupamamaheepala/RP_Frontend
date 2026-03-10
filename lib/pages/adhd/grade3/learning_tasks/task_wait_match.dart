import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config.dart';
import '../../../../utils/sessions.dart';

class TaskWaitMatch extends StatefulWidget {
  final int difficulty;
  final int sessionNumber;
  const TaskWaitMatch(
      {super.key, required this.difficulty, required this.sessionNumber});

  @override
  State<TaskWaitMatch> createState() => _TaskWaitMatchState();
}

class _TaskWaitMatchState extends State<TaskWaitMatch> {
  // Data loaded from JSON
  List<Map<String, dynamic>> _shapes = [];
  bool _isLoading = true;

  int  _trial       = 0;
  int  _correct     = 0;
  int  _wrong       = 0;
  int  _premature   = 0;
  final List<int> _rts = [];

  String? _targetKey;
  String? _targetEmoji;
  bool    _showTarget   = false;
  bool    _canTap       = false;
  bool    _showOptions  = false;
  List<Map<String, dynamic>> _options = [];
  DateTime? _goTime;

  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);

  int get _totalTrials => widget.difficulty == 1 ? 8
      : widget.difficulty == 2 ? 10 : 12;

  int get _showDurationMs => widget.difficulty == 1 ? 3000
      : widget.difficulty == 2 ? 2000 : 1000;

  @override
  void initState() {
    super.initState();
    _loadShapeData();
  }

  // Fetch shapes from external JSON
  Future<void> _loadShapeData() async {
    try {
      final String response = await rootBundle.loadString('assets/tasks_adhd/wait_match_data.json');
      final data = await json.decode(response);
      setState(() {
        _shapes = List<Map<String, dynamic>>.from(data['shapes']);
        _isLoading = false;
      });
      _runTrial();
    } catch (e) {
      debugPrint("දත්ත පැටවීමේ දෝෂයකි: $e");
      // Fallback data if JSON fails
      setState(() {
        _shapes = [
          {'emoji': '🔴', 'key': 'red_circle'},
          {'emoji': '🔵', 'key': 'blue_circle'},
          {'emoji': '🟡', 'key': 'yellow_circle'},
        ];
        _isLoading = false;
      });
      _runTrial();
    }
  }

  Future<void> _runTrial() async {
    if (_trial >= _totalTrials) {
      _finishTask();
      return;
    }

    if (_shapes.isEmpty) return;

    final rng    = Random();
    final target = _shapes[rng.nextInt(_shapes.length)];
    final others = _shapes.where((s) => s['key'] != target['key']).toList()
      ..shuffle();

    final optionCount = widget.difficulty == 1 ? 2 : 3;
    final opts        = [target, ...others.take(optionCount - 1)]..shuffle();

    setState(() {
      _targetKey   = target['key'] as String;
      _targetEmoji = target['emoji'] as String;
      _showTarget  = true;
      _canTap      = false;
      _showOptions = false;
      _options     = opts.cast<Map<String, dynamic>>();
    });

    // Show target for N seconds
    await Future.delayed(Duration(milliseconds: _showDurationMs));
    if (!mounted) return;

    setState(() => _showTarget = false);

    // Brief pause before go signal
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() {
      _canTap      = true;
      _showOptions = true;
      _goTime      = DateTime.now();
    });
  }

  void _handleChoice(String key) {
    if (!_canTap) {
      _premature++;
      HapticFeedback.vibrate();
      return;
    }

    final rt = DateTime.now().difference(_goTime!).inMilliseconds;

    if (key == _targetKey) {
      _correct++;
      _rts.add(rt);
      HapticFeedback.lightImpact();
    } else {
      _wrong++;
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _canTap      = false;
      _showOptions = false;
      _trial++;
    });

    Future.delayed(const Duration(milliseconds: 500), _runTrial);
  }

  Future<void> _finishTask() async {
    final url = Uri.parse("${Config.baseUrl}/learning-tasks/submit-result");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id":          Session.userId ?? "unknown",
          "grade":             Session.grade  ?? 3,
          "task_id":           "wait_match",
          "difficulty":        widget.difficulty,
          "correct":           _correct,
          "wrong":             _wrong,
          "premature":         _premature,
          "total_trials":      _totalTrials,
          "response_times_ms": _rts,
          "session_number":    widget.sessionNumber,
        }),
      );
      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        _showResultDialog(data);
      }
    } catch (e) {
      debugPrint("Submit error: $e");
    }
  }

  void _showResultDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('මතකයෙන් ගැලපීම — මට්ටම ${widget.difficulty}',
            style: TextStyle(
                color: secondaryPurple, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _trial / _totalTrials,
            minHeight: 6,
            color: secondaryPurple,
            backgroundColor: Colors.grey[200],
          ),
          const Spacer(),

          // Target or go signal
          if (_showTarget)
            Column(
              children: [
                const Text('මෙම රූපය මතක තබා ගන්න!',
                    style: TextStyle(
                        fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(_targetEmoji ?? '',
                    style: const TextStyle(fontSize: 100)),
              ],
            )
          else if (!_showOptions)
            const Text('⏳ සූදානම් වන්න...',
                style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold))
          else
            Column(
              children: [
                const Text('ගැලපෙන රූපය තෝරන්න!',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: _options
                      .map((o) => GestureDetector(
                    onTap: () =>
                        _handleChoice(o['key'] as String),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: secondaryPurple
                                .withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                              color: secondaryPurple
                                  .withOpacity(0.08),
                              blurRadius: 8)
                        ],
                      ),
                      child: Center(
                        child: Text(o['emoji'] as String,
                            style: const TextStyle(
                                fontSize: 48)),
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),

          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _chip('✅ $_correct',  Colors.green),
              _chip('❌ $_wrong',    Colors.red),
              _chip('${_trial + 1}/$_totalTrials', Colors.grey),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color, fontSize: 15)),
    );
  }
}