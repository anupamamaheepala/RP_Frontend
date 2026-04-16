// import 'dart:math';
// import 'package:flutter/material.dart';
//
// class MistakeAnalysisPage extends StatelessWidget {
//   final List sentences;
//
//   const MistakeAnalysisPage({super.key, required this.sentences});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: sentences.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("🧠 Mistake Analysis"),
//           backgroundColor: Colors.purple,
//           bottom: TabBar(
//             isScrollable: true,
//             tabs: List.generate(
//               sentences.length,
//                   (i) => Tab(text: "Sentence ${i + 1}"),
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: sentences.map<Widget>((s) {
//             final metrics = s["metrics"] ?? {};
//             final transcript = metrics["transcript"] ?? "";
//             final reference = s["reference_text"] ?? "";
//             final feedback = metrics["xai_feedback"] ?? [];
//
//             final wordErrors =
//             _buildWordErrors(reference, transcript, feedback);
//
//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: ListView(
//                 children: [
//                   // Reference sentence
//                   _sentenceCard(
//                     "📘 Reference Sentence",
//                     reference,
//                     Colors.green,
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Student sentence
//                   _sentenceCard(
//                     "🎤 Your Sentence",
//                     transcript,
//                     Colors.blue,
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   if (wordErrors.isEmpty)
//                     const Text(
//                       "🎉 No mistakes found!",
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     )
//                   else
//                     ...wordErrors.map((w) => _wordErrorCard(w)).toList(),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   // ==========================
//   // 🔥 WORD ERROR BUILDER
//   // ==========================
//   List<Map<String, dynamic>> _buildWordErrors(
//       String reference, String transcript, List feedback) {
//     List<String> refWords = reference.split(" ");
//     List<String> studentWords = transcript.split(" ");
//
//     List<Map<String, dynamic>> wordErrors = [];
//
//     int len = min(refWords.length, studentWords.length);
//
//     for (int i = 0; i < len; i++) {
//       if (refWords[i] != studentWords[i]) {
//         wordErrors.add({
//           "incorrect": studentWords[i],
//           "correct": refWords[i],
//           "index": i,
//           "char_errors": [],
//         });
//       }
//     }
//
//     // Attach character errors to correct word
//     for (var error in feedback) {
//       int charPos = error["position"] ?? 0;
//       int wordIndex = _getWordIndex(transcript, charPos);
//
//       for (var w in wordErrors) {
//         if (w["index"] == wordIndex) {
//           w["char_errors"].add(error["message"]);
//         }
//       }
//     }
//
//     return wordErrors;
//   }
//
//   // ==========================
//   // 🔥 CHAR POSITION → WORD INDEX
//   // ==========================
//   int _getWordIndex(String sentence, int charIndex) {
//     int count = 0;
//     for (int i = 0; i < charIndex && i < sentence.length; i++) {
//       if (sentence[i] == " ") count++;
//     }
//     return count;
//   }
//
//   // ==========================
//   // 🎨 UI COMPONENTS
//   // ==========================
//
//   Widget _sentenceCard(String title, String text, Color color) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//               TextStyle(fontWeight: FontWeight.bold, color: color)),
//           const SizedBox(height: 6),
//           Text(text, style: const TextStyle(fontSize: 16)),
//         ],
//       ),
//     );
//   }
//
//   Widget _wordErrorCard(Map<String, dynamic> w) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "❌ Incorrect: ${w["incorrect"]}",
//             style: const TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "✅ Correct: ${w["correct"]}",
//             style: const TextStyle(
//               color: Colors.green,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 10),
//
//           const Text(
//             "🔤 Character Analysis:",
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 6),
//
//           ...(w["char_errors"] as List).isEmpty
//               ? [const Text("• No detailed character errors")]
//               : (w["char_errors"] as List)
//               .map<Widget>((e) => Text("• $e"))
//               .toList(),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';

class MistakeAnalysisPage extends StatelessWidget {
  final List sentences;

  const MistakeAnalysisPage({super.key, required this.sentences});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: sentences.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEF0FF),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEEF0FF), Color(0xFFE8F4FF)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ─── Header ───────────────────────────────────────
                _buildHeader(context),

                // ─── Tab Bar ──────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: const Color(0xFF7B6EF6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF7B6EF6),
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13),
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    tabs: List.generate(
                      sentences.length,
                          (i) => Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Text("Sentence ${i + 1}"),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                // ─── Tab Content ──────────────────────────────────
                Expanded(
                  child: TabBarView(
                    children: sentences.map<Widget>((s) {
                      final metrics = s["metrics"] ?? {};
                      final transcript = metrics["transcript"] ?? "";
                      final reference = s["reference_text"] ?? "";
                      final feedback = metrics["xai_feedback"] ?? [];

                      final wordErrors =
                      _buildWordErrors(reference, transcript, feedback);

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Reference sentence card
                          _referenceCard(reference),
                          const SizedBox(height: 10),

                          // Student sentence card
                          _studentCard(transcript, reference),
                          const SizedBox(height: 16),

                          if (wordErrors.isEmpty)
                            _noMistakesCard()
                          else ...[
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                "WORD ERRORS FOUND",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[500],
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            ...wordErrors
                                .map((w) => _wordErrorCard(w))
                                .toList(),
                          ],

                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Color(0xFF7B6EF6), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '🧠 Mistake Analysis',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE040FB),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ─── Reference Card ──────────────────────────────────────────────────
  Widget _referenceCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA8D8A0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("📘", style: TextStyle(fontSize: 14)),
              SizedBox(width: 6),
              Text(
                "Reference Sentence",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Color(0xFF2E9E40),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2D2D2D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Student Card ────────────────────────────────────────────────────
  Widget _studentCard(String transcript, String reference) {
    final refWords = reference.split(" ");
    final stuWords = transcript.split(" ");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7EC8F8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("🎤", style: TextStyle(fontSize: 14)),
              SizedBox(width: 6),
              Text(
                "Your Sentence",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Color(0xFF1976D2),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 4,
            runSpacing: 2,
            children: List.generate(stuWords.length, (i) {
              final isError = i < refWords.length &&
                  stuWords[i] != refWords[i];
              return Text(
                "${stuWords[i]} ",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: isError
                      ? const Color(0xFFE53935)
                      : const Color(0xFF2D2D2D),
                  fontWeight: isError
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── No Mistakes Card ────────────────────────────────────────────────
  Widget _noMistakesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA5D6A7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text("🎉", style: TextStyle(fontSize: 36)),
          SizedBox(height: 10),
          Text(
            "No mistakes found!",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Perfect pronunciation on this sentence.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF66BB6A),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Word Error Card ──────────────────────────────────────────────────
  Widget _wordErrorCard(Map<String, dynamic> w) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B6EF6).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Incorrect → Correct row
          Row(
            children: [
              const Icon(Icons.close_rounded,
                  color: Color(0xFFE53935), size: 18),
              const SizedBox(width: 6),
              const Text(
                "You said:",
                style: TextStyle(
                    fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(width: 8),
              _pill(w["incorrect"], isError: true),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 16, color: Color(0xFFBDBDBD)),
              ),
              const Icon(Icons.check_rounded,
                  color: Color(0xFF43A047), size: 18),
              const SizedBox(width: 6),
              _pill(w["correct"], isError: false),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF5F5F5)),
          ),

          // Character analysis
          const Text(
            "CHARACTER ANALYSIS",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFBDBDBD),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          (w["char_errors"] as List).isEmpty
              ? const Text(
            "• No detailed character errors",
            style: TextStyle(
                fontSize: 13, color: Color(0xFF9E9E9E)),
          )
              : Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (w["char_errors"] as List)
                .map<Widget>(
                  (e) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFFFCC80)),
                ),
                child: Text(
                  e.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE65100),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── Pill Widget ──────────────────────────────────────────────────────
  Widget _pill(String text, {required bool isError}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isError
            ? const Color(0xFFFDECEA)
            : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isError
              ? const Color(0xFFFFCDD2)
              : const Color(0xFFA5D6A7),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isError
              ? const Color(0xFFC62828)
              : const Color(0xFF2E7D32),
        ),
      ),
    );
  }

  // ─── Word Error Builder ───────────────────────────────────────────────
  List<Map<String, dynamic>> _buildWordErrors(
      String reference, String transcript, List feedback) {
    final refWords = reference.split(" ");
    final stuWords = transcript.split(" ");
    final List<Map<String, dynamic>> wordErrors = [];

    final len = min(refWords.length, stuWords.length);
    for (int i = 0; i < len; i++) {
      if (refWords[i] != stuWords[i]) {
        wordErrors.add({
          "incorrect": stuWords[i],
          "correct": refWords[i],
          "index": i,
          "char_errors": [],
        });
      }
    }

    for (var error in feedback) {
      final charPos = error["position"] ?? 0;
      final wordIndex = _getWordIndex(transcript, charPos);
      for (var w in wordErrors) {
        if (w["index"] == wordIndex) {
          w["char_errors"].add(error["message"]);
        }
      }
    }

    return wordErrors;
  }

  int _getWordIndex(String sentence, int charIndex) {
    int count = 0;
    for (int i = 0; i < charIndex && i < sentence.length; i++) {
      if (sentence[i] == " ") count++;
    }
    return count;
  }
}