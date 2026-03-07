// lib/adhd/grade_selection_page.dart
import 'package:flutter/material.dart';
import 'adhd_level_page.dart';

class GradeSelectionPage extends StatelessWidget {
  const GradeSelectionPage({super.key});

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color colorBG = Color(0xFFF8FAFC); // 60%
  static const Color colorPrimary = Color(0xFF0288D1); // 30%
  static const Color colorAccent = Color(0xFFFF9800); // 10%

  Widget _buildGradeCard({
    required int grade,
    required List<Color> colors,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 35),
          ),
          title: Text(
            "ශ්‍රේණිය $grade",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          subtitle: Text(
            "ඉගෙනුම් මට්ටම", // Grammar fixed to 'Learning Level' in Sinhala
            style: TextStyle(color: Colors.white12, fontSize: 16),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ADHDLevelPage(grade: grade),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: colorPrimary, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ශ්‍රේණිය තෝරන්න', // Grammar fixed to 'Choose Grade'
          style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              const Center(
                child: Text(
                  "ඔබේ ශ්‍රේණිය තෝරා ක්‍රීඩාව අරඹන්න",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Grade Cards with updated vibrant but balanced colors
              _buildGradeCard(
                  grade: 3,
                  colors: [const Color(0xFF2196F3), const Color(0xFF00BCD4)],
                  context: context
              ),
              _buildGradeCard(
                  grade: 4,
                  colors: [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
                  context: context
              ),
              _buildGradeCard(
                  grade: 5,
                  colors: [const Color(0xFFE91E63), const Color(0xFFFFC107)],
                  context: context
              ),
              _buildGradeCard(
                  grade: 6,
                  colors: [const Color(0xFF673AB7), const Color(0xFF9C27B0)],
                  context: context
              ),
              _buildGradeCard(
                  grade: 7,
                  colors: [const Color(0xFFFF5722), const Color(0xFFFF9800)],
                  context: context
              ),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "ඔයාට පුළුවන්! ජය වේවා! 🌟",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}