import 'package:flutter/material.dart';
import 'dysgraphia_activity_selection_page.dart';
import 'Activities/Grade 3/Grade3_high_risk_activities.dart';
import 'Activities/Grade 3/Grade3_medium_risk_activities.dart';
import 'Activities/Grade 3/Grade3_low_risk_activities.dart';

class DysgraphiaLearningPage extends StatelessWidget {
  final int grade;

  const DysgraphiaLearningPage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'ලිවීමේ දුෂ්කරතා',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            'ශ්‍රේණිය $grade',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.purple.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Detect card
                      _buildCard(
                        context: context,
                        icon: Icons.search_rounded,
                        title: 'දුෂ්කරතා හඳුනාගැනීම',
                        subtitle: 'Detect Dysgraphia',
                        gradientColors: [Colors.purple.shade400, Colors.blue.shade400],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DysgraphiaSelectionPage(grade: grade),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Improve card
                      _buildCard(
                        context: context,
                        icon: Icons.trending_up_rounded,
                        title: 'හැකියාවන් දියුණු කිරීම',
                        subtitle: 'Improve Writing Skills',
                        gradientColors: [Colors.orange.shade400, Colors.pink.shade400],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DysgraphiaImprovePage(grade: grade),
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

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 52, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPROVE PAGE — activity selector by risk level
// ─────────────────────────────────────────────────────────────────────────────

class DysgraphiaImprovePage extends StatelessWidget {
  final int grade;

  const DysgraphiaImprovePage({super.key, required this.grade});

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
              // Header
              Container(
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
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'හැකියාවන් දියුණු කිරීම',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'ශ්‍රේණිය $grade',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'අවදානම් මට්ටම තෝරන්න:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRiskButton(
                        context: context,
                        emoji: '🔴',
                        label: 'ඉහළ අවදානම',
                        sublabel: 'High Risk',
                        color: Colors.red.shade400,
                        onTap: () => _navigate(context, 'high'),
                      ),
                      const SizedBox(height: 16),
                      _buildRiskButton(
                        context: context,
                        emoji: '🟠',
                        label: 'මධ්‍යම අවදානම',
                        sublabel: 'Medium Risk',
                        color: Colors.orange.shade400,
                        onTap: () => _navigate(context, 'medium'),
                      ),
                      const SizedBox(height: 16),
                      _buildRiskButton(
                        context: context,
                        emoji: '🟡',
                        label: 'අඩු අවදානම',
                        sublabel: 'Low Risk',
                        color: Colors.teal.shade400,
                        onTap: () => _navigate(context, 'low'),
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

  void _navigate(BuildContext context, String riskLevel) {
    // Only Grade 3 activities exist so far — extend this switch as more grades are added
    if (grade == 3) {
      Widget page;
      switch (riskLevel) {
        case 'high':
          page = const Grade3HighRiskPage();
          break;
        case 'medium':
          page = const Grade3MediumRiskPage();
          break;
        case 'low':
        default:
          page = const Grade3LowRiskPage();
          break;
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ශ්‍රේණිය $grade සඳහා ක්‍රියාකාරකම් ඉදිරියේදී එක් කෙරේ.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildRiskButton({
    required BuildContext context,
    required String emoji,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 4,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(sublabel,
                    style: TextStyle(
                        fontSize: 13, color: Colors.white.withOpacity(0.85))),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}