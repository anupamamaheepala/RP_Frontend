// lib/adhd/grade5/grade5_task4_switch_go.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade5_success_page.dart';
import 'grade5_results_page.dart';

class Grade5Task4SwitchGo extends StatefulWidget {
  const Grade5Task4SwitchGo({super.key});

  @override
  _Grade5Task4SwitchGoState createState() => _Grade5Task4SwitchGoState();
}

class _Grade5Task4SwitchGoState extends State<Grade5Task4SwitchGo> {
  bool isAnimalRule = true;
  int trials = 0;
  final int maxTrials = 50;
  int correct = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 4: Switch Rules')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Rule: ${isAnimalRule ? "Animals" : "Vehicles"}',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                // Simulate tap on animal or vehicle
                if (isAnimalRule) correct++;
                setState(() {
                  trials++;
                  if (trials % 10 == 0) isAnimalRule = !isAnimalRule;
                  if (trials >= maxTrials) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Grade5SuccessPage(
                          taskNumber: '4',
                          nextPage: const Grade5ResultsPage(),
                        ),
                      ),
                    );
                  }
                });
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.orange,
                child: const Center(child: Text('Tap here (animal/vehicle)')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}