import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config.dart';
import '../../../../utils/sessions.dart';

class TaskGoNoGo extends StatefulWidget {
  final int difficulty;
  final int sessionNumber;
  const TaskGoNoGo(
      {super.key, required this.difficulty, required this.sessionNumber});

  @override
  State<TaskGoNoGo> createState() => _TaskGoNoGoState();
}

class _TaskGoNoGoState extends State<TaskGoNoGo> {
  // Data loaded from JSON
  List<String> _goAnimals = [];
  List<String> _noGoAnimals = [];
  Map<String, String> _emojiMap = {};
  bool _isLoading = true;

  final List<Map<String, dynamic>> _trials = [];
  int _currentTrial = 0;
  bool _waitingForTap = false;
  bool _taskDone = false;
  String? _currentAnimal;
  bool _isNoGo = false;
  DateTime? _stimulusTime;

  int _correct = 0;
  int _wrong = 0;
  int _premature = 0;
  final List<int> _rts = [];

  late final AudioPlayer _player;
  final Color primaryBg = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);

  int get _totalTrials => widget.difficulty == 1 ? 10
      : widget.difficulty == 2 ? 14 : 18;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadAssetData();
  }

  // Load animal data and emojis from external JSON
  Future<void> _loadAssetData() async {
    try {
      final String response = await rootBundle.loadString('assets/tasks_adhd/gonogo_assets.json');
      final data = await json.decode(response);
      final List animals = data['animals'];

      setState(() {
        for (var a in animals) {
          _emojiMap[a['id']] = a['emoji'];
          if (a['isGo']) {
            _goAnimals.add(a['id']);
          } else {
            _noGoAnimals.add(a['id']);
          }
        }
        _isLoading = false;
      });

      _buildTrials();
      _runNextTrial();
    } catch (e) {
      debugPrint("දත්ත පැටවීමේ දෝෂයකි: $e");
      // Fallback data
      setState(() {
        _goAnimals = ['dog', 'bird'];
        _noGoAnimals = ['cat'];
        _emojiMap = {'dog': '🐕', 'bird': '🐦', 'cat': '🐈'};
        _isLoading = false;
      });
      _buildTrials();
      _runNextTrial();
    }
  }

  void _buildTrials() {
    final rng = Random();
    for (int i = 0; i < _totalTrials; i++) {
      // 30% chance of no-go
      final isNoGo = rng.nextDouble() < 0.30;
      final animals = isNoGo ? _noGoAnimals : _goAnimals;
      _trials.add({
        'animal': animals[rng.nextInt(animals.length)],
        'isNoGo': isNoGo,
      });
    }
  }

  Future<void> _runNextTrial() async {
    if (_currentTrial >= _totalTrials) {
      _finishTask();
      return;
    }

    final trial = _trials[_currentTrial];
    setState(() {
      _currentAnimal = trial['animal'] as String;
      _isNoGo = trial['isNoGo'] as bool;
      _waitingForTap = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await _player.play(AssetSource('sounds/animals/${trial['animal']}.wav'));
    } catch (_) {}

    if (mounted) {
      setState(() {
        _waitingForTap = true;
        _stimulusTime = DateTime.now();
      });
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted && _waitingForTap) {
      if (_isNoGo) {
        _correct++;
      } else {
        _wrong++;
      }
      setState(() {
        _waitingForTap = false;
        _currentTrial++;
      });
      _runNextTrial();
    }
  }

  void _handleTap() {
    if (!_waitingForTap) {
      _premature++;
      HapticFeedback.vibrate();
      return;
    }

    final rt = DateTime.now().difference(_stimulusTime!).inMilliseconds;

    if (_isNoGo) {
      _wrong++;
      HapticFeedback.heavyImpact();
      _showFeedback(false);
    } else {
      _correct++;
      _rts.add(rt);
      HapticFeedback.lightImpact();
      _showFeedback(true);
    }

    setState(() {
      _waitingForTap = false;
      _currentTrial++;
    });

    Future.delayed(const Duration(milliseconds: 600), _runNextTrial);
  }

  void _showFeedback(bool correct) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(correct ? '✅ නිවැරදියි!' : '❌ වැරදියි!'),
      duration: const Duration(milliseconds: 500),
      backgroundColor: correct ? Colors.green : Colors.red,
    ));
  }

  Future<void> _finishTask() async {
    setState(() => _taskDone = true);
    await _submitResult();
  }

  Future<void> _submitResult() async {
    final url = Uri.parse("${Config.baseUrl}/learning-tasks/submit-result");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id": Session.userId ?? "unknown",
          "grade": Session.grade ?? 3,
          "task_id": "gonogo",
          "difficulty": widget.difficulty,
          "correct": _correct,
          "wrong": _wrong,
          "premature": _premature,
          "total_trials": _totalTrials,
          "response_times_ms": _rts,
          "session_number": widget.sessionNumber,
        }),
      );
      if (response.statusCode == 200) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('කාර්යය අවසන්! 🎉', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ලකුණු: ${data['score_percent']}%',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(data['encouragement'] as String, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('ඊළඟ මට්ටම: ${data['next_difficulty']}',
                style: const TextStyle(color: Colors.grey)),
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
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = _currentTrial / _totalTrials;

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('යන්න / නවතින්න — මට්ටම ${widget.difficulty}',
            style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: _handleTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: secondaryPurple,
                backgroundColor: Colors.grey[200],
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentAnimal == null
                    ? const CircularProgressIndicator()
                    : Column(
                  key: ValueKey(_currentTrial),
                  children: [
                    Text(
                      _emojiMap[_currentAnimal] ?? '🐾',
                      style: const TextStyle(fontSize: 100),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isNoGo ? '🛑 අල්ලන්න එපා!' : '👆 ඉක්මනින් අල්ලන්න!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isNoGo ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statChip('✅ $_correct', Colors.green),
                  _statChip('❌ $_wrong', Colors.red),
                  _statChip('⚡ $_premature', Colors.orange),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '${_currentTrial + 1} / $_totalTrials',
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
    );
  }
}