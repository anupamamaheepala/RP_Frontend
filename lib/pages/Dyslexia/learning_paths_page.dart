import 'package:flutter/material.dart';

class LearningPathsPage extends StatelessWidget {
  final String tier;  // The risk assessment tier (e.g., "Low", "Medium", "High")
  final int grade;  // The grade of the student
  final int level;  // The level of the reading task (1-4)
  final Map<String, dynamic> sessionPayload;  // The session data containing metrics

  const LearningPathsPage({
    super.key,
    required this.tier,
    required this.grade,
    required this.level,
    required this.sessionPayload,
  });

  @override
  Widget build(BuildContext context) {
    // Example of personalized learning paths based on tier
    String learningPath = _getLearningPathBasedOnTier(tier);

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
            // Title
            Text(
              'Personalized Learning Path for Grade $grade, Level $level',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Risk level
            Text(
              'Risk Level: $tier',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getRiskColor(tier),
              ),
            ),
            const SizedBox(height: 24),

            // Display the learning path based on the risk tier
            Text(
              'Recommended Path:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              learningPath,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Additional resources or tips can go here
            const Text(
              'Tips to improve your reading:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _getReadingTips(tier),
          ],
        ),
      ),
    );
  }

  // Function to get the learning path based on the dyslexia risk tier
  String _getLearningPathBasedOnTier(String tier) {
    switch (tier) {
      case "Low":
        return "Continue practicing with more complex sentences. Focus on fluency and speed.";
      case "Medium":
        return "Practice simple to moderately complex sentences. Focus on word accuracy and pacing.";
      case "High":
        return "Work on simpler sentences and improve accuracy. Focus on word recognition and pacing.";
      default:
        return "No specific learning path available.";
    }
  }

  // Function to get color for the risk level
  Color _getRiskColor(String level) {
    switch (level) {
      case "Low":
        return Colors.green;
      case "Medium":
        return Colors.orange;
      case "High":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Function to get the relevant reading tips based on the risk level
  Widget _getReadingTips(String tier) {
    switch (tier) {
      case "Low":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("- Practice reading longer sentences with focus on fluency."),
            Text("- Work on increasing reading speed while maintaining accuracy."),
            Text("- Use advanced reading materials to further challenge the student."),
          ],
        );
      case "Medium":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("- Focus on reading simpler sentences and increase accuracy."),
            Text("- Start practicing with compound sentences for better flow."),
            Text("- Spend more time on improving reading speed with basic texts."),
          ],
        );
      case "High":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("- Practice reading simple and short sentences."),
            Text("- Focus on recognition of words and reading slowly for accuracy."),
            Text("- Use visuals or phonics tools to aid recognition of words."),
          ],
        );
      default:
        return const Text("No specific tips available.");
    }
  }
}