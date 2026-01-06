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
  Timer? _gameTimer;

  int _secondsRemaining = 60; // තත්පර 60 ක අභියෝගය (ඔබේ කේතයේ ඇති පරිදි)

  // 60-30-10 වර්ණ තේමාව
  final Color color60BG = const Color(0xFFF8FAFF);
  final Color color30Secondary = const Color(0xFF6741D9);
  final Color color10Accent = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _startVisualTask();
    _startAudioTask();
    _startGameTimer();
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        _endTask();
      }
    });
  }

  void _startVisualTask() {
    _visualTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (Random().nextDouble() < 0.25) {
        if (mounted) {
          setState(() {
            isTargetActive = true;
            visualTargetsShown++;
          });
        }

        _targetTimeout?.cancel();
        _targetTimeout = Timer(const Duration(milliseconds: 600), () {
          if (mounted && isTargetActive) {
            setState(() => isTargetActive = false);
          }
        });
      }
    });
  }

  void _startAudioTask() {
    _audioTimer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (mounted) {
        setState(() {
          beepCount++;
        });
        await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
      }
    });
  }

  void _onTap() {
    if (isTargetActive) {
      setState(() {
        visualHits++;
        isTargetActive = false;
      });
      _targetTimeout?.cancel();
    } else {
      setState(() => visualFalseAlarms++);
    }
  }

  void _endTask() {
    _visualTimer?.cancel();
    _audioTimer?.cancel();
    _targetTimeout?.cancel();
    _gameTimer?.cancel();
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
    _gameTimer?.cancel();
    _audioPlayer.dispose();
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
        title: Text(
          'පියවර 4: අවධාන බෙදීම',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // කාලය ගණනය කරන ප්‍රගති තීරුව (30% Element)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _secondsRemaining / 60,
                        backgroundColor: color30Secondary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color30Secondary),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('ඉතිරි කාලය: $_secondsRemaining තත්පර',
                        style: TextStyle(fontWeight: FontWeight.bold, color: color30Secondary)),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'රතු රවුම දුටු සැණින් තට්ටු කරන්න!\nඒ අතරතුර ඇසෙන බීප් (Beep) ශබ්ද ගණන මතක තබා ගන්න.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),



              // මධ්‍ය උත්තේජක ප්‍රදේශය (10% Focus)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: isTargetActive ? Colors.redAccent : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isTargetActive ? Colors.white : color30Secondary.withOpacity(0.2),
                    width: 6,
                  ),
                  boxShadow: isTargetActive
                      ? [BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 30, spreadRadius: 5)]
                      : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Center(
                  child: Text(
                    isTargetActive ? 'දැන් තට්ටු කරන්න!' : 'බලා සිටින්න...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isTargetActive ? Colors.white : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // සංඛ්‍යාලේඛන පුවරුව (10% Accent Background)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: color30Secondary.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up_rounded, color: color10Accent),
                        const SizedBox(width: 10),
                        Text(
                          'ශබ්ද ඇසුණු වාර ගණන: $beepCount',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color10Accent),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('දිස්වූ වාර', visualTargetsShown),
                        _statItem('නිවැරදි', visualHits),
                        _statItem('වැරදි', visualFalseAlarms),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, int value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 5),
        Text(value.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color30Secondary)),
      ],
    );
  }
}