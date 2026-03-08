import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config.dart';

class Grade3LearningPlanPage extends StatefulWidget {
  final String childId;
  const Grade3LearningPlanPage({super.key, required this.childId});

  @override
  State<Grade3LearningPlanPage> createState() =>
      _Grade3LearningPlanPageState();
}

class _Grade3LearningPlanPageState extends State<Grade3LearningPlanPage> {
  Map<String, dynamic>? _plan;
  bool _isLoading = true;
  String? _error;

  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber     = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _fetchPlan();
  }

  Future<void> _fetchPlan() async {
    final url = Uri.parse(
        "${Config.baseUrl}/learning-plan/latest/${widget.childId}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _plan      = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error     = "සැලැස්ම සොයා ගත නොහැකිය";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error     = "සම්බන්ධතා දෝෂයක් ඇත";
        _isLoading = false;
      });
    }
  }

  Color _profileColor(String? profile) {
    const colors = {
      'profile_a': Colors.green,
      'profile_b': Colors.blue,
      'profile_c': Colors.orange,
      'profile_d': Colors.redAccent,
    };
    return colors[profile] ?? Colors.grey;
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
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        ),
        title: Text('ඔබේ ඉගෙනුම් සැලැස්ම',
            style: TextStyle(
                color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
          child: Text(_error!,
              style: TextStyle(color: secondaryPurple)))
          : _buildPlanContent(),
    );
  }

  Widget _buildPlanContent() {
    final profile    = _plan!['profile']            as String?;
    final label      = _plan!['profile_label']      as String? ?? '';
    final params     = _plan!['adaptation_params']  as Map<String, dynamic>;
    final activities = _plan!['activities']         as List<dynamic>;
    final teacherNote = _plan!['teacher_note']      as String;
    final parentNote  = _plan!['parent_note']       as String;
    final color      = _profileColor(profile);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Profile header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            child: Column(children: [
              Icon(Icons.psychology_rounded, size: 60, color: color),
              const SizedBox(height: 12),
              Text(label,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Adaptation params ──
          _sectionTitle('ඔබේ ඉගෙනුම් ශෛලිය'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                  color: secondaryPurple.withOpacity(0.05),
                  blurRadius: 15)],
            ),
            child: Column(children: [
              _paramRow(Icons.view_agenda_outlined,
                  'එක් වරට ප්‍රශ්න ගණන', '${params['chunk_size']}'),
              _paramRow(Icons.timer_outlined,
                  'විවේකයට පෙර මිනිත්තු', '${params['session_minutes']} min'),
              _paramRow(Icons.speed_outlined,
                  'වේගය', _label(params['pacing'], _pacingLabels)),
              _paramRow(Icons.volume_up_outlined,
                  'ඉගෙනුම් ආකාරය', _label(params['modality'], _modalityLabels)),
              _paramRow(Icons.emoji_events_outlined,
                  'දිරිගැන්වීම', _label(params['encouragement_level'], _encourageLabels)),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Activities ──
          _sectionTitle('ඔබට ගැලපෙන ක්‍රියාකාරකම්'),
          const SizedBox(height: 12),
          ...activities.map((a) =>
              _activityCard(a as Map<String, dynamic>, color)),

          const SizedBox(height: 24),

          // ── Teacher note ──
          _sectionTitle('ගුරුවරයා සඳහා'),
          const SizedBox(height: 8),
          _noteCard(teacherNote, Icons.school_outlined, Colors.blue),

          const SizedBox(height: 16),

          // ── Parent note ──
          _sectionTitle('දෙමාපියන් සඳහා'),
          const SizedBox(height: 8),
          _noteCard(parentNote, Icons.family_restroom, accentAmber),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: secondaryPurple));

  Widget _paramRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Icon(icon, color: secondaryPurple, size: 22),
      const SizedBox(width: 12),
      Expanded(child: Text(label,
          style: const TextStyle(fontSize: 15, color: Colors.black87))),
      Text(value,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: secondaryPurple)),
    ]),
  );

  Widget _activityCard(Map<String, dynamic> a, Color color) {
    final delivery = a['delivery'] as String? ?? 'in_app';
    final deliveryIcon = delivery == 'teacher_led'
        ? Icons.school
        : delivery == 'independent'
        ? Icons.home
        : Icons.phone_android;
    final deliveryLabel = delivery == 'teacher_led'
        ? 'ගුරු මඟ'
        : delivery == 'independent'
        ? 'ස්වයං'
        : 'ඇප්';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [BoxShadow(
            color: secondaryPurple.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(_activityIcon(a['type'] as String),
                color: color, size: 24),
          ),
          title: Text(a['title'] as String,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: secondaryPurple)),
          subtitle: Row(children: [
            Icon(deliveryIcon, size: 13, color: Colors.grey),
            const SizedBox(width: 4),
            Text('$deliveryLabel · ${a['duration_min']} min',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a['description'] as String,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(a['instructions'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noteCard(String text, IconData icon, Color color) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.07),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.25), width: 1.5),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: 12),
      Expanded(
        child: Text(text,
            style: const TextStyle(
                fontSize: 14, color: Colors.black87, height: 1.6)),
      ),
    ]),
  );

  IconData _activityIcon(String type) {
    switch (type) {
      case 'focus_builder':  return Icons.center_focus_strong;
      case 'memory':         return Icons.psychology_outlined;
      case 'inhibition':     return Icons.pause_circle_outline;
      case 'comprehension':  return Icons.menu_book_outlined;
      case 'categorization': return Icons.category_outlined;
      default:               return Icons.star_outline;
    }
  }

  String _label(String key, Map<String, String> map) =>
      map[key] ?? key;

  final _pacingLabels = const {
    'self_paced':    'තමා ගමනින්',
    'timed_relaxed': 'සැහැල්ලු',
    'timed':         'නිශ්චිත',
  };

  final _modalityLabels = const {
    'audio_visual': 'ශ්‍රව්‍ය + දෘශ්‍ය',
    'visual_only':  'දෘශ්‍ය',
    'interactive':  'අන්තර්ක්‍රියාකාරී',
  };

  final _encourageLabels = const {
    'standard':   'සාමාන්‍ය',
    'high':       'ඉහළ',
    'very_high':  'ඉතා ඉහළ',
  };
}