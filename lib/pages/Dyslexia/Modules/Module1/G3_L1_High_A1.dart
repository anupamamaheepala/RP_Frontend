import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A1_Animate extends StatefulWidget {
  const G3_L1_High_A1_Animate({super.key});

  @override
  State<G3_L1_High_A1_Animate> createState() => _G3_L1_High_A1_AnimateState();
}

class _G3_L1_High_A1_AnimateState extends State<G3_L1_High_A1_Animate>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;
  int _playCount = 0;
  bool _isCorrectAnswerSelected = false;
  bool _isWrongAnswerSelected = false;
  String _selectedAnswer = '';
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  final List<Map<String, dynamic>> _tasks = [
    {
      "sound": "අලියා",
      "options": ["කලය", "අලියා", "ජලය", "අලය"],
      "correctAnswer": "අලියා",
      "exampleWord": "අලියා",
      "optionEmojis": ["🏺", "🐘", "💧", "🌿"],
    },
    {
      "sound": "යතුර",
      "options": ["වතුර", "මිතුරා", "යතුර", "කතුර"],
      "correctAnswer": "යතුර",
      "exampleWord": "යතුර (key)",
      "optionEmojis": ["💧", "👤", "🔑", "✂️"],
    },
    {
      "sound": "කලය",
      "options": ["කලය", "මාලය", "සාලය", "ජලය"],
      "correctAnswer": "කලය",
      "exampleWord": "කලය",
      "optionEmojis": ["🏺", "📿", "🏠", "💧"],
    },
    {
      "sound": "අම්මා",
      "options": ["තාත්තා", "අයියා", "අම්මා", "අක්කා"],
      "correctAnswer": "අම්මා",
      "exampleWord": "අම්මා",
      "optionEmojis": ["👨", "👦", "👩", "👧"],
    },
    {
      "sound": "නිවස",
      "options": ["නිවස", "මල්ලි", "සල්ලි", "කැලය"],
      "correctAnswer": "නිවස",
      "exampleWord": "නිවස",
      "optionEmojis": ["🏠", "👦", "💰", "🌳"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _playLetterSound();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playLetterSound() async {
    _bounceController.forward(from: 0);
    await _flutterTts.speak(_tasks[_taskIndex]["sound"]);
    setState(() {
      _playCount++;
    });
  }

  void _checkAnswer(String selectedLetter) {
    if (_isCorrectAnswerSelected) return;
    setState(() {
      _selectedAnswer = selectedLetter;
      if (selectedLetter == _tasks[_taskIndex]["correctAnswer"]) {
        _isCorrectAnswerSelected = true;
        _isWrongAnswerSelected = false;
      } else {
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = true;
      }
    });
  }

  void _nextTask() {
    setState(() {
      if (_taskIndex < _tasks.length - 1) {
        _taskIndex++;
        _isCorrectAnswerSelected = false;
        _isWrongAnswerSelected = false;
        _playCount = 0;
        _selectedAnswer = '';
        _playLetterSound();
      } else {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];
    final totalTasks = _tasks.length;
    final progress = (_taskIndex + 1) / totalTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _buildBadge("ඉහළ අවදානම", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFF4A90D9), Colors.white),
                // const SizedBox(width: 6),
                // _buildBadge("Module 1", const Color(0xFF7B61FF), Colors.white),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "පැවරුම 1 - ශබ්ද හඳුනාගැනීම",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "වචන $totalTasks න් ${_taskIndex + 1} වන වචනය",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${(progress * 100).round()}%",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B61FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B61FF)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Instruction
              Row(
                children: const [
                  Text("🎯", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "ශබ්දයට සවන් දී, ගැලපෙන වචනය තට්ටු කරන්න!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sound card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    children: [
                      // Animated music note
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EDFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text("🎵", style: TextStyle(fontSize: 40)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "වචනයේ ශබ්දය ඇසීමට බොත්තම තට්ටු කරන්න",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),

                      // Play Sound button
                      GestureDetector(
                        onTap: _playLetterSound,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B61FF),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B61FF).withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                              SizedBox(width: 8),
                              Text(
                                "ශබ්දය වාදනය කරන්න",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _playCount <= 1
                            ? "1 වතාවක් වාදනය කළා — ඔබට අවශ්‍ය තරම් වාර ගණනක් ක්‍රීඩා කළ හැකියි!"
                            : "$_playCount වතාවක් වාදනය කළා — ඔබට අවශ්‍ය තරම් වාර ගණනක් ක්‍රීඩා කළ හැකියි!",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Letter options — show only first 3 options
              Row(
                children: List.generate(3, (index) {
                  final letter = currentTask["options"][index] as String;
                  final emoji = currentTask["optionEmojis"][index] as String;
                  final isCorrect = _isCorrectAnswerSelected &&
                      letter == currentTask["correctAnswer"];
                  final isWrong =
                      _isWrongAnswerSelected && letter == _selectedAnswer;

                  Color borderColor = const Color(0xFFE5E7EB);
                  Color bgColor = Colors.white;
                  Color textColor = const Color(0xFF1A1A2E);

                  if (isCorrect) {
                    borderColor = const Color(0xFF22C55E);
                    bgColor = const Color(0xFFF0FDF4);
                    textColor = const Color(0xFF16A34A);
                  } else if (isWrong) {
                    borderColor = const Color(0xFFEF4444);
                    bgColor = const Color(0xFFFFF1F1);
                    textColor = const Color(0xFFDC2626);
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _checkAnswer(letter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.only(
                          left: index == 0 ? 0 : 6,
                          right: index == 2 ? 0 : 6,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              letter,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(emoji, style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Correct answer feedback banner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _isCorrectAnswerSelected
                    ? _buildCorrectBanner(currentTask)
                    : _isWrongAnswerSelected
                    ? _buildWrongBanner()
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // Next button
              SizedBox(
                width: double.infinity,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isCorrectAnswerSelected ? 1.0 : 0.4,
                  child: ElevatedButton(
                    onPressed: _isCorrectAnswerSelected ? _nextTask : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90D9),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF4A90D9),
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: _isCorrectAnswerSelected ? 4 : 0,
                      shadowColor: const Color(0xFF4A90D9).withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _taskIndex < _tasks.length - 1 ? "ඊළඟ" : "ඊළඟ පැවරුම",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorrectBanner(Map<String, dynamic> currentTask) {
    return Container(
      key: const ValueKey('correct'),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("🎉", style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "නිවැරදියි! එය \"${currentTask['correctAnswer']}\"",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row(
          //   children: [
          //     const Text("🌟", style: TextStyle(fontSize: 14)),
          //     const SizedBox(width: 6),
          //     // Text(
          //     //   "Example word: ${currentTask['exampleWord']}",
          //     //   style: const TextStyle(
          //     //     fontSize: 13,
          //     //     color: Color(0xFF4B5563),
          //     //   ),
          //     // ),
          //   ],
          // ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _flutterTts.speak(currentTask["exampleWord"]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.volume_up_rounded,
                      color: Color(0xFF16A34A), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "අහන්න \"${currentTask['correctAnswer']}\"",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWrongBanner() {
    return Container(
      key: const ValueKey('wrong'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
      ),
      child: Row(
        children: const [
          Text("❌", style: TextStyle(fontSize: 18)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Not quite — try again! You can replay the sound.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}