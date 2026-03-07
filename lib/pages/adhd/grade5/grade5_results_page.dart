// lib/adhd/grade5/grade5_results_page.dart
import 'package:flutter/material.dart';

class Grade5ResultsPage extends StatelessWidget {
  const Grade5ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Grade 5 Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 120, color: Colors.yellow),
            const Text('හොඳින් කළා!', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 20),
            const Text('Your scores will appear here.'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}