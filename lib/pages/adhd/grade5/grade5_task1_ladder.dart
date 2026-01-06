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
  bool isCircleGreen = false;
  bool starDragged = false;
  Timer? _waitTimer;

  // 60-30-10 වර්ණ නීතිය
  static const Color color60BG = Color(0xFFF8FAFC);
  static const Color color30Secondary = Color(0xFF0288D1);
  static const Color color10Accent = Color(0xFFFF9800);

  final List<Map<String, String>> steps = [
    {
      'instr': 'නිල් පැහැති සමචතුරස්‍රය ස්පර්ශ කරන්න.',
      'hint': 'වර්ණ කිහිපය අතරින් නිවැරදි කොටුව තෝරන්න'
    },
    {
      'instr': 'රවුම කොළ පැහැ වන තුරු රැඳී සිට එය ස්පර්ශ කරන්න.',
      'hint': 'මඳ වේලාවක් ඉවසීමෙන් රැඳී සිටින්න...'
    },
    {
      'instr': 'තරුව ඇදගෙන ගොස් පෙට්ටිය තුළට දමන්න.',
      'hint': 'තරුව නිවැරදිව පෙට්ටිය මත අත්හරින්න'
    },
    {
      'instr': 'අංක 3 ස්පර්ශ කරන්න.',
      'hint': 'අංක කිහිපයක් අතරින් 3 සොයන්න'
    },
    {
      'instr': 'රතු පැහැති ත්‍රිකෝණය ස්පර්ශ කරන්න.',
      'hint': 'හැඩතල අතරින් නිවැරදි රූපය තෝරන්න'
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkSpecialStepLogic();
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
        isCircleGreen = false;
        starDragged = false;
      });
      _checkSpecialStepLogic();
    } else {
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
  }

  void _checkSpecialStepLogic() {
    // පියවර 2: අවුරුදු 11ක දරුවෙකුගේ අවධානය පරීක්ෂා කිරීමට තත්පර 3ක කාලයක්
    if (currentStep == 1) {
      _waitTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => isCircleGreen = true);
      });
    }
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'පියවර 1: උපදෙස් අනුගමනය',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ප්‍රගති තීරුව (30% Element)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentStep + 1) / steps.length,
                      backgroundColor: color30Secondary.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(color30Secondary),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ප්‍රගතිය: ${currentStep + 1} / ${steps.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: color30Secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // උපදෙස් පුවරුව (30% structural)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
                ],
                border: Border.all(color: color30Secondary.withOpacity(0.2), width: 2),
              ),
              child: Text(
                steps[currentStep]['instr']!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // අන්තර්ක්‍රියාකාරී ප්‍රදේශය (10% Accent Focus)
            _buildInteractionArea(),

            const Spacer(),

            // ඉඟිය (Hint)
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 30),
              child: Text(
                'උදව්: ${steps[currentStep]['hint']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionArea() {
    // වයස අවුරුදු 10-11 දරුවන්ට ගැළපෙන ක්‍රියාකාරකම්
    switch (currentStep) {
      case 0: // Blue Square with Distractors
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _shapeBox(Colors.red, false),
            _shapeBox(Colors.blue, true),
            _shapeBox(Colors.green, false),
          ],
        );
      case 1: // Wait for Green Circle
        return GestureDetector(
          onTap: isCircleGreen ? _nextStep : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 140, height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCircleGreen ? Colors.green : Colors.grey[300],
              boxShadow: isCircleGreen
                  ? [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)]
                  : [],
            ),
            child: Icon(
                isCircleGreen ? Icons.touch_app : Icons.hourglass_top_rounded,
                color: Colors.white, size: 60
            ),
          ),
        );
      case 2: // Drag Star to Target
        return Column(
          children: [
            if (!starDragged)
              Draggable<String>(
                data: 'star',
                feedback: const Icon(Icons.star_rounded, size: 100, color: color10Accent),
                childWhenDragging: Opacity(opacity: 0.2, child: const Icon(Icons.star_rounded, size: 80, color: color10Accent)),
                child: const Icon(Icons.star_rounded, size: 80, color: color10Accent),
              ),
            const SizedBox(height: 50),
            DragTarget<String>(
              onAccept: (data) {
                setState(() => starDragged = true);
                Future.delayed(const Duration(milliseconds: 600), _nextStep);
              },
              builder: (context, _, __) => Container(
                width: 150, height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: color30Secondary, width: 3, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(25),
                  color: starDragged ? Colors.green.withOpacity(0.1) : Colors.transparent,
                ),
                child: Center(
                  child: starDragged
                      ? const Icon(Icons.check_circle_rounded, size: 80, color: Colors.green)
                      : const Text('මෙහි ගෙන එන්න', textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        );
      case 3: // Grid of numbers
        return Wrap(
          spacing: 20, runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [7, 5, 3, 9, 1, 2].map((n) => GestureDetector(
            onTap: n == 3 ? _nextStep : null,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: color30Secondary, borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text('$n', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
            ),
          )).toList(),
        );
      case 4: // Red Triangle
        return GestureDetector(
          onTap: _nextStep,
          child: CustomPaint(
            size: const Size(140, 140),
            painter: TrianglePainter(),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _shapeBox(Color color, bool correct) {
    return GestureDetector(
      onTap: correct ? _nextStep : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 90, height: 90,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.redAccent..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}