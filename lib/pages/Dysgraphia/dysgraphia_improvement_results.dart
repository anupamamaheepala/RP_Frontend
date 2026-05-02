import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart';
import '/utils/sessions.dart';
import 'dysgraphia_xai_service.dart';

class DysgraphiaImprovementResults extends StatefulWidget {
  const DysgraphiaImprovementResults({super.key});

  @override
  State<DysgraphiaImprovementResults> createState() =>
      _DysgraphiaImprovementResultsState();
}

class _DysgraphiaImprovementResultsState
    extends State<DysgraphiaImprovementResults> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  // ── Activity metadata ──────────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _activityMeta = {
    'confusable_pairs':   { 'en': 'Confusable Pairs',      'emoji': '🔤', 'color': Color(0xFF5C6BC0) },
    'beat_your_time':     { 'en': 'Beat Your Time',         'emoji': '⏱️', 'color': Color(0xFF26A69A) },
    'sentence_completion':{ 'en': 'Sentence Completion',    'emoji': '✍️', 'color': Color(0xFF8D6E63) },
    'spot_and_fix':       { 'en': 'Spot & Fix',             'emoji': '🔍', 'color': Color(0xFFEF5350) },
    'free_copy':          { 'en': 'Free Copy',              'emoji': '📋', 'color': Color(0xFFFF7043) },
    'word_in_context':    { 'en': 'Word in Context',        'emoji': '🖼️', 'color': Color(0xFF66BB6A) },
    'my_best_one':        { 'en': 'My Best One',            'emoji': '⭐', 'color': Color(0xFFAB47BC) },
    'drag_and_build':     { 'en': 'Drag & Build',           'emoji': '🧩', 'color': Color(0xFF29B6F6) },
    'ghost_trace':        { 'en': 'Ghost Trace',            'emoji': '👻', 'color': Color(0xFF78909C) },
    'dot_to_dot':         { 'en': 'Dot to Dot',             'emoji': '🔵', 'color': Color(0xFF42A5F5) },
    'which_one_is_right': { 'en': 'Which One is Right',     'emoji': '✅', 'color': Color(0xFF26C6DA) },
    'watch_and_copy':     { 'en': 'Watch & Copy',           'emoji': '👀', 'color': Color(0xFF7E57C2) },
  };

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _activityEn(String name) =>
      _activityMeta[name]?['en'] as String? ?? name;
  String _activityEmoji(String name) =>
      _activityMeta[name]?['emoji'] as String? ?? '📝';
  Color _activityColor(String name) =>
      _activityMeta[name]?['color'] as Color? ?? Colors.blueGrey;

  Color _scoreColor(double score) {
    if (score >= 80) return const Color(0xFF43A047);
    if (score >= 60) return const Color(0xFF7CB342);
    if (score >= 40) return const Color(0xFFFB8C00);
    return const Color(0xFFE53935);
  }

  String _scoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Practice';
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':    return const Color(0xFF42A5F5);
      case 'medium': return const Color(0xFFFFA726);
      case 'high':   return const Color(0xFFEF5350);
      default:       return Colors.grey;
    }
  }

  String _riskLabel(String level) {
    switch (level.toLowerCase()) {
      case 'low':    return 'Low Risk';
      case 'medium': return 'Medium Risk';
      case 'high':   return 'High Risk';
      default:       return level;
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return '-';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso.length >= 10 ? iso.substring(0, 10) : iso;
    }
  }

  String _formatDuration(double? secs) {
    if (secs == null) return '-';
    final m = (secs / 60).floor();
    final s = (secs % 60).round();
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  // ── Fetch ──────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    setState(() { _loading = true; _error = null; });
    try {
      final userId = Session.userId;
      if (userId == null || userId.isEmpty) {
        setState(() { _error = 'පරිශීලක ID හමු නොවීය.'; _loading = false; });
        return;
      }
      final url = Uri.parse(
          '${Config.baseUrl}/dysgraphia-improvement/user-results/$userId');
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body) as Map<String, dynamic>;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'දත්ත ලබා ගැනීමට නොහැකි විය. (${response.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _error = 'සම්බන්ධතා දෝෂයකි: $e'; _loading = false; });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.pink.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSubtitleBar(),
              Expanded(
                child: _loading
                    ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange))
                    : _error != null
                    ? _buildError()
                    : _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.deepOrange),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'දියුණු කිරීමේ ප්‍රතිඵල',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.deepOrange),
            onPressed: _fetchResults,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitleBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      color: Colors.orange.shade50,
      child: const Text(
        'Dysgraphia Improvement Activity Results',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.black54)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchResults,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('නැවත උත්සාහ කරන්න'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty ──────────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up_rounded, size: 80, color: Colors.orange.shade200),
          const SizedBox(height: 20),
          const Text('තවම ක්‍රියාකාරකම් නොමැත.',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
            'No improvement activities completed yet.\nComplete some activities to see progress here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  // ── Main body ──────────────────────────────────────────────────────────────
  Widget _buildBody() {
    final totalCount = _data!['total_sessions'] as int? ?? 0;
    if (totalCount == 0) return _buildEmpty();

    final summary = _data!['summary'] as Map<String, dynamic>;
    final sessions = (_data!['sessions'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: _fetchResults,
      color: Colors.deepOrange,
      child: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        children: [
          _buildOverviewCard(summary, totalCount),
          const SizedBox(height: 16),
          _buildInsightBanner(summary),
          const SizedBox(height: 16),
          _buildActivityBarChart(summary),
          const SizedBox(height: 16),
          _buildRiskTierCard(summary),
          const SizedBox(height: 16),
          _buildSessionHistoryHeader(totalCount),
          const SizedBox(height: 8),
          ...sessions.asMap().entries.map(
                (e) => _buildSessionCard(e.value, e.key),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // OVERVIEW & CHART WIDGETS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildOverviewCard(Map<String, dynamic> summary, int total) {
    final avg    = (summary['average_score']  as num?)?.toDouble() ?? 0;
    final best   = (summary['best_score']     as num?)?.toDouble() ?? 0;
    final latest = (summary['latest_score']   as num?)?.toDouble() ?? 0;
    final latestActivity = summary['latest_activity'] as String? ?? '-';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6F00), Color(0xFFE91E63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('දරුවාගේ ප්‍රගතිය',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      Text("Child's Progress Overview",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$total sessions',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _overviewChip('Average\nScore', '${avg.toStringAsFixed(1)}%', Icons.bar_chart_rounded),
                const SizedBox(width: 10),
                _overviewChip('Best\nScore', '${best.toStringAsFixed(1)}%', Icons.star_rounded),
                const SizedBox(width: 10),
                _overviewChip('Latest\nScore', '${latest.toStringAsFixed(1)}%', Icons.access_time_rounded),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.play_circle_outline_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                const Text('Last Activity: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Expanded(
                  child: Text(latestActivity,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Overall Average', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('${avg.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (avg / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewChip(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightBanner(Map<String, dynamic> summary) {
    final avg = (summary['average_score'] as num?)?.toDouble() ?? 0;
    final riskCounts = summary['risk_counts'] as Map<String, dynamic>? ?? {};
    final highCount = (riskCounts['high'] as int?) ?? 0;
    final medCount = (riskCounts['medium'] as int?) ?? 0;

    String insightSi;
    String insightEn;
    Color insightColor;
    IconData insightIcon;

    if (avg >= 75) {
      insightSi = 'දරුවා ඉතා හොඳ ප්‍රගතියක් දක්වයි! 🎉';
      insightEn = 'The child is showing excellent improvement. Keep up the great work!';
      insightColor = const Color(0xFF2E7D32);
      insightIcon = Icons.celebration_rounded;
    } else if (avg >= 55) {
      insightSi = 'දරුවා ස්ථාවර ප්‍රගතියක් දක්වයි. 👍';
      insightEn = 'The child is making steady progress. Continue regular practice.';
      insightColor = const Color(0xFF1565C0);
      insightIcon = Icons.trending_up_rounded;
    } else if (highCount > medCount) {
      insightSi = 'ඉහළ අවදානම් ක්‍රියාකාරකම් වැඩිපුර කළ යුතුය.';
      insightEn = 'The child has been doing high-risk activities. Consider more guided practice sessions.';
      insightColor = const Color(0xFFB71C1C);
      insightIcon = Icons.warning_amber_rounded;
    } else {
      insightSi = 'දරුවාට තව ප්‍රගතියක් අවශ්‍ය වේ. 💪';
      insightEn = 'The child needs more consistent practice to improve scores.';
      insightColor = const Color(0xFFE65100);
      insightIcon = Icons.info_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insightColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: insightColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: insightColor.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(insightIcon, color: insightColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ගුරු / දෙමාපිය අදහස', style: TextStyle(fontSize: 11, color: insightColor.withOpacity(0.7), fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(insightSi, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: insightColor)),
                const SizedBox(height: 4),
                Text(insightEn, style: TextStyle(fontSize: 12, color: insightColor.withOpacity(0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBarChart(Map<String, dynamic> summary) {
    final activityBests = (summary['activity_bests'] as Map<String, dynamic>?) ?? {};
    if (activityBests.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bar_chart_rounded, color: Colors.deepOrange, size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ක්‍රියාකාරකම් ප්‍රගතිය', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('Best score achieved per activity', style: TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...activityBests.entries.map((e) {
            final name  = e.key;
            final score = (e.value as num).toDouble();
            return _buildActivityBar(_activityEmoji(name), _activityEn(name), score, _activityColor(name));
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(const Color(0xFF43A047), '≥ 80% Excellent'),
              const SizedBox(width: 14),
              _legendDot(const Color(0xFFFB8C00), '40–79% Good/Fair'),
              const SizedBox(width: 14),
              _legendDot(const Color(0xFFE53935), '< 40% Practice'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBar(String emoji, String label, double score, Color actColor) {
    final scoreColor = _scoreColor(score);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87), overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: scoreColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text('${score.toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: scoreColor)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(height: 12, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6))),
              FractionallySizedBox(
                widthFactor: (score / 100).clamp(0.0, 1.0),
                child: Container(height: 12, decoration: BoxDecoration(gradient: LinearGradient(colors: [scoreColor.withOpacity(0.7), scoreColor]), borderRadius: BorderRadius.circular(6))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45)),
      ],
    );
  }

  Widget _buildRiskTierCard(Map<String, dynamic> summary) {
    final riskCounts = (summary['risk_counts'] as Map<String, dynamic>?) ?? {};
    final high = (riskCounts['high'] as int?) ?? 0;
    final medium = (riskCounts['medium'] as int?) ?? 0;
    final low = (riskCounts['low'] as int?) ?? 0;
    final total = high + medium + low;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.layers_rounded, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ක්‍රියාකාරකම් මට්ටම්', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('Sessions completed per difficulty tier', style: TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTierRow('High Risk', '👻', high, total, const Color(0xFFEF5350), 'Most intensive — needs strong support'),
          const SizedBox(height: 12),
          _buildTierRow('Medium Risk', '✍️', medium, total, const Color(0xFFFFA726), 'Moderate difficulty — building consistency'),
          const SizedBox(height: 12),
          _buildTierRow('Low Risk', '⭐', low, total, const Color(0xFF42A5F5), 'Refinement activities — near independent'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 10),
          const Text('What this means for the child:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 6),
          _tierExplanation(high, medium, low),
        ],
      ),
    );
  }

  Widget _buildTierRow(String label, String emoji, int count, int total, Color color, String subtitle) {
    final frac = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black45)),
                ],
              ),
            ),
            Text('$count session${count == 1 ? '' : 's'}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 5),
        Stack(
          children: [
            Container(height: 8, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4))),
            FractionallySizedBox(
              widthFactor: frac.clamp(0.0, 1.0),
              child: Container(height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tierExplanation(int high, int medium, int low) {
    String text;
    if (high > medium && high > low) {
      text = 'The child has been practising mostly high-risk activities...';
    } else if (low > medium && low > high) {
      text = 'The child has been working on low-risk activities...';
    } else {
      text = 'The child has a balanced mix of activity levels...';
    }
    return Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5));
  }

  Widget _buildSessionHistoryHeader(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, size: 18, color: Colors.black45),
          const SizedBox(width: 6),
          Text('සැසි ඉතිහාසය ($total)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session, int index) {
    final activityName  = session['activity_name']  as String? ?? '';
    final activityLabel = session['activity_label'] as String? ?? activityName;
    final riskLevel     = session['risk_level']     as String? ?? '';
    final score    = (session['score_percent']  as num?)?.toDouble() ?? 0;
    final correct  = session['correct_count']   as int? ?? 0;
    final total    = session['total_items']     as int? ?? 0;
    final duration = (session['duration_seconds'] as num?)?.toDouble();
    final grade    = session['grade']           as int? ?? 0;
    final date     = _formatDate(session['created_at'] as String?);

    final actColor   = _activityColor(activityName);
    final riskColor  = _riskColor(riskLevel);
    final scoreColor = _scoreColor(score);
    final emoji      = _activityEmoji(activityName);
    final actEn      = _activityEn(activityName);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: actColor.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSessionHeaderContent(emoji, activityLabel, actEn, actColor, score, scoreColor),
          const Divider(height: 1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.withOpacity(0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 6),
                    Text("AI FEEDBACK & ANALYSIS",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            letterSpacing: 1.1
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DysgraphiaXAIService(
                  riskLevel: riskLevel,
                  kinematicData: {
                    'duration': duration ?? 0,
                    'accuracy': score,
                    'strokeCount': session['stroke_count'] ?? 0,
                    'clears': session['clear_count'] ?? 0,
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildSessionFooterDetails(correct, total, scoreColor, grade, riskLevel, riskColor, duration, date),
        ],
      ),
    );
  }

  Widget _buildSessionHeaderContent(String emoji, String activityLabel, String actEn, Color actColor, double score, Color scoreColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activityLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: actColor)),
                Text(actEn, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          _buildScoreBadge(score, scoreColor),
        ],
      ),
    );
  }

  Widget _buildScoreBadge(double score, Color scoreColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scoreColor.withOpacity(0.4), width: 1),
      ),
      child: Column(
        children: [
          Text('${score.toStringAsFixed(0)}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: scoreColor)),
          Text(_scoreLabel(score), style: TextStyle(fontSize: 9, color: scoreColor.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildSessionFooterDetails(int correct, int total, Color scoreColor, int grade, String riskLevel, Color riskColor, double? duration, String date) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Score', style: TextStyle(fontSize: 11, color: Colors.black45)),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (total > 0 ? correct / total : 0.0),
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$correct / $total correct', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(Icons.school_rounded, 'Grade $grade', Colors.purple),
              const SizedBox(width: 8),
              _chip(Icons.layers_rounded, _riskLabel(riskLevel), riskColor),
              if (duration != null) ...[
                const SizedBox(width: 8),
                _chip(Icons.timer_outlined, _formatDuration(duration), Colors.teal),
              ],
              const Spacer(),
              Text(date, style: const TextStyle(fontSize: 11, color: Colors.black38)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}