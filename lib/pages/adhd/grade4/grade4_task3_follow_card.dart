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

  // Tracking progress
  int tappedBlueCount = 0;
  bool draggedStar = false;
  int tappedTriangleCount = 0;

  // 60-30-10 වර්ණ
  final Color color60 = const Color(0xFFF1F5F9); // පසුබිම
  final Color color30 = const Color(0xFF0288D1); // ව්‍යුහය
  final Color color10 = const Color(0xFFFF9800); // ක්‍රියාකාරී බොත්තම්

  @override
  Widget build(BuildContext context) {
    if (showInstructions) {
      return Scaffold(
        backgroundColor: color60,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('පියවර 3: උපදෙස් මතක තබා ගන්න', style: TextStyle(color: color30, fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(35),
                    child: Column(
                      children: [
                        Text(
                          'මෙම නීති හොඳින් මතක තබා ගන්න:',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color30),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        _ruleText('1. නිල් රවුම මත 3 වතාවක් තට්ටු කරන්න.'),
                        _ruleText('2. කහ තරුව ඇදගෙන ගොස් පෙට්ටිය තුළට දමන්න.'),
                        _ruleText('3. රතු ත්‍රිකෝණය ස්පර්ශ නොකරන්න.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => setState(() => showInstructions = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color10,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('මම සූදානම්! ක්‍රීඩාව අරඹන්න', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => setState(() => helpCount++),
                  child: Text('නැවත පෙන්වන්න ($helpCount)', style: TextStyle(color: color30, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Task phase
    return Scaffold(
      backgroundColor: color60,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('දැන් මතකයෙන් වැඩ කරන්න', style: TextStyle(color: color30, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'පවසා ඇති දේ නිවැරදිව කරන්න!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color30),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Blue circle (Must tap 3 times)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (tappedBlueCount < 3) tappedBlueCount++;
                        });
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(
                                color: tappedBlueCount >= 3 ? Colors.greenAccent : Colors.white,
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
                              ],
                            ),
                            child: Center(
                              child: tappedBlueCount >= 3
                                  ? const Icon(Icons.check, color: Colors.white, size: 50)
                                  : Text('$tappedBlueCount', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('නිල් රවුම', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    // Triangle (The Trap)
                    GestureDetector(
                      onTap: () {
                        setState(() => tappedTriangleCount++);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('අයියෝ! ත්‍රිකෝණය ස්පර්ශ කරන්න එපා!', style: TextStyle(fontFamily: 'Sinhala')),
                            backgroundColor: Colors.red,
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CustomPaint(size: const Size(100, 100), painter: TrianglePainter()),
                          const SizedBox(height: 8),
                          const Text('ත්‍රිකෝණය', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Draggable Star Section
                if (!draggedStar)
                  Draggable<String>(
                    data: 'star',
                    feedback: const Icon(Icons.star, size: 100, color: Colors.amber),
                    childWhenDragging: Opacity(opacity: 0.2, child: const Icon(Icons.star, size: 90, color: Colors.amber)),
                    child: const Icon(Icons.star, size: 90, color: Colors.amber),
                  ),

                const SizedBox(height: 30),

                // Target Box
                DragTarget<String>(
                  onAccept: (data) => setState(() => draggedStar = true),
                  builder: (context, candidateData, rejectedData) => Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 4,
                        color: draggedStar ? Colors.green : color30.withOpacity(0.5),
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: draggedStar
                          ? const Icon(Icons.star, size: 100, color: Colors.amber)
                          : Text('තරුව මෙතැනට\nඅත්හරින්න', textAlign: TextAlign.center, style: TextStyle(color: color30.withOpacity(0.6))),
                    ),
                  ),
                ),
                const Spacer(),

                // Stats
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'වැරදි තට්ටු කිරීම්: $tappedTriangleCount',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Help Button
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  showInstructions = true;
                  helpCount++;
                });
              },
              backgroundColor: color10,
              icon: const Icon(Icons.help_outline, color: Colors.white),
              label: const Text('උදව්', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          // Next Button (Only visible when tasks are complete)
          if (draggedStar && tappedBlueCount >= 3)
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('මීළඟ පියවරට යන්න ➔', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _ruleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color30, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 18, height: 1.4))),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
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