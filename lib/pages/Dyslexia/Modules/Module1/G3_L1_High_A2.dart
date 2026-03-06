import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G3_L1_High_A2_Repeat extends StatefulWidget {
  const G3_L1_High_A2_Repeat({super.key});

  @override
  State<G3_L1_High_A2_Repeat> createState() => _G3_L1_High_A2_RepeatState();
}

class _G3_L1_High_A2_RepeatState extends State<G3_L1_High_A2_Repeat>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  int _taskIndex = 0;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _tasks = [
    {'word': 'අලියා', 'letterName': '', 'example': 'අලියා', 'emoji': '🐘'},
    {'word': 'බල්ලා', 'letterName': 'ඇ', 'example': 'බල්ලා', 'emoji': '🐕'},
    {'word': 'ළමයා', 'letterName': 'ඉ (i)', 'example': 'ළමයා', 'emoji': '👨‍🎓'},
    {'word': 'වලසා', 'letterName': 'එ (e)', 'example': 'වලසා', 'emoji': '🐻'},
    {'word': 'ගිරවා', 'letterName': 'ක (ka)', 'example': 'ගිරවා', 'emoji': '🦜'},
    {'word': 'කොටියා', 'letterName': 'ම (ma)', 'example': 'කොටියා', 'emoji': '🐯'},
    {'word': 'පුටුව', 'letterName': 'න (na)', 'example': 'පුටුව', 'emoji': '🪑'},
    {'word': 'මේසය', 'letterName': 'ත (ta)', 'example': 'මේසය', 'emoji': '┬─┬'},
    {'word': 'බෝලය', 'letterName': 'ස (sa)', 'example': 'බෝලය', 'emoji': '🥎'},
    {'word': 'කූඩුව', 'letterName': 'ඇ (ae)', 'example': 'කූඩුව', 'emoji': '🏮'},
  ];

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("si-LK");
    _flutterTts.setSpeechRate(0.35);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _playWordSound();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playWordSound() async {
    await _flutterTts.speak(_tasks[_taskIndex]['word']!);
  }

  void _nextTask() {
    if (_taskIndex < _tasks.length - 1) {
      setState(() => _taskIndex++);
      _playWordSound();
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _tasks[_taskIndex];
    final progress = (_taskIndex + 1) / _tasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                _buildBadge("ඉහළ අවදානම", const Color(0xFFFF6B6B), Colors.white),
                const SizedBox(width: 6),
                _buildBadge("ශ්‍රේණිය 3 · මට්ටම 1", const Color(0xFF4A90D9), Colors.white),
                // const SizedBox(width: 6),
                // _buildBadge("පැවරුම 2", const Color(0xFF7B61FF), Colors.white),
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
              const Text(
                "පැවරුම 2 — Letter & Sound Recognition",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 14),

              // Progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(

                "වචන ${_tasks.length} න් ${_taskIndex + 1} වන වචනය",
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
              const SizedBox(height: 18),

              // "Now say it aloud!" pill
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("✏️", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Text(
                        "දැන් ඒක හයියෙන් කියන්න!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Main letter card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFFFD199), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFAA44).withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Text(
                          currentTask['word']!,
                          style: const TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFE07B20),
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFFFEDD5),
                      //     borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(color: const Color(0xFFFFD199), width: 1),
                      //   ),
                      //   // child: Text(
                      //   //   currentTask['letterName']!,
                      //   //   style: const TextStyle(
                      //   //     fontSize: 14,
                      //   //     fontWeight: FontWeight.w700,
                      //   //     color: Color(0xFFB45309),
                      //   //   ),
                      //   // ),
                      // ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentTask['emoji']!, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text(
                            currentTask['example']!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '',
                            style: TextStyle(fontSize: 14, color: Color(0xFFB45309)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Hear Again button
              Center(
                child: GestureDetector(
                  onTap: _playWordSound,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFF7B61FF), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("🔊", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text(
                          "නැවත අහන්න",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7B61FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
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
              const SizedBox(height: 24),
            ],
          ),
        ),
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