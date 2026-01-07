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
  // පරීක්ෂණ සඳහා වට ගණන 5ක් කර ඇත. පසුව මෙය 30 දක්වා වැඩි කරන්න.
  final int maxTrials = 5;
  int correctTaps = 0;
  int wrongTaps = 0;

  List<Color> _currentColors = [];
  late Color _targetColor;
  late String _targetColorName;

  // 60-30-10 වර්ණ
  static const Color color60BG = Color(0xFFF8FAFC);
  static const Color color30Secondary = Color(0xFF0288D1);
  static const Color color10Accent = Color(0xFFFF9800);

  // භාවිතා කරන වර්ණ පරාසය සහ ඒවායේ සිංහල නම්
  final Map<Color, String> _colorPool = {
    Colors.red: 'රතු',
    Colors.green: 'කොළ',
    Colors.blue: 'නිල්',
    Colors.orange: 'තැඹිලි',
    Colors.purple: 'දම්',
  };

  @override
  void initState() {
    super.initState();
    _generateNextRound();
  }

  void _generateNextRound() {
    setState(() {
      final random = Random();
      List<Color> keys = _colorPool.keys.toList();

      // අහඹු ලෙස ඉලක්කගත වර්ණයක් තෝරා ගැනීම
      _targetColor = keys[random.nextInt(keys.length)];
      _targetColorName = _colorPool[_targetColor]!;

      // Grid එක සඳහා වර්ණ 16ක් ජනනය කිරීම (ඉලක්කගත වර්ණය අවම වශයෙන් 3ක්වත් ඇති බව සහතික කරමු)
      _currentColors = List.generate(16, (index) {
        return keys[random.nextInt(keys.length)];
      });

      // අවම වශයෙන් එකක්වත් target color එක ඇති බව තහවුරු කිරීමට
      if (!_currentColors.contains(_targetColor)) {
        _currentColors[random.nextInt(16)] = _targetColor;
      }
    });
  }

  void _handleTap(Color tappedColor) {
    setState(() {
      if (tappedColor == _targetColor) {
        correctTaps++;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('නිවැරදියි! $_targetColorName පාට තෝරාගත්තා 🌟'), backgroundColor: Colors.green, duration: const Duration(milliseconds: 600)),
        );
      } else {
        wrongTaps++;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('වැරදියි! ඔබෙන් ඉල්ලුවේ $_targetColorName පාටයි 🤔'), backgroundColor: Colors.redAccent, duration: const Duration(milliseconds: 600)),
        );
      }

      trials++;

      if (trials >= maxTrials) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Grade5SuccessPage(
              taskNumber: '2',
              nextPage: const Grade5Task3Stillness(),
            ),
          ),
        );
      } else {
        _generateNextRound(); // මීළඟ වටයේදී වර්ණය සහ Grid එක මාරු වේ
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentColors.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'පියවර 2: වර්ණ පෙරීම',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // මාරු වන උපදෙස් (Target Instruction)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _targetColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _targetColor, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'මෙම වටයේදී ඔබ තෝරාගත යුත්තේ:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$_targetColorName පාට කොටු',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _targetColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ප්‍රගති දර්ශකය
              Column(
                children: [
                  LinearProgressIndicator(
                    value: trials / maxTrials,
                    backgroundColor: color30Secondary.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(color30Secondary),
                    minHeight: 12,
                  ),
                  const SizedBox(height: 10),
                  Text('ප්‍රගතිය: $trials / $maxTrials', style: const TextStyle(fontWeight: FontWeight.bold, color: color30Secondary)),
                ],
              ),

              const SizedBox(height: 30),



              // ක්‍රීඩා ප්‍රදේශය
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: color30Secondary.withOpacity(0.1), blurRadius: 20)],
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _handleTap(_currentColors[index]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _currentColors[index],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: _currentColors[index].withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // ලකුණු පුවරුව
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color30Secondary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _scoreColumn('නිවැරදි', correctTaps, Colors.green),
                    const VerticalDivider(thickness: 2),
                    _scoreColumn('වැරදි', wrongTaps, Colors.redAccent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 5),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}