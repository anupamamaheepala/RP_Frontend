import 'package:flutter/material.dart';
import 'adhd_level_page.dart'; // Make sure this path is correct (e.g., 'adhd_level_page.dart' or '../adhd_level_page.dart')

class GradeSelectionPage extends StatelessWidget {
  const GradeSelectionPage({super.key});

  final List<int> grades = const [3, 4, 5, 6, 7];

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
              builder: (_) => ADHDLevelPage(grade: grade),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'අවධාන ඌණතා – Grade Selection',
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
                "Select your grade level",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildGradeCard(grade: 3, colors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)], context: context),
              _buildGradeCard(grade: 4, colors: [const Color(0xFF43e97b), const Color(0xFF38f9d7)], context: context),
              _buildGradeCard(grade: 5, colors: [const Color(0xFFfa709a), const Color(0xFFfee140)], context: context),
              _buildGradeCard(grade: 6, colors: [const Color(0xFFF68084), const Color(0xFF8EC5FC)], context: context),
              _buildGradeCard(grade: 7, colors: [const Color(0xFFf7971e), const Color(0xFFffd200)], context: context),
            ],
          ),
        ),
      ),
    );
  }
}