import 'package:flutter/material.dart';

class G7_L3_High_A3 extends StatefulWidget {
  const G7_L3_High_A3({super.key});

  @override
  State<G7_L3_High_A3> createState() => _G7_L3_High_A3State();
}

class _G7_L3_High_A3State extends State<G7_L3_High_A3> {
  bool _started = false;
  int setIndex = 0;
  Map<int, String> selectedRatings = {};
  bool showResult = false;

  // Rating config
  static const List<Map<String, dynamic>> ratingOptions = [
    {
      "value": "strong",
      "label": "ශක්තිමත්",
      "emoji": "💪",
      "color": Color(0xFF1A6B4A),
      "bg": Color(0xFFEAF7EE),
      "border": Color(0xFF1A6B4A),
      "lightBg": Color(0xFFEAF7EE),
      "lightBorder": Color(0xFF2D9E6B),
    },
    {
      "value": "ok",
      "label": "සාමාන්‍යය",
      "emoji": "🔶",
      "color": Color(0xFFE67E00),
      "bg": Color(0xFFFFF8E6),
      "border": Color(0xFFE67E00),
      "lightBg": Color(0xFFFFF8E6),
      "lightBorder": Color(0xFFE67E00),
    },
    {
      "value": "weak",
      "label": "දුර්වල",
      "emoji": "⚠️",
      "color": Color(0xFFB71C1C),
      "bg": Color(0xFFFFF0F0),
      "border": Color(0xFFB71C1C),
      "lightBg": Color(0xFFFFF0F0),
      "lightBorder": Color(0xFFB71C1C),
    },
  ];

  final List<Map<String, dynamic>> sets = [
    {
      "claim":
      "Reading every day improves students' academic performance.",
      "claim_si":
      "දිනපතා කියවීම ශිෂ්‍යයන්ගේ අධ්‍යාපන කාර්යසාධනය වැඩි දියුණු කරයි.",
      "evidence": [
        {
          "text":
          "රටවල් 12 ක සිසුන් 4,000 ක් යොදාගෙන 2019 දී කරන ලද අධ්‍යයනයකින් හෙළි වූයේ දිනකට මිනිත්තු 30+ ක් කියවන සිසුන් කියවීමේ අවබෝධතා පරීක්ෂණවලදී 23% ක් ඉහළ ලකුණු ලබා ඇති බවයි.",
          "correct": "strong",
          "whyTitle": "ප්‍රබල සාක්ෂි ඇති වීමට හේතුව:",
          "why":
          "නිශ්චිත වර්ෂය + විශාල නියැදිය (4,000) + රටවල් කිහිපයක් + නිශ්චිත ප්‍රතිශතය = ඉහළ විශ්වසනීයත්වයක්. මෙය මහා පරිමාණ අධ්‍යයනයකින් ලබාගත් ප්‍රායෝගික දත්ත වේ.",
        },
        {
          "text":
          "මගේ ගුරුතුමිය කියනවා වැඩිපුර කියවන ළමයි හැම විටම පාසලේදී හොඳින් ඉගෙන ගන්නවා කියලා.",
          "correct": "weak",
          "whyTitle": "දුර්වල සාක්ෂි ඇති වීමට හේතුව:",
          "why":
          "දත්ත නොමැතිව එක් පුද්ගලයෙකුගේ මතය. 'සැමවිටම' යනු නිරපේක්ෂ වචනයකි - අන්තවාදී ප්‍රකාශ සඳහා ශක්තිමත් සාක්ෂි අවශ්‍ය වේ. එක් ගුරුවරයෙකුගේ පෞද්ගලික නිරීක්ෂණයක් යනු පර්යේෂණයක් නොව, කතන්දරයකි.",
        },
        {
          "text":
          "ජාතික අධ්‍යාපන අමාත්‍යාංශය වාර්තා කළේ කියවීමේ වැඩසටහන් සහිත පාසල් වසර තුනක් තුළ 5 ශ්‍රේණියේ ශිෂ්‍යත්ව විභාග සමත් වීමේ අනුපාතයේ දියුණුවක් පෙන්නුම් කළ බවයි.",
          "correct": "ok",
          "whyTitle": "සාමාන්‍ය සාක්ෂි ඇති වීමට හේතුව:",
          "why":
          "නිල මූලාශ්‍රය (අමාත්‍යාංශය) + කාල සීමාව (අවුරුදු 3) + නිශ්චිත විභාගය — හොඳයි! නමුත් 'වැඩිදියුණු කර ඇත' යන්න අපැහැදිලියි (කොපමණද?) එය එක් රටක දත්ත. උපමාවකට වඩා ශක්තිමත්, බහු-රට අධ්‍යයනය තරම් ශක්තිමත් නොවේ.",
        },
      ],
    },
    {
      "claim":
      "Social media has a negative impact on teenagers' mental health.",
      "claim_si":
      "සමාජ මාධ්‍ය නව යොවුන් වියේ මානසික සෞඛ්‍යයට අහිතකර බලපෑමක් ඇති කරයි.",
      "evidence": [
        {
          "text":
          "වසර 5ක් පුරා යෞවනයන් 10,000ක් නිරීක්ෂණය කරන ලද හාවඩ් අධ්‍යයනයකින් (2022) සමාජ මාධ්‍ය භාවිතා කරන්නන් අතර කාංසාව 34% කින් වැඩි වී ඇති බව සොයා ගන්නා ලදී.",
          "correct": "strong",
          "whyTitle": "ප්‍රබල සාක්ෂි ඇති වීමට හේතුව:",
          "why":
          "කීර්තිමත් ආයතනය + විශාල නියැදිය + දිගු කාලසීමාව + නිශ්චිත ප්‍රතිශතය = ඉතා විශ්වාසදායක පර්යේෂණ දත්ත.",
        },
        {
          "text":
          "ඕනෑවට වඩා තිර කාලය ගත කිරීම ඔබට නරක හැඟීමක් ඇති කරන බව කවුරුත් දනිති.",
          "correct": "weak",
          "whyTitle": "දුර්වල සාක්ෂි ඇති වීමට හේතුව:",
          "why":
          "'හැමෝම දන්නවා' යනු තාර්කික වැරැද්දකි. දත්ත නැත, මූලාශ්‍රයක් නැත. මෙය සත්‍යයක් ලෙස ඉදිරිපත් කරන ලද පොදු විශ්වාසයකි.",
        },
        {
          "text":
          "2021 දී නිකුත් කළ වාර්තාවක ලෝක සෞඛ්‍ය සංවිධානය සඳහන් කළේ, අධික සමාජ මාධ්‍ය භාවිතය නව යොවුන් වියේ පසුවන්නන්ගේ නින්දට බාධා ඇති කිරීමට හේතු වන බවයි.",
          "correct": "ok",
          "whyTitle": "සාමාන්‍ය සාක්ෂි ඇති වීමට හේතුව:",
          "why":
          "විශ්වාසදායක මූලාශ්‍රය (WHO) + වර්ෂය. කෙසේ වෙතත්, 'සම්බන්ධ' යන්නෙන් පෙන්නුම් කරන්නේ සහසම්බන්ධතාවය මිස හේතුඵල සම්බන්ධතාවය නොවේ. නින්දට පමණක් සීමා වූ විෂය පථය, සියලු මානසික සෞඛ්‍ය නොවේ.",
        },
      ],
    },
    {
      "claim":
      "Eating breakfast improves concentration and learning in school.",
      "claim_si":
      "උදෑසන ආහාරය ගැනීම පාසලේ සාන්ද්‍රණය හා ඉගෙනීම වැඩිදියුණු කරයි.",
      "evidence": [
        {
          "text":
          "A controlled study by Oxford University (2020) with 600 primary school children showed a 17% improvement in attention tasks after a standardised breakfast.",
          "correct": "strong",
          "whyTitle": "Why Strong Evidence:",
          "why":
          "Controlled study + reputable university + specific sample size + measurable outcome (17%) = strong empirical evidence.",
        },
        {
          "text":
          "My mum always told me breakfast is the most important meal of the day.",
          "correct": "weak",
          "whyTitle": "Why Weak Evidence:",
          "why":
          "Personal anecdote. No research basis. Common saying does not equal evidence.",
        },
        {
          "text":
          "The Ministry of Health recommends breakfast for school children and notes that programmes providing school meals have shown better attendance.",
          "correct": "ok",
          "whyTitle": "Why OK Evidence:",
          "why":
          "Official recommendation + real programme data. But attendance ≠ concentration. Indirect link to the claim.",
        },
      ],
    },
  ];

  bool allRated() => selectedRatings.length == 3;

  void selectRating(int index, String value) {
    if (showResult) return;
    setState(() => selectedRatings[index] = value);
  }

  void showEvaluation() {
    if (!allRated()) return;
    setState(() => showResult = true);
  }

  void nextSet() {
    if (setIndex < sets.length - 1) {
      setState(() {
        setIndex++;
        selectedRatings.clear();
        showResult = false;
      });
    } else {
      Navigator.pop(context, true);
    }
  }

  Map<String, dynamic> _ratingConfig(String value) {
    return ratingOptions.firstWhere((r) => r["value"] == value);
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
                    const SizedBox(height: 24),
                    const Text("🎯", style: TextStyle(fontSize: 68)),
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
                        "පැවරුම 3 · විවේචනාත්මක ඇගයීම",
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
                      "සාක්ෂි බර කරන්නා",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "සෑම සාක්ෂි කොටසක්ම සමාන නොවේ. ඔබ හිමිකම් පෑමක් කියවා, පසුව සාක්ෂි තුනක් විනිශ්චය කරනු ඇත - එක් එක් සාක්ෂි ශක්තිමත්, හරි හෝ දුර්වල ලෙස ශ්‍රේණිගත කරන්න. ඉන්පසු සෑම ශ්‍රේණිගත කිරීමක්ම නිවැරදි වන්නේ මන්දැයි හරියටම සොයා ගන්න.",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.65),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

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
                              "දත්ත සමඟ කරුණු පරීක්ෂා කළ හැකිය. මතවල විනිශ්චයන් අඩංගු වේ. 'සැමවිටම', 'හොඳම', 'කළ යුතු' වැනි වචන මත සංඥා වේ. සංඛ්‍යා සහ නම් කරන ලද මූලාශ්‍ර කරුණු සංඥා වේ.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.5),
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
    final current = sets[setIndex];
    final List evidence = current["evidence"] as List;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildOuterProgressBar(setIndex / sets.length),
            _buildSubLabelRow(),

            // Inner progress
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildInnerProgressBar(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set ${setIndex + 1} of ${sets.length}",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    // ── Claim card ──
                    _buildClaimCard(current),

                    const SizedBox(height: 18),

                    const Text(
                      "එක් එක් සාක්ෂි කොටස ශ්‍රේණිගත කරන්න:",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    // ── Evidence cards ──
                    ...List.generate(evidence.length, (i) {
                      return _buildEvidenceCard(
                          i, evidence[i] as Map<String, dynamic>);
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: showResult
                      ? nextSet
                      : (allRated() ? showEvaluation : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showResult || allRated()
                        ? const Color(0xFF1A4D2E)
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    showResult
                        ? (setIndex < sets.length - 1
                        ? "ඊළඟ හිමිකම් පෑම →"
                        : "ක්‍රියාකාරකම් අවසන් කරන්න ✓")
                        : "ඉදිරියට යාමට සියලු සාක්ෂි ශ්‍රේණිගත කරන්න",
                    style: const TextStyle(
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

  // ─── CLAIM CARD ────────────────────────────────────────────────────────────
  Widget _buildClaimCard(Map<String, dynamic> current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF7EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D8B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📌  THE CLAIM",
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            current["claim"],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            current["claim_si"],
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── EVIDENCE CARD ─────────────────────────────────────────────────────────
  Widget _buildEvidenceCard(int i, Map<String, dynamic> e) {
    final String? selected = selectedRatings[i];
    final String correct = e["correct"] as String;
    final bool userCorrect = selected == correct;
    final Map<String, dynamic> correctCfg = _ratingConfig(correct);

    // Border/bg after result
    Color cardBg = Colors.white;
    Color cardBorder = Colors.grey.shade200;

    if (showResult) {
      cardBg = correctCfg["lightBg"] as Color;
      cardBorder = correctCfg["lightBorder"] as Color;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A4D2E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Evidence ${String.fromCharCode(65 + i)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // After result: show correct rating label
              if (showResult)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: correctCfg["bg"] as Color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: correctCfg["border"] as Color),
                  ),
                  child: Text(
                    "${correctCfg["emoji"]} ${correct[0].toUpperCase()}${correct.substring(1)} Evidence",
                    style: TextStyle(
                      color: correctCfg["color"] as Color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Evidence text
          Text(
            e["text"],
            style: const TextStyle(
                fontSize: 14, height: 1.6, color: Colors.black87),
          ),

          const SizedBox(height: 12),

          // Rating buttons (hidden after result)
          if (!showResult)
            Row(
              children: ratingOptions.map((opt) {
                final bool isSelected = selected == opt["value"];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => selectRating(i, opt["value"]),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: opt != ratingOptions.last ? 8 : 0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (opt["bg"] as Color)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? (opt["border"] as Color)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(opt["emoji"],
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 3),
                          Text(
                            opt["label"],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? (opt["color"] as Color)
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          // Why explanation (after result)
          if (showResult) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e["whyTitle"],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: correctCfg["color"] as Color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    e["why"],
                    style: const TextStyle(
                        fontSize: 13, height: 1.55),
                  ),
                ],
              ),
            ),
          ],
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
                  // _buildTag("පැවරුම 3",
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
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

  Widget _buildOuterProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          double fill = 0.0;
          if (_started && i == 2) fill = progress.clamp(0.0, 1.0);
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
                      color: const Color(0xFF1A4D2E),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInnerProgressBar() {
    final double fill =
    sets.isEmpty ? 0 : (setIndex) / sets.length;
    return Container(
      height: 4,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: fill.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(3)),
        ),
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
              Text("⚖️", style: TextStyle(fontSize: 13)),
              SizedBox(width: 4),
              Text(
                "සාක්ෂි බර කරන්නා",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A4D2E),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // const Text("Activity 3 of 6",
          //     style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}