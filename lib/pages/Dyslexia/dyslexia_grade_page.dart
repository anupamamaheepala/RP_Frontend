import 'package:flutter/material.dart';
import 'dyslexia_level_page.dart';

class DyslexiaGradePage extends StatelessWidget {
  const DyslexiaGradePage({super.key});

  // Grade list (3–7)
  final List<int> grades = const [3, 4, 5, 6, 7];

  // Beautiful gradient card builder
  Widget _buildGradeCard({
    required int grade,
    required List<Color> colors,
    required BuildContext context,
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
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.school_rounded, color: Colors.white, size: 35),
        title: Text(
          "ශ්‍රේණිය $grade",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          "Grade Level",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DyslexiaLevelPage(grade: grade),
            ),
          );
        },
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
        title: const Text(
          'කියවීමේ දුෂ්කරතා – Grade Selection',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select your grade level",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Grade Cards
            _buildGradeCard(
              grade: 3,
              colors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
              context: context,
            ),
            _buildGradeCard(
              grade: 4,
              colors: [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
              context: context,
            ),
            _buildGradeCard(
              grade: 5,
              colors: [const Color(0xFFfa709a), const Color(0xFFfee140)],
              context: context,
            ),
            _buildGradeCard(
              grade: 6,
              colors: [const Color(0xFFF68084), const Color(0xFF8EC5FC)],
              context: context,
            ),
            _buildGradeCard(
              grade: 7,
              colors: [const Color(0xFFf7971e), const Color(0xFFffd200)],
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
