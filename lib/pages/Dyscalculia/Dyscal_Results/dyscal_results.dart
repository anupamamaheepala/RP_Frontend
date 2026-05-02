import 'package:flutter/material.dart';
import 'dyscal_detect_result.dart';
import 'dyscal_improve_result.dart';
import 'dyscal_dashboard_instructions.dart';  // NEW IMPORT

class DyscalResultsPage extends StatelessWidget {
  const DyscalResultsPage({super.key});

  Widget _buildSquareButton({
    required BuildContext context,
    required String titleSi,
    required String titleEn,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 270,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              titleSi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              titleEn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
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
                        'ඩිස්කැල්කියුලියා ප්‍රතිඵල',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        _buildSquareButton(
                          context: context,
                          titleSi: 'ගණිත දුෂ්කරතා හඳුනාගැනීමේ ප්‍රතිඵල',
                          titleEn: 'Detection Results',
                          icon: Icons.analytics_rounded,
                          gradientColors: [Colors.green.shade400, Colors.teal.shade300],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DyscalDetectResultPage()));
                          },
                        ),
                        const SizedBox(height: 25),
                        _buildSquareButton(
                          context: context,
                          titleSi: 'ගණිත හැකියා දියුණු කිරීමේ ප්‍රතිඵල',
                          titleEn: 'Improvement Results',
                          icon: Icons.trending_up_rounded,
                          gradientColors: [Colors.orange.shade400, Colors.pink.shade300],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DyscalImproveResultPage()));
                          },
                        ),
                        const SizedBox(height: 25),
                        // NEW DASHBOARD BUTTON
                        _buildSquareButton(
                          context: context,
                          titleSi: 'ප්‍රතිඵල පුවරුව සහ උපදෙස්',
                          titleEn: 'Dashboard & Instructions',
                          icon: Icons.dashboard_rounded,
                          gradientColors: [Colors.purple.shade400, Colors.indigo.shade400],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DyscalDashboardInstructionsPage()));
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
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