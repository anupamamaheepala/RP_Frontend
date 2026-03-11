import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config.dart';
import '../../../../utils/sessions.dart';

class TaskAudioSequence extends StatefulWidget {
  final int difficulty;
  final int sessionNumber;
  const TaskAudioSequence(
      {super.key, required this.difficulty, required this.sessionNumber});

  @override
  State<TaskAudioSequence> createState() => _TaskAudioSequenceState();
}

class _TaskAudioSequenceState extends State<TaskAudioSequence> {
  late final AudioPlayer _player;

  // Data loaded from JSON
  List<Map<String, dynamic>> _stories = [];
  bool _isLoading = true;

  int _trial = 0;
  int _correct = 0;
  int _attempts = 0;
  bool _isPlaying = false;
  bool _audioPlayed = false;
  bool _taskDone = false;

  // Analysis variables
  DateTime? _taskStartTime;
  final List<int> _rts = [];

  List<Map<String, dynamic>?> _slots = [null, null, null];
  List<Map<String, dynamic>> _pool = [];
  List<Map<String, dynamic>> _correctOrder = [];

  final Color primaryBg = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);

  int get _totalTrials => widget.difficulty == 1 ? 2 : widget.difficulty == 2 ? 3 : 4;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadStoryData();
  }

  Future<void> _loadStoryData() async {
    try {
      final String response = await rootBundle
          .loadString('assets/tasks_adhd/audio_sequence_data.json');
      final data = await json.decode(response);
      setState(() {
        _stories = List<Map<String, dynamic>>.from(data['stories']);
        _isLoading = false;
      });
      _initTrial();
    } catch (e) {
      debugPrint("දත්ත පැටවීමේ දෝෂයකි: $e");
      setState(() {
        _stories = [
          {
            'audio': 'sounds/lplans/story_1.wav',
            'items': [
              {'emoji': '☀️', 'label': 'අවදි වුණා'},
              {'emoji': '🍚', 'label': 'කෑම කෑවා'},
              {'emoji': '🏫', 'label': 'පාසල් ගියා'},
            ],
          }
        ];
        _isLoading = false;
      });
      _initTrial();
    }
  }

  void _initTrial() {
    if (_stories.isEmpty) return;
    final storyData = _stories[_trial % _stories.length];
    final items = List<Map<String, dynamic>>.from(storyData['items']);
    _correctOrder = List.from(items);
    _pool = List.from(items)..shuffle(Random());
    _slots = [null, null, null];
    _audioPlayed = false;
  }

  void _nextTrial() {
    if (_trial >= _totalTrials) {
      _finishTask();
      return;
    }
    setState(() {
      _initTrial();
    });
  }

  Future<void> _playStory() async {
    setState(() => _isPlaying = true);
    try {
      // Path is updated to look into assets/sounds/lplans/ via the JSON or hardcoded fallback
      final String audioPath = _stories[_trial % _stories.length]['audio'] as String;

      await _player.play(AssetSource(audioPath));
      await _player.onPlayerComplete.first;
    } catch (e) {
      debugPrint("Audio Play Error: $e");
      await Future.delayed(const Duration(seconds: 3));
    }
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _audioPlayed = true;
        _taskStartTime = DateTime.now(); // Start tracking time for impulsivity/focus
      });
    }
  }

  void _handlePoolTap(int index) {
    if (!_audioPlayed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('කරුණාකර පළමුව කතාවට සවන් දෙන්න 🎧'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    int emptyIndex = _slots.indexOf(null);
    if (emptyIndex != -1) {
      setState(() {
        _slots[emptyIndex] = _pool.removeAt(index);
      });
    }
  }

  void _handleSlotTap(int index) {
    if (_slots[index] == null) return;
    setState(() {
      _pool.add(_slots[index]!);
      _slots[index] = null;
    });
  }

  void _checkAnswer() {
    _attempts++;

    // Capture the time taken to complete the sequence
    if (_taskStartTime != null) {
      final duration = DateTime.now().difference(_taskStartTime!).inMilliseconds;
      _rts.add(duration);
    }

    bool isCorrect = true;
    for (int i = 0; i < 3; i++) {
      if (_slots[i]?['label'] != _correctOrder[i]['label']) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      _correct++;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ ඉතාම හොඳයි! පිළිතුර නිවැරදියි.'),
          backgroundColor: Colors.green));
      _trial++;
      Future.delayed(const Duration(milliseconds: 1500), _nextTrial);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('❌ පිළිතුර වැරදියි, නැවත උත්සාහ කරමු!'),
          backgroundColor: Colors.orange));
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _pool = List.from(_correctOrder)..shuffle();
            _slots = [null, null, null];
            _taskStartTime = DateTime.now(); // Reset timer for the retry
          });
        }
      });
    }
  }

  Future<void> _finishTask() async {
    if (_taskDone) return;
    setState(() => _taskDone = true);
    final url = Uri.parse("${Config.baseUrl}/learning-tasks/submit-result");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id":          Session.userId ?? "unknown",
          "grade":             Session.grade  ?? 3,
          "task_id":           "audio_sequence",
          "difficulty":        widget.difficulty,
          "correct":           _correct,
          "wrong":             _attempts - _correct,
          "premature":         0,
          "total_trials":      _totalTrials,
          "response_times_ms": _rts, // Now sending actual completion times
          "session_number":    widget.sessionNumber,
        }),
      );
      if (response.statusCode == 200 && mounted) {
        _showResult(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("API Error: $e");
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
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    bool isAllFilled = !_slots.contains(null);

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('කතාවේ අනුපිළිවෙල — මට්ටම ${widget.difficulty}',
            style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LinearProgressIndicator(
                value: _trial / _totalTrials,
                minHeight: 6,
                color: secondaryPurple,
                backgroundColor: Colors.grey[200],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildAudioSection(),
                  const SizedBox(height: 30),
                  const Text('පළමු, දෙවන සහ තෙවන රූප පිළිවෙලට තෝරන්න:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildSlotsRow(),
                  const SizedBox(height: 30),

                  if (isAllFilled)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton.icon(
                        onPressed: _checkAnswer,
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text('පිළිතුර පරීක්ෂා කරන්න',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                  const Text('රූප මෙතැනින් තෝරන්න:',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 15),
                  _buildPoolGrid(),
                  const SizedBox(height: 40),
                  _buildBottomStats(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(_audioPlayed ? Icons.check_circle : Icons.headphones,
              color: _audioPlayed ? Colors.green : secondaryPurple),
          const SizedBox(width: 12),
          Expanded(
              child: Text(_isPlaying ? 'සවන් දෙන්න...' : _audioPlayed ? 'නැවත අසන්න' : 'කතාවට සවන් දෙන්න',
                  style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold))),
          IconButton(
            onPressed: _isPlaying ? null : _playStory,
            icon: Icon(_isPlaying ? Icons.hourglass_top : Icons.play_circle_fill,
                size: 38, color: secondaryPurple),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) => _buildSlotCard(i)),
    );
  }

  Widget _buildSlotCard(int index) {
    final item = _slots[index];
    return GestureDetector(
      onTap: () => _handleSlotTap(index),
      child: Column(
        children: [
          Container(
            width: 80, height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: item == null ? Colors.grey.shade300 : secondaryPurple, width: 2),
            ),
            child: Center(
              child: item == null
                  ? Text('${index + 1}',
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 32, fontWeight: FontWeight.bold))
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(item['emoji'], style: const TextStyle(fontSize: 34)),
                const SizedBox(height: 4),
                Text(item['label'], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const SizedBox(height: 5),
          Text(index == 0 ? "පළමු" : index == 1 ? "දෙවන" : "තෙවන",
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPoolGrid() {
    return SizedBox(
      height: 120,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: _pool.length,
        itemBuilder: (context, index) {
          final item = _pool[index];
          return GestureDetector(
            onTap: () => _handlePoolTap(index),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(item['label'], textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _chip('✅ $_correct', Colors.green),
        _chip('🔄 $_attempts', Colors.blue),
        _chip('${_trial + 1}/$_totalTrials', Colors.grey),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
    );
  }
}