import 'package:flutter/material.dart';
import 'Dyslexia/dyslexia_grade_page.dart';
import 'Dysgraphia/dysgraphia_grade_selection.dart';
// import 'Dyscalculia/dyscalculia_page.dart';
import 'dyscalculia_page.dart';

import '/profile.dart'; // Import your Profile Page here


import 'ADHD/grade_selection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildCard({
    required String titleSi,
    required String titleEn,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 35),
        title: Text(
          titleSi,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          titleEn,
          style: const TextStyle(color: Colors.white70),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        title: const Text(
          'කුමක් පරික්ෂා කරමු?',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "What would you like to check?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              // Dyslexia – unchanged (your friend's code)
              _buildCard(
                titleSi: 'කියවීමේ දුෂ්කරතා',
                titleEn: 'Dyslexia',
                icon: Icons.menu_book_rounded,
                colors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyslexiaGradePage()),
                  );
                },
              ),

              // Dysgraphia – unchanged (your friend's code)
              _buildCard(
                titleSi: 'ලිවීමේ දුෂ්කරතා',
                titleEn: 'Dysgraphia',
                icon: Icons.edit_note,
                colors: [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DysgraphiaGradePage()),
                  );
                },
              ),

              // Dyscalculia – unchanged (your friend's code)
              _buildCard(
                titleSi: 'ගණනයේ දුෂ්කරතා',
                titleEn: 'Dyscalculia',
                icon: Icons.calculate_rounded,
                colors: [const Color(0xFFfa709a), const Color(0xFFfee140)],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyscalculiaPage()),
                  );
                },
              ),

              // ADHD/ADD – ONLY THIS PART CHANGED (your component)
              _buildCard(
                titleSi: 'අවධාන ඌණතා',
                titleEn: 'ADHD',
                icon: Icons.psychology_alt_rounded,
                colors: [const Color(0xFFf7971e), const Color(0xFFffd200)],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GradeSelectionPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}