import 'package:flutter/material.dart';
import 'dyslexia_read_session_page.dart';  // Existing task page
import 'learning_paths_page.dart';  // New learning paths page

class DyslexiaLevelDetailsPage extends StatelessWidget {
  final int grade;
  final int level;
  final String tier;  // Pass tier here
  final Map<String, dynamic> sessionPayload;  // Pass sessionPayload here

  const DyslexiaLevelDetailsPage({
    super.key,
    required this.grade,
    required this.level,
    required this.tier,
    required this.sessionPayload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ශ්‍රේණිය $grade - මට්ටම $level'),
        backgroundColor: Colors.purple,  // Same theme color as your other pages
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),  // Same padding as other pages
            child: Column(
              children: [
                // Two buttons for navigation (Tasks and Learning Paths)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Tasks page (DyslexiaReadSessionPage)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DyslexiaReadSessionPage(
                              grade: grade,
                              level: level,
                            ),
                          ),
                        );
                      },
                      child: const Text('Tasks'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,  // Same color as in DyslexiaLevelPage
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Learning Paths page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LearningPathsPage(
                              tier: tier,  // Pass the tier here
                              grade: grade,  // Pass the grade here
                              level: level,  // Pass the level here
                              sessionPayload: sessionPayload,  // Pass sessionPayload here
                            ),
                          ),
                        );
                      },
                      child: const Text('Learning Paths'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,  // Same color as in DyslexiaLevelPage
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Instructions or any other content you want to display
                const Text(
                  "Select an option to proceed:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}