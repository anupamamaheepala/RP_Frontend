// lib/adhd/grade5/grade5_task2_filter.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade5_success_page.dart';
import 'grade5_task3_stillness.dart';

class Grade5Task2Filter extends StatefulWidget {
  const Grade5Task2Filter({super.key});

  @override
  _Grade5Task2FilterState createState() => _Grade5Task2FilterState();
}

class _Grade5Task2FilterState extends State<Grade5Task2Filter> {
  int trials = 0;
  final int maxTrials = 30;
  int correctTaps = 0;
  int wrongTaps = 0; // ← Renamed from 'false'
  List<Widget> gridItems = [];

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  void _generateGrid() {
    gridItems = List.generate(16, (index) {
      // Randomly choose green or blue
      Color color = [Colors.green, Colors.blue][Random().nextInt(2)];
      return GestureDetector(
        onTap: () {
          if (color == Colors.green) {
            correctTaps++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Correct!'),
              ),
            );
          } else {
            wrongTaps++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Wrong!'),
              ),
            );
          }
          setState(() {
            trials++;
            if (trials >= maxTrials) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const Grade5SuccessPage(
                    taskNumber: '2',
                    nextPage: Grade5Task3Stillness(),
                  ),
                ),
              );
            } else {
              _generateGrid(); // Refresh grid for next trial
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          color: color,
        ),
      );
    });
    setState(() {}); // Ensure UI updates after generating grid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 2: Tap Green!')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Tap all GREEN shapes!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Trial $trials / $maxTrials',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: gridItems,
            ),
          ],
        ),
      ),
    );
  }
}