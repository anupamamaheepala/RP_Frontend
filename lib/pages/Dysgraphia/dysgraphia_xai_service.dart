import 'package:flutter/material.dart';

class DysgraphiaXAIService extends StatelessWidget {
  final Map<String, dynamic> kinematicData;
  final String riskLevel;

  const DysgraphiaXAIService({
    super.key,
    required this.kinematicData,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("පුද්ගලීකෘත විශ්ලේෂණය (Personalized Analysis)"),
        const SizedBox(height: 10),
        Text(
          "මෙම දරුවාටම ආවේණික වූ ලිවීමේ ලක්ෂණ සහ දෝෂ මෙහි දැක්වේ.",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 20),

        // 1. SPECIFIC FAULTS ENGINE (Addresses exact issues per child)
        _buildSpecificFaults(),

        const SizedBox(height: 24),
        _buildSectionHeader("මූලික දත්ත විශ්ලේෂණය (Core Analysis)"),
        const SizedBox(height: 15),

        // 2. KINEMATIC FEATURE CARDS
        _buildKinematicInsight(
          label: "ලිවීමේ වේගය (Writing Speed)",
          value: "${kinematicData['duration']}s",
          insight: _getSpeedInsight(kinematicData['duration']),
          icon: Icons.timer_outlined,
          accentColor: Colors.blue.shade700,
        ),
        _buildKinematicInsight(
          label: "අකුරු අඛණ්ඩතාවය (Stroke Count)",
          value: "${kinematicData['strokeCount']} strokes",
          insight: _getStrokeInsight(kinematicData['strokeCount']),
          icon: Icons.gesture_rounded,
          accentColor: Colors.purple.shade700,
        ),
        _buildKinematicInsight(
          label: "නිරවද්‍යතාවය (Accuracy)",
          value: "${kinematicData['accuracy']}%",
          insight: _getAccuracyInsight(kinematicData['accuracy']),
          icon: Icons.verified_outlined,
          accentColor: Colors.teal.shade700,
        ),

        const SizedBox(height: 24),
        _buildAdviceSection(),
      ],
    );
  }

  // --- SPECIFIC FAULTS LOGIC ---

  Widget _buildSpecificFaults() {
    List<Widget> faults = [];

    // Issue: Curvature Difficulty (High time + Low accuracy)
    // Common in Sinhala letters like 'බ', 'ම', 'න'[cite: 1]
    if (kinematicData['accuracy'] < 55 && kinematicData['duration'] > 15) {
      faults.add(_faultTile(
        "වක්‍ර අකුරු ලිවීමේ අපහසුව (Curvature Difficulty)",
        "දරුවා වක්‍ර සහිත අකුරු ලිවීමට වැඩි කාලයක් ගන්නා අතර එහි හැඩය නිවැරදිව තබා ගැනීමට අපහසු වේ.",
        Icons.architecture_rounded,
      ));
    }

    // Issue: Repetitive Frustration (High 'Clears' count)
    // User tries the same letter twice or erases frequently[cite: 4]
    if (kinematicData['clears'] != null && kinematicData['clears'] > 3) {
      faults.add(_faultTile(
        "නැවත නැවත ලිවීමේ ප්‍රවණතාවය (Repetition/Uncertainty)",
        "එකම අකුර කිහිප වතාවක් මකා ලිවීම මගින් දරුවාගේ ඇති අවිශ්වාසය හෝ හැඩය අමතක වීම පෙන්නුම් කරයි.",
        Icons.refresh_rounded,
      ));
    }

    // Issue: Fragmented Strokes (Pen lifts)
    // High stroke count for simple Grade 3 letters
    if (kinematicData['strokeCount'] > 7) {
      faults.add(_faultTile(
        "අසම්පූර්ණ අකුරු පහරවල් (Fragmented Strokes)",
        "අකුරක හැඩය සම්පූර්ණ කිරීමට පෙර පෑන එසවීම සිදු කරයි. මෙය මාංශපේශි පාලනයේ දුර්වලතාවයක් විය හැක.",
        Icons.line_style_rounded,
      ));
    }

    if (faults.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          "සුවිශේෂී ලිවීමේ දෝෂ හමු නොවීය. දරුවාගේ ලිවීමේ රටාව සාමාන්‍ය මට්ටමේ පවතී.",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
        ),
      );
    }

    return Column(children: faults);
  }

  Widget _faultTile(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.red.shade800, fontSize: 13, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- UI COMPONENTS & HELPERS ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildKinematicInsight({
    required String label,
    required String value,
    required String insight,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: accentColor.withOpacity(0.1), child: Icon(icon, color: accentColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600)),
                Text(value, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(insight, style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSpeedInsight(dynamic duration) {
    double val = (duration is int) ? duration.toDouble() : duration;
    return val > 15 ? "සාමාන්‍ය කාලයට වඩා වැඩි කාලයක් ගෙන ඇත." : "වේගය සාමාන්‍ය මට්ටමේ පවතී.";
  }

  String _getStrokeInsight(int strokes) {
    return strokes > 5 ? "වැඩි වාර ගණනක් පෑන එසවීම සිදු කර ඇත." : "අකුරු ලිවීමේ අඛණ්ඩතාවය ඉතා හොඳයි.";
  }

  String _getAccuracyInsight(dynamic accuracy) {
    double val = (accuracy is int) ? accuracy.toDouble() : accuracy;
    return val < 60 ? "අකුරු වල හැඩය නිවැරදිව ලිවීමට පුහුණු කරවන්න." : "නිරවද්‍යතාවය යහපත් මට්ටමක පවතී.";
  }

  Widget _buildAdviceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple.shade400, Colors.blue.shade400]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.tips_and_updates, color: Colors.white), SizedBox(width: 10), Text("ඊළඟ පියවර", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10),
          Text(
            riskLevel.toLowerCase() == "high"
                ? "මූලික මෝටර් කුසලතා සඳහා 'Ghost Trace' සහ 'Dot-to-Dot' නිර්දේශ කෙරේ."
                : "වේගය සහ නිවැරදි බව වැඩි කිරීමට 'Beat Your Time' භාවිතා කරන්න.",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}