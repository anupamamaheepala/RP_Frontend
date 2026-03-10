import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L2_High_A1 extends StatefulWidget {
  const G7_L2_High_A1({super.key});

  @override
  State<G7_L2_High_A1> createState() => _G7_L2_High_A1State();
}

class _G7_L2_High_A1State extends State<G7_L2_High_A1> {
  final FlutterTts _tts = FlutterTts();

  bool _started = false;
  int _index = 0;
  bool _correct = false;
  bool _wrong = false;
  int? _selected;

  final List<Map<String, dynamic>> _signals = [
    {
      "sentence": "ඔහු වෙහෙසට පත් විය. එසේ වුවත් ඔහු පාඩම් කළේය.",
      "signal": "එසේ වුවත්",
      "english": "He was tired. Even so, he studied.",
      "signalLabel": "එසේ වුවත් = Even so",
      "correct": 1,
      "explanation":
      "'එසේ වුවත්' --> ඊළඟට එන දෙය කලින් පැමිණි දෙයට පටහැනි බව සංඥා කරයි. ප්‍රතිවිරුද්ධ සම්බන්ධතාවය.",
    },
    {
      "sentence": "අධික වැසි වැටුණි. එබැවින් ගඟ පිරී ගියේය.",
      "signal": "එබැවින්",
      "english": "It rained heavily. Therefore, the river flooded.",
      "signalLabel": "එබැවින් = Therefore",
      "correct": 2,
      "explanation":
      "'එබැවින්' --> හේතුව → ඵල සම්බන්ධතාවයක් සංඥා කරයි. ප්‍රතිඵලය හේතුවෙන් පැමිණේ.",
    },
    {
      "sentence": "පළමුව බීජ වපුරන්න. ඉන්පසු වතුර දමන්න.",
      "signal": "ඉන්පසු",
      "english": "First, sow the seeds. Then, water them.",
      "signalLabel": "ඉන්පසු = Then",
      "correct": 3,
      "explanation":
      "'ඉන්පසු' --> අනුපිළිවෙලක් සංඥා කරයි — සිදුවීම් එකින් එක අනුපිළිවෙලින් සිදුවෙමින් පවතී.",
    },
    {
      "sentence": "ඔහු බුද්ධිමත්ය. තවද ඔහු මහන්සිවෙයි.",
      "signal": "තවද",
      "english": "He is smart. Also, he works hard.",
      "signalLabel": "තවද = Also",
      "correct": 0,
      "explanation":
      "'තවද' --> එකතු කිරීම සංඥා කරයි — පළමු අදහසට තවත් අදහසක් එකතු වෙමින් පවතී.",
    },
    {
      "sentence": "ඔහු අසනීප විය. එසේ නමුත් ඔහු පන්තියට පැමිණියේය.",
      "signal": "එසේ නමුත්",
      "english": "He was sick. However, he came to class.",
      "signalLabel": "එසේ නමුත් = However",
      "correct": 1,
      "explanation":
      "'එසේ නමුත්' --> වෙනස සංඥා කරයි - දෙවන අදහස ඔබ අපේක්ෂා කරන දෙයට ප්‍රතිවිරුද්ධය.",
    },
  ];

  // Options with icons and labels (index-matched to correct answers)
  final List<Map<String, dynamic>> _options = [
    {"icon": "+", "label": "එකතු කිරීම - සහ ද"},
    {"icon": "⚡", "label": "වෙනස — ප්‍රතිවිරුද්ධ අදහස අනුගමනය කරයි"},
    {"icon": "→", "label": "හේතුව - ඒ නිසා"},
    {"icon": "1→2", "label": "අනුපිළිවෙල - ඊළඟට"},
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("si-LK");
    _tts.setSpeechRate(0.35);
  }

  Future<void> _speak() async {
    await _tts.speak(_signals[_index]["sentence"]);
  }

  void _select(int i) {
    if (_correct) return;
    setState(() {
      _selected = i;
      if (i == _signals[_index]["correct"]) {
        _correct = true;
        _wrong = false;
      } else {
        _wrong = true;
      }
    });
  }

  void _next() {
    if (_index < _signals.length - 1) {
      setState(() {
        _index++;
        _correct = false;
        _wrong = false;
        _selected = null;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return _buildIntroScreen();
    return _buildActivityScreen();
  }

  // ─── INTRO SCREEN ───────────────────────────────────────────────────────────
  Widget _buildIntroScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(),

            // Progress bar (empty on intro)
            _buildProgressBar(0),

            // Sub label row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.search, size: 14, color: Colors.deepPurple),
                      SizedBox(width: 4),
                      Text(
                        "පෙළ සංඥා පරීක්ෂණය",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // const Text(
                  //   "Activity 1 of 6",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // Magnifier emoji / icon
                    const Text("🔍", style: TextStyle(fontSize: 72)),

                    const SizedBox(height: 24),

                    // Activity label pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "පැවරුම 1 - සම්බන්ධක වචන සම්බන්ධතා",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "පෙළ සංඥා පරීක්ෂණය",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "ශාස්ත්‍රීය සිංහල පාඨවල විශේෂ 'සංඥා වචන' භාවිතා කරයි - ඒසේ වුනාත් (එසේ වුවත්) හෝ එබැවින් (එබැවින්) වැනි - ඒවා අදහස් දෙකක් සම්බන්ධ වන ආකාරය හරියටම ඔබට කියයි. මෙම සංඥා අතුරුදහන් වීම යනු අර්ථය අතුරුදහන් වීමයි. ඔබ සංඥා වචනය හඳුනාගෙන එය නිර්මාණය කරන සම්බන්ධතාවය හඳුනා ගනු ඇත.",
                      //"Academic Sinhala texts use special 'signal words' — like එසේ වුවත් (even so) or එබැවින් (therefore) — that tell you exactly how two ideas are connected. Missing these signals means missing the meaning. You'll spot the signal word and identify what relationship it creates.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Tip box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("💡", style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14, height: 1.5),
                                children: [
                                  TextSpan(
                                    text:
                                    "සංඥා වචනය වාක්‍යයේ රථවාහන සලකුණයි - එය අර්ථය හැරෙන්නේ කුමන දිශාවටද යන්න ඔබට කියයි.",
                                    //"The signal word is the traffic sign of the sentence — it tells you which direction the meaning is turning.",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Let's Start button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _started = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2F6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "🚀  අපි ආරම්භ කරමු",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTIVITY SCREEN ────────────────────────────────────────────────────────
  Widget _buildActivityScreen() {
    final task = _signals[_index];
    final correctIndex = task["correct"] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar((_index + 1) / _signals.length),

            // Sub label row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.search, size: 14, color: Colors.deepPurple),
                      SizedBox(width: 4),
                      Text(
                        "පෙළ සංඥා පරීක්ෂණය",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // const Text(
                  //   "Activity 1 of 6",
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "සංඥා ${_signals.length} න් ${_index + 1} වන සංඥාව",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    // Sentence card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFD0D4FF)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "සංඥා වචනය සොයා ගන්න",
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Sentence with highlighted signal
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black),
                              children: _buildSentence(task),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '"${task["english"]}"',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Hear it + Signal word row
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: _speak,
                                icon: const Icon(Icons.volume_up,
                                    size: 16, color: Colors.deepPurple),
                                label: const Text(
                                  "අසන්න",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.deepPurple),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.deepPurple.shade200),
                                  ),
                                  child: Text(
                                    "සංඥා වචනය: ${task["signalLabel"]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Question
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                        children: [
                          const TextSpan(text: 'මොකක්ද සම්බන්ධය කරන්නේ-->  '),
                          TextSpan(
                            text: '"${task["signal"]}"',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          const TextSpan(text: '  සංඥාව?'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Options
                    ...List.generate(_options.length, (i) {
                      return _buildOption(i, correctIndex);
                    }),

                    const SizedBox(height: 16),

                    // Feedback box
                    if (_wrong || _correct) _buildFeedback(task, correctIndex),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _correct ? _next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2F6B),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "ඊළඟ සංඥාව →",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int i, int correctIndex) {
    final opt = _options[i];
    final isSelected = _selected == i;
    final isCorrectOption = i == correctIndex;
    final isWrongSelected = isSelected && !isCorrectOption;
    final showCorrect = (_wrong || _correct) && isCorrectOption;
    final showWrong = isWrongSelected && (_wrong || _correct);

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Widget? trailingIcon;

    if (showCorrect) {
      bgColor = const Color(0xFFEAF7EE);
      borderColor = Colors.green.shade300;
      trailingIcon = const Icon(Icons.check_box, color: Colors.green, size: 22);
    } else if (showWrong) {
      bgColor = const Color(0xFFFFF0F0);
      borderColor = Colors.red.shade200;
      trailingIcon = const Icon(Icons.close, color: Colors.red, size: 22);
    }

    // Icon widget for the option type
    Widget iconWidget = Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        opt["icon"]!,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );

    return GestureDetector(
      onTap: _correct ? null : () => _select(i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                opt["label"]!,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(Map task, int correctIndex) {
    if (_correct) {
      // Correct feedback: just explanation
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  "නිවැරදියි!",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task["explanation"],
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      );
    }

    // Wrong feedback
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("✗", style: TextStyle(color: Colors.red, fontSize: 16)),
              SizedBox(width: 6),
              Text(
                "වැරදියි",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            task["explanation"],
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ─── SHARED WIDGETS ──────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: back arrow (left) + tags (right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.chevron_left, size: 28, color: Colors.black87),
              ),
              Row(
                children: [
                  _buildTag("● ඉහළ අවදානම", const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("ශ්‍රේණිය 7 · මට්ටම 2", const Color(0xFF2D2F6B), Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title below
          const Text(
            "පැවරුම 1 - සම්බන්ධක වචන සම්බන්ධතා",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bg, Color fg) {
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    // Segmented progress bar (6 segments for 6 activities)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: List.generate(6, (i) {
          double segmentProgress = 0.0;
          if (!_started) {
            segmentProgress = 0.0;
          } else if (i == 0) {
            // First segment fills as activity progresses
            segmentProgress = (_index + ((_correct || _wrong) ? 1 : 0)) /
                _signals.length;
            segmentProgress = segmentProgress.clamp(0.0, 1.0);
          }
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 5 ? 4 : 0),
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: i == 0 ? segmentProgress : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2F6B),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<TextSpan> _buildSentence(Map task) {
    String sentence = task["sentence"];
    String signal = task["signal"];
    List<TextSpan> spans = [];

    int index = sentence.indexOf(signal);

    if (index == -1) {
      spans.add(TextSpan(text: sentence));
      return spans;
    }

    spans.add(TextSpan(text: sentence.substring(0, index)));
    spans.add(
      TextSpan(
        text: signal,
        style: const TextStyle(
          backgroundColor: Color(0xFF2D2F6B),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    spans.add(TextSpan(text: sentence.substring(index + signal.length)));

    return spans;
  }
}