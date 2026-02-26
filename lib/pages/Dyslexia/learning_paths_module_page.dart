import 'package:flutter/material.dart';

import 'module_activity_page.dart';

class LearningPathsPage extends StatelessWidget {
  final String tier;
  final int grade;
  final int level;
  final Map<String, dynamic> sessionPayload;

  const LearningPathsPage({
    super.key,
    required this.tier,
    required this.grade,
    required this.level,
    required this.sessionPayload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Paths'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grade $grade - Level $level',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Display the 4 modules (M1, M2, M3, M4)
            Text(
              'Modules:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Modules List
            Expanded(
              child: ListView(
                children: [
                  _buildModuleCard(context, 'M1: Basic Activities', 1),
                  _buildModuleCard(context, 'M2: Intermediate Activities', 2),
                  _buildModuleCard(context, 'M3: Advanced Activities', 3),
                  _buildModuleCard(context, 'M4: Mastery Activities', 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create a module card (with locking and unlocking logic)
  Widget _buildModuleCard(BuildContext context, String moduleTitle, int moduleNumber) {
    // Logic to lock/unlock modules based on the student's current progress
    bool isUnlocked = false;
    if (moduleNumber == 1) {
      isUnlocked = true;  // M1 is always unlocked (first module)
    } else if (moduleNumber == 2) {
      isUnlocked = sessionPayload['M1_completed'] ?? false;  // M2 is unlocked if M1 is completed
    } else if (moduleNumber == 3) {
      isUnlocked = sessionPayload['M2_completed'] ?? false;  // M3 is unlocked if M2 is completed
    } else if (moduleNumber == 4) {
      isUnlocked = sessionPayload['M3_completed'] ?? false;  // M4 is unlocked if M3 is completed
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      child: ListTile(
        title: Text(moduleTitle),
        trailing: Icon(
          isUnlocked ? Icons.lock_open : Icons.lock,
          color: isUnlocked ? Colors.green : Colors.red,
        ),
        onTap: isUnlocked
            ? () {
          // Navigate to the module's activity page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModuleActivityPage(
                moduleNumber: moduleNumber,
                sessionPayload: sessionPayload,
              ),
            ),
          );
        }
            : null,  // If the module is locked, disable the onTap
      ),
    );
  }
}