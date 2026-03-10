import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L1_High_A1 extends StatefulWidget {
  const G7_L1_High_A1({super.key});

  @override
  State<G7_L1_High_A1> createState() => _G7_L1_High_A1State();
}

class _G7_L1_High_A1State extends State<G7_L1_High_A1> {
  final FlutterTts _tts = FlutterTts();

  bool _started = false;
  int _taskIndex = 0;
  int _highlightIndex = -1;
  bool _showExplanation = false;
  bool _correct = false;

  // Tracks which inference trail steps have been revealed
  int _trailStep = -1;

  final List<Map<String, dynamic>> _tasks = [
    {
      "paragraph": [
        "සඳුනි අද පාසලට පැමිණියේ තරමක් ප්‍රමාදවයි.",
        "ඇගේ ඇඳුම් තරමක් තෙත් විය.",
        "ඇය පන්තියට ඇතුල් වූ විට ගුරුතුමිය කවුළුවෙන් පිටත බලමින් සිටියාය.",
        "පිටත තවමත් වැසි වැටෙමින් තිබුණි.",
      ],
      "question": "සඳුනි ප්‍රමාද වීමට හැකි හේතුව කුමක්ද?",
      "options": [
        "වර්ෂාව නිසා ඇය ප්‍රමාද විය",
        "ගුරුතුමිය කවුළුවෙන් බලමින් සිටියා",
        "සඳුනි පාසලට යාම අමතක විය",
      ],
      "correctIndex": 0,
      "inferenceTrail": [
        {
          "sentence": 1,
          "explanation":
          "ඇගේ ඇඳුම් තෙත් වීමෙන් ඇය වැස්සට ලක්ව ඇති බව පෙන්වයි.",
        },
        {
          "sentence": 3,
          "explanation":
          "පිටත තවමත් වැසි වැටෙන බවින් වැසි තිබූ බව තහවුරු වේ.",
        },
        {
          "sentence": 0,
          "explanation":
          "එම නිසා සඳුනි ප්‍රමාද වීමට වැස්ස හේතුවක් විය හැක.",
        },
      ],
    },
    {
      "paragraph": [
        "නිමේෂා අද පන්තියේ කතා නොකළාය.",
        "ඇය හිස පහළ කරගෙන සටහන් ලියමින් සිටියාය.",
        "ඇගේ මිතුරිය ඇයගෙන් 'ඔයාට හොඳ නැද්ද?' කියා ඇසුවාය.",
      ],
      "question":
      "නිමේෂා කතා නොකළේ ඇයි කියා අපට අනුමාන කළ හැක්කේ කුමක්ද?",
      "options": [
        "ඇයට සනීප නැති විය හැක",
        "ඇය සටහන් ලියමින් සිටියා",
        "ඇය ගුරුවරියට බිය වූවා",
      ],
      "correctIndex": 0,
      "inferenceTrail": [
        {
          "sentence": 2,
          "explanation":
          "මිතුරිය ඇයගෙන් 'ඔයාට හොඳ නැද්ද?' කියා ඇසීමෙන් ඇය හොඳින් නොසිටින්නට පුළුවන්.",
        },
        {
          "sentence": 1,
          "explanation":
          "ඇය හිස පහළ කරගෙන සිටීමත් සාමාන්‍යයෙන් අසනීප හෝ කම්මැලි බවක් පෙන්වයි.",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("si-LK");
    _tts.setSpeechRate(0.15);
    _tts.setPitch(1.0);
    _tts.setVolume(1.0);
  }

  Future<void> _speakParagraph() async {
    final paragraph = List<String>.from(_tasks[_taskIndex]["paragraph"]);
    await _tts.awaitSpeakCompletion(true);

    for (int i = 0; i < paragraph.length; i++) {
      setState(() => _highlightIndex = i);
      await _tts.speak(paragraph[i]);
      await _tts.awaitSpeakCompletion(true);
    }

    setState(() => _highlightIndex = -1);
  }

  void _selectAnswer(int index) {
    if (_correct) return;

    if (index == _tasks[_taskIndex]["correctIndex"]) {
      setState(() {
        _correct = true;
        _trailStep = -1;
      });
      _playInferenceTrail();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ නැවත සිතන්න!")),
      );
    }
  }

  Future<void> _playInferenceTrail() async {
    final trail = _tasks[_taskIndex]["inferenceTrail"];

    for (int i = 0; i < trail.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _highlightIndex = trail[i]["sentence"];
        _showExplanation = true;
        _trailStep = i;
      });
    }
  }

  void _nextTask() {
    if (_taskIndex < _tasks.length - 1) {
      setState(() {
        _taskIndex++;
        _correct = false;
        _highlightIndex = -1;
        _showExplanation = false;
        _trailStep = -1;
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

  // ─── INTRO SCREEN ──────────────────────────────────────────────────────────
  Widget _buildIntroScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(0),
            _buildSubLabelRow(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text("🔍", style: TextStyle(fontSize: 68)),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "පැවරුම 1 - ඡේද අතර කියවීම",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "අනුමාන කියවීම",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "හොඳ පාඨකයින් වචන පමණක් කියවන්නේ නැත - ඔවුන් පේළි අතර කියවති. ඔබ කෙටි ඡේදයක් කියවා ඇත්ත වශයෙන්ම සිදුවන්නේ කුමක්ද යන්න පිළිබඳ නිගමනයක් කිරීමට පෙළෙන් ඉඟි භාවිතා කරනු ඇත.",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.65),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFE082)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("💡", style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "අනුමානයක් යනු අනුමානයක් නොවේ — එය ඉඟි වලින් ගොඩනඟන ලද නිගමනයකි. ඔබ පිළිතුරු දුන් පසු, රේඩාර් මඟින් ඔබට පිළිතුර ලබා දුන්නේ කුමන වාක්‍යයෙන්ද යන්න හරියටම පෙන්වනු ඇත.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

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
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "🚀  අපි ආරම්භ කරමු",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTIVITY SCREEN ───────────────────────────────────────────────────────
  Widget _buildActivityScreen() {
    final task = _tasks[_taskIndex];
    final List<String> paragraph =
    List<String>.from(task["paragraph"]);
    final List<Map<String, dynamic>> trail =
    List<Map<String, dynamic>>.from(task["inferenceTrail"]);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar((_taskIndex) / _tasks.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ඡේද ${_tasks.length} න් ${_taskIndex + 1} වන ඡේදය",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Paragraph card ──
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0FF),
                        borderRadius: BorderRadius.circular(20),
                        border:
                        Border.all(color: const Color(0xFFD0D4FF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 14, 12, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ඡේදය කියවන්න",
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _speakParagraph,
                                  icon: const Icon(Icons.volume_up,
                                      size: 15,
                                      color: Colors.deepPurple),
                                  label: const SizedBox.shrink(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.deepPurple),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Sentences with highlight
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12, 10, 12, 16),
                            child: Column(
                              children: List.generate(
                                paragraph.length,
                                    (i) => AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _highlightIndex == i
                                        ? const Color(0xFFFFEB3B)
                                        .withOpacity(0.6)
                                        : Colors.transparent,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    paragraph[i],
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.6,
                                      color: Colors.black87,
                                      fontWeight: _highlightIndex == i
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Question ──
                    Text(
                      task["question"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Answer options ──
                    ...List.generate(
                      task["options"].length,
                          (i) => _buildOptionRow(
                          i, task["options"][i], task["correctIndex"]),
                    ),

                    const SizedBox(height: 14),

                    // ── Inference trail (shown after correct) ──
                    if (_showExplanation && _trailStep >= 0)
                      _buildInferenceTrail(trail),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Next button
            if (_correct)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2F6B),
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      _taskIndex < _tasks.length - 1
                          ? "ඊළඟ ඡේදය →"
                          : "ඊළඟ පැවරුම ✓",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      "ඊළඟ ඡේදය →",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── OPTION ROW ────────────────────────────────────────────────────────────
  Widget _buildOptionRow(int i, String text, int correctIndex) {
    final bool isCorrect = _correct && i == correctIndex;
    final bool isDisabled = _correct;

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Widget? trailingIcon;

    if (isCorrect) {
      bgColor = const Color(0xFFEAF7EE);
      borderColor = Colors.green.shade300;
      trailingIcon =
      const Icon(Icons.check_box, color: Colors.green, size: 22);
    }

    return GestureDetector(
      onTap: isDisabled ? null : () => _selectAnswer(i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
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

  // ─── INFERENCE TRAIL ───────────────────────────────────────────────────────
  Widget _buildInferenceTrail(List<Map<String, dynamic>> trail) {
    final visibleTrail = trail
        .sublist(0, (_trailStep + 1).clamp(0, trail.length));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("🔍", style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                "අනුමාන මාවත",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(visibleTrail.length, (i) {
            final step = visibleTrail[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${i + 1}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      step["explanation"],
                      style: const TextStyle(
                          fontSize: 14, height: 1.55),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── SHARED WIDGETS ────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.chevron_left,
                    size: 28, color: Colors.black87),
              ),
              Row(
                children: [
                  _buildTag("● ඉහළ අවදානම",
                      const Color(0xFFFFE4E4), const Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  _buildTag("ශ්‍රේණිය 7 · මට්ටම 1",
                      const Color(0xFF2D2F6B), Colors.white),
                  const SizedBox(width: 8),
                  // _buildTag("පැවරුම 1",
                  //     Colors.grey.shade200, Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text("🔍", style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "ඡේද අතර කියවීම",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (_started && i == 0) fill = progress.clamp(0.0, 1.0);
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 5 ? 4 : 0),
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3)),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF2D2F6B),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubLabelRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("🔍", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "අනුමාන කියවීම",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2D2F6B),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text("Activity 1 of 6",
          //     style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}