import 'package:flutter/material.dart';
import 'dyslexia_read_page.dart';

class DyslexiaLevelPage extends StatelessWidget {
  final int grade;

  const DyslexiaLevelPage({super.key, required this.grade});

  List<Map<String, dynamic>> getLevels() {
    return [
      {
        "level": 1,
        "titleSi": "මූලික වාක්‍ය ඛණ්ඩ",
        "titleEn": "Basic Sentence Fragments",
        "colors": [Colors.purple.shade400, Colors.blue.shade400],
      },
      {
        "level": 2,
        "titleSi": "සරල වාක්‍ය ඛණ්ඩ",
        "titleEn": "Simple Sentence Fragments",
        "colors": [Colors.blue.shade400, Colors.teal.shade300],
      },
      {
        "level": 3,
        "titleSi": "මධ්‍යම සංකීර්ණ වාක්‍ය",
        "titleEn": "Moderately Complex Sentences",
        "colors": [Colors.green.shade400, Colors.teal.shade300],
      },
      {
        "level": 4,
        "titleSi": "සංකීර්ණ වාක්‍ය",
        "titleEn": "Complex Sentences",
        "colors": [Colors.deepPurple.shade400, Colors.indigo.shade400],
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
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          "$titleSi (Level $level)",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          titleEn,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levels = getLevels();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER (same style as other pages)
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
                      child: Text(
                        'ශ්‍රේණිය $grade – මට්ටම තෝරන්න',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "කියවීමේ මට්ටම තෝරන්න",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // LEVEL LIST
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
