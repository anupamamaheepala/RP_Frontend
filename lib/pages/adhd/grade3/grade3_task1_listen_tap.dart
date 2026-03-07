import 'dart:async';
import 'dart:math';  // NEW: for Random
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'grade3_success_page.dart';
import 'grade3_task2_sequence_tap.dart';
import 'task_stats.dart';

class Grade3Task1ListenTap extends StatefulWidget {
  const Grade3Task1ListenTap({super.key});

  @override
  _Grade3Task1ListenTapState createState() => _Grade3Task1ListenTapState();
}

class _Grade3Task1ListenTapState extends State<Grade3Task1ListenTap> {
  final List<String> instructions = [
    'රතු රවුම ස්පර්ශ කරන්න',
    'නිල් රවුම ස්පර්ශ කරන්න',
    'කහ රවුම ස්පර්ශ කරන්න',
    'කොළ රවුම ස්පර්ශ කරන්න',
  ];

  final Map<int, String> colorAudioFiles = {
    0: 'red_3.wav',
    1: 'blue_3.wav',
    2: 'yello_3.wav',  // Fixed typo
    3: 'green_3.wav',
  };

  int currentIndex = 0;
  bool canTap = false;

  int correctTaps = 0;
  int prematureTaps = 0;
  int wrongTaps = 0;

  Color? feedbackColor;

  final Color primaryBg = const Color(0xFFF8FAFF);
  final Color secondaryPurple = const Color(0xFF6741D9);
  final Color accentAmber = const Color(0xFFFFB300);

  late final AudioPlayer _audioPlayer;

  // NEW: List of all four circles (color + key) — we'll shuffle this each step
  late List<Map<String, dynamic>> circleData;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);

    // Define the four circles once
    circleData = [
      {'color': Colors.red, 'key': 'red'},
      {'color': Colors.blue, 'key': 'blue'},
      {'color': Colors.amber, 'key': 'yellow'},
      {'color': Colors.green, 'key': 'green'},
    ];

    _startInstruction();
  }

  void _startInstruction() async {
    setState(() {
      canTap = false;
      feedbackColor = null;

      // NEW: Randomize positions for this instruction
      circleData.shuffle(Random());
    });

    String audioFile = colorAudioFiles[currentIndex]!;
    await _audioPlayer.play(AssetSource('sounds/$audioFile'));
    await _audioPlayer.onPlayerComplete.first;

    if (mounted) {
      setState(() => canTap = true);
    }
  }

  void _handleTap(String tappedColor) {
    if (!canTap) {
      prematureTaps++;
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          duration: Duration(milliseconds: 1000),
          content: Text('පොඩ්ඩක් ඉන්න! උපදෙස් ලැබෙන තෙක් ඉන්න.'),
        ),
      );
      return;
    }

    List<String> colorKeys = ['red', 'blue', 'yellow', 'green'];
    String expected = colorKeys[currentIndex];

    if (tappedColor == expected) {
      correctTaps++;
      setState(() => feedbackColor = Colors.green.withOpacity(0.4));
      HapticFeedback.lightImpact();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          feedbackColor = null;
          currentIndex++;
        });

        if (currentIndex >= instructions.length) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Grade3SuccessPage(
                taskNumber: '1',
                stats: {
                  'correct': correctTaps,
                  'premature': prematureTaps,
                  'wrong': wrongTaps,
                },
                nextPage: const Grade3Task2SequenceTap(),
              ),
            ),
          );
        } else {
          _startInstruction();
        }
      });
    } else {
      wrongTaps++;
      setState(() => feedbackColor = Colors.red.withOpacity(0.4));
      HapticFeedback.heavyImpact();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => feedbackColor = null);
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: secondaryPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'පියවර 1: සවන් දී ස්පර්ශ කරන්න',
          style: TextStyle(color: secondaryPurple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressIndicator(
                value: currentIndex / instructions.length,
                backgroundColor: Colors.grey[200],
                color: accentAmber,
                minHeight: 6,
              ),
              const SizedBox(height: 40),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: secondaryPurple.withOpacity(0.1), blurRadius: 20)
                  ],
                ),
                child: Column(
                  children: [
                    Icon(canTap ? Icons.play_circle_fill : Icons.spatial_audio_off,
                        size: 40, color: canTap ? Colors.green : Colors.grey),
                    const SizedBox(height: 15),
                    Text(
                      currentIndex < instructions.length
                          ? instructions[currentIndex]
                          : 'නිමයි!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: secondaryPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Use shuffled list for positions
                        _buildCircle(circleData[0]['color'], circleData[0]['key']),
                        _buildCircle(circleData[1]['color'], circleData[1]['key']),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircle(circleData[2]['color'], circleData[2]['key']),
                        _buildCircle(circleData[3]['color'], circleData[3]['key']),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),

          if (feedbackColor != null)
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: 0.6,
                duration: const Duration(milliseconds: 300),
                child: Container(color: feedbackColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircle(Color color, String tapColor) {
    return GestureDetector(
      onTap: () => _handleTap(tapColor),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: canTap ? 1.0 : 0.6,
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: canTap ? 15 : 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}