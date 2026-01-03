// lib/adhd/grade4/grade4_ready_page.dart
import 'package:flutter/material.dart';
import 'grade4_task1_listen_extract.dart';

class Grade4ReadyPage extends StatelessWidget {
  const Grade4ReadyPage({super.key});

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
          'අධිමානසික නෝයීන්තා – ශ්‍රේණිය 4',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology_alt_rounded, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'ඔබට සූදානම්ද?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            const Text(
              'ඔබ 4 කෙටි ක්‍රියාකාරකම් කරනවා. උත්සාහ කරන්න!',
              style: TextStyle(fontSize: 20, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Grade4Task1ListenExtract()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf7971e),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              ),
              child: const Text('ආරම්භ කරමු!', style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}