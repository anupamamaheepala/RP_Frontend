import 'package:flutter/material.dart';

class DyslexiaLevelPage extends StatelessWidget {
  final int grade;

  const DyslexiaLevelPage({super.key, required this.grade});

  // You can customize levels per grade here later
  List<Map<String, dynamic>> getLevels() {
    return [
      {
        "level": 1,
        "titleSi": "මූලික වචන",
        "titleEn": "Basic Words",
        "colors": [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      },
      {
        "level": 2,
        "titleSi": "සරල වාක්‍ය",
        "titleEn": "Simple Sentences",
        "colors": [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      },
      {
        "level": 3,
        "titleSi": "කෙටි වක්‍රාන්ත",
        "titleEn": "Short Paragraph",
        "colors": [const Color(0xFFfa709a), const Color(0xFFfee140)],
      },
      {
        "level": 4,
        "titleSi": "උසස් මට්ටම",
        "titleEn": "Advanced Reading",
        "colors": [const Color(0xFFf7971e), const Color(0xFFffd200)],
      },
    ];
  }

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
        leading:
        const Icon(Icons.star_rounded, color: Colors.white, size: 32),
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
        trailing:
        const Icon(Icons.arrow_forward_ios, color: Colors.white),
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
                // Later we navigate to actual Dyslexia test page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text("Selected Level ${level["level"]} for Grade $grade"),
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
