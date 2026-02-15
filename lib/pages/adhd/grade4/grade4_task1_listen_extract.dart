// lib/adhd/grade4/grade4_task1_listen_extract.dart
import 'package:audioplayers/audioplayers.dart'; // NEW: Only this import added
import 'package:flutter/material.dart';
import 'grade4_success_page.dart';
import 'grade4_task2_stop_go_signals.dart';

class Grade4Task1ListenExtract extends StatefulWidget {
  const Grade4Task1ListenExtract({super.key});

  @override
  _Grade4Task1ListenExtractState createState() => _Grade4Task1ListenExtractState();
}

class _Grade4Task1ListenExtractState extends State<Grade4Task1ListenExtract> {
  int currentQuestion = 0;
  int correctCount = 0;
  int replayCount = 0;

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color colorPrimaryBG = Color(0xFFFEF9E7);
  static const Color colorSecondary = Color(0xFF2E86C1);
  static const Color colorAccent = Color(0xFFE67E22);

  final List<Map<String, dynamic>> tasks = [
    {
      'audio': 'g4.1.wav', // NEW: Audio file name
      'message': 'කහ පැහැති පියාපත් ඇති කුඩා නිල් කුරුල්ලෙක් විශාල අඹ ගසක අත්තක වාඩි වී සිංදු කියයි.',
      'question': 'කුරුල්ලාගේ පියාපත්වල වර්ණය කුමක්ද?',
      'answers': ['කහ', 'කහ පාට', 'yellow', 'kaha'],
    },
    {
      'audio': 'g4.2.wav',
      'message': 'පාර අයිනේ නවතා ඇති රතු මෝටර් රථයේ රෝද හතරම කළු පැහැතිය, එහි සුදු පාට ඉරි දෙකක් ඇත.',
      'question': 'මෝටර් රථයේ රෝද කීයක් තිබේද?',
      'answers': ['හතරක්', '4', 'four', 'hatharak'],
    },
    {
      'audio': 'g4.3.wav',
      'message': 'අපේ වත්තේ ඇති උස පොල් ගසේ කොළ පැහැති අතු අතර ලොකු ගෙඩි පහක් හැදී තිබේ.',
      'question': 'පොල් ගසේ ගෙඩි කීයක් තිබේද?',
      'answers': ['පහක්', '5', 'five', 'pahak'],
    },
    {
      'audio': 'g4.4.wav',
      'message': 'මගේ කුඩා බල්ලාගේ කළු ලොම් මත සුදු පැහැති ලප තුනක් සහ දුඹුරු පැහැති තිතක් ඇත.',
      'question': 'බල්ලාට ඇති සුදු ලප ගණන කීයක්ද?',
      'answers': ['තුනක්', '3', 'three', 'thunak'],
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late final AudioPlayer _audioPlayer; // NEW

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);
    _playCurrentAudio(); // Auto-play first sentence
  }

  void _playCurrentAudio() async {
    String audioFile = tasks[currentQuestion]['audio'];
    await _audioPlayer.play(AssetSource('sounds/$audioFile'));
  }

  void _checkAnswer() {
    String userAnswer = _controller.text.trim().toLowerCase();
    List<String> validAnswers = tasks[currentQuestion]['answers'];

    bool isCorrect = validAnswers.any((ans) => ans.toString().toLowerCase() == userAnswer);

    if (isCorrect) {
      correctCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ඔබේ පිළිතුර නිවැරදියි! 🌟', style: TextStyle(fontFamily: 'Sinhala')), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('නැවත උත්සාහ කරන්න. නිවැරදි පිළිතුර: "${validAnswers[0]}"'), backgroundColor: Colors.redAccent),
      );
    }

    _controller.clear();

    if (currentQuestion < tasks.length - 1) {
      setState(() {
        currentQuestion++;
        replayCount = 0;
      });
      _playCurrentAudio(); // Auto-play next sentence
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade4SuccessPage(
            taskNumber: '1',
            nextPage: Grade4Task2StopGoSignals(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = tasks[currentQuestion];

    return Scaffold(
      backgroundColor: colorPrimaryBG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('සවන් දී පිළිතුරු දෙන්න', style: TextStyle(color: colorSecondary, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (currentQuestion + 1) / tasks.length,
                  minHeight: 12,
                  backgroundColor: colorSecondary.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(colorSecondary),
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                'වාක්‍යයට හොඳින් සවන් දී නිවැරදි පිළිතුර ලියන්න.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                  border: Border.all(color: colorSecondary.withOpacity(0.3), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      task['message']!,
                      style: const TextStyle(fontSize: 22, height: 1.6, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        setState(() => replayCount++);
                        _playCurrentAudio(); // Replay on tap
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(color: colorAccent, shape: BoxShape.circle),
                        child: const Icon(Icons.volume_up, size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('නැවත ඇසීමට තට්ටු කරන්න ($replayCount)', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              Text(
                task['question']!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  hintText: 'පිළිතුර මෙහි ඇතුළත් කරන්න...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: colorSecondary)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: colorAccent, width: 2)),
                ),
              ),
              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  child: const Text('පිළිතුර තහවුරු කරන්න', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Text('ප්‍රශ්න ${currentQuestion + 1} / ${tasks.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}