import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class G7_L3_High_A1 extends StatefulWidget {
  const G7_L3_High_A1({super.key});

  @override
  State<G7_L3_High_A1> createState() => _G7_L3_High_A1State();
}

class _G7_L3_High_A1State extends State<G7_L3_High_A1> {
  final FlutterTts _tts = FlutterTts();

  bool _started = false;
  int index = 0;
  int? selected;
  bool showExplanation = false;

  final List<Map<String, dynamic>> statements = [
    {
      "category": "Geography",
      "categoryColor": Color(0xFF2D9E6B),
      "categoryBg": Color(0xFFE6F7EF),
      "text": "ශ්‍රී ලංකාවේ ජනගහනය මිලියන 22 ඉක්මවයි.",
      "english": "Sri Lanka's population exceeds 22 million.",
      "answer": 0,
      "feedbackTitle": "✓ මෙය පැහැදිලි කරුණකි",
      "explanation":
      "Signal:සංඛ්‍යා සහ මැනිය හැකි සංඛ්‍යාලේඛන → සත්‍යාපනය කළ හැකි → පැහැදිලි කරුණ ජනගහන සංඛ්‍යාලේඛන දත්ත සමඟ පරීක්ෂා කළ හැකිය. මෙය වෛෂයික, මැනිය හැකි ප්‍රකාශයකි.",
      //"Signal: Numbers and measurable statistics → verifiable → Clear Fact\nPopulation figures can be checked with census data. This is an objective, measurable statement.",
    },
    {
      "category": "Education",
      "categoryColor": Color(0xFFD44000),
      "categoryBg": Color(0xFFFFF0EA),
      "text":
      "ශ්‍රී ලංකාවේ ශිෂ්‍යයන් ලෝකයේ වෙනත් රටවල ශිෂ්‍යයන්ට වඩා වෙහෙස මහන්සි වී ඉගෙනෙති.",
      "english":
      "Students in Sri Lanka study harder than students in other countries.",
      "answer": 3,
      "feedbackTitle": "✗ මෙය පැහැදිලි මතයකි",
      "explanation":
      "Signal:සාක්ෂි නොමැතිව සංසන්දනාත්මක විනිශ්චය → ආත්මීය → පැහැදිලි මතය 'අනෙක් අයට වඩා අමාරු' යනු 'දැඩි' යන්න අර්ථ දැක්වීමකින් තොරව මැනිය නොහැකි විනිශ්චයකි. මෙය සත්‍යයක් ලෙස ඉදිරිපත් කරන කෙනෙකුගේ පෞද්ගලික අදහසකි.",
      //"Signal: Comparative judgment with no evidence → subjective → Clear Opinion\n'Harder than others' is a judgment that cannot be measured without defining 'hard'. This is someone's personal view presented as if it were a fact.",
    },
    {
      "category": "Environment",
      "categoryColor": Color(0xFF2D9E6B),
      "categoryBg": Color(0xFFE6F7EF),
      "text": "වනාන්තර ආරක්ෂා කිරීම වැදගත් ය.",
      "english": "Protecting forests is important.",
      "answer": 2,
      "feedbackTitle": "✗ මෙය විය හැකි මතයකි",
      "explanation":
      "Signal:'වැදගත්' යනු ඇගයීමේ විශේෂණ පදයකි → මත සංඥාව\nබොහෝ දෙනෙක් එකඟ වුවද, 'වැදගත්' යන්නෙන් පිළිබිඹු වන්නේ සත්‍යාපනය කළ හැකි කරුණක් නොව වටිනාකම් විනිශ්චයකි.",
      //"Signal: 'Important' is an evaluative adjective → opinion signal\nWhile many agree, 'important' reflects a value judgment, not a verifiable fact.",
    },
    {
      "category": "Science",
      "categoryColor": Color(0xFF1A5FA8),
      "categoryBg": Color(0xFFEAF2FF),
      "text": "ජලය සෙල්සියස් 100° දී උණු වී යයි.",
      "english": "Water boils at 100°C.",
      "answer": 0,
      "feedbackTitle": "✓ මෙය පැහැදිලි කරුණකි",
      "explanation":
      "Signal: අත්හදා බැලීම් මගින් තහවුරු කරන ලද විද්‍යාත්මක මිනුම් → පැහැදිලි කරුණ\nමෙය උෂ්ණත්වමානයක් ඇති ඕනෑම කෙනෙකුට සත්‍යාපනය කළ හැකිය. එය විශ්වීයව පිළිගත් විද්‍යාත්මක සත්‍යයකි.",
      //"Signal: Scientific measurement confirmed by experiment → Clear Fact\nThis can be verified by anyone with a thermometer. It is a universally accepted scientific fact.",
    },
    {
      "category": "General",
      "categoryColor": Color(0xFF7B3FA0),
      "categoryBg": Color(0xFFF5EEFF),
      "text": "හැමෝම දන්නවා ක්‍රිකට් හොඳම ක්‍රීඩාව කියලා.",
      "english": "Everyone knows this is the best sport.",
      "answer": 3,
      "feedbackTitle": "✗ මෙය පැහැදිලි මතයකි",
      "explanation":
      "Signal:'හැමෝම දන්නවා' සහ 'හොඳම' යනු සම්භාව්‍ය මත සංඥා වේ\n'හොඳම' යනු ආත්මීයයි — එය පුද්ගලයා අනුව වෙනස් වේ. 'හැමෝම දන්නවා' යනු මතයක් සත්‍යයක් ලෙස ශබ්ද කිරීමට භාවිතා කරන අතිශයෝක්තියකි.",
      //"Signal: 'Everyone knows' and 'best' are classic opinion signals\n'Best' is subjective — it varies by person. 'Everyone knows' is an exaggeration used to make an opinion sound like fact.",
    },
  ];

  // 4 options: index 0=Clear Fact, 1=Likely Fact, 2=Likely Opinion, 3=Clear Opinion
  final List<Map<String, dynamic>> options = [
    {
      "label": "පැහැදිලි කරුණක්",
      "dotColor": Color(0xFF2D9E6B),
      "selectedBg": Color(0xFFE6F7EF),
      "selectedBorder": Color(0xFF2D9E6B),
      "textColor": Color(0xFF2D9E6B),
    },
    {
      "label": "බොහෝ දුරට කරුණක්",
      "dotColor": Color(0xFF1A5FA8),
      "selectedBg": Color(0xFFEAF2FF),
      "selectedBorder": Color(0xFF1A5FA8),
      "textColor": Color(0xFF1A5FA8),
    },
    {
      "label": "බොහෝ දුරට මතයක්",
      "dotColor": Color(0xFFD44000),
      "selectedBg": Color(0xFFFFF0EA),
      "selectedBorder": Color(0xFFD44000),
      "textColor": Color(0xFFD44000),
    },
    {
      "label": "පැහැදිලි මතයක්",
      "dotColor": Color(0xFFB71C1C),
      "selectedBg": Color(0xFFFFF0F0),
      "selectedBorder": Color(0xFFB71C1C),
      "textColor": Color(0xFFB71C1C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("si-LK");
    _tts.setSpeechRate(0.35);
  }

  Future<void> speak() async {
    await _tts.speak(statements[index]["text"]);
  }

  void choose(int i) {
    if (showExplanation) return;
    setState(() {
      selected = i;
      showExplanation = true;
    });
  }

  void next() {
    if (index < statements.length - 1) {
      setState(() {
        index++;
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
                    const Text("🎯", style: TextStyle(fontSize: 72)),
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
                        "පැවරුම 1 · විවේචනාත්මක ඇගයීම",
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
                      "කරුණු හෝ මත වර්ගීකරණය",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "ඔබ කියවන සෑම දෙයක්ම සත්‍ය නොවේ. සමහර ප්‍රකාශ මතයන් වේ - ඒවා කරුණු ලෙස ඉදිරිපත් කෙරේ. ඔබ සිංහල ප්‍රකාශ කියවා ඒ සෑම එකක්ම 4-ලක්ෂ්‍ය පරිමාණයකින් වර්ගීකරණය කරනු ඇත: පැහැදිලි සත්‍යය, ඉඩ ඇති සත්‍යය, ඉඩ ඇති මතය හෝ පැහැදිලි මතය. ඉන්පසු වෙනස හෙළි කරන භාෂාමය සංඥා සොයා ගන්න.",
                      //"Not everything you read is a fact. Some statements are opinions — presented as if they were facts. You'll read Sinhala statements and classify each one on a 4-point scale: Clear Fact, Likely Fact, Likely Opinion, or Clear Opinion. Then discover the linguistic signals that reveal the difference.",
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
                          const Text("💡", style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.55),
                                children: [
                                  TextSpan(
                                    text:
                                      "දත්ත සමඟ කරුණු පරීක්ෂා කළ හැකිය. මතවල විනිශ්චයන් අඩංගු වේ. 'සැමවිටම', 'හොඳම', 'කළ යුතු' වැනි වචන මත සංඥා වේ. සංඛ්‍යා සහ නම් කරන ලද මූලාශ්‍ර කරුණු සංඥා වේ.",
                                    //"Facts can be checked with data. Opinions contain judgments. Words like 'always', 'best', 'should' are opinion signals. Numbers and named sources are fact signals.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
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
    final s = statements[index];
    final int correctAnswer = s["answer"] as int;
    final bool isCorrect = selected == correctAnswer;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar((index) / statements.length),
            _buildSubLabelRow(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ප්‍රකාශ ${statements.length} න් ${index + 1} වන ප්‍රකාශය",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: s["categoryBg"] as Color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s["category"] as String,
                        style: TextStyle(
                          color: s["categoryColor"] as Color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Statement card
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 14, 12, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "මෙම ප්‍රකාශය කියවන්න",
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
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

                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 10, 16, 4),
                            child: Text(
                              s["text"] as String,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 16),
                            // child: Text(
                            //   s["english"] as String,
                            //   style: const TextStyle(
                            //     fontSize: 13,
                            //     fontStyle: FontStyle.italic,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "මෙම ප්‍රකාශය වර්ණාවලියේ කොතැනද පිහිටා ඇත්තේ?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Spectrum bar
                    _buildSpectrumBar(),

                    const SizedBox(height: 16),

                    // 2x2 option grid
                    _buildOptionGrid(correctAnswer),

                    const SizedBox(height: 14),

                    // Feedback
                    if (showExplanation)
                      _buildFeedback(s, isCorrect, correctAnswer),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Next button
            if (showExplanation)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB71C1C),
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      index < statements.length - 1
                          ? "ඊළඟ ප්‍රකාශය →"
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
                      "ඊළඟ ප්‍රකාශය →",
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

  // ─── SPECTRUM BAR ──────────────────────────────────────────────────────────
  Widget _buildSpectrumBar() {
    return Column(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2D9E6B), // green - Clear Fact
                Color(0xFF1A5FA8), // blue - Likely Fact
                Color(0xFFD44000), // orange - Likely Opinion
                Color(0xFFB71C1C), // red - Clear Opinion
              ],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("◄ කරුණු",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D9E6B))),
            Text("මතය ►",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB71C1C))),
          ],
        ),
      ],
    );
  }

  // ─── 2×2 OPTION GRID ───────────────────────────────────────────────────────
  Widget _buildOptionGrid(int correctAnswer) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildOptionCard(0, correctAnswer)),
            const SizedBox(width: 10),
            Expanded(child: _buildOptionCard(1, correctAnswer)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildOptionCard(2, correctAnswer)),
            const SizedBox(width: 10),
            Expanded(child: _buildOptionCard(3, correctAnswer)),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard(int i, int correctAnswer) {
    final opt = options[i];
    final bool isSelected = selected == i;
    final bool isCorrectOption = i == correctAnswer;
    final bool showCorrect = showExplanation && isCorrectOption;
    final bool showWrong = showExplanation && isSelected && !isCorrectOption;

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Widget? badgeIcon;

    if (showCorrect) {
      bgColor = opt["selectedBg"] as Color;
      borderColor = opt["selectedBorder"] as Color;
      badgeIcon = const Icon(Icons.check_box, color: Colors.green, size: 20);
    } else if (showWrong) {
      bgColor = const Color(0xFFFFF0F0);
      borderColor = Colors.red.shade300;
      badgeIcon = const Icon(Icons.close, color: Colors.red, size: 20);
    } else if (isSelected) {
      bgColor = opt["selectedBg"] as Color;
      borderColor = opt["selectedBorder"] as Color;
    }

    return GestureDetector(
      onTap: showExplanation ? null : () => choose(i),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          children: [
            // Colored dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: opt["dotColor"] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              opt["label"] as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: opt["textColor"] as Color,
              ),
              textAlign: TextAlign.center,
            ),
            if (badgeIcon != null) ...[
              const SizedBox(height: 6),
              badgeIcon,
            ],
          ],
        ),
      ),
    );
  }

  // ─── FEEDBACK BOX ──────────────────────────────────────────────────────────
  Widget _buildFeedback(
      Map<String, dynamic> s, bool isCorrect, int correctAnswer) {
    final Color bgColor = isCorrect
        ? const Color(0xFFEAF7EE)
        : const Color(0xFFFFF0F0);
    final Color borderColor =
    isCorrect ? Colors.green.shade300 : Colors.red.shade300;
    final String title = s["feedbackTitle"] as String;

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
            title,
            style: TextStyle(
              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s["explanation"] as String,
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
                  // _buildTag("පැවරුම 1",
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (!_started) {
            fill = 0.0;
          } else if (i == 0) {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text("🎯", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "කරුණු හෝ මත වර්ගීකරණය",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A4D2E),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text(
          //   "Activity 1 of 6",
          //   style: TextStyle(fontSize: 12, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}