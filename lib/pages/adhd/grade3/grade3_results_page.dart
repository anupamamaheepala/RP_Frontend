import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/sessions.dart';
import 'task_stats.dart';
import '../../../config.dart';
import 'learning_tasks/learning_task_home.dart';

class Grade3ResultsPage extends StatefulWidget {
  const Grade3ResultsPage({super.key});

  @override
  State<Grade3ResultsPage> createState() => _Grade3ResultsPageState();
}

class _Grade3ResultsPageState extends State<Grade3ResultsPage> {
  // ── State ─────────────────────────────────────────────────────────────────
  bool _isSaving = true;
  String _saveMessage = "ප්‍රතිඵල සුරැකෙමින් පවතී...";
  String? _profile;
  Map<String, dynamic>? _computedMetrics;

  // ── Theme Constants ──────────────────────────────────────────────────────
  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber     = const Color(0xFFFFB300);

  // Gradients matching your project theme
  final List<Color> greenGrad  = [const Color(0xFF56AB2F), const Color(0xFFA8E063)];
  final List<Color> amberGrad  = [const Color(0xFFF2994A), const Color(0xFFF2C94C)];
  final List<Color> purpleGrad = [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)];

  int get totalActions =>
      TaskStats.totalCorrect + TaskStats.totalWrong + TaskStats.totalPremature;

  double get overallAccuracy {
    if (totalActions == 0) return 100.0;
    return (TaskStats.totalCorrect / totalActions * 100).clamp(0.0, 100.0);
  }

  String get attentionLevel {
    if (TaskStats.totalPremature >= 8 || TaskStats.totalWrong >= 10) {
      return "අවධානය වර්ධනය කරගත යුතුයි";
    } else if (TaskStats.totalPremature >= 5 || TaskStats.totalWrong >= 6) {
      return "මධ්‍යස්ථ අවධානයක්";
    } else {
      return "ඉතා හොඳ අවධානයක්!";
    }
  }

  @override
  void initState() {
    super.initState();
    _submitResultsToBackend();
  }

  // ── Logic ──────────────────────────────────────────────────────
  Future<void> _submitResultsToBackend() async {
    final url     = Uri.parse("${Config.baseUrl}/adhd/submit-results");
    final childId = Session.userId ?? "unknown";

    final payload = {
      "grade":             3,
      "total_correct":     TaskStats.totalCorrect,
      "total_premature":   TaskStats.totalPremature,
      "total_wrong":       TaskStats.totalWrong,
      "overall_accuracy":  overallAccuracy,
      "timestamp":         DateTime.now().toIso8601String(),
      "child_id":          childId,
      "task_response_times": {
        "task1": TaskStats.task1ResponseTimes,
        "task2": TaskStats.task2ResponseTimes,
        "task3": TaskStats.task3ResponseTimes,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _isSaving        = false;
          _saveMessage     = "ප්‍රතිඵල සාර්ථකව සුරකින ලදී!";
          _profile         = responseData['computed_metrics']['attention_label'] as String;
          _computedMetrics = responseData['computed_metrics'] as Map<String, dynamic>;
        });
        TaskStats.reset();
      } else {
        setState(() {
          _isSaving    = false;
          _saveMessage = "දෝෂයකි (Error: ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        _isSaving    = false;
        _saveMessage = "සම්බන්ධතා දෝෂයක් පවතී";
      });
    }
  }

  // ── UI Components ─────────────────────────────────────────────────────────

  Widget _buildResultRow({required IconData icon, required String label, required String value, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: secondaryPurple, size: 28),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text('ප්‍රතිඵල වාර්තාව', style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // ── Hero Section ──────────────────────────────────────────
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [accentAmber.withOpacity(0.3), Colors.transparent],
                ),
              ),
              child: Icon(Icons.emoji_events_rounded, size: 90, color: accentAmber),
            ),
            const SizedBox(height: 10),
            Text('විශිෂ්ටයි!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: secondaryPurple)),
            const Text('ඔබේ අද දවසේ ප්‍රගතිය මෙන්න', style: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.w600)),

            const SizedBox(height: 30),

            // ── Main Stats Card ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  _buildResultRow(icon: Icons.check_circle_rounded, label: 'සම්පූර්ණ කළ ප්‍රමාණය', value: '3 / 3', color: Colors.blue),
                  const Divider(height: 10, color: Color(0xFFF1F4F8)),
                  _buildResultRow(icon: Icons.speed_rounded, label: 'නිරවද්‍යතාව', value: '${overallAccuracy.toStringAsFixed(0)}%', color: Colors.green),
                  const Divider(height: 10, color: Color(0xFFF1F4F8)),
                  _buildResultRow(icon: Icons.bolt_rounded, label: 'ආවේගශීලී බව', value: '${TaskStats.totalPremature}', color: Colors.orange),
                  const Divider(height: 10, color: Color(0xFFF1F4F8)),
                  _buildResultRow(icon: Icons.visibility_off_rounded, label: 'අවධානය ගිලිහී යාම්', value: '${TaskStats.totalWrong}', color: Colors.redAccent),

                  const SizedBox(height: 20),

                  // ── Attention Level (Only Value Displayed Here) ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [secondaryPurple.withOpacity(0.1), secondaryPurple.withOpacity(0.05)]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: secondaryPurple.withOpacity(0.1)),
                    ),
                    child: Text(
                      attentionLevel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: secondaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ── Save status indicator ──
            if (_isSaving)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(_saveMessage, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),

            const SizedBox(height: 30),

            // ── Action Buttons ──────────────────────────────────────────
            _buildActionButton(
              label: 'ක්‍රියාකාරකම් අරඹන්න',
              icon: Icons.play_circle_fill_rounded,
              gradient: greenGrad,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LearningTaskHome())),
            ),

            const SizedBox(height: 12),

            _buildActionButton(
              label: 'මුල් තිරයට යන්න',
              icon: Icons.home_rounded,
              gradient: amberGrad,
              onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required List<Color> gradient, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: gradient.last.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 24),
        label: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}