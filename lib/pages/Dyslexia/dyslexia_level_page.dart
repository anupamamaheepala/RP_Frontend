import 'package:flutter/material.dart';
import 'dyslexia_read_page.dart';

class DyslexiaLevelPage extends StatelessWidget {
  final int grade;

  const DyslexiaLevelPage({super.key, required this.grade});

  // Levels Definition
  List<Map<String, dynamic>> getLevels() {
    return [
      {
        "level": 1,
        "titleSi": "මූලික වචන",
        "titleEn": "Basic Words",
        "colors": [Color(0xFF4facfe), Color(0xFF00f2fe)],
      },
      {
        "level": 2,
        "titleSi": "සරල වාක්‍ය",
        "titleEn": "Simple Sentences",
        "colors": [Color(0xFF43e97b), Color(0xFF38f9d7)],
      },
      {
        "level": 3,
        "titleSi": "කෙටි වාක්‍ය ඛණ්ඩ",
        "titleEn": "Short Paragraph",
        "colors": [Color(0xFFfa709a), Color(0xFFfee140)],
      },
      {
        "level": 4,
        "titleSi": "උසස් මට්ටම",
        "titleEn": "Advanced Reading",
        "colors": [Color(0xFFf7971e), Color(0xFFffd200)],
      },
    ];
  }

  // UI for each Level Card
  Widget _buildLevelCard({
    required String titleSi,
    required String titleEn,
    required int level,
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
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.star_rounded, color: Colors.white, size: 32),
        title: Text(
          "$titleSi (Level $level)",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          titleEn,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = getLevels();

    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Grade $grade – Select Level",
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: levels.map((level) {
            return _buildLevelCard(
              titleSi: level["titleSi"],
              titleEn: level["titleEn"],
              level: level["level"],
              colors: level["colors"],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DyslexiaReadPage(
                      grade: grade,
                      level: level["level"],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
