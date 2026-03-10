import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config.dart';
import '../../../../utils/sessions.dart';
import 'task_gonogo.dart';
import 'task_wait_match.dart';
import 'task_audio_sequence.dart';
import 'task_spot_change.dart';
import 'task_attention_grid.dart';

class LearningTaskHome extends StatefulWidget {
  const LearningTaskHome({super.key});

  @override
  State<LearningTaskHome> createState() => _LearningTaskHomeState();
}

class _LearningTaskHomeState extends State<LearningTaskHome> {
  Map<String, dynamic>? _assignment;
  bool _isLoading = true;
  String? _error;

  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber     = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _fetchAssignment();
  }

  Future<void> _fetchAssignment() async {
    final url = Uri.parse("${Config.baseUrl}/learning-tasks/assign");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id": Session.userId ?? "unknown",
          "grade":    Session.grade  ?? 3,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          _assignment = jsonDecode(response.body);
          _isLoading  = false;
        });
      } else {
        setState(() {
          _error     = "කාර්යයන් ලබා ගත නොහැකිය";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error     = "සම්බන්ධතා දෝෂයක් ඇත: $e";
        _isLoading = false;
      });
    }
  }

  void _startTask(Map<String, dynamic> task) {
    final taskId     = task['task_id'] as String;
    final difficulty = task['difficulty'] as int;
    final session    = _assignment!['session_number'] as int;

    Widget page;
    switch (taskId) {
      case 'gonogo':
        page = TaskGoNoGo(difficulty: difficulty, sessionNumber: session);
        break;
      case 'wait_match':
        page = TaskWaitMatch(difficulty: difficulty, sessionNumber: session);
        break;
      case 'audio_sequence':
        page = TaskAudioSequence(difficulty: difficulty, sessionNumber: session);
        break;
      case 'spot_change':
        page = TaskSpotChange(difficulty: difficulty, sessionNumber: session);
        break;
      case 'attention_grid':
        page = TaskAttentionGrid(difficulty: difficulty, sessionNumber: session);
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: secondaryPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('ඉගෙනුම් කාර්යයන්',
            style: TextStyle(
                color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    final tasks    = _assignment!['tasks']            as List<dynamic>;
    final deficit  = _assignment!['dominant_deficit'] as String;
    final scores   = _assignment!['severity_scores']  as Map<String, dynamic>;
    final session  = _assignment!['session_number']   as int;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Session banner ─────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryPurple, secondaryPurple.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('සැසිය $session',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                const Text('අද ඔබේ කාර්යයන්',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Severity bars ───────────────────────────────────────────
          _buildSeverityCard(scores),

          const SizedBox(height: 20),

          Text('ඔබේ කාර්යයන්',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: secondaryPurple)),
          const SizedBox(height: 12),

          // ── Task cards ──────────────────────────────────────────────
          ...tasks.map((t) => _buildTaskCard(t as Map<String, dynamic>)),
        ],
      ),
    );
  }

  Widget _buildSeverityCard(Map<String, dynamic> scores) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: secondaryPurple.withOpacity(0.06), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ඔබේ ප්‍රතිඵල',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: secondaryPurple)),
          const SizedBox(height: 12),
          _buildBar('ඉක්මන් ප්‍රතිචාරය',
              scores['impulsivity'] as double, Colors.orange),
          _buildBar('අවධානය',
              scores['inattention'] as double, Colors.blue),
          _buildBar('නිරවද්‍යතාව',
              1 - (scores['accuracy'] as double), Colors.red),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    final pct = (value * 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
              Text('$pct%',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final difficulty = task['difficulty'] as int;
    final stars      = '⭐' * difficulty;

    final deficitColors = {
      'impulsivity': Colors.orange,
      'inattention': Colors.blue,
      'accuracy':    Colors.red,
      'maintenance': Colors.green,
    };
    final color =
        deficitColors[task['target_deficit']] ?? secondaryPurple;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: secondaryPurple.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_taskIcon(task['task_id'] as String),
                color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['task_name'] as String,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryPurple)),
                const SizedBox(height: 4),
                Text(task['instructions'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('මට්ටම $difficulty $stars',
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _startTask(task),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
            ),
            child: const Text('ආරම්භ',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  IconData _taskIcon(String taskId) {
    switch (taskId) {
      case 'gonogo':          return Icons.do_not_touch;
      case 'wait_match':      return Icons.hourglass_empty;
      case 'audio_sequence':  return Icons.queue_music;
      case 'spot_change':     return Icons.find_in_page;
      case 'attention_grid':  return Icons.grid_on;
      default:                return Icons.star;
    }
  }
}