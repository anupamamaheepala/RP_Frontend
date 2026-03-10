import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/sessions.dart';
import 'task_stats.dart';
import '../../../config.dart';
import 'grade3_learning_plan_page.dart';
import 'learning_tasks/learning_task_home.dart';

class Grade3ResultsPage extends StatefulWidget {
  const Grade3ResultsPage({super.key});

  @override
  State<Grade3ResultsPage> createState() => _Grade3ResultsPageState();
}

class _Grade3ResultsPageState extends State<Grade3ResultsPage> {
  bool _isSaving = true;
  String _saveMessage = "ප්‍රතිඵල සුරකිමින්...";
  String? _profile;
  Map<String, dynamic>? _computedMetrics;

  int get totalActions =>
      TaskStats.totalCorrect + TaskStats.totalWrong + TaskStats.totalPremature;

  double get overallAccuracy {
    if (totalActions == 0) return 100.0;
    return (TaskStats.totalCorrect / totalActions * 100).clamp(0.0, 100.0);
  }

  String get attentionLevel {
    if (TaskStats.totalPremature >= 8 || TaskStats.totalWrong >= 10) {
      return "අවධානය වැඩිදියුණු කිරීම අවශ්‍යයි";
    } else if (TaskStats.totalPremature >= 5 || TaskStats.totalWrong >= 6) {
      return "මධ්‍යම අවධානය";
    } else {
      return "ඉතා හොඳ අවධානය!";
    }
  }

  @override
  void initState() {
    super.initState();
    _submitResultsToBackend();
  }

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
        final profile =
        responseData['computed_metrics']['attention_label'] as String;
        final metrics =
        responseData['computed_metrics'] as Map<String, dynamic>;

        await _generateLearningPlan(profile, childId);

        setState(() {
          _isSaving        = false;
          _saveMessage     = "ප්‍රතිඵල සාර්ථකව සුරකින ලදී!";
          _profile         = profile;
          _computedMetrics = metrics;
        });
        TaskStats.reset();
      } else {
        setState(() {
          _isSaving    = false;
          _saveMessage = "සේවාදායක දෝෂයක් (Status: ${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        _isSaving    = false;
        _saveMessage = "සම්බන්ධතා දෝෂයක් ඇත";
      });
    }
  }

  Future<void> _generateLearningPlan(String profile, String childId) async {
    final url = Uri.parse("${Config.baseUrl}/learning-plan/generate");
    try {
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "child_id":          childId,
          "grade":             3,
          "attention_profile": profile,
        }),
      );
    } catch (e) {
      debugPrint("Learning plan generation failed: $e");
    }
  }

  // ── Teacher section ────────────────────────────────────────────────────────
  Widget _buildTeacherSection() {
    if (_computedMetrics == null) return const SizedBox.shrink();

    final imp  = (_computedMetrics!['impulsivity_ratio'] as num).toDouble();
    final inat = (_computedMetrics!['inattention_score'] as num).toDouble();
    final acc  = (_computedMetrics!['overall_accuracy']  as num).toDouble();
    final label = _computedMetrics!['attention_label'] as String? ?? '';

    final impLevel  = imp  > 0.35 ? 'ඉහළ 🔴' : imp  > 0.2 ? 'මධ්‍යම 🟡' : 'පහළ 🟢';
    final inatLevel = inat > 0.35 ? 'ඉහළ 🔴' : inat > 0.2 ? 'මධ්‍යම 🟡' : 'පහළ 🟢';

    final strategies = _teacherStrategies(label);

    return ExpansionTile(
      leading: const Icon(Icons.school, color: Colors.teal),
      title: const Text(
        '👩‍🏫 ගුරුවරයා සඳහා',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
      ),
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.teal.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _teacherRow('ශ්‍රේණිය',              'Grade 3'),
              _teacherRow('අවධාන පැතිකඩ',          label),
              _teacherRow('ඉක්මන් ප්‍රතිචාරය',     impLevel),
              _teacherRow('අවධාන දුර්වලතා',        inatLevel),
              _teacherRow('නිරවද්‍යතාව',           '${(acc * 100).round()}%'),
              _teacherRow('ඉක්මන් ක්‍රියා ගණන',   '${TaskStats.totalPremature}'),
              _teacherRow('වැරදි ප්‍රතිචාර ගණන',  '${TaskStats.totalWrong}'),

              const Divider(height: 24),

              const Text(
                'නිර්දේශිත උපාය මාර්ග:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              ...strategies.map((s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(color: Colors.teal)),
                    Expanded(
                      child: Text(s,
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _teacherRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  List<String> _teacherStrategies(String profile) {
    switch (profile) {
      case 'profile_a':
        return [
          'සාමාන්‍ය පන්ති ක්‍රමය ප්‍රමාණවත්',
          'අභියෝගාත්මක කාර්යයන් ලබා දෙන්න',
          'නිර්මාණශීලී ක්‍රියාකාරකම් දිරිමත් කරන්න',
        ];
      case 'profile_b':
        return [
          'කාර්යයන් විනාඩි 7 කොටස්වලට කඩා ලබා දෙන්න',
          'ශ්‍රව්‍ය + දෘශ්‍ය ද්විත්ව ක්‍රමය භාවිතා කරන්න',
          'ඉදිරිපස ආසනයක් ලබා දෙන්න',
          'සෑම කාර්ය 2කට වරක් ප්‍රශංසා කරන්න',
          'ශබ්ද රහිත පරිසරයක ඉගෙනීමට ඉඩ දෙන්න',
        ];
      case 'profile_c':
        return [
          'ප්‍රශ්නයට පිළිතුරු දීමට පෙර 3 ගණන් කිරීමට කියන්න',
          'ඉක්මන් ප්‍රතිචාරවලට ලකුණු නොදෙන්න',
          'ඉවසීම සඳහා ත්‍යාග ලබා දෙන්න',
          'රතු/කොළ ක්‍රීඩාව දිනකට 5 min කරන්න',
          'Chess, puzzles දිරිමත් කරන්න',
        ];
      case 'profile_d':
        return [
          'එකවර කාර්ය 1ක් පමණ ලබා දෙන්න',
          'විනාඩි 5ට අඩු කාර්යයන් ලබා දෙන්න',
          'ස්ටිකර් ත්‍යාග ක්‍රමයක් භාවිතා කරන්න',
          'දෙමාපියන් සමඟ ගෙදර පුහුණුව ගැන කතා කරන්න',
          'ළමා රෝගී විශේෂඥ ඇගයීමක් ගැන සලකා බලන්න',
        ];
      default:
        return ['ගුරුවරයාගේ නිරීක්ෂණය නිතිපතා කරන්න'];
    }
  }

  // ── Shared UI helpers ──────────────────────────────────────────────────────
  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber     = const Color(0xFFFFB300);

  Widget _buildResultRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              isBold ? FontWeight.bold : FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 32, thickness: 1, color: Colors.grey[100]);

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: secondaryPurple),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text('ප්‍රතිඵල සටහන',
            style: TextStyle(
                color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            // ── Trophy ──────────────────────────────────────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: accentAmber.withOpacity(0.1),
                        shape: BoxShape.circle)),
                Icon(Icons.emoji_events_rounded,
                    size: 100, color: accentAmber),
              ],
            ),
            const SizedBox(height: 16),
            Text('ඔබ හොඳින් කළා!',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: secondaryPurple)),
            const SizedBox(height: 8),
            const Text('ඔබේ අවධානය සහ හැසිරීම පිළිබඳ වාර්තාව',
                style:
                TextStyle(fontSize: 16, color: Colors.black54)),

            const SizedBox(height: 30),

            // ── Stats card ───────────────────────────────────────────────
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: secondaryPurple.withOpacity(0.1))),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildResultRow(
                        icon: Icons.task_alt_rounded,
                        label: 'සම්පූර්ණ කළ ක්‍රියාකාරකම්',
                        value: '3 / 3',
                        color: Colors.blue),
                    _buildDivider(),
                    _buildResultRow(
                        icon: Icons.speed_rounded,
                        label: 'සමස්ත නිවැරදිතාව',
                        value:
                        '${overallAccuracy.toStringAsFixed(0)}%',
                        color: overallAccuracy >= 80
                            ? Colors.green
                            : Colors.orange),
                    _buildDivider(),
                    _buildResultRow(
                        icon: Icons.bolt_rounded,
                        label: 'ක්ෂණික ප්‍රතිචාර (Impulsivity)',
                        value: '${TaskStats.totalPremature}',
                        color: TaskStats.totalPremature > 5
                            ? Colors.red
                            : Colors.orange),
                    _buildDivider(),
                    _buildResultRow(
                        icon: Icons.visibility_off_rounded,
                        label: 'අවධානය ගිලිහී යාම් (Inattention)',
                        value: '${TaskStats.totalWrong}',
                        color: TaskStats.totalWrong > 6
                            ? Colors.red
                            : Colors.orange),
                    _buildDivider(),
                    _buildResultRow(
                        icon: Icons.psychology_rounded,
                        label: 'අවධානය මට්ටම',
                        value: attentionLevel,
                        color: secondaryPurple,
                        isBold: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── Info banner ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: accentAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                'ඔබේ ප්‍රතිඵල අනුව, අපි ඔබට ගැලපෙන විශේෂ ඉගෙනුම් සැලැස්මක් සකස් කරන්නෙමු!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: secondaryPurple,
                    fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),

            // ── Save status ──────────────────────────────────────────────
            if (_isSaving)
              const CircularProgressIndicator()
            else
              Text(_saveMessage,
                  style: TextStyle(
                      color: _saveMessage.contains("සාර්ථක")
                          ? Colors.green
                          : Colors.red,
                      fontSize: 14)),

            const SizedBox(height: 30),

            // ── Action buttons ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(
                    context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                    backgroundColor: accentAmber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text('මුල් පිටුවට ආපසු',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),

            if (!_isSaving && _profile != null) ...[

              const SizedBox(height: 12),

              // View learning plan
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Grade3LearningPlanPage(
                        childId: Session.userId ?? "unknown",
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.auto_awesome,
                      color: Colors.white),
                  label: const Text(
                    'ඉගෙනුම් සැලැස්ම බලන්න',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Start learning tasks
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LearningTaskHome(),
                    ),
                  ),
                  icon: const Icon(Icons.play_circle_fill,
                      color: Colors.white),
                  label: const Text(
                    'ඉගෙනුම් කාර්යයන් ආරම්භ කරන්න',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Teacher section ────────────────────────────────────────
              _buildTeacherSection(),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}