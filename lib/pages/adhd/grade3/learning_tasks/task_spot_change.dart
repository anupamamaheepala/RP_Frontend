import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config.dart';
import '../../../../utils/sessions.dart';

class TaskSpotChange extends StatefulWidget {
  final int difficulty;
  final int sessionNumber;
  const TaskSpotChange(
      {super.key, required this.difficulty, required this.sessionNumber});

  @override
  State<TaskSpotChange> createState() => _TaskSpotChangeState();
}

class _TaskSpotChangeState extends State<TaskSpotChange> {
  // Data loaded from JSON
  List<List<String>> _scenePairs = [];
  bool _isLoading = true;

  int  _trial   = 0;
  int  _correct = 0;
  int  _wrong   = 0;
  int  _changeIndex = 0;
  List<String> _sceneA = [];
  List<String> _sceneB = [];

  // Timer variables
  DateTime? _startTime;
  Timer? _uiTimer;
  int _secondsElapsed = 0;
  final List<int> _rts = [];

  int get _totalTrials => widget.difficulty == 1 ? 5
      : widget.difficulty == 2 ? 8
      : 12;

  final Color secondaryPurple = const Color(0xFF6741D9);

  @override
  void initState() {
    super.initState();
    _loadSceneData();
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  // Fetch scene data from external JSON
  Future<void> _loadSceneData() async {
    try {
      final String response = await rootBundle.loadString('assets/tasks_adhd/spot_change_data.json');
      final data = await json.decode(response);
      setState(() {
        _scenePairs = (data['scenePairs'] as List)
            .map((item) => List<String>.from(item))
            .toList();
        _isLoading = false;
      });
      _loadTrial();
    } catch (e) {
      debugPrint("දත්ත පැටවීමේ දෝෂයකි: $e");
      // Fallback data if JSON fails
      setState(() {
        _scenePairs = [['🌳', '🌸', '🐦', '☀️', '🌳', '🌸', '🐕', '☀️']];
        _isLoading = false;
      });
      _loadTrial();
    }
  }

  void _startTimer() {
    _secondsElapsed = 0;
    _uiTimer?.cancel();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _loadTrial() {
    if (_trial >= _totalTrials) {
      _finishTask();
      return;
    }

    if (_scenePairs.isEmpty) return;

    final rng = Random();
    final pair = _scenePairs[rng.nextInt(_scenePairs.length)];

    setState(() {
      _sceneA      = pair.sublist(0, 4);
      _sceneB      = pair.sublist(4, 8);
      _changeIndex = -1;
      for (int i = 0; i < 4; i++) {
        if (_sceneA[i] != _sceneB[i]) _changeIndex = i;
      }
      _startTime = DateTime.now();
      _startTimer();
    });
  }

  void _handleTap(int index, bool isSceneB) {
    if (index == _changeIndex) {
      _uiTimer?.cancel();
      final endTime = DateTime.now();
      final duration = endTime.difference(_startTime!).inMilliseconds;
      _rts.add(duration);

      _correct++;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ නිවැරදියි! ඔබ වෙනස සොයාගත්තා!'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 800),
      ));

      setState(() => _trial++);
      Future.delayed(const Duration(milliseconds: 900), _loadTrial);
    } else {
      _wrong++;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('❌ වැරදියි, නැවත බලන්න...'),
        backgroundColor: Colors.orange,
        duration: Duration(milliseconds: 600),
      ));
    }
  }

  Future<void> _finishTask() async {
    _uiTimer?.cancel();
    final url = Uri.parse("${Config.baseUrl}/learning-tasks/submit-result");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id":          Session.userId ?? "unknown",
          "grade":             Session.grade  ?? 3,
          "task_id":           "spot_change",
          "difficulty":        widget.difficulty,
          "correct":           _correct,
          "wrong":             _wrong,
          "premature":         0,
          "total_trials":      _totalTrials,
          "response_times_ms": _rts,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('කාර්යය අවසන්! 🎉', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ලකුණු: ${data['score_percent']}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(data['encouragement'] as String, textAlign: TextAlign.center),
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
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('වෙනස සොයන්න — මට්ටම ${widget.difficulty}',
            style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _trial / _totalTrials,
              minHeight: 6,
              color: secondaryPurple,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),

            const Text('රූප දෙකේ වෙනස සොයා එය ස්පර්ශ කරන්න',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _buildScene(_sceneA, false, 'පළමු රූපය')),
                const SizedBox(width: 12),
                Expanded(child: _buildScene(_sceneB, true, 'දෙවන රූපය')),
              ],
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chip('⏱️ ${_secondsElapsed}s', Colors.blue),
                _chip('✅ $_correct', Colors.green),
                _chip('❌ $_wrong',   Colors.red),
                _chip('${_trial + 1}/$_totalTrials', Colors.grey),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScene(List<String> items, bool isB, String label) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: secondaryPurple)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: secondaryPurple.withOpacity(0.2)),
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: items.asMap().entries.map((e) {
              return GestureDetector(
                onTap: isB ? () => _handleTap(e.key, isB) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(e.value, style: const TextStyle(fontSize: 36)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
    );
  }
}