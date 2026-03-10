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
  bool _isLoading = true;
  String? _error;

  late TabController _tabController;

  // ── Theme ─────────────────────────────────────────────────────────────────
  final Color primaryBg       = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber     = const Color(0xFFFFB300);

  // ── Profile helpers ───────────────────────────────────────────────────────
  static const _profileColors = {
    'profile_a': Color(0xFF4CAF50),
    'profile_b': Color(0xFF2196F3),
    'profile_c': Color(0xFFFF9800),
    'profile_d': Color(0xFFF44336),
  };
  static const _profileLabels = {
    'profile_a': 'ඉහළ අවධානය 🌟',
    'profile_b': 'අවධානය ගොඩනගමු 🎧',
    'profile_c': 'ඉවසීම ගොඩනගමු ⏸️',
    'profile_d': 'අවධානය වර්ධනය කරමු 💪',
  };
  static const _taskLabels = {
    'gonogo':          'යන්න / නවතින්න',
    'wait_match':      'බලා ගැලපීම',
    'audio_sequence':  'කතාව අනුපිළිවෙල',
    'spot_change':     'වෙනස සොයන්න',
    'attention_grid':  'අවධාන ජාලය',
  };
  static const _taskIcons = {
    'gonogo':          Icons.do_not_touch,
    'wait_match':      Icons.hourglass_empty,
    'audio_sequence':  Icons.queue_music,
    'spot_change':     Icons.find_in_page,
    'attention_grid':  Icons.grid_on,
  };
  static const _taskColors = {
    'gonogo':          Color(0xFF4CAF50),
    'wait_match':      Color(0xFFFF9800),
    'audio_sequence':  Color(0xFF9C27B0),
    'spot_change':     Color(0xFF2196F3),
    'attention_grid':  Color(0xFFE91E63),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Data loading ──────────────────────────────────────────────────────────
  Future<void> _loadAll() async {
    setState(() { _isLoading = true; _error = null; });
    final childId = Session.userId ?? 'unknown';
    try {
      final results = await Future.wait([
        _fetchDiagnosticHistory(childId),
        _fetchTaskProgress(childId),
      ]);
      setState(() {
        _diagnosticHistory = results[0];
        _taskProgress      = results[1];
        _isLoading         = false;
      });
    } catch (e) {
      setState(() {
        _error     = 'දත්ත ලබා ගත නොහැකිය: $e';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchDiagnosticHistory(String id) async {
    final res = await http.get(
        Uri.parse('${Config.baseUrl}/adhd/history/$id'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('History fetch failed: ${res.statusCode}');
  }

  Future<Map<String, dynamic>> _fetchTaskProgress(String id) async {
    final res = await http.get(
        Uri.parse('${Config.baseUrl}/learning-tasks/progress/$id'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Progress fetch failed: ${res.statusCode}');
  }

  // ── Build ─────────────────────────────────────────────────────────────────
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
        title: Text('ප්‍රගති වාර්තාව',
            style: TextStyle(
                color: secondaryPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: secondaryPurple),
            onPressed: _loadAll,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: secondaryPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: secondaryPurple,
          tabs: const [
            Tab(icon: Icon(Icons.psychology_alt), text: 'රෝග විනිශ්චය'),
            Tab(icon: Icon(Icons.task_alt),        text: 'ඉගෙනුම් කාර්ය'),
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LearningTaskHome())),
        backgroundColor: secondaryPurple,
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text('කාර්ය ආරම්භ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(_error!,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh),
            label: const Text('නැවත උත්සාහ කරන්න'),
            style: ElevatedButton.styleFrom(
                backgroundColor: secondaryPurple,
                foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // TAB 1 — Diagnostic history
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildDiagnosticTab() {
    final history = _diagnosticHistory!['history'] as List<dynamic>? ?? [];
    final total   = _diagnosticHistory!['total_sessions'] as int? ?? 0;

    if (total == 0) return _buildEmpty('රෝග විනිශ්චය සැසි නොමැත',
        'ළමාවයෙ ශිෂ්‍යයා රෝග විනිශ්චය ක්‍රියාකාරකම් සම්පූර්ණ කළ විට ප්‍රතිඵල මෙහි දිස්වේ');

    final latest  = history.first as Map<String, dynamic>;
    final metrics = latest['computed_metrics'] as Map<String, dynamic>? ?? {};
    final label   = metrics['attention_label'] as String? ?? '';
    final profileColor = _profileColors[label] ?? Colors.grey;

    return RefreshIndicator(
      onRefresh: _loadAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Latest profile card ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: profileColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: profileColor.withOpacity(0.4), width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.psychology_rounded, size: 52, color: profileColor),
                  const SizedBox(height: 12),
                  Text(
                    _profileLabels[label] ?? label,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: profileColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text('නවතම සැසිය · $total සැසි ගණනාවක් ලකුණු කළා',
                      style: const TextStyle(fontSize: 13, color: Colors.black45)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Metric bars ──────────────────────────────────────────────
            _sectionTitle('නවතම මෙට්‍රික්'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _metricBar('ඉක්මන් ප්‍රතිචාරය',
                      (metrics['impulsivity_ratio'] as num?)?.toDouble() ?? 0,
                      Colors.orange),
                  const SizedBox(height: 12),
                  _metricBar('අවධාන දුර්වලතා',
                      (metrics['inattention_score'] as num?)?.toDouble() ?? 0,
                      Colors.blue),
                  const SizedBox(height: 12),
                  _metricBar('නිරවද්‍යතාව',
                      (metrics['overall_accuracy'] as num?)?.toDouble() ?? 0,
                      Colors.green,
                      isPositive: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Accuracy trend ───────────────────────────────────────────
            _sectionTitle('නිරවද්‍යතා ප්‍රවණතාව'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: _buildAccuracyChart(history),
            ),

            const SizedBox(height: 24),

            // ── Session history list ─────────────────────────────────────
            _sectionTitle('සැසි ඉතිහාසය ($total)'),
            const SizedBox(height: 12),
            ...history.take(10).map((s) =>
                _buildDiagnosticSessionCard(s as Map<String, dynamic>)),
          ],
        ),
      ),
    );
  }

  Widget _metricBar(String label, double value, Color color,
      {bool isPositive = false}) {
    final pct = (value * 100).round();
    final level = isPositive
        ? (value >= 0.7 ? 'ඉහළ 🟢' : value >= 0.4 ? 'මධ්‍යම 🟡' : 'පහළ 🔴')
        : (value > 0.35 ? 'ඉහළ 🔴' : value > 0.2 ? 'මධ්‍යම 🟡' : 'පහළ 🟢');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            Row(children: [
              Text(level,
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text('$pct%',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ]),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAccuracyChart(List<dynamic> history) {
    if (history.isEmpty) {
      return const Center(
          child: Text('දත්ත නොමැත', style: TextStyle(color: Colors.grey)));
    }
    final reversed = history.reversed.toList();
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: reversed.take(10).toList().asMap().entries.map((e) {
          final m   = (e.value as Map<String, dynamic>)['computed_metrics']
          as Map<String, dynamic>? ?? {};
          final acc = (m['overall_accuracy'] as num?)?.toDouble() ?? 0;
          final height = (acc * 80).clamp(4.0, 80.0);
          final barColor = acc >= 0.7
              ? Colors.green
              : acc >= 0.4
              ? Colors.orange
              : Colors.red;
          return Tooltip(
            message: '${(acc * 100).round()}%',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${(acc * 100).round()}%',
                    style: TextStyle(
                        fontSize: 9,
                        color: barColor,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: 22,
                  height: height,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${e.key + 1}',
                    style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDiagnosticSessionCard(Map<String, dynamic> session) {
    final metrics = session['computed_metrics'] as Map<String, dynamic>? ?? {};
    final label   = metrics['attention_label'] as String? ?? '';
    final acc     = (metrics['overall_accuracy'] as num?)?.toDouble() ?? 0;
    final ts      = session['timestamp'] as String? ?? '';
    final color   = _profileColors[label] ?? Colors.grey;

    String dateStr = '';
    try {
      final dt = DateTime.parse(ts).toLocal();
      dateStr =
      '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      dateStr = ts.length > 10 ? ts.substring(0, 10) : ts;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('${(acc * 100).round()}%',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_profileLabels[label] ?? label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: color)),
                const SizedBox(height: 2),
                Text(
                    'නිවැරදි: ${session['total_correct']}  '
                        'ඉක්මන්: ${session['total_premature']}  '
                        'වැරදි: ${session['total_wrong']}',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          Text(dateStr,
              style: const TextStyle(fontSize: 11, color: Colors.black38)),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // TAB 2 — Learning task progress
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildLearningTaskTab() {
    final sessions = _taskProgress!['sessions'] as List<dynamic>? ?? [];

    if (sessions.isEmpty) {
      return _buildEmpty('ඉගෙනුම් කාර්ය ලකුණු නොමැත',
          '"කාර්ය ආරම්භ" බොත්තම ඔබා කාර්ය ආරම්භ කරන්න');
    }

    // Group sessions by task_id
    final Map<String, List<Map<String, dynamic>>> byTask = {};
    for (final s in sessions) {
      final m  = s as Map<String, dynamic>;
      final id = m['task_id'] as String? ?? 'unknown';
      byTask.putIfAbsent(id, () => []).add(m);
    }

    return RefreshIndicator(
      onRefresh: _loadAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary row ──────────────────────────────────────────────
            _buildTaskSummaryRow(sessions),
            const SizedBox(height: 24),

            // ── Per-task progress cards ───────────────────────────────────
            _sectionTitle('කාර්ය අනුව ප්‍රගතිය'),
            const SizedBox(height: 12),
            ...byTask.entries.map((e) =>
                _buildPerTaskCard(e.key, e.value)),

            const SizedBox(height: 24),

            // ── Recent session list ───────────────────────────────────────
            _sectionTitle('මෑත සැසි (${sessions.length})'),
            const SizedBox(height: 12),
            ...sessions.take(15).map((s) =>
                _buildTaskSessionCard(s as Map<String, dynamic>)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSummaryRow(List<dynamic> sessions) {
    final totalSessions = sessions.length;
    final avgScore = sessions.isEmpty
        ? 0.0
        : sessions
        .map((s) =>
    (s as Map<String, dynamic>)['score_percent'] as num? ?? 0)
        .reduce((a, b) => a + b) /
        sessions.length;
    final maxDiff = sessions.isEmpty
        ? 1
        : sessions
        .map((s) => (s as Map<String, dynamic>)['difficulty'] as int? ?? 1)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      children: [
        Expanded(
            child: _summaryTile('සැසි', '$totalSessions', Colors.blue)),
        const SizedBox(width: 10),
        Expanded(
            child: _summaryTile(
                'සාමාන්‍ය ලකුණු',
                '${avgScore.toStringAsFixed(1)}%',
                avgScore >= 70 ? Colors.green : Colors.orange)),
        const SizedBox(width: 10),
        Expanded(
            child: _summaryTile('ඉහළ මට්ටම', '$maxDiff',
                maxDiff == 3 ? Colors.purple : Colors.teal)),
      ],
    );
  }

  Widget _summaryTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPerTaskCard(
      String taskId, List<Map<String, dynamic>> sessions) {
    final color  = _taskColors[taskId] ?? secondaryPurple;
    final icon   = _taskIcons[taskId] ?? Icons.star;
    final label  = _taskLabels[taskId] ?? taskId;
    final latest = sessions.first;
    final diff   = latest['difficulty'] as int? ?? 1;
    final score  = (latest['score_percent'] as num?)?.toDouble() ?? 0;
    final stars  = '⭐' * diff;

    // Trend: compare last 2 sessions
    String trend = '';
    if (sessions.length >= 2) {
      final prev =
          (sessions[1]['score_percent'] as num?)?.toDouble() ?? 0;
      if (score > prev + 5) {
        trend = ' ↑';
      } else if (score < prev - 5) {
        trend = ' ↓';
      }
    }

    // Mini score bars for last 5 sessions
    final recent = sessions.take(5).toList().reversed.toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: color)),
                    Text('මට්ටම $diff $stars  ·  ${sessions.length} සැසි',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45)),
                  ],
                ),
              ),
              Text(
                '${score.toStringAsFixed(0)}%$trend',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: score >= 75
                        ? Colors.green
                        : score >= 50
                        ? Colors.orange
                        : Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Mini bar chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('ප්‍රගතිය: ',
                  style: TextStyle(fontSize: 11, color: Colors.black38)),
              ...recent.map((r) {
                final s =
                    (r['score_percent'] as num?)?.toDouble() ?? 0;
                final h = (s / 100 * 28).clamp(2.0, 28.0);
                final c = s >= 75
                    ? Colors.green
                    : s >= 50
                    ? Colors.orange
                    : Colors.red;
                return Container(
                  width: 16,
                  height: h,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSessionCard(Map<String, dynamic> session) {
    final taskId = session['task_id'] as String? ?? '';
    final score  = (session['score_percent'] as num?)?.toDouble() ?? 0;
    final diff   = session['difficulty'] as int? ?? 1;
    final ts     = session['timestamp'] as String? ?? '';
    final color  = _taskColors[taskId] ?? secondaryPurple;
    final icon   = _taskIcons[taskId] ?? Icons.star;

    String dateStr = '';
    try {
      final dt = DateTime.parse(ts).toLocal();
      dateStr =
      '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      dateStr = ts.length > 10 ? ts.substring(0, 10) : ts;
    }

    // Stars for difficulty
    final stars = '⭐' * diff;
    // Score circle color
    final scoreColor = score >= 75
        ? Colors.green
        : score >= 50
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_taskLabels[taskId] ?? taskId,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: color)),
                Text('$stars  ·  නිවැරදි: ${session['correct']}  '
                    'වැරදි: ${session['wrong']}',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black38)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${score.toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: scoreColor)),
              ),
              const SizedBox(height: 2),
              Text(dateStr,
                  style: const TextStyle(
                      fontSize: 10, color: Colors.black38)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────
  Widget _sectionTitle(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: secondaryPurple));
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
            color: secondaryPurple.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4))
      ],
    );
  }

  Widget _buildEmpty(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500]),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}