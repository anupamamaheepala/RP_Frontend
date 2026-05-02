import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L3_High_A2 extends StatefulWidget {
  const G7_L3_High_A2({super.key});

  @override
  State<G7_L3_High_A2> createState() => _G7_L3_High_A2State();
}

class _G7_L3_High_A2State extends State<G7_L3_High_A2> {
  final FlutterTts _tts = FlutterTts();

  bool _started = false;
  int pairIndex = 0;
  int? selected;
  bool showExplanation = false;

  final List<Map<String, dynamic>> pairs = [
    {
      "topic": "නව පාසල් ආහාරගාරය",
      "topicEnglish": "A New School Canteen",
      "author": "පාසල් විදුහල්පතිගේ පුවත් පත්‍රිකාව",
      "authorBg": const Color(0xFF1A4D2E),
      "text":
      "අපගේ නව ආහාරගාරය සිසුන්ගේ නවතම සෞඛ්‍ය සම්පන්න ආහාර ලබා දීමට සූදානම් ය. සිසුන්ගේ ශාරීරික හා මානසික සෞඛ්‍යය වර්ධනය කිරීම අපගේ ප්‍රධාන අරමුණයි.",
      "english":
      "Our new canteen is ready to provide students with fresh, healthy food. Promoting students' physical and mental health is our primary goal.",
      "answer": 2,
      "feedbackTitle":"✓ ප්‍රවර්ධනය කිරීමට / ඒත්තු ගැන්වීමට",
      // "feedbackTitle": "✓ To promote / persuade",
      "explanation":
      "'සෞඛ්‍ය සම්පන්න', 'ප්‍රාථමික ඉලක්කය' වැනි ධනාත්මක භාෂාවෙන් කතුවරයා යමක් ප්‍රවර්ධනය කරන බව අඟවයි. විදුහල්පතිවරයාට නව ආපන ශාලාව කෙරෙහි විශ්වාසය ගොඩනැගීමට අවශ්‍ය වේ.",
    },
    {
      "topic": "පාසල් ක්‍රීඩා තරඟ",
      "topicEnglish": "පාසල් ක්‍රීඩා ඉසව්ව",
      "author": "Student Newspaper",
      "authorBg": const Color(0xFF1A3A8F),
      "text":
      "මෙම වසරේ ක්‍රීඩා තරඟය සිසුන්ට විනෝදයෙන් හා උද්‍යෝගයෙන් පිරුණු අත්දැකීමක් විය. මිතුරන් සමඟ ජයග්‍රහණය සැමරීම විශේෂ අත්දැකීමක් විය.",
      "english":
      "This year's sports event was full of excitement and fun for students. Celebrating victory with friends was a special experience.",
      "answer": 1,
     // "feedbackTitle": "✓ To entertain / amuse",
      "feedbackTitle": "✓ විනෝද වීමට / සතුටු වීමට",
      "explanation":
      "'විනෝදය', 'උද්යෝගිමත්', 'විශේෂ අත්දැකීම' වැනි වචන වලින් කතුවරයා පාඨකයින්ට විනෝදාස්වාදය ලබා දෙන බව අඟවයි. ශිෂ්‍ය මාධ්‍යවේදියා හැඟීම් සහ රසවින්දනය කෙරෙහි අවධානය යොමු කරයි.",
    },
    {
      "topic": "පරිසර ආරක්ෂාව",
      "topicEnglish": "පාරිසරික ආරක්ෂාව",
      "author": "Science Article",
      "authorBg": const Color(0xFF7B3FA0),
      "text":
      "පරිසර දූෂණය ඉහළ යාම පිළිබඳව විද්‍යාඥයන් පරීක්ෂණ සිදු කරමින් සිටිති. මෙම පර්යේෂණ මඟින් දූෂණය අවම කිරීමේ ක්‍රම සොයා ගැනීමට උත්සාහ කරයි.",
      "english":
      "Scientists are investigating the increase of environmental pollution. These studies aim to find methods to reduce pollution.",
      "answer": 0,
      // "feedbackTitle": "✓ To question / investigate",
      "feedbackTitle": "✓ ප්‍රශ්න කිරීමට / විමර්ශනයට",
      "explanation":
      "'පරීක්ෂා කරන්න', 'පර්යේෂණ', 'අධ්‍යයනය' වැනි වචන ප්‍රශ්න කිරීම හෝ විමර්ශනය කිරීම දක්වයි. විද්‍යා ලිපියේ කිසිදු ඒත්තු ගැන්වීමේ හෝ චිත්තවේගීය ස්වරයකින් තොරව මධ්‍යස්ථ, විශ්ලේෂණාත්මක භාෂාවක් භාවිතා කර ඇත.",
    },
  ];

  // Options with dot colours
  final List<Map<String, dynamic>> options = [
    {
      "label": "ප්‍රශ්න කිරීමට / විමර්ශනයට",
      "dotColor": const Color(0xFF1A4D2E),
    },
    {
      "label": "විනෝද වීමට / සතුටු වීමට",
      "dotColor": const Color(0xFF1A4D2E),
    },
    {
      "label": "ප්‍රවර්ධනය කිරීමට / ඒත්තු ගැන්වීමට",
      "dotColor": const Color(0xFF1A4D2E),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("si-LK");
    _tts.setSpeechRate(0.35);
  }

  Future<void> speak() async {
    await _tts.speak(pairs[pairIndex]["text"] as String);
  }

  void choose(int i) {
    if (showExplanation) return;
    setState(() {
      selected = i;
      showExplanation = true;
    });
  }

  void next() {
    if (pairIndex < pairs.length - 1) {
      setState(() {
        pairIndex++;
        selected = null;
        showExplanation = false;
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
      backgroundColor: const Color(0xFFF5FFF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(0),
            _buildSubLabelRow(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    const Text("🔭", style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 22),

                    // Activity pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "පැවරුම 2 · අරමුණ අනාවරණය",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "කතෘගේ කාචය",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "එකම සිදුවීම ලියන්නේ කවුද සහ ඇයි යන්න මත පදනම්ව බෙහෙවින් වෙනස් ලෙස ලිවිය හැකිය. කතුවරුන් දෙදෙනෙකු එකම මාතෘකාව ගැන ලියයි - ඔබ එක් එක් කතුවරයාගේ අරමුණ හඳුනාගෙන එම අරමුණ හෙළි කරන නිශ්චිත වචන තේරීම් මොනවාදැයි සොයා ගනු ඇත.",
                     // "The same event can be written about very differently depending on WHO is writing and WHY. Two authors write about the same topic — you'll identify each author's purpose and discover what specific word choices reveal that purpose.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.65,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

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
                          const Text("💡",
                              style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "අසන්න: මෙම කතුවරයාට මා සිතීමට හෝ කිරීමට අවශ්‍ය වන්නේ කුමක්ද? සෑම වචන තේරීමක්ම තීරණයක් - සහ තීරණය අරමුණ හෙළි කරයි.",
                              //"Ask: What does this author WANT me to think or do? Every word choice is a decision — and the decision reveals the purpose.",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),
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
                    backgroundColor: const Color(0xFF1A4D2E),
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
    final p = pairs[pairIndex];
    final int correctAnswer = p["answer"] as int;
    final bool isCorrect = selected == correctAnswer;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar((pairIndex) / pairs.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "යුගල ${pairs.length} න් ${pairIndex + 1} වන යුගලය",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    // ── Topic banner ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "එකම මාතෘකාව - කතුවරුන් දෙදෙනෙක්",
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: p["topic"] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                // TextSpan(
                                //   text:
                                //   " — ${p["topicEnglish"] as String}",
                                //   style: const TextStyle(
                                //       color: Colors.grey,
                                //       fontWeight: FontWeight.normal),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Text card ──
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Author tag + hear button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                14, 14, 12, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: p["authorBg"] as Color,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    p["author"] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: speak,
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

                          // Sinhala text
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 12, 16, 4),
                            child: Text(
                              p["text"] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.7,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          // English
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 16),
                            // child: Text(
                            //   p["english"] as String,
                            //   style: const TextStyle(
                            //     fontSize: 13,
                            //     fontStyle: FontStyle.italic,
                            //     color: Colors.grey,
                            //     height: 1.5,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "ඉහත වාක්‍යයෙහි කතුවරයා කිරීමට උත්සාහ කරන්නේ කුමක්ද?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Options
                    ...List.generate(options.length, (i) {
                      return _buildOptionRow(
                          i, correctAnswer);
                    }),

                    const SizedBox(height: 14),

                    // Feedback
                    if (showExplanation)
                      _buildFeedback(p, isCorrect),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom button
            if (showExplanation)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A4D2E),
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      pairIndex < pairs.length - 1
                          ? "Next Pair →"
                          : "Finish Activity ✓",
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
                      "ඊළඟ පැවරුම →",
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
  Widget _buildOptionRow(int i, int correctAnswer) {
    final opt = options[i];
    final bool isSelected = selected == i;
    final bool isCorrectOption = i == correctAnswer;
    final bool showCorrect = showExplanation && isCorrectOption;
    final bool showWrong =
        showExplanation && isSelected && !isCorrectOption;

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Widget? trailingIcon;

    if (showCorrect) {
      bgColor = const Color(0xFFEAF7EE);
      borderColor = Colors.green.shade300;
      trailingIcon =
      const Icon(Icons.check_box, color: Colors.green, size: 22);
    } else if (showWrong) {
      bgColor = const Color(0xFFFFF0F0);
      borderColor = Colors.red.shade300;
      trailingIcon =
      const Icon(Icons.close, color: Colors.red, size: 22);
    }

    return GestureDetector(
      onTap: showExplanation ? null : () => choose(i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: opt["dotColor"] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                opt["label"] as String,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }

  // ─── FEEDBACK BOX ──────────────────────────────────────────────────────────
  Widget _buildFeedback(Map<String, dynamic> p, bool isCorrect) {
    final Color bgColor = isCorrect
        ? const Color(0xFFEAF7EE)
        : const Color(0xFFFFF0F0);
    final Color borderColor =
    isCorrect ? Colors.green.shade300 : Colors.red.shade300;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p["feedbackTitle"] as String,
            style: TextStyle(
              color: isCorrect
                  ? Colors.green.shade700
                  : Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p["explanation"] as String,
            style: const TextStyle(fontSize: 14, height: 1.55),
          ),
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
                  _buildTag("ශ්‍රේණිය 7 · මට්ටම 3",
                      const Color(0xFF1A4D2E), Colors.white),
                  const SizedBox(width: 8),
                  // _buildTag("පැවරුම 2",
                  //     Colors.grey.shade200, Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text("🎯", style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                "කියවන්නෙකු මෙන් සිතන්න",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildOuterProgressBar(double progress) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (_started && i == 1) {
            fill = progress.clamp(0.0, 1.0);
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
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A4D2E),
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

  Widget _buildSubLabelRow() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("🔭", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "කතෘගේ කාචය",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A4D2E),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text(
          //   "Activity 2 of 6",
          //   style: TextStyle(fontSize: 12, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}