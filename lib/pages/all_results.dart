import 'package:flutter/material.dart';
import '/pages/Dyscalculia/dyscal_results.dart';
import 'adhd/grade3/learning_tasks/adhd_progress_page.dart';


class AllResultsPage extends StatelessWidget {
  const AllResultsPage({super.key});

  Widget _buildResultCard({
    required String titleSi,
    required String titleEn,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        title: Text(
          titleSi,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            titleEn,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            color: Colors.white, size: 20),
        onTap: onTap,
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
              // --- APP BAR HEADER ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'ප්‍රතිඵල (Results)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // --- RESULTS CARDS LIST ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  children: [
                    _buildResultCard(
                      titleSi: 'කියවීමේ දුෂ්කරතා ප්‍රතිඵල',
                      titleEn: 'Dyslexia Results',
                      icon: Icons.menu_book_rounded,
                      colors: [
                        Colors.purple.shade400,
                        Colors.blue.shade400
                      ],
                      onTap: () {
                        // TODO: Navigate to Dyslexia Results Fetch Page
                      },
                    ),
                    _buildResultCard(
                      titleSi: 'ලිවීමේ දුෂ්කරතා ප්‍රතිඵල',
                      titleEn: 'Dysgraphia Results',
                      icon: Icons.drive_file_rename_outline_rounded,
                      colors: [
                        Colors.blue.shade400,
                        Colors.teal.shade300
                      ],
                      onTap: () {
                        // TODO: Navigate to Dysgraphia Results Fetch Page
                      },
                    ),
                    _buildResultCard(
                      titleSi: 'ගණනයේ දුෂ්කරතා ප්‍රතිඵල',
                      titleEn: 'Dyscalculia Results',
                      icon: Icons.calculate_rounded,
                      colors: [
                        Colors.green.shade400,
                        Colors.teal.shade300
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const DyscalResultsPage()),
                        );
                      },
                    ),
                    // ✅ Updated: navigates to AdhDProgressPage
                    _buildResultCard(
                      titleSi: 'අවධාන ඌණතා ප්‍රතිඵල',
                      titleEn: 'ADHD Results & Progress',
                      icon: Icons.psychology_alt_rounded,
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.indigo.shade400
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AdhDProgressPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}