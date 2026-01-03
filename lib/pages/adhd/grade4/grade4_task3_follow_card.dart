// lib/adhd/grade4/grade4_task3_follow_card.dart
import 'package:flutter/material.dart';
import 'grade4_success_page.dart';
import 'grade4_task4_stay_complete.dart';

class Grade4Task3FollowCard extends StatefulWidget {
  const Grade4Task3FollowCard({super.key});

  @override
  _Grade4Task3FollowCardState createState() => _Grade4Task3FollowCardState();
}

class _Grade4Task3FollowCardState extends State<Grade4Task3FollowCard> {
  bool showInstructions = true;
  int helpCount = 0;

  // Tracking
  bool tappedBlue = false;
  bool draggedStar = false;
  int tappedTriangleCount = 0;

  @override
  Widget build(BuildContext context) {
    if (showInstructions) {
      return Scaffold(
        backgroundColor: const Color(0xFF8EC5FC),
        appBar: AppBar(title: const Text('Task 3: Follow the Card')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'Remember these rules:\n\n'
                        '1. Tap the BLUE circle\n'
                        '2. Drag the STAR to the box\n'
                        '3. Do NOT tap the triangle',
                    style: const TextStyle(fontSize: 22, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => setState(() => showInstructions = false),
                child: const Text('I Remember! Start Task', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => setState(() => helpCount++),
                child: Text('Show Again ($helpCount times)', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      );
    }

    // Task phase
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 3: Do What the Card Said')),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Now follow the instructions!', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Blue circle
                      GestureDetector(
                        onTap: () => setState(() => tappedBlue = true),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: tappedBlue ? Border.all(color: Colors.green, width: 6) : null,
                          ),
                        ),
                      ),
                      // Triangle (forbidden)
                      GestureDetector(
                        onTap: () {
                          setState(() => tappedTriangleCount++);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Oops! Do NOT tap the triangle!'), duration: Duration(seconds: 1)),
                          );
                        },
                        child: CustomPaint(size: const Size(100, 100), painter: TrianglePainter()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  // Draggable star (disappears when dragged successfully)
                  if (!draggedStar)
                    Draggable<String>(
                      data: 'star',
                      feedback: const Icon(Icons.star, size: 80, color: Colors.yellow),
                      childWhenDragging: Opacity(opacity: 0.3, child: const Icon(Icons.star, size: 80, color: Colors.yellow)),
                      child: const Icon(Icons.star, size: 80, color: Colors.yellow),
                    ),
                  const SizedBox(height: 40),
                  // Drop box - now shows star inside when accepted
                  DragTarget<String>(
                    onAccept: (data) => setState(() => draggedStar = true),
                    builder: (context, candidateData, rejectedData) => Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: draggedStar ? Colors.green : Colors.purple),
                        borderRadius: BorderRadius.circular(20),
                        color: draggedStar ? Colors.green.withOpacity(0.2) : null,
                      ),
                      child: Center(
                        child: draggedStar
                            ? const Icon(Icons.star, size: 80, color: Colors.yellow)
                            : const Text('Drop star here', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Help requests: $helpCount | Forbidden taps: $tappedTriangleCount',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Help button - moved down, clearer label + icon
          Positioned(
            top: 160,  // ← Moved down a bit
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                setState(() {
                  showInstructions = true;
                  helpCount++;
                });
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outline, size: 28),
                  Text('Help', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          // Next button
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Grade4SuccessPage(
                      taskNumber: '3',
                      nextPage: Grade4Task4StayComplete(),
                    ),
                  ),
                );
              },
              child: const Text('Next Task', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}