// lib/adhd/grade4/grade4_task1_listen_extract.dart
import 'package:audioplayers/audioplayers.dart';
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

  // 60-30-10 වර්ණ පද්ධතිය (60% Primary Background, 30% Secondary, 10% Accent)
  static const Color color60BG = Color(0xFFF8FAFC); // සන්සුන් ලා අළු/සුදු පසුබිම
  static const Color color30Secondary = Color(0xFF2E86C1); // ශීර්ෂ සහ ප්‍රගති දර්ශක සඳහා
  static const Color color10Accent = Color(0xFFE67E22);    // බොත්තම් සහ ක්‍රියාකාරකම් සඳහා

  final List<Map<String, dynamic>> tasks = [
    {
      'audio': 'g4.1.wav',
      'message': 'කහ පැහැති පියාපත් ඇති කුඩා නිල් කුරුල්ලෙක් විශාල අඹ ගසක අත්තක වාඩි වී ගීත ගයයි.',
      'question': 'කුරුල්ලාගේ පියාපත්වල වර්ණය කුමක්ද?',
      'answers': ['කහ', 'කහ පාට', 'yellow', 'kaha'],
    },
    {
      'audio': 'g4.2.wav',
      'message': 'පාර අයිනේ නවතා ඇති රතු මෝටර් රථයේ රෝද හතරම කළු පැහැතිය. එහි සුදු පැහැති ඉරි දෙකක් ඇත.',
      'question': 'මෝටර් රථයේ රෝද කීයක් තිබේද?',
      'answers': ['හතරක්', '4', 'four', 'hatharak'],
    },
    {
      'audio': 'g4.3.wav',
      'message': 'අපේ වත්තේ ඇති උස පොල් ගසක කොළ පැහැති අතු අතර ලොකු ගෙඩි පහක් හටගෙන තිබේ.',
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
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);
    _playCurrentAudio();
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
        const SnackBar(
          content: Text('ඉතා හොඳයි! ඔබේ පිළිතුර නිවැරදියි 🎉', style: TextStyle(fontFamily: 'Sinhala')),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('නැවත උත්සාහ කරන්න. නිවැරදි පිළිතුර: "${validAnswers[0]}"'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }

    _controller.clear();

    if (currentQuestion < tasks.length - 1) {
      setState(() {
        currentQuestion++;
        replayCount = 0;
      });
      _playCurrentAudio();
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
    _audioPlayer.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = tasks[currentQuestion];

    return Scaffold(
      backgroundColor: color60BG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'පියවර 1: සවන් දී පිළිතුරු දෙන්න',
          style: TextStyle(color: color30Secondary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            children: [
              // ප්‍රගති දර්ශකය (30% Element)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (currentQuestion + 1) / tasks.length,
                  minHeight: 10,
                  backgroundColor: color30Secondary.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(color30Secondary),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'වාක්‍යයට හොඳින් සවන් දී නිවැරදි පිළිතුර ලියන්න.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // පණිවිඩ කාඩ්පත (30% Container)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color30Secondary.withOpacity(0.2), width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      task['message']!,
                      style: const TextStyle(fontSize: 20, height: 1.5, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // ශබ්ද බොත්තම (10% Accent)
                    GestureDetector(
                      onTap: () {
                        setState(() => replayCount++);
                        _playCurrentAudio();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: color10Accent, shape: BoxShape.circle),
                        child: const Icon(Icons.volume_up, size: 35, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'නැවත ඇසීමට තට්ටු කරන්න ($replayCount)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),
              Text(
                task['question']!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color30Secondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // පිළිතුර ඇතුළත් කරන තීරුව
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'පිළිතුර මෙහි ඇතුළත් කරන්න...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: color30Secondary.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: color10Accent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // තහවුරු කිරීමේ බොත්තම (10% Accent)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color10Accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                  ),
                  child: const Text(
                    'පිළිතුර තහවුරු කරන්න',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ප්‍රශ්න ${currentQuestion + 1} / ${tasks.length}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              const SizedBox(height: 40), // යතුරුපුවරුවට ඉඩ ලබා දීමට
            ],
          ),
        ),
      ),
    );
  }
}