// lib/adhd/grade5/grade5_task1_ladder.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'grade5_success_page.dart';
import 'grade5_task2_filter.dart';

class Grade5Task1Ladder extends StatefulWidget {
  const Grade5Task1Ladder({super.key});

  @override
  _Grade5Task1LadderState createState() => _Grade5Task1LadderState();
}

class _Grade5Task1LadderState extends State<Grade5Task1Ladder> {
  int currentStep = 0;
  final List<String> steps = [
    'Tap the blue square',
    'Wait until the circle turns green',
    'Drag the star into the box',
    'Tap the number 3',
    'Tap the red triangle',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 1: Follow Steps')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step ${currentStep + 1} of ${steps.length}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              steps[currentStep],
              style: const TextStyle(fontSize: 24, color: Colors.purple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Placeholder for step interaction (expand later)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep++;
                });
                if (currentStep >= steps.length) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Grade5SuccessPage(
                        taskNumber: '1',
                        nextPage: Grade5Task2Filter(),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Next Step (Demo)'),
            ),
          ],
        ),
      ),
    );
  }
}