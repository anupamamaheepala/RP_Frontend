import 'package:flutter/material.dart';
import 'dart:math' as math;

class DysgraphiaResultsPage extends StatefulWidget {
  final int grade;
  final String activityType;
  final int totalPrompts;
  final int completedPrompts;
  final List<double> timesTaken;
  final int totalStrokes;
  final int totalClears;
  final String riskLevel;
  final double riskScore;
  final double formationAccuracy; // NEW: 0.0 to 1.0 from ML Kit

  const DysgraphiaResultsPage({
    super.key,
    required this.grade,
    required this.activityType,
    required this.totalPrompts,
    required this.completedPrompts,
    required this.timesTaken,
    required this.totalStrokes,
    required this.totalClears,
    required this.riskLevel,
    required this.riskScore,
    required this.formationAccuracy,
  });

  @override
  State<DysgraphiaResultsPage> createState() => _DysgraphiaResultsPageState();
}

class _DysgraphiaResultsPageState extends State<DysgraphiaResultsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getActivityName() {
    switch (widget.activityType) {
      case 'letters':  return 'අකුරු ඉගෙනීම';
      case 'words':    return 'වචන ලිවීම';
      case 'sentences':return 'වාක්‍ය ලිවීම';
      default:         return 'ලිවීම';
    }
  }

  double _calculateTotalTime() => widget.timesTaken.fold(0.0, (s, t) => s + t);

  double _calculateAverageTime() {
    if (widget.timesTaken.isEmpty) return 0.0;
    return _calculateTotalTime() / widget.timesTaken.length;
  }

  // ── Risk helpers ──────────────────────────────────────────────────────────
  Color _getRiskColor() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':   return Colors.green;
      case 'low':    return Colors.blue;
      case 'medium': return Colors.orange;
      case 'high':   return Colors.red;
      default:       return Colors.grey;
    }
  }

  Color _getRiskColorLight() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':   return Colors.green.shade50;
      case 'low':    return Colors.blue.shade50;
      case 'medium': return Colors.orange.shade50;
      case 'high':   return Colors.red.shade50;
      default:       return Colors.grey.shade200;
    }
  }

  Color _getRiskColorMedium() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':   return Colors.green.shade100;
      case 'low':    return Colors.blue.shade100;
      case 'medium': return Colors.orange.shade100;
      case 'high':   return Colors.red.shade100;
      default:       return Colors.grey.shade300;
    }
  }

  Color _getRiskColorBorder() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':   return Colors.green.shade300;
      case 'low':    return Colors.blue.shade300;
      case 'medium': return Colors.orange.shade300;
      case 'high':   return Colors.red.shade300;
      default:       return Colors.grey.shade400;
    }
  }

  String _getRiskDisplayText() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':   return 'අවදානමක් නැත';
      case 'low':    return 'අඩු අවදානම';
      case 'medium': return 'මධ්‍යම අවදානම';
      case 'high':   return 'ඉහළ අවදානම';
      default:       return 'නොදනී';
    }
  }

  IconData _getRiskIcon() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':   return Icons.check_circle;
      case 'low':    return Icons.info;
      case 'medium': return Icons.warning;
      case 'high':   return Icons.error;
      default:       return Icons.help;
    }
  }

  String _getRecommendation() {
    switch (widget.riskLevel.toLowerCase()) {
      case 'none':
        return 'ඔබගේ ලිවීමේ කුසලතා සාමාන්‍ය සීමාව තුළයි. දිගටම අභ්‍යාස කරන්න!';
      case 'low':
        return 'සුළු ප්‍රශ්න දක්නට ලැබේ. නිතිපතා අභ්‍යාස කිරීමෙන් දියුණු කර ගත හැක.';
      case 'medium':
        return 'මධ්‍යම මට්ටමේ අභියෝග හමුවේ. ගුරුවරයා හෝ විශේෂඥයකුගෙන් උපකාර ලබා ගැනීම වැදගත්.';
      case 'high':
        return 'වැදගත්: ලිවීමේ දුෂ්කරතා පවතී. කරුණාකර වහාම විශේෂඥ උපකාර ලබා ගන්න.';
      default:
        return 'තවත් අභ්‍යාස අවශ්‍යයි.';
    }
  }

  // ── Formation accuracy helpers ────────────────────────────────────────────
  String _getFormationLabel() {
    final p = widget.formationAccuracy;
    if (p >= 0.8) return 'විශිෂ්ට';       // Excellent
    if (p >= 0.6) return 'හොඳ';            // Good
    if (p >= 0.4) return 'සාමාන්‍ය';      // Average
    return 'දුෂ්කරතා ඇත';                 // Difficulty
  }

  Color _getFormationColor() {
    final p = widget.formationAccuracy;
    if (p >= 0.8) return Colors.green;
    if (p >= 0.6) return Colors.blue;
    if (p >= 0.4) return Colors.orange;
    return Colors.red;
  }

  // ── Reusable metric card ─────────────────────────────────────────────────
  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color backgroundColor,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: iconColor.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Formation accuracy card with progress bar ─────────────────────────────
  Widget _buildFormationCard() {
    // Sentences are skipped by ML Kit so don't show this card for them
    if (widget.activityType == 'sentences') return const SizedBox.shrink();

    final color = _getFormationColor();
    final label = _getFormationLabel();
    final pct = widget.formationAccuracy;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 2),
          boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.gesture, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('අකුරු හැඩගැස්ම', style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(label, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                    ],
                  ),
                ),
                Text(
                  '${(pct * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalTime = _calculateTotalTime();
    final avgTime = _calculateAverageTime();
    final riskColor = _getRiskColor();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50, Colors.pink.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'ප්‍රතිඵල (Results)',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Celebration header
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.amber.shade100, Colors.orange.shade100]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(color: Colors.amber.shade50, shape: BoxShape.circle),
                                child: const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
                              ),
                              const SizedBox(height: 16),
                              const Text('ඔබ හොඳින් කළා!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 8),
                              const Text('ඔබගේ අධ්‍යාපනය සඳහා සාර්ථකව වාර්තාව', style: TextStyle(fontSize: 15, color: Colors.black54), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Activity info
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.blue.shade100]),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.purple.shade200, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.assessment, color: Colors.purple, size: 28),
                              const SizedBox(width: 12),
                              Text('ශ්‍රේණිය ${widget.grade} - ${_getActivityName()}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Risk Assessment Card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [_getRiskColorLight(), _getRiskColorMedium()]),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getRiskColorBorder(), width: 3),
                            boxShadow: [BoxShadow(color: riskColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                          ),
                          child: Column(
                            children: [
                              Icon(_getRiskIcon(), size: 64, color: riskColor),
                              const SizedBox(height: 16),
                              const Text('ඩිස්ග්‍රැෆියා අවදානම් මට්ටම',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const SizedBox(height: 8),
                              Text(_getRiskDisplayText(),
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: riskColor)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
                                child: Text('ලකුණු: ${widget.riskScore.toStringAsFixed(1)}/100',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: riskColor)),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline, color: riskColor, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text(_getRecommendation(),
                                        style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Formation Accuracy Card (NEW - only for letters & words)
                      _buildFormationCard(),

                      const SizedBox(height: 8),

                      // Performance metrics
                      _buildMetricCard(
                        icon: Icons.check_circle_outline, iconColor: Colors.green,
                        label: 'සම්පූර්ණ කළ ප්‍රශ්න',
                        value: '${widget.completedPrompts} / ${widget.totalPrompts}',
                        backgroundColor: Colors.green.shade50,
                      ),
                      _buildMetricCard(
                        icon: Icons.timer_outlined, iconColor: Colors.blue,
                        label: 'සමස්ත කාලය',
                        value: '${totalTime.toStringAsFixed(1)} තත්පර',
                        backgroundColor: Colors.blue.shade50,
                      ),
                      _buildMetricCard(
                        icon: Icons.speed, iconColor: Colors.orange,
                        label: 'සාමාන්‍ය කාලය',
                        value: '${avgTime.toStringAsFixed(1)} තත්පර',
                        backgroundColor: Colors.orange.shade50,
                      ),
                      _buildMetricCard(
                        icon: Icons.edit, iconColor: Colors.purple,
                        label: 'මුළු ස්ට්‍රෝක්',
                        value: '${widget.totalStrokes}',
                        backgroundColor: Colors.purple.shade50,
                      ),
                      _buildMetricCard(
                        icon: Icons.refresh, iconColor: Colors.red,
                        label: 'නැවත උත්සාහයන්',
                        value: '${widget.totalClears} වාර',
                        backgroundColor: Colors.red.shade50,
                      ),

                      const SizedBox(height: 32),

                      // Back button
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, size: 24),
                            label: const Text('ආපසු යන්න', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'දිගටම අභ්‍යාස කරන්න! ඔබේ ලිවීමේ කුසලතා දියුණු වේ.',
                                  style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}