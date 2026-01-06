// lib/adhd/grade5/grade5_task4_switch_go.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'grade5_results_page.dart'; // සෘජුවම ප්‍රතිඵල පිටුවට යාම සඳහා

class Grade5Task4SwitchGo extends StatefulWidget {
  const Grade5Task4SwitchGo({super.key});

  @override
  _Grade5Task4SwitchGoState createState() => _Grade5Task4SwitchGoState();
}

class _Grade5Task4SwitchGoState extends State<Grade5Task4SwitchGo> {
  bool isAnimalRule = true;
  int trials = 0;
  // පරීක්ෂණ සඳහා වට ගණන 10ක් කර ඇත. පසුව මෙය 50 දක්වා වැඩි කරන්න.
  final int maxTrials = 10;
  int correct = 0;

  IconData _leftIcon = Icons.pets;
  IconData _rightIcon = Icons.directions_car;
  bool _leftIsAnimal = true;

  final List<IconData> _animals = [Icons.pets, Icons.flutter_dash, Icons.bug_report];
  final List<IconData> _vehicles = [Icons.directions_car, Icons.pedal_bike, Icons.directions_bus];

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color color60BG = Color(0xFFF8FAFC);
  static const Color color30Secondary = Color(0xFF0288D1);
  static const Color color10Accent = Color(0xFFFF9800);

  @override
  void initState() {
    super.initState();
    _generateNextTrial();
  }

  void _generateNextTrial() {
    final random = Random();
    _leftIsAnimal = random.nextBool();
    if (_leftIsAnimal) {
      _leftIcon = _animals[random.nextInt(_animals.length)];
      _rightIcon = _vehicles[random.nextInt(_vehicles.length)];
    } else {
      _leftIcon = _vehicles[random.nextInt(_vehicles.length)];
      _rightIcon = _animals[random.nextInt(_animals.length)];
    }
    setState(() {});
  }

  void _handleTap(bool tappedLeft) {
    bool tappedAnimal = tappedLeft ? _leftIsAnimal : !_leftIsAnimal;
    bool isCorrect = (isAnimalRule && tappedAnimal) || (!isAnimalRule && !tappedAnimal);

    setState(() {
      if (isCorrect) correct++;
      trials++;

      // සෑම වට 5කට වරක් නීතිය මාරු කිරීම
      if (trials % 5 == 0 && trials < maxTrials) {
        isAnimalRule = !isAnimalRule;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'නීතිය මාරු වුණා! දැන් ${isAnimalRule ? "සතුන්" : "වාහන"} සොයන්න.',
              style: const TextStyle(fontFamily: 'Sinhala', fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            backgroundColor: color10Accent,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      if (trials >= maxTrials) {
        // ඔබ ඉල්ලා සිටි පරිදි සාර්ථකත්වයේ පිටුව (Success Page) මඟහැර සෘජුවම ප්‍රතිඵල පිටුවට යාම
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Grade5ResultsPage()),
        );
      } else {
        _generateNextTrial();
      }
    });
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
          'පියවර 4: නීති මාරු කිරීම',
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
              child: LinearProgressIndicator(
                value: trials / maxTrials,
                backgroundColor: color30Secondary.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(color30Secondary),
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 40),

            // වත්මන් නීතිය පෙන්වන කාඩ්පත (10% Accent)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: color10Accent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: color10Accent.withOpacity(0.3), blurRadius: 15)],
              ),
              child: Column(
                children: [
                  const Text('දැන් ඔබ තෝරාගත යුත්තේ:',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(
                    isAnimalRule ? "සතුන් 🦁" : "වාහන 🚗",
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Spacer(),

            //

            const Text(
              'නීතියට ගැලපෙන රූපය මත තට්ටු කරන්න!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 30),

            // රූප තේරීමේ ප්‍රදේශය (30% Secondary Style)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoiceButton(_leftIcon, () => _handleTap(true)),
                _buildChoiceButton(_rightIcon, () => _handleTap(false)),
              ],
            ),

            const Spacer(),

            // ලකුණු පුවරුව
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color30Secondary.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'නිවැරදි පිළිතුරු: $correct / $trials',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color30Secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color30Secondary.withOpacity(0.2), width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Icon(icon, size: 70, color: color30Secondary),
      ),
    );
  }
}