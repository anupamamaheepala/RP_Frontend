import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart';
import '/utils/sessions.dart';

class DysgraphiaDetectionResults extends StatefulWidget {
  const DysgraphiaDetectionResults({super.key});

  @override
  State<DysgraphiaDetectionResults> createState() =>
      _DysgraphiaDetectionResultsState();
}

class _DysgraphiaDetectionResultsState
    extends State<DysgraphiaDetectionResults> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

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
      final url = Uri.parse('${Config.baseUrl}/dysgraphia/user-results/$userId');
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        setState(() { _data = jsonDecode(response.body) as Map<String, dynamic>; _loading = false; });
      } else {
        setState(() { _error = 'දත්ත ලබා ගැනීමට නොහැකි විය. (${response.statusCode})'; _loading = false; });
      }
    } catch (e) {
      setState(() { _error = 'සම්බන්ධතා දෝෂයකි: $e'; _loading = false; });
    }
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'none':   return Colors.green;
      case 'low':    return Colors.blue;
      case 'medium': return Colors.orange;
      case 'high':   return Colors.red;
      default:       return Colors.grey;
    }
  }

  Color _riskColorLight(String level) {
    switch (level.toLowerCase()) {
      case 'none':   return Colors.green.shade50;
      case 'low':    return Colors.blue.shade50;
      case 'medium': return Colors.orange.shade50;
      case 'high':   return Colors.red.shade50;
      default:       return Colors.grey.shade100;
    }
  }

  IconData _riskIcon(String level) {
    switch (level.toLowerCase()) {
      case 'none':   return Icons.check_circle_rounded;
      case 'low':    return Icons.info_rounded;
      case 'medium': return Icons.warning_rounded;
      case 'high':   return Icons.error_rounded;
      default:       return Icons.help_rounded;
    }
  }

  String _riskLabel(String level) {
    switch (level.toLowerCase()) {
      case 'none':   return 'අවදානමක් නැත';
      case 'low':    return 'අඩු අවදානම';
      case 'medium': return 'මධ්‍යම අවදානම';
      case 'high':   return 'ඉහළ අවදානම';
      default:       return level;
    }
  }

  String _activityLabel(String type) {
    switch (type) {
      case 'letters':   return 'අකුරු';
      case 'words':     return 'වචන';
      case 'sentences': return 'වාක්‍ය';
      default:          return type;
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return '-';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}  '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso.length >= 10 ? iso.substring(0, 10) : iso;
    }
  }

  Widget _buildSummaryCard(Map<String, dynamic> summary, int total) {
    final level  = summary['latest_risk_level'] as String? ?? 'none';
    final score  = (summary['latest_risk_score'] as num?)?.toDouble() ?? 0;
    final avg    = (summary['average_risk_score'] as num?)?.toDouble() ?? 0;
    final counts = summary['risk_counts'] as Map<String, dynamic>? ?? {};
    final color  = _riskColor(level);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35), width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(_riskIcon(level), color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('නවතම අවදානම් මට්ටම',
                        style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
                    Text(_riskLabel(level),
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${score.toStringAsFixed(1)}/100',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                  Text('$total සැසි', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 14),

          Row(
            children: [
              const Text('සාමාන්‍ය ලකුණු:',
                  style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Text(avg.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (avg / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _riskChip('None', counts['none'] ?? 0, Colors.green),
              const SizedBox(width: 8),
              _riskChip('Low', counts['low'] ?? 0, Colors.blue),
              const SizedBox(width: 8),
              _riskChip('Med', counts['medium'] ?? 0, Colors.orange),
              const SizedBox(width: 8),
              _riskChip('High', counts['high'] ?? 0, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _riskChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text('$count',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session, int index) {
    final level     = session['risk_level'] as String? ?? 'none';
    final score     = (session['risk_score'] as num?)?.toDouble() ?? 0;
    final grade     = session['grade'] as int? ?? 0;
    final activity  = session['activity_type'] as String? ?? '';
    final date      = _formatDate(session['created_at'] as String?);
    final avgTime   = (session['avg_time'] as num?)?.toDouble();
    final avgClears = (session['avg_clears'] as num?)?.toDouble();
    final prompts   = session['total_prompts'] as int?;
    final color     = _riskColor(level);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          // Top coloured bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _riskColorLight(level),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(_riskIcon(level), color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_riskLabel(level),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${score.toStringAsFixed(1)}/100',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
                ),
              ],
            ),
          ),

          // Detail chips
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    _detailChip(Icons.school_rounded, 'ශ්‍රේණිය $grade', Colors.purple),
                    const SizedBox(width: 8),
                    _detailChip(Icons.edit_rounded, _activityLabel(activity), Colors.blue),
                    if (prompts != null) ...[
                      const SizedBox(width: 8),
                      _detailChip(Icons.list_alt_rounded, '$prompts ප්‍රශ්න', Colors.teal),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (avgTime != null)
                      _detailChip(Icons.timer_outlined, '${avgTime.toStringAsFixed(1)}s', Colors.orange),
                    if (avgTime != null) const SizedBox(width: 8),
                    if (avgClears != null)
                      _detailChip(Icons.refresh_rounded,
                          '${avgClears.toStringAsFixed(1)} clears', Colors.red),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.black38),
                        const SizedBox(width: 4),
                        Text(date,
                            style: const TextStyle(fontSize: 11, color: Colors.black38)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.teal.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'හඳුනාගැනීමේ ප්‍රතිඵල',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.blue),
                      onPressed: _fetchResults,
                    ),
                  ],
                ),
              ),

              // Subtitle
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                color: Colors.blue.shade50,
                child: const Text(
                  'Dysgraphia Detection History',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
              ),

              // Body
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                    : _error != null
                    ? _buildError()
                    : _buildResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                backgroundColor: Colors.blue,
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

  Widget _buildResults() {
    final total    = _data!['total_sessions'] as int? ?? 0;
    final summary  = _data!['summary'] as Map<String, dynamic>?;
    final sessions = (_data!['sessions'] as List<dynamic>?) ?? [];

    if (total == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 72, color: Colors.blue.shade200),
            const SizedBox(height: 16),
            const Text('තවම හඳුනාගැනීම් නොමැත.',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('No detection sessions found.',
                style: TextStyle(fontSize: 13, color: Colors.black38)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchResults,
      color: Colors.blue,
      child: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        children: [
          if (summary != null) _buildSummaryCard(summary, total),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 18, color: Colors.black45),
                const SizedBox(width: 6),
                Text('සැසි ඉතිහාසය ($total)',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ],
            ),
          ),

          ...sessions
              .asMap()
              .entries
              .map((e) =>
              _buildSessionCard(e.value as Map<String, dynamic>, e.key)),
        ],
      ),
    );
  }
}