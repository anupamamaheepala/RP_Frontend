// lib/adhd/grade7/grade7_task4_divided.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'grade7_success_page.dart';
import 'grade7_task5_inhibition.dart';

class Grade7Task4Divided extends StatefulWidget {
  const Grade7Task4Divided({super.key});

  @override
  _Grade7Task4DividedState createState() => _Grade7Task4DividedState();
}

class _Grade7Task4DividedState extends State<Grade7Task4Divided> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int beepCount = 0;
  int visualTargetsShown = 0;
  int visualHits = 0;
  int visualFalseAlarms = 0;

  bool isTargetActive = false;
  Timer? _visualTimer;
  Timer? _audioTimer;
  Timer? _targetTimeout;

  @override
  void initState() {
    super.initState();
    _startVisualTask();
    _startAudioTask();
    Future.delayed(const Duration(minutes: 1), _endTask);//task duration ==> ideal 4 mins
  }

  void _startVisualTask() {
    _visualTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (Random().nextDouble() < 0.25) { // ~1 target every 8 seconds on average
        setState(() {
          isTargetActive = true;
          visualTargetsShown++;
        });

        // Target disappears after 1.5 seconds if not tapped (miss)
        _targetTimeout?.cancel();
        _targetTimeout = Timer(const Duration(milliseconds: 600), () {//duration ==> ideal 1500
          if (mounted && isTargetActive) {
            setState(() => isTargetActive = false);
          }
        });
      }
    });
  }

  void _startAudioTask() {
    _audioTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      setState(() {
        beepCount++;
      });
      // Play the real beep sound
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    });
  }

  void _onTap() {
    if (isTargetActive) {
      // Correct hit
      setState(() {
        visualHits++;
        isTargetActive = false;
      });
      _targetTimeout?.cancel();
    } else {
      // False alarm (tapped when no target)
      setState(() => visualFalseAlarms++);
    }
  }

  void _endTask() {
    _visualTimer?.cancel();
    _audioTimer?.cancel();
    _targetTimeout?.cancel();
    _audioPlayer.dispose();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Grade7SuccessPage(
          taskNumber: '4',
          nextPage: Grade7Task5Inhibition(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _visualTimer?.cancel();
    _audioTimer?.cancel();
    _targetTimeout?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(title: const Text('Task 4: Divided Attention')),
      body: GestureDetector(
        onTap: _onTap, // Tap anywhere to respond to visual target
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tap when you see the RED circle!\nAlso count the beeps in your head!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: isTargetActive ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isTargetActive ? Colors.white : Colors.transparent,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    isTargetActive ? 'TAP NOW!' : 'Watch here',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Beeps heard: $beepCount',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Targets shown: $visualTargetsShown | Hits: $visualHits | Errors: $visualFalseAlarms',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}