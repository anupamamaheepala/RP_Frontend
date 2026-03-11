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

  @override
  void initState() {
    super.initState();
    _fetchPlan();
  }

  Future<void> _fetchPlan() async {
    final url = Uri.parse("${Config.baseUrl}/learning-plan/latest/${widget.childId}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _plan      = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error     = "සැලැස්ම සොයා ගත නොහැක";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error     = "සම්බන්ධතා දෝෂයක් පවතී";
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: secondaryPurple, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('මගේ ඉගෙනුම් සැලැස්ම',
            style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)))
          : _buildPlanContent(),
    );
  }

  Widget _buildPlanContent() {
    final profile    = _plan!['profile']            as String?;
    final label      = _plan!['profile_label']      as String? ?? '';
    final params     = _plan!['adaptation_params']  as Map<String, dynamic>;
    final activities = _plan!['activities']         as List<dynamic>;
    final color      = _profileColor(profile);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Child Friendly Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                child: Icon(Icons.auto_awesome_rounded, size: 35, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(label,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('ඔබටම ගැලපෙන ඉගෙනුම් මාවත',
                  style: TextStyle(fontSize: 12, color: Colors.white70)),
            ]),
          ),

          const SizedBox(height: 30),

          _sectionTitle('මගේ ඉගෙනුම් විලාසය'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)],
            ),
            child: Column(children: [
              _paramRow(Icons.layers_rounded, 'එකවර ලැබෙන ප්‍රශ්න ගණන', '${params['chunk_size']}'),
              _divider(),
              _paramRow(Icons.timer_rounded, 'විවේකයට පෙර කාලය', '${params['session_minutes']} min'),
              _divider(),
              _paramRow(Icons.bolt_rounded, 'ඉගෙනීමේ වේගය', _label(params['pacing'], _pacingLabels)),
              _divider(),
              _paramRow(Icons.record_voice_over_rounded, 'ඉගෙනුම් මාධ්‍යය', _label(params['modality'], _modalityLabels)),
            ]),
          ),

          const SizedBox(height: 30),

          _sectionTitle('මට ගැලපෙන ක්‍රියාකාරකම්'),
          const SizedBox(height: 12),
          ...activities.map((a) => _activityCard(a as Map<String, dynamic>, color)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: secondaryPurple));

  Widget _divider() => Divider(color: Colors.grey.shade100, height: 20);

  Widget _paramRow(IconData icon, String label, String value) => Row(children: [
    Icon(icon, color: secondaryPurple.withOpacity(0.5), size: 22),
    const SizedBox(width: 12),
    Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54))),
    Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondaryPurple)),
  ]);

  Widget _activityCard(Map<String, dynamic> a, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(_activityIcon(a['type'] as String), color: color, size: 24),
        ),
        title: Text(a['title'] as String,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: secondaryPurple)),
        subtitle: Text('${a['duration_min']} min • ක්‍රියාකාරකම', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a['description'] as String, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                  child: Text(a['instructions'] as String, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'focus_builder': return Icons.center_focus_strong;
      case 'memory':        return Icons.psychology_rounded;
      case 'inhibition':    return Icons.pause_circle_filled_rounded;
      default:              return Icons.star_rounded;
    }
  }

  String _label(String key, Map<String, String> map) => map[key] ?? key;

  final _pacingLabels = const { 'self_paced': 'තමාගේ වේගයෙන්', 'timed_relaxed': 'සැහැල්ලු', 'timed': 'නිශ්චිත කාලසීමාවන්' };
  final _modalityLabels = const { 'audio_visual': 'ශ්‍රව්‍ය + දෘශ්‍ය', 'visual_only': 'දෘශ්‍ය පමණි', 'interactive': 'අන්තර්ක්‍රියාකාරී' };
}