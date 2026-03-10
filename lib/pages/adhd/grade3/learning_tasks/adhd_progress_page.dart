import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../config.dart';
import '../../../../utils/sessions.dart';
import 'learning_task_home.dart';

class AdhDProgressPage extends StatefulWidget {
  const AdhDProgressPage({super.key});

  @override
  State<AdhDProgressPage> createState() => _AdhDProgressPageState();
}

class _AdhDProgressPageState extends State<AdhDProgressPage>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  Map<String, dynamic>? _diagnosticHistory;
  Map<String, dynamic>? _taskProgress;
  Map<String, dynamic>? _plan;
  bool _isLoading = true;
  String? _error;

  late TabController _tabController;

  // ── Theme Gradients ───────────────────────────────────────────────────────
  final List<Color> blueGradient   = [const Color(0xFF00B4DB), const Color(0xFF0083B0)];
  final List<Color> greenGradient  = [const Color(0xFF56AB2F), const Color(0xFFA8E063)];
  final List<Color> pinkGradient   = [const Color(0xFFFF512F), const Color(0xFFDD2476)];
  final List<Color> purpleGradient = [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)];
  final List<Color> orangeGradient = [const Color(0xFFF2994A), const Color(0xFFF2C94C)];

  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);

  static const _profileGradients = {
    'profile_a': [Color(0xFF56AB2F), Color(0xFFA8E063)],
    'profile_b': [Color(0xFF00B4DB), Color(0xFF0083B0)],
    'profile_c': [Color(0xFFF2994A), Color(0xFFF2C94C)],
    'profile_d': [Color(0xFFFF512F), Color(0xFFDD2476)],
  };

  static const _profileLabels = {
    'profile_a': 'ඉහළ අවධානය 🌟',
    'profile_b': 'අවධානය ගොඩනගමු 🎧',
    'profile_c': 'ඉවසීම පුරුදු වෙමු ⏸️',
    'profile_d': 'අවධානය වර්ධනය කරමු 💪',
  };

  static const _taskLabels = {
    'gonogo':          'යන්න / නවතින්න',
    'wait_match':      'බලා ගැලපීම',
    'audio_sequence':  'කතාවේ අනුපිළිවෙල',
    'spot_change':     'වෙනස සොයන්න',
    'attention_grid':  'අවධාන ජාලය',
  };

  static const _taskIcons = {
    'gonogo':          Icons.pan_tool_alt_rounded,
    'wait_match':      Icons.timer_rounded,
    'audio_sequence':  Icons.auto_stories_rounded,
    'spot_change':     Icons.remove_red_eye_rounded,
    'attention_grid':  Icons.grid_view_rounded,
  };

  @override
  void initState() {
    super.initState();
    // length 3 to match the UI tabs
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() { _isLoading = true; _error = null; });
    final childId = Session.userId ?? 'unknown';
    try {
      final results = await Future.wait([
        _fetchDiagnosticHistory(childId),
        _fetchTaskProgress(childId),
        _fetchLatestPlan(childId),
      ]);
      setState(() {
        _diagnosticHistory = results[0];
        _taskProgress      = results[1];
        _plan              = results[2];
        _isLoading         = false;
      });
    } catch (e) {
      setState(() {
        _error     = 'දත්ත ලබා ගත නොහැක: $e';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchDiagnosticHistory(String id) async {
    final res = await http.get(Uri.parse('${Config.baseUrl}/adhd/history/$id'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return {};
  }

  Future<Map<String, dynamic>> _fetchTaskProgress(String id) async {
    final res = await http.get(Uri.parse('${Config.baseUrl}/learning-tasks/progress/$id'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return {};
  }

  Future<Map<String, dynamic>> _fetchLatestPlan(String id) async {
    final res = await http.get(Uri.parse('${Config.baseUrl}/learning-plan/latest/$id'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return {};
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
        title: Text('ප්‍රගති වාර්තාව', style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: secondaryPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: secondaryPurple,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: 'රෝග විනිශ්චය'),
            Tab(text: 'ක්‍රියාකාරකම්'),
            Tab(text: 'ඉගෙනුම් සැලැස්ම'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildError()
          : TabBarView(
        controller: _tabController,
        children: [
          _buildDiagnosticTab(),
          _buildLearningTaskTab(),
          _buildPlanTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LearningTaskHome())),
        backgroundColor: secondaryPurple,
        icon: const Icon(Icons.play_circle_fill, color: Colors.white),
        label: const Text('ක්‍රියාකාරකම් අරඹන්න', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildError() => Center(child: Text(_error!));

  // ════════════════════════════════════════════════════════════════════════════
  // TAB 1 — Diagnostic History
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildDiagnosticTab() {
    final history = _diagnosticHistory!['history'] as List<dynamic>? ?? [];
    final total   = _diagnosticHistory!['total_sessions'] as int? ?? 0;

    if (total == 0) return _buildEmpty('ප්‍රතිඵල තවම නොමැත', 'පළමු පරීක්ෂණයෙන් පසු විස්තර මෙහි දිස්වේ');

    final latest  = history.first as Map<String, dynamic>;
    final metrics = latest['computed_metrics'] as Map<String, dynamic>? ?? {};
    final label   = metrics['attention_label'] as String? ?? '';
    final gradient = _profileGradients[label] ?? blueGradient;

    return RefreshIndicator(
      onRefresh: _loadAll,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: gradient.last.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Column(
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.psychology_rounded, size: 35, color: Colors.white)),
                  const SizedBox(height: 16),
                  Text(_profileLabels[label] ?? label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text('නවතම වාර්තාව • සැසි $total ක් සම්පූර්ණයි', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('මෑතකාලීන මිනුම්'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20), decoration: _cardDecoration(),
              child: Column(children: [
                _metricBar('ආවේගශීලී බව (Impulsivity)', (metrics['impulsivity_ratio'] as num?)?.toDouble() ?? 0, Colors.orange),
                const SizedBox(height: 16),
                _metricBar('අවධානය අඩුවීම (Inattention)', (metrics['inattention_score'] as num?)?.toDouble() ?? 0, Colors.blue),
                const SizedBox(height: 16),
                _metricBar('නිරවද්‍යතාව (Accuracy)', (metrics['overall_accuracy'] as num?)?.toDouble() ?? 0, Colors.green),
              ]),
            ),
            const SizedBox(height: 24),
            _sectionTitle('ප්‍රගති ප්‍රස්ථාරය'),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(20), decoration: _cardDecoration(), child: _buildAccuracyChart(history)),
            const SizedBox(height: 24),
            _sectionTitle('පෙර සැසි වාර්තා'),
            const SizedBox(height: 12),
            ...history.take(5).map((s) => _buildDiagnosticSessionCard(s as Map<String, dynamic>)),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // TAB 2 — Task Progress
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildLearningTaskTab() {
    final sessions = _taskProgress!['sessions'] as List<dynamic>? ?? [];
    if (sessions.isEmpty) return _buildEmpty('ක්‍රියාකාරකම් තවම නැත', 'ක්‍රියාකාරකම් අරඹා ඔබේ ප්‍රගතිය නිරීක්ෂණය කරන්න');

    final Map<String, List<Map<String, dynamic>>> byTask = {};
    for (final s in sessions) {
      final m = s as Map<String, dynamic>;
      final id = m['task_id'] as String? ?? 'unknown';
      byTask.putIfAbsent(id, () => []).add(m);
    }

    return RefreshIndicator(
      onRefresh: _loadAll,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskSummaryRow(sessions),
            const SizedBox(height: 24),
            _sectionTitle('ක්‍රියාකාරකම් අනුව ප්‍රගතිය'),
            const SizedBox(height: 12),
            ...byTask.entries.map((e) => _buildPerTaskCard(e.key, e.value)),
            const SizedBox(height: 24),
            _sectionTitle('මෑතකාලීන සැසි'),
            const SizedBox(height: 12),
            ...sessions.take(10).map((s) => _buildTaskSessionCard(s as Map<String, dynamic>)),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // TAB 3 — Learning Plan
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildPlanTab() {
    if (_plan == null || _plan!.isEmpty) return _buildEmpty('සැලැස්ම තවම නැත', 'පළමු පරීක්ෂණයෙන් පසු විස්තර මෙහි දිස්වේ');

    final params     = _plan!['adaptation_params'] as Map<String, dynamic>;
    final activities = _plan!['activities'] as List<dynamic>;
    final teacherNote = _plan!['teacher_note'] as String? ?? "";
    final parentNote  = _plan!['parent_note'] as String? ?? "";
    final profile    = _plan!['profile'] as String?;
    final color      = _profileGradients[profile]?[0] ?? Colors.grey;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('දරුවාගේ ඉගෙනුම් සැලැස්ම සහ ගුරු උපදෙස්'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20), decoration: _cardDecoration(),
            child: Column(children: [
              _paramRow(Icons.layers_rounded, 'එකවර ලැබෙන ප්‍රශ්න ගණන', '${params['chunk_size']}'),
              _divider(),
              _paramRow(Icons.timer_rounded, 'සැසි කාලය', '${params['session_minutes']} min'),
            ]),
          ),
          const SizedBox(height: 25),
          _sectionTitle('නිර්දේශිත ක්‍රියාකාරකම්'),
          const SizedBox(height: 12),
          ...activities.map((a) => _activityCard(a as Map<String, dynamic>, color)),
          const SizedBox(height: 25),
          _noteCard(teacherNote, Icons.school_rounded, Colors.teal, "ගුරු උපදෙස්"),
          const SizedBox(height: 12),
          _noteCard(parentNote, Icons.family_restroom_rounded, Colors.orange, "දෙමාපියන් සඳහා"),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // UI HELPERS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _sectionTitle(String text) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: secondaryPurple)));

  BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))]);

  Widget _divider() => Divider(color: Colors.grey.shade100, height: 20);

  Widget _metricBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)), Text('${(value * 100).round()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color))]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: value.clamp(0.0, 1.0), minHeight: 12, backgroundColor: color.withOpacity(0.1), color: color)),
      ],
    );
  }

  Widget _noteCard(String text, IconData icon, Color color, String title) {
    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: color, size: 18), const SizedBox(width: 8), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13))]),
        const SizedBox(height: 8), Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5)),
      ]),
    );
  }

  Widget _paramRow(IconData icon, String label, String value) {
    return Row(children: [Icon(icon, color: secondaryPurple.withOpacity(0.5), size: 20), const SizedBox(width: 12), Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)), const Spacer(), Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: secondaryPurple))]);
  }

  Widget _buildEmpty(String title, String subtitle) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.auto_awesome_motion_rounded, size: 80, color: Colors.grey[300]), const SizedBox(height: 16), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)), Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey)))]));
  }

  Widget _activityCard(Map<String, dynamic> a, Color color) {
    final List<Color> gradient = a['title'].hashCode % 2 == 0 ? blueGradient : purpleGradient;
    return Container(
      margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: gradient)), child: Row(children: [CircleAvatar(backgroundColor: Colors.white24, child: Icon(_taskIcons[a['type']] ?? Icons.star, color: Colors.white)), const SizedBox(width: 12), Expanded(child: Text(a['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))])),
          Padding(padding: const EdgeInsets.all(16), child: Text(a['description'], style: const TextStyle(color: Colors.grey, fontSize: 13))),
        ]),
      ),
    );
  }

  Widget _buildAccuracyChart(List<dynamic> history) {
    if (history.isEmpty) return const SizedBox();
    return SizedBox(height: 100, child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: history.reversed.take(8).toList().asMap().entries.map((e) {
      final acc = (e.value['computed_metrics']['overall_accuracy'] as num).toDouble();
      return Container(width: 25, height: (acc * 70).clamp(5.0, 70.0), decoration: BoxDecoration(gradient: LinearGradient(colors: acc > 0.6 ? greenGradient : orangeGradient, begin: Alignment.bottomCenter, end: Alignment.topCenter), borderRadius: BorderRadius.circular(6)));
    }).toList()));
  }

  Widget _buildDiagnosticSessionCard(Map<String, dynamic> session) {
    final metrics = session['computed_metrics'] as Map<String, dynamic>? ?? {};
    final label = metrics['attention_label'] as String? ?? '';
    final color = (_profileGradients[label] ?? blueGradient).first;
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12), decoration: _cardDecoration(), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: LinearGradient(colors: _profileGradients[label] ?? blueGradient), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.history_rounded, color: Colors.white, size: 20)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_profileLabels[label] ?? label, style: TextStyle(fontWeight: FontWeight.bold, color: color)), Text('නිවැරදි: ${session['total_correct']} | වැරදි: ${session['total_wrong']}', style: const TextStyle(fontSize: 11, color: Colors.grey))]))]));
  }

  Widget _buildPerTaskCard(String taskId, List<Map<String, dynamic>> sessions) {
    final label = _taskLabels[taskId] ?? taskId;
    final score = (sessions.first['score_percent'] as num).toDouble();
    final gradient = taskId.hashCode % 2 == 0 ? blueGradient : purpleGradient;
    return Container(margin: const EdgeInsets.only(bottom: 16), decoration: _cardDecoration(), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Column(children: [Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: gradient)), child: Row(children: [CircleAvatar(backgroundColor: Colors.white24, child: Icon(_taskIcons[taskId] ?? Icons.star, color: Colors.white)), const SizedBox(width: 12), Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))), Text('${score.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))])), Padding(padding: const EdgeInsets.all(16), child: Text('සම්පූර්ණ කළ වාර: ${sessions.length}', style: const TextStyle(color: Colors.grey, fontSize: 13)))])));
  }

  Widget _buildTaskSummaryRow(List<dynamic> sessions) {
    final avgScore = sessions.isEmpty ? 0 : (sessions.map((s) => s['score_percent'] as num).reduce((a, b) => a + b) / sessions.length).round();
    return Row(children: [Expanded(child: _summaryTile('සැසි වාර', '${sessions.length}', blueGradient)), const SizedBox(width: 12), Expanded(child: _summaryTile('සාමාන්‍යය', '$avgScore%', greenGradient)), const SizedBox(width: 12), Expanded(child: _summaryTile('දක්ෂතාව', 'ඉහළ', orangeGradient))]);
  }

  Widget _summaryTile(String label, String value, List<Color> colors) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(20)), child: Column(children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70))]));

  Widget _buildTaskSessionCard(Map<String, dynamic> session) {
    final score = (session['score_percent'] as num).toDouble();
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)), child: Row(children: [Icon(_taskIcons[session['task_id']] ?? Icons.task_alt, color: secondaryPurple.withOpacity(0.5), size: 20), const SizedBox(width: 10), Expanded(child: Text(_taskLabels[session['task_id']] ?? session['task_id'].toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))), Text('${score.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: score > 70 ? Colors.green : Colors.orange))]));
  }
}