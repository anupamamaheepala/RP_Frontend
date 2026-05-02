import 'package:flutter/material.dart';
import 'package:rp_frontend/pages/Dysgraphia/Dysgraphia_improve/dashboard/screens/dysgraphia_dashboard_main.dart';
import 'dysgraphia_detection_results.dart';
class DysgraphiaResultsHub extends StatelessWidget {
  const DysgraphiaResultsHub({super.key});

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
                    const Expanded(
                      child: Text(
                        'ඩිස්ග්‍රැෆියා ප්‍රතිඵල',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
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
                      // Detection Results card
                      _buildCard(
                        context: context,
                        icon: Icons.bar_chart_rounded,
                        titleSi: 'ලිවීමේ දුෂ්කරතා\nහඳුනාගැනීමේ ප්‍රතිඵල',
                        titleEn: 'Detection Results',
                        gradientColors: [Colors.blue.shade400, Colors.teal.shade400],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DysgraphiaDashboardMain(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Improvement Results card
                      _buildCard(
                        context: context,
                        icon: Icons.trending_up_rounded,
                        titleSi: 'ලිවීමේ හැකියාවන්\nදියුණු කිරීමේ ප්‍රතිඵල',
                        titleEn: 'Improvement Results',
                        gradientColors: [Colors.orange.shade400, Colors.pink.shade400],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DysgraphiaDashboardMain(),
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
    required String titleSi,
    required String titleEn,
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
              titleSi,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              titleEn,
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