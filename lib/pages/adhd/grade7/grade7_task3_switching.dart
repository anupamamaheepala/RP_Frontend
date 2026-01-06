// lib/adhd/grade7/grade7_task3_switching.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade7_success_page.dart';
import 'grade7_task4_divided.dart';

class Grade7Task3Switching extends StatefulWidget {
  const Grade7Task3Switching({super.key});

  @override
  State<Grade7Task3Switching> createState() => _Grade7Task3SwitchingState();
}

class _Grade7Task3SwitchingState extends State<Grade7Task3Switching> {
  final int maxTrials = 15; // Change to 60+ later for full assessment
  int currentTrial = 0;
  bool isColorRule = true;
  final int switchInterval = 5;
  int correct = 0;
  int errors = 0;

  // Colors
  final Color color60BG = const Color(0xFFF8FAFF);
  final Color color30Secondary = const Color(0xFF6741D9);
  final Color color10Accent = const Color(0xFFFFB300);

  // Stimulus with safe defaults
  Color stimulusColor = Colors.blue;
  BoxShape stimulusShape = BoxShape.circle;

  final Random _random = Random();

  // Target criteria
  final Color targetColor = Colors.blue;
  final BoxShape targetShape = BoxShape.circle;

  Timer? _ruleSnackBarTimer;

  @override
  void initState() {
    super.initState();
    // Generate first stimulus AFTER the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateStimulus();
    });
  }

  void _generateStimulus() {
    if (!mounted) return;

    setState(() {
      currentTrial++;

      // Switch rule after every 5 completed trials
      if ((currentTrial - 1) % switchInterval == 0 && currentTrial > 1) {
        isColorRule = !isColorRule;
        _showRuleChangeSnackBar();
      }

      // Random stimulus
      stimulusColor = _random.nextBool() ? Colors.blue : Colors.red;
      stimulusShape = _random.nextBool() ? BoxShape.circle : BoxShape.rectangle;
    });
  }

  void _showRuleChangeSnackBar() {
    _ruleSnackBarTimer?.cancel();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'නීතිය මාරු වුණා! දැන් ${isColorRule ? "නිල් පැහැතිදැයි" : "රවුම් හැඩයදැයි"} බලන්න.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: color10Accent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleTap(bool userSaysMatches) {
    if (!mounted) return;

    bool actuallyMatches = isColorRule
        ? (stimulusColor == targetColor)
        : (stimulusShape == targetShape);

    if (userSaysMatches == actuallyMatches) {
      correct++;
    } else {
      errors++;
    }

    if (currentTrial >= maxTrials) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade7SuccessPage(
            taskNumber: '3',
            nextPage: Grade7Task4Divided(),
          ),
        ),
      );
    } else {
      Future.delayed(const Duration(milliseconds: 400), _generateStimulus);
    }
  }

  @override
  void dispose() {
    _ruleSnackBarTimer?.cancel();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: color30Secondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'පියවර 3: නීති මාරු කිරීම (Task Switching)',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Progress
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: currentTrial / maxTrials,
                                backgroundColor: color30Secondary.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(color30Secondary),
                                minHeight: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'වටය: $currentTrial / $maxTrials',
                              style: TextStyle(fontWeight: FontWeight.bold, color: color30Secondary),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Rule Card
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: color10Accent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: color10Accent.withOpacity(0.3), blurRadius: 15)],
                        ),
                        child: Column(
                          children: [
                            const Text('වර්තමාන නීතිය:', style: TextStyle(color: Colors.white, fontSize: 18)),
                            const SizedBox(height: 8),
                            Text(
                              isColorRule ? "නිල් පැහැතිදැයි බලන්න" : "රවුම් හැඩයදැයි බලන්න",
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Stimulus
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: stimulusShape,
                          color: stimulusColor,
                          borderRadius: stimulusShape == BoxShape.rectangle ? BorderRadius.circular(30) : null,
                          boxShadow: [
                            BoxShadow(
                              color: stimulusColor.withOpacity(0.4),
                              blurRadius: 25,
                              spreadRadius: 8,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleTap(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 22),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Text(
                                  'ගැලපේ',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleTap(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 22),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Text(
                                  'නොගැලපේ',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Score Board
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color30Secondary.withOpacity(0.1)),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _scoreItem('නිවැරදි', correct, Colors.green),
                            _scoreItem('වැරදි', errors, Colors.redAccent),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _scoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}