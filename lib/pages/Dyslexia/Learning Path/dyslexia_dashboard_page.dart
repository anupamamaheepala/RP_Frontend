// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// import '../../../config.dart';
//
// class DyslexiaDashboardPage extends StatefulWidget {
//   const DyslexiaDashboardPage({super.key});
//
//   @override
//   State<DyslexiaDashboardPage> createState() => _DyslexiaDashboardPageState();
// }
//
// class _DyslexiaDashboardPageState extends State<DyslexiaDashboardPage> {
//   List sessions = [];
//   bool loading = true;
//   String? selectedGrade;
//   String? selectedLevel;
//
//   // ─── Theme Colors ─────────────────────────────────────────────────────
//   static const Color kPurple = Color(0xFF7B6EF6);
//   static const Color kPink = Color(0xFFE040FB);
//   static const Color kBgStart = Color(0xFFEEF0FF);
//   static const Color kBgEnd = Color(0xFFE8F4FF);
//   static const Color kCardShadow = Color(0xFF7B6EF6);
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   Future<void> loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("user_id");
//
//     final res = await http.get(
//       Uri.parse("${Config.baseUrl}/dyslexia/history?user_id=$userId"),
//     );
//
//     final data = jsonDecode(res.body);
//
//     setState(() {
//       sessions = data["sessions"] ?? [];
//       loading = false;
//     });
//   }
//
//   // =========================
//   // CALCULATIONS
//   // =========================
//
//   double avgAccuracy() {
//     final data = getFilteredSessions();
//     if (data.isEmpty) return 0;
//     return data
//         .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//         .reduce((a, b) => a + b) /
//         data.length;
//   }
//
//   double maxAccuracy() {
//     if (sessions.isEmpty) return 0;
//     return sessions
//         .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//         .reduce((a, b) => a > b ? a : b);
//   }
//
//   double minAccuracy() {
//     if (sessions.isEmpty) return 0;
//     return sessions
//         .map((e) => (e["overall_accuracy"] ?? 0).toDouble())
//         .reduce((a, b) => a < b ? a : b);
//   }
//
//   double avgTime() {
//     final data = getFilteredSessions();
//     if (data.isEmpty) return 0;
//     final total = data
//         .map((e) => (e["total_time_seconds"] ?? 0))
//         .map((e) => e is num ? e.toDouble() : 0.0)
//         .reduce((a, b) => a + b);
//     return total / data.length;
//   }
//   Map<String, double> avgEyeMetrics() {
//     final data = getFilteredSessions();
//     if (data.isEmpty) {
//       return {
//         "fixation": 0,
//         "regression": 0,
//         "saccade": 0,
//         "blink": 0,
//       };
//     }
//
//     double fixation = 0;
//     double regression = 0;
//     double saccade = 0;
//     double blink = 0;
//
//     for (var s in data) {
//       fixation += (s["avg_fixation_time"] ?? 0).toDouble();
//       regression += (s["avg_regression_count"] ?? 0).toDouble();
//       saccade += (s["avg_saccade_count"] ?? 0).toDouble();
//       blink += (s["avg_blink_rate_per_min"] ?? 0).toDouble();
//     }
//
//     return {
//       "fixation": fixation / data.length,
//       "regression": regression / data.length,
//       "saccade": saccade / data.length,
//       "blink": blink / data.length,
//     };
//   }
//
//   Map<String, double> normalizedEyeMetrics() {
//     final raw = avgEyeMetrics();
//
//     return {
//       // 👁 Fixation (higher is better → normalize directly)
//       "fixation": normalize(raw["fixation"]!, 100, 400),
//
//       // 🔁 Regression (lower is better → invert)
//       "regression": 100 - normalize(raw["regression"]!, 0, 20),
//
//       // ➡ Saccade (moderate is good → assume higher is better for now)
//       "saccade": normalize(raw["saccade"]!, 0, 30),
//
//       // 👀 Blink (too low or too high bad → simple normalize)
//       "blink": normalize(raw["blink"]!, 5, 25),
//     };
//   }
//
//   Map<String, double> gradeNorm() {
//     return {
//       "fixation": 250,
//       "regression": 5,
//       "saccade": 12,
//       "blink": 15,
//     };
//   }
//
//   Map<String, double> normalizedGradeNorm() {
//     final norm = gradeNorm();
//
//     return {
//       "fixation": normalize(norm["fixation"]!, 100, 400),
//       "regression": 100 - normalize(norm["regression"]!, 0, 20),
//       "saccade": normalize(norm["saccade"]!, 0, 30),
//       "blink": normalize(norm["blink"]!, 5, 25),
//     };
//   }
//
//   double normalize(double value, double min, double max) {
//     if (max - min == 0) return 0;
//     return ((value - min) / (max - min)) * 100;
//   }
//
//   List<String> getGrades() =>
//       sessions.map((e) => e["grade"].toString()).toSet().toList();
//
//   List<String> getLevels() =>
//       sessions.map((e) => e["level"].toString()).toSet().toList();
//
//   List getFilteredSessions() {
//     return sessions.where((s) {
//       final matchGrade =
//           selectedGrade == null || s["grade"].toString() == selectedGrade;
//       final matchLevel =
//           selectedLevel == null || s["level"].toString() == selectedLevel;
//       return matchGrade && matchLevel;
//     }).toList();
//   }
//
//   // =========================
//   // CHART DATA
//   // =========================
//
//   List<FlSpot> accuracySpots() {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < sessions.length; i++) {
//       spots.add(FlSpot(
//           i.toDouble(), (sessions[i]["overall_accuracy"] ?? 0).toDouble()));
//     }
//     return spots;
//   }
//
//   Map<String, int> letterErrors() {
//     Map<String, int> map = {};
//     for (var s in sessions) {
//       var words = s["incorrect_words_all"] ?? [];
//       for (var w in words) {
//         for (var c in ["්", "ි", "ු", "ම්", "න්"]) {
//           if (w.toString().contains(c)) {
//             map[c] = (map[c] ?? 0) + 1;
//           }
//         }
//       }
//     }
//     return map;
//   }
//
//   // =========================
//   // UI COMPONENTS
//   // =========================
//
//   Widget kpiCard(String title, String value) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.all(5),
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: kCardShadow.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF9E9E9E),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: kPurple,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10, top: 4),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w700,
//           color: Color(0xFF2D2D2D),
//         ),
//       ),
//     );
//   }
//
//   Widget _chartCard({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: kCardShadow.withOpacity(0.07),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   Widget _infoCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: kCardShadow.withOpacity(0.07),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
//
//   // =========================
//   // OVERVIEW TAB
//   // =========================
//
//   Widget slicers() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFD0C8FF), width: 1.5),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: selectedGrade,
//                 hint: const Text("Select Grade",
//                     style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
//                 isExpanded: true,
//                 items: getGrades()
//                     .map((g) => DropdownMenuItem(
//                   value: g,
//                   child: Text("Grade $g",
//                       style: const TextStyle(
//                           fontSize: 13, color: Color(0xFF2D2D2D))),
//                 ))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedGrade = val),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFD0C8FF), width: 1.5),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: selectedLevel,
//                 hint: const Text("Select Level",
//                     style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
//                 isExpanded: true,
//                 items: getLevels()
//                     .map((l) => DropdownMenuItem(
//                   value: l,
//                   child: Text("Level $l",
//                       style: const TextStyle(
//                           fontSize: 13, color: Color(0xFF2D2D2D))),
//                 ))
//                     .toList(),
//                 onChanged: (val) => setState(() => selectedLevel = val),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget resetFilters() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: TextButton.icon(
//         onPressed: () =>
//             setState(() => selectedGrade = selectedLevel = null),
//         icon: const Icon(Icons.refresh_rounded, size: 16, color: kPurple),
//         label: const Text(
//           "Reset Filters",
//           style: TextStyle(color: kPurple, fontSize: 13),
//         ),
//       ),
//     );
//   }
//
//   Widget scatterChart() {
//     final data = getFilteredSessions();
//     List<ScatterSpot> spots = data.map((e) {
//       return ScatterSpot(
//         (e["total_time_seconds"] ?? 0).toDouble(),
//         (e["overall_accuracy"] ?? 0).toDouble(),
//       );
//     }).toList();
//
//     return _chartCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionTitle("📍 Time vs Accuracy"),
//           SizedBox(
//             height: 200,
//             child: ScatterChart(
//               ScatterChartData(
//                 titlesData: FlTitlesData(
//                   topTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   bottomTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: true)),
//                   leftTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: true)),
//                 ),
//                 scatterSpots: spots,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget gradeBarChart() {
//     final data = getFilteredSessions();
//     Map<String, List<double>> map = {};
//     for (var s in data) {
//       final grade = s["grade"].toString();
//       final acc = (s["overall_accuracy"] ?? 0).toDouble();
//       map.putIfAbsent(grade, () => []).add(acc);
//     }
//
//     List<BarChartGroupData> bars = [];
//     int i = 0;
//     map.forEach((grade, list) {
//       double avg = list.reduce((a, b) => a + b) / list.length;
//       bars.add(BarChartGroupData(
//         x: i++,
//         barRods: [
//           BarChartRodData(toY: avg, width: 16, color: kPurple,
//               borderRadius: BorderRadius.circular(6))
//         ],
//       ));
//     });
//
//     return _chartCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionTitle("📊 Grade Performance"),
//           SizedBox(
//             height: 200,
//             child: BarChart(
//               BarChartData(
//                 titlesData: FlTitlesData(
//                   topTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   bottomTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: true)),
//                   leftTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: true)),
//                 ),
//                 barGroups: bars,
//                 gridData: FlGridData(
//                   getDrawingHorizontalLine: (value) => FlLine(
//                     color: const Color(0xFFF0F0F0),
//                     strokeWidth: 1,
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget accuracyGauge(double value) {
//     final color = value < 60
//         ? const Color(0xFFE53935)
//         : value < 80
//         ? const Color(0xFFFF8F00)
//         : const Color(0xFF43A047);
//
//     return _chartCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionTitle("🎯 Accuracy Gauge"),
//           SizedBox(
//             height: 200,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 PieChart(
//                   PieChartData(
//                     startDegreeOffset: 180,
//                     sectionsSpace: 0,
//                     centerSpaceRadius: 60,
//                     sections: [
//                       PieChartSectionData(
//                         value: value,
//                         color: color,
//                         radius: 22,
//                         title: "",
//                       ),
//                       PieChartSectionData(
//                         value: 100 - value,
//                         color: const Color(0xFFF0F0F0),
//                         radius: 22,
//                         title: "",
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "${value.toStringAsFixed(0)}%",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: color,
//                       ),
//                     ),
//                     const Text(
//                       "Avg Accuracy",
//                       style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget overviewTab() {
//     final acc = avgAccuracy();
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         // Filters
//         slicers(),
//         resetFilters(),
//
//         const SizedBox(height: 4),
//
//         // KPI Cards
//         Row(children: [
//           kpiCard("Avg", "${acc.toStringAsFixed(1)}%"),
//           kpiCard("Max", "${maxAccuracy().toStringAsFixed(1)}%"),
//         ]),
//         Row(children: [
//           kpiCard("Min", "${minAccuracy().toStringAsFixed(1)}%"),
//           kpiCard("Time", "${avgTime().toStringAsFixed(1)}s"),
//         ]),
//
//         const SizedBox(height: 16),
//
//         // Gauge
//         accuracyGauge(acc),
//
//         const SizedBox(height: 14),
//
//         // Line chart
//         _chartCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("📈 Accuracy Trend"),
//               SizedBox(
//                 height: 200,
//                 child: LineChart(
//                   LineChartData(
//                     titlesData: FlTitlesData(
//                       topTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false)),
//                       rightTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false)),
//                       bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: true)),
//                       leftTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: true)),
//                     ),
//                     gridData: FlGridData(
//                       getDrawingHorizontalLine: (value) => FlLine(
//                         color: const Color(0xFFF0F0F0),
//                         strokeWidth: 1,
//                       ),
//                     ),
//                     borderData: FlBorderData(show: false),
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: getFilteredSessions().asMap().entries.map((e) {
//                           return FlSpot(
//                             e.key.toDouble(),
//                             (e.value["overall_accuracy"] ?? 0).toDouble(),
//                           );
//                         }).toList(),
//                         isCurved: true,
//                         color: kPurple,
//                         barWidth: 3,
//                         dotData: FlDotData(show: false),
//                         belowBarData: BarAreaData(
//                           show: true,
//                           color: kPurple.withOpacity(0.08),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 14),
//
//         gradeBarChart(),
//
//         const SizedBox(height: 14),
//
//         scatterChart(),
//
//         const SizedBox(height: 20),
//       ],
//     );
//   }
//
//   // =========================
//   // ERROR TAB
//   // =========================
//
//   Widget errorTab() {
//     final data = letterErrors();
//     final colors = [
//       const Color(0xFF7B6EF6),
//       const Color(0xFFE040FB),
//       const Color(0xFF43A047),
//       const Color(0xFFFF8F00),
//       const Color(0xFFE53935),
//     ];
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _chartCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("🔤 Letter Error Distribution"),
//               SizedBox(
//                 height: 200,
//                 child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 3,
//                     centerSpaceRadius: 40,
//                     sections: data.entries.toList().asMap().entries.map((e) {
//                       final idx = e.key;
//                       final entry = e.value;
//                       return PieChartSectionData(
//                         value: entry.value.toDouble(),
//                         title: entry.key,
//                         color: colors[idx % colors.length],
//                         radius: 55,
//                         titleStyle: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // =========================
//   // BEHAVIOR TAB
//   // =========================
//   Widget radarChart() {
//     final student = normalizedEyeMetrics();
//     final norm = normalizedGradeNorm();
//
//     return _chartCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionTitle("🕸 Eye Tracking Radar"),
//
//           SizedBox(
//             height: 260,
//             child: RadarChart(
//               RadarChartData(
//                 radarBorderData: const BorderSide(color: Colors.transparent),
//
//                 titlePositionPercentageOffset: 0.2,
//
//                 getTitle: (index, angle) {
//                   const titles = [
//                     "Fixation",
//                     "Regression",
//                     "Saccade",
//                     "Blink"
//                   ];
//                   return RadarChartTitle(text: titles[index]);
//                 },
//
//                 dataSets: [
//                   // 🎯 Student
//                   RadarDataSet(
//                     dataEntries: [
//                       RadarEntry(value: student["fixation"]!),
//                       RadarEntry(value: student["regression"]!),
//                       RadarEntry(value: student["saccade"]!),
//                       RadarEntry(value: student["blink"]!),
//                     ],
//                     borderColor: kPurple,
//                     fillColor: kPurple.withOpacity(0.3),
//                     borderWidth: 2,
//                   ),
//
//                   // 📊 Grade Norm
//                   RadarDataSet(
//                     dataEntries: [
//                       RadarEntry(value: norm["fixation"]!),
//                       RadarEntry(value: norm["regression"]!),
//                       RadarEntry(value: norm["saccade"]!),
//                       RadarEntry(value: norm["blink"]!),
//                     ],
//                     borderColor: Colors.orange,
//                     fillColor: Colors.orange.withOpacity(0.2),
//                     borderWidth: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Legend
//           Row(
//             children: const [
//               Icon(Icons.circle, color: kPurple, size: 10),
//               SizedBox(width: 5),
//               Text("Student"),
//               SizedBox(width: 15),
//               Icon(Icons.circle, color: Colors.orange, size: 10),
//               SizedBox(width: 5),
//               Text("Grade Norm"),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _behaviorItem(String text, {bool isWarning = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: isWarning ? const Color(0xFFFF8F00) : kPurple,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isWarning
//                     ? const Color(0xFFE65100)
//                     : const Color(0xFF2D2D2D),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget behaviorTab() {
//   //   return ListView(
//   //     padding: const EdgeInsets.all(16),
//   //     children: [
//   //       _infoCard(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             _sectionTitle("👀 Reading Behavior"),
//   //             _behaviorItem("Avg Time: ${avgTime().toStringAsFixed(1)}s"),
//   //             if (avgTime() > 25)
//   //               _behaviorItem("Reading speed is slow",
//   //                   isWarning: true),
//   //             if (avgAccuracy() < 70)
//   //               _behaviorItem("Accuracy is low → difficulty",
//   //                   isWarning: true),
//   //           ],
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget behaviorTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//
//         // 🕸 Radar Chart FIRST
//         radarChart(),
//
//         const SizedBox(height: 14),
//
//         _infoCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("👀 Reading Behavior"),
//
//               _behaviorItem("Avg Time: ${avgTime().toStringAsFixed(1)}s"),
//
//               if (avgTime() > 25)
//                 _behaviorItem("Reading speed is slow", isWarning: true),
//
//               if (avgAccuracy() < 70)
//                 _behaviorItem("Accuracy is low → difficulty",
//                     isWarning: true),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // =========================
//   // INSIGHTS TAB (XAI)
//   // =========================
//
//   Widget _insightItem(String text, {bool isRec = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 5),
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: isRec ? const Color(0xFF43A047) : kPurple,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isRec
//                     ? const Color(0xFF2E7D32)
//                     : const Color(0xFF2D2D2D),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget insightTab() {
//     final letters = letterErrors();
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _infoCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("🧠 Insights"),
//               if (letters.containsKey("ම්"))
//                 _insightItem("Difficulty with 'ම්' endings"),
//               if (letters.containsKey("ි"))
//                 _insightItem("Difficulty with vowel 'ි'"),
//             ],
//           ),
//         ),
//         const SizedBox(height: 14),
//         _infoCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _sectionTitle("📚 Recommendations"),
//               _insightItem("Practice reading daily", isRec: true),
//               _insightItem("Focus on weak letters", isRec: true),
//               _insightItem("Improve pronunciation", isRec: true),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // =========================
//   // MAIN BUILD
//   // =========================
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         backgroundColor: kBgStart,
//         body: Center(
//           child: CircularProgressIndicator(color: kPurple),
//         ),
//       );
//     }
//
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         backgroundColor: kBgStart,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [kBgStart, kBgEnd],
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 // ─── Header ───────────────────────────────
//                 Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 12),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back_ios,
//                             color: kPurple, size: 20),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       const Expanded(
//                         child: Text(
//                           '📊 Dashboard',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: kPink,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 48),
//                     ],
//                   ),
//                 ),
//
//                 // ─── Tab Bar ──────────────────────────────
//                 Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 10),
//                   child: TabBar(
//                     indicator: BoxDecoration(
//                       color: kPurple,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     labelColor: Colors.white,
//                     unselectedLabelColor: kPurple,
//                     labelStyle: const TextStyle(
//                         fontWeight: FontWeight.w600, fontSize: 13),
//                     unselectedLabelStyle: const TextStyle(
//                         fontWeight: FontWeight.w500, fontSize: 13),
//                     dividerColor: Colors.transparent,
//                     tabs: const [
//                       Tab(text: "Overview"),
//                       Tab(text: "Errors"),
//                       Tab(text: "Behavior"),
//                       Tab(text: "Insights"),
//                     ],
//                   ),
//                 ),
//
//                 // ─── Content ──────────────────────────────
//                 Expanded(
//                   child: TabBarView(
//                     children: [
//                       overviewTab(),
//                       errorTab(),
//                       behaviorTab(),
//                       insightTab(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

import '../../../config.dart';

class DyslexiaDashboardPage extends StatefulWidget {
  const DyslexiaDashboardPage({super.key});

  @override
  State<DyslexiaDashboardPage> createState() =>
      _DyslexiaDashboardPageState();
}

class _DyslexiaDashboardPageState extends State<DyslexiaDashboardPage>
    with SingleTickerProviderStateMixin {
  List sessions = [];
  bool loading = true;
  String? selectedGrade;
  String? selectedLevel;
  late TabController _tabController;

  // ─── Design Tokens ────────────────────────────────────────────────────────
  static const Color kPurple     = Color(0xFF534AB7);
  static const Color kPurpleLight= Color(0xFFEEEDFE);
  static const Color kTeal       = Color(0xFF1D9E75);
  static const Color kTealLight  = Color(0xFFE1F5EE);
  static const Color kAmber      = Color(0xFFBA7517);
  static const Color kAmberLight = Color(0xFFFAEEDA);
  static const Color kCoral      = Color(0xFFD85A30);
  static const Color kCoralLight = Color(0xFFFAECE7);
  static const Color kRed        = Color(0xFFE24B4A);
  static const Color kRedLight   = Color(0xFFFCEBEB);
  static const Color kBg         = Color(0xFFF7F6FF);
  static const Color kCard       = Colors.white;
  static const Color kBorder     = Color(0xFFEAE8FF);
  static const Color kTextPri    = Color(0xFF1A1A2E);
  static const Color kTextSec    = Color(0xFF888888);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Data Loading ─────────────────────────────────────────────────────────
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");
    final res = await http.get(
      Uri.parse("${Config.baseUrl}/dyslexia/history?user_id=$userId"),
    );
    final data = jsonDecode(res.body);
    setState(() {
      sessions = data["sessions"] ?? [];
      loading = false;
    });
  }

  // ─── Computed Properties ──────────────────────────────────────────────────
  List get filteredSessions => sessions.where((s) {
    final matchGrade =
        selectedGrade == null || s["grade"].toString() == selectedGrade;
    final matchLevel =
        selectedLevel == null || s["level"].toString() == selectedLevel;
    return matchGrade && matchLevel;
  }).toList();

  double get avgAccuracy {
    final d = filteredSessions;
    if (d.isEmpty) return 0;
    return d.map((e) => (e["overall_accuracy"] ?? 0).toDouble()).reduce((a, b) => a + b) / d.length;
  }

  double get maxAccuracy {
    if (sessions.isEmpty) return 0;
    return sessions.map((e) => (e["overall_accuracy"] ?? 0).toDouble()).reduce((a, b) => a > b ? a : b);
  }

  double get minAccuracy {
    if (sessions.isEmpty) return 0;
    return sessions.map((e) => (e["overall_accuracy"] ?? 0).toDouble()).reduce((a, b) => a < b ? a : b);
  }

  double get avgTime {
    final d = filteredSessions;
    if (d.isEmpty) return 0;
    return d.map((e) => (e["total_time_seconds"] ?? 0).toDouble()).reduce((a, b) => a + b) / d.length;
  }

  double get avgWordsPerSecond {
    final d = filteredSessions;
    if (d.isEmpty) return 0;
    return d.map((e) => (e["avg_words_per_second"] ?? 0).toDouble()).reduce((a, b) => a + b) / d.length;
  }

  double get avgWER {
    final d = filteredSessions;
    if (d.isEmpty) return 0;
    return d.map((e) => (e["avg_WER"] ?? 0).toDouble()).reduce((a, b) => a + b) / d.length;
  }

  double get avgCER {
    final d = filteredSessions;
    if (d.isEmpty) return 0;
    return d.map((e) => (e["avg_CER"] ?? 0).toDouble()).reduce((a, b) => a + b) / d.length;
  }

  String get latestRiskLevel {
    if (sessions.isEmpty) return "UNKNOWN";
    final last = sessions.last;
    return (last["dyslexia_assessment"]?["risk_level"] ?? "UNKNOWN").toString().toUpperCase();
  }

  double get latestConfidence {
    if (sessions.isEmpty) return 0;
    return ((sessions.last["dyslexia_assessment"]?["confidence"] ?? 0) * 100).toDouble();
  }

  // Trend slope (linear regression over accuracy)
  double get trendSlope {
    final d = filteredSessions;
    if (d.length < 2) return 0;
    final n = d.length.toDouble();
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (int i = 0; i < d.length; i++) {
      final x = i.toDouble();
      final y = (d[i]["overall_accuracy"] ?? 0).toDouble();
      sumX += x; sumY += y; sumXY += x * y; sumX2 += x * x;
    }
    return (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  }

  Map<String, double> get eyeMetrics {
    final d = filteredSessions;
    if (d.isEmpty) return {"fixation": 0, "regression": 0, "saccade": 0, "blink": 0};
    return {
      "fixation":   d.map((e) => (e["avg_fixation_time"]      ?? 0).toDouble()).reduce((a, b) => a + b) / d.length,
      "regression": d.map((e) => (e["avg_regression_count"]   ?? 0).toDouble()).reduce((a, b) => a + b) / d.length,
      "saccade":    d.map((e) => (e["avg_saccade_count"]       ?? 0).toDouble()).reduce((a, b) => a + b) / d.length,
      "blink":      d.map((e) => (e["avg_blink_rate_per_min"]  ?? 0).toDouble()).reduce((a, b) => a + b) / d.length,
    };
  }

  double _norm(double v, double mn, double mx) =>
      mx == mn ? 0 : ((v - mn) / (mx - mn)) * 100;

  Map<String, double> get normalizedEye {
    final r = eyeMetrics;
    return {
      "fixation":   _norm(r["fixation"]!,   100, 4000),
      "regression": 100 - _norm(r["regression"]!, 0, 20),
      "saccade":    _norm(r["saccade"]!,    0, 30),
      "blink":      _norm(r["blink"]!,      0, 30),
    };
  }

  static const Map<String, double> _gradeNormRaw = {
    "fixation": 2500, "regression": 5, "saccade": 12, "blink": 15,
  };

  Map<String, double> get normalizedGradeNorm => {
    "fixation":   _norm(_gradeNormRaw["fixation"]!,   100, 4000),
    "regression": 100 - _norm(_gradeNormRaw["regression"]!, 0, 20),
    "saccade":    _norm(_gradeNormRaw["saccade"]!,    0, 30),
    "blink":      _norm(_gradeNormRaw["blink"]!,      0, 30),
  };

  Map<String, int> get letterErrors {
    Map<String, int> map = {};
    for (var s in sessions) {
      for (var w in (s["incorrect_words_all"] ?? [])) {
        for (var c in ["්", "ි", "ු", "ම්", "න්", "ෙ", "ා"]) {
          if (w.toString().contains(c)) map[c] = (map[c] ?? 0) + 1;
        }
      }
    }
    return map;
  }

  List<String> get grades =>
      sessions.map((e) => e["grade"].toString()).toSet().toList()..sort();
  List<String> get levels =>
      sessions.map((e) => e["level"].toString()).toSet().toList()..sort();

  // ─── Risk helpers ─────────────────────────────────────────────────────────
  Color _riskColor(String level) {
    switch (level) {
      case "LOW":    return kTeal;
      case "MEDIUM": return kAmber;
      case "HIGH":   return kCoral;
      default:       return kTextSec;
    }
  }

  Color _riskBg(String level) {
    switch (level) {
      case "LOW":    return kTealLight;
      case "MEDIUM": return kAmberLight;
      case "HIGH":   return kCoralLight;
      default:       return kBorder;
    }
  }

  Color _accColor(double v) =>
      v >= 70 ? kTeal : v >= 50 ? kAmber : kCoral;

  // ─── Shared UI Builders ───────────────────────────────────────────────────
  Widget _card({required Widget child, EdgeInsets? padding}) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: kBorder, width: 0.5),
    ),
    child: child,
  );

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kTextPri,
            letterSpacing: -0.2)),
  );

  Widget _kpiCard(String label, String value, Color color, {String? sub}) =>
      Expanded(
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11,
                    color: kTextSec,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -0.5)),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(sub,
                  style: const TextStyle(fontSize: 10, color: kTextSec)),
            ]
          ]),
        ),
      );

  Widget _insightRow(String text,
      {bool isWarning = false, bool isRec = false}) {
    final color = isRec ? kTeal : isWarning ? kCoral : kPurple;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isRec
                      ? const Color(0xFF085041)
                      : isWarning
                      ? const Color(0xFF712B13)
                      : kTextPri)),
        ),
      ]),
    );
  }

  Widget _progressBar(String label, double pct, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: kTextSec)),
        Text("${pct.toStringAsFixed(0)}%",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ]),
      const SizedBox(height: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: pct / 100,
          minHeight: 7,
          backgroundColor: color.withOpacity(0.12),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    ]),
  );

  // ─── Overview Tab ─────────────────────────────────────────────────────────
  Widget _overviewTab() {
    final acc = avgAccuracy;
    final sessions = filteredSessions;

    return ListView(padding: const EdgeInsets.all(14), children: [
      // Filters
      Row(children: [
        Expanded(child: _dropdown("Grade", selectedGrade, grades,
                (v) => setState(() => selectedGrade = v),
            prefix: "Grade ")),
        const SizedBox(width: 8),
        Expanded(child: _dropdown("Level", selectedLevel, levels,
                (v) => setState(() => selectedLevel = v),
            prefix: "Level ")),
        TextButton(
          onPressed: () =>
              setState(() => selectedGrade = selectedLevel = null),
          child: const Text("Reset",
              style: TextStyle(color: kPurple, fontSize: 13)),
        ),
      ]),
      const SizedBox(height: 4),

      // KPI Row 1
      Row(children: [
        _kpiCard("Avg accuracy", "${acc.toStringAsFixed(1)}%",
            _accColor(acc), sub: "filtered"),
        _kpiCard("Best session", "${maxAccuracy.toStringAsFixed(0)}%",
            kTeal, sub: "all time"),
      ]),
      Row(children: [
        _kpiCard("Avg time", "${avgTime.toStringAsFixed(0)}s",
            kAmber, sub: "per session"),
        _kpiCard("Speed", "${avgWordsPerSecond.toStringAsFixed(2)} wps",
            kPurple, sub: "words/sec"),
      ]),
      const SizedBox(height: 4),

      // Accuracy Gauge card
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Accuracy gauge"),
          SizedBox(
            height: 180,
            child: Stack(alignment: Alignment.center, children: [
              PieChart(PieChartData(
                startDegreeOffset: 180,
                sectionsSpace: 0,
                centerSpaceRadius: 62,
                sections: [
                  PieChartSectionData(
                      value: acc,
                      color: _accColor(acc),
                      radius: 20,
                      title: ""),
                  PieChartSectionData(
                      value: 100 - acc,
                      color: const Color(0xFFF0EEF8),
                      radius: 20,
                      title: ""),
                ],
              )),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text("${acc.toStringAsFixed(1)}%",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: _accColor(acc),
                        letterSpacing: -1)),
                const Text("avg accuracy",
                    style: TextStyle(fontSize: 12, color: kTextSec)),
              ]),
            ]),
          ),
          const SizedBox(height: 8),
          // Zone labels
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _zonePill("< 50%", kCoralLight, kCoral),
            _zonePill("50–70%", kAmberLight, kAmber),
            _zonePill("> 70%", kTealLight, kTeal),
          ]),
        ]),
      ),

      // Accuracy Trend
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Accuracy trend"),
          SizedBox(
            height: 200,
            child: sessions.isEmpty
                ? const Center(
                child: Text("No data", style: TextStyle(color: kTextSec)))
                : LineChart(LineChartData(
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "${v.toInt()}%",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ),
                        reservedSize: 36)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "S${(v.toInt() + 1)}",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ))),
              ),
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: sessions.asMap().entries.map((e) => FlSpot(
                    e.key.toDouble(),
                    (e.value["overall_accuracy"] ?? 0).toDouble(),
                  )).toList(),
                  isCurved: true,
                  color: kPurple,
                  barWidth: 2.5,
                  dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) =>
                          FlDotCirclePainter(
                              radius: 3.5,
                              color: kPurple,
                              strokeWidth: 2,
                              strokeColor: Colors.white)),
                  belowBarData: BarAreaData(
                      show: true,
                      color: kPurple.withOpacity(0.07)),
                ),
              ],
            )),
          ),
        ]),
      ),

      // Speed vs Benchmark
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Reading speed vs grade benchmark"),
          SizedBox(
            height: 160,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "${v.toStringAsFixed(1)}",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ),
                        reservedSize: 32)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const labels = ["Student", "Grade norm"];
                          return Text(
                            v.toInt() < labels.length
                                ? labels[v.toInt()]
                                : "",
                            style: const TextStyle(
                                fontSize: 11, color: kTextSec),
                          );
                        })),
              ),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(
                      toY: avgWordsPerSecond,
                      width: 40,
                      color: kPurple,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6))),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(
                      toY: 1.1,
                      width: 40,
                      color: const Color(0xFFD3D1C7),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6))),
                ]),
              ],
            )),
          ),
        ]),
      ),

      // Session history list
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Session history"),
          ...sessions.reversed.take(6).toList().asMap().entries.map((entry) {
            final s = entry.value;
            final acc = (s["overall_accuracy"] ?? 0).toDouble();
            final type = s["session_type"] ?? "diagnostic";
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: kBorder.withOpacity(0.6))),
              ),
              child: Row(children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      color: kPurpleLight, borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      "${sessions.length - entry.key}",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grade ${s["grade"]} · Level ${s["level"]}",
                          style: const TextStyle(
                              fontSize: 12, color: kTextSec),
                        ),
                      ]),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: type == "diagnostic"
                        ? const Color(0xFFE6F1FB)
                        : kTealLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type == "diagnostic" ? "Diagnostic" : "Improvement",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: type == "diagnostic"
                            ? const Color(0xFF0C447C)
                            : const Color(0xFF085041)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${acc.toStringAsFixed(0)}%",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _accColor(acc)),
                ),
              ]),
            );
          }),
        ]),
      ),
    ]);
  }

  Widget _zonePill(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration:
    BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style:
        TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
  );

  Widget _dropdown(String hint, String? value, List<String> items,
      ValueChanged<String?> onChanged,
      {String prefix = ""}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorder, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: const TextStyle(fontSize: 13, color: kTextSec)),
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: kTextPri),
          items: items
              .map((g) => DropdownMenuItem(value: g, child: Text("$prefix$g")))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ─── Errors Tab ───────────────────────────────────────────────────────────
  Widget _errorsTab() {
    final errors = letterErrors;
    final sorted = errors.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(8).toList();
    final total = top.fold<int>(0, (s, e) => s + e.value);

    return ListView(padding: const EdgeInsets.all(14), children: [
      // WER / CER metric cards
      Row(children: [
        _kpiCard("Word error rate", "${avgWER.toStringAsFixed(1)}%", kCoral,
            sub: "lower is better"),
        _kpiCard("Char error rate", "${avgCER.toStringAsFixed(1)}%", kAmber,
            sub: "lower is better"),
      ]),
      const SizedBox(height: 4),

      // Error word bar chart
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Most-missed word patterns"),
          if (top.isEmpty)
            const Text("No error data available",
                style: TextStyle(color: kTextSec, fontSize: 13))
          else
            SizedBox(
              height: (top.length * 38.0) + 20,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.center,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: true,
                  drawHorizontalLine: false,
                  getDrawingVerticalLine: (_) =>
                  const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) => Text(
                            "${v.toInt()}",
                            style: const TextStyle(
                                fontSize: 10, color: kTextSec),
                          ))),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (v, meta) {
                            final idx = v.toInt();
                            if (idx < top.length) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(top[idx].key,
                                    style: const TextStyle(
                                        fontSize: 12, color: kTextPri)),
                              );
                            }
                            return const SizedBox();
                          })),
                ),
                barGroups: top.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: e.value.value.toDouble(),
                        width: 18,
                        color: kPurple.withOpacity(0.7 + e.key * 0.03),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              )),
            ),
        ]),
      ),

      // Error type donut + WER/CER bar
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: _card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("Error types"),
                  SizedBox(
                    height: 180,
                    child: PieChart(PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 38,
                      sections: [
                        PieChartSectionData(
                            value: 38, color: kPurple,      radius: 50, title: "38%", titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                        PieChartSectionData(
                            value: 32, color: kCoral,      radius: 50, title: "32%", titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                        PieChartSectionData(
                            value: 18, color: kAmber,      radius: 50, title: "18%", titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                        PieChartSectionData(
                            value: 12, color: kTeal,       radius: 50, title: "12%", titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    )),
                  ),
                  const SizedBox(height: 8),
                  _legendDot("Omissions", kPurple),
                  _legendDot("Substitutions", kCoral),
                  _legendDot("Reversals", kAmber),
                  _legendDot("Insertions", kTeal),
                ]),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("Error rates"),
                  const SizedBox(height: 8),
                  _progressBar("Word errors", avgWER, kCoral),
                  _progressBar("Char errors", avgCER, kAmber),
                  const SizedBox(height: 8),
                  const Text(
                    "Grade 4–5 benchmark:\nWER < 30% · CER < 15%",
                    style: TextStyle(fontSize: 11, color: kTextSec, height: 1.5),
                  ),
                ]),
          ),
        ),
      ]),

      // Sentence accuracy breakdown
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Sentence accuracy breakdown"),
          ...(() {
            final sess = filteredSessions;
            if (sess.isEmpty) return <Widget>[];
            final last = sess.last;
            final sents = last["sentences"] ?? [];
            return (sents as List).asMap().entries.map<Widget>((e) {
              final acc = (e.value["accuracy"] ?? 0).toDouble();
              return _progressBar("Sentence ${e.key + 1}", acc, _accColor(acc));
            }).toList();
          })(),
        ]),
      ),
    ]);
  }

  Widget _legendDot(String label, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [
      Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(fontSize: 11, color: kTextSec)),
    ]),
  );

  // ─── Behavior Tab ─────────────────────────────────────────────────────────
  Widget _behaviorTab() {
    final eye = eyeMetrics;
    final normStudent = normalizedEye;
    final normGrade   = normalizedGradeNorm;

    final radarLabels = ["Fixation", "Regression\ncontrol", "Saccade\nflow", "Blink rate"];
    final studentVals = [
      normStudent["fixation"]!,
      normStudent["regression"]!,
      normStudent["saccade"]!,
      normStudent["blink"]!,
    ];
    final gradeVals = [
      normGrade["fixation"]!,
      normGrade["regression"]!,
      normGrade["saccade"]!,
      normGrade["blink"]!,
    ];

    return ListView(padding: const EdgeInsets.all(14), children: [
      // Eye metric KPI cards
      Row(children: [
        _kpiCard("Fixation", "${eye["fixation"]!.toStringAsFixed(0)}ms",
            kPurple, sub: "avg per word"),
        _kpiCard("Regressions", eye["regression"]!.toStringAsFixed(1),
            kCoral, sub: "per sentence"),
      ]),
      Row(children: [
        _kpiCard("Saccades", eye["saccade"]!.toStringAsFixed(1),
            kTeal, sub: "per sentence"),
        _kpiCard("Blink rate", eye["blink"]!.toStringAsFixed(0),
            kAmber, sub: "per minute"),
      ]),
      const SizedBox(height: 4),

      // Radar Chart
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Eye-tracking radar"),
          SizedBox(
            height: 280,
            child: RadarChart(RadarChartData(
              radarBorderData: const BorderSide(color: Colors.transparent),
              titlePositionPercentageOffset: 0.25,
              getTitle: (index, angle) =>
                  RadarChartTitle(text: radarLabels[index], angle: 0),
              dataSets: [
                RadarDataSet(
                  dataEntries: studentVals
                      .map((v) => RadarEntry(value: v))
                      .toList(),
                  borderColor: kPurple,
                  fillColor: kPurple.withOpacity(0.2),
                  borderWidth: 2,
                  entryRadius: 3,
                ),
                RadarDataSet(
                  dataEntries: gradeVals
                      .map((v) => RadarEntry(value: v))
                      .toList(),
                  borderColor: kAmber,
                  fillColor: kAmber.withOpacity(0.15),
                  borderWidth: 2,
                  entryRadius: 3,
                ),
              ],
            )),
          ),
          const SizedBox(height: 8),
          Row(children: [
            _legendDot("Student", kPurple),
            const SizedBox(width: 16),
            _legendDot("Grade norm", kAmber),
          ]),
        ]),
      ),

      // Consistency chart
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Session consistency"),
          SizedBox(
            height: 180,
            child: filteredSessions.isEmpty
                ? const Center(
                child: Text("No data", style: TextStyle(color: kTextSec)))
                : BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "${v.toInt()}%",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ),
                        reservedSize: 32)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "S${v.toInt() + 1}",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ))),
              ),
              barGroups: filteredSessions.asMap().entries.map((e) {
                final acc =
                (e.value["overall_accuracy"] ?? 0).toDouble();
                final std =
                (e.value["sentence_accuracy_std_dev"] ?? 0).toDouble();
                return BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(
                      toY: acc,
                      width: 16,
                      color: kPurple.withOpacity(0.75),
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4))),
                  BarChartRodData(
                      toY: std,
                      width: 8,
                      color: kCoral.withOpacity(0.4),
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4))),
                ]);
              }).toList(),
            )),
          ),
          const SizedBox(height: 6),
          Row(children: [
            _legendDot("Accuracy", kPurple),
            const SizedBox(width: 14),
            _legendDot("Std deviation", kCoral),
          ]),
        ]),
      ),

      // Scatter: Time vs Accuracy
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Time vs accuracy"),
          SizedBox(
            height: 200,
            child: filteredSessions.isEmpty
                ? const Center(
                child: Text("No data", style: TextStyle(color: kTextSec)))
                : ScatterChart(ScatterChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
                getDrawingVerticalLine: (_) =>
                const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "${v.toInt()}%",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ),
                        reservedSize: 32)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "${v.toInt()}s",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ))),
              ),
              scatterSpots: filteredSessions.map((s) {
                final acc = (s["overall_accuracy"] ?? 0).toDouble();
                final time =
                (s["total_time_seconds"] ?? 0).toDouble();
                return ScatterSpot(time, acc,
                    dotPainter: FlDotCirclePainter(
                        radius: 5,
                        color: kPurple.withOpacity(0.75),
                        strokeWidth: 1.5,
                        strokeColor: Colors.white));
              }).toList(),
            )),
          ),
          const SizedBox(height: 4),
          const Text(
            "Each dot = one session. Shorter time + higher accuracy = ideal.",
            style: TextStyle(fontSize: 11, color: kTextSec),
          ),
        ]),
      ),

      // Reading behavior summary
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Reading behavior summary"),
          if (avgTime > 25)
            _insightRow("Reading speed is slow (${avgTime.toStringAsFixed(0)}s avg). Grade norm < 25s.",
                isWarning: true),
          if (avgAccuracy < 70)
            _insightRow("Accuracy below target (${avgAccuracy.toStringAsFixed(1)}%). Work toward 70%+.",
                isWarning: true),
          if (eye["regression"]! > 1.5)
            _insightRow("High regression count (${eye["regression"]!.toStringAsFixed(1)}) — frequent backtracking detected.",
                isWarning: true),
          if (eye["blink"]! == 0)
            _insightRow("Zero blink rate detected. Sensor calibration recommended.",
                isWarning: true),
          if (avgAccuracy >= 70)
            _insightRow("Accuracy is on track. Keep up the practice!"),
        ]),
      ),
    ]);
  }

  // ─── Insights Tab ─────────────────────────────────────────────────────────
  Widget _insightsTab() {
    final slope = trendSlope;
    final sessionsToTarget = slope > 0
        ? ((70 - avgAccuracy) / slope).ceil()
        : null;

    return ListView(padding: const EdgeInsets.all(14), children: [
      // Risk + confidence cards
      Row(children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _riskBg(latestRiskLevel),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              Text("Dyslexia risk",
                  style:
                  TextStyle(fontSize: 11, color: _riskColor(latestRiskLevel).withOpacity(0.7))),
              const SizedBox(height: 6),
              Text(latestRiskLevel,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _riskColor(latestRiskLevel))),
              const SizedBox(height: 2),
              Text("Random Forest",
                  style: TextStyle(
                      fontSize: 10,
                      color: _riskColor(latestRiskLevel).withOpacity(0.6))),
            ]),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kPurpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              const Text("ML confidence",
                  style: TextStyle(fontSize: 11, color: Color(0xFF534AB7))),
              const SizedBox(height: 6),
              Text("${latestConfidence.toStringAsFixed(0)}%",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kPurple)),
              const SizedBox(height: 2),
              const Text("latest session",
                  style: TextStyle(fontSize: 10, color: Color(0xFF7F77DD))),
            ]),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: slope >= 0 ? kTealLight : kCoralLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              const Text("Trend/session",
                  style: TextStyle(fontSize: 11, color: kTextSec)),
              const SizedBox(height: 6),
              Text("${slope >= 0 ? "+" : ""}${slope.toStringAsFixed(1)}%",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: slope >= 0 ? kTeal : kCoral)),
              const SizedBox(height: 2),
              Text(slope >= 0 ? "improving" : "declining",
                  style: TextStyle(
                      fontSize: 10,
                      color: slope >= 0
                          ? const Color(0xFF085041)
                          : const Color(0xFF712B13))),
            ]),
          ),
        ),
      ]),
      const SizedBox(height: 4),

      // Forecast chart
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Accuracy forecast"),
          SizedBox(
            height: 200,
            child: filteredSessions.isEmpty
                ? const Center(
                child: Text("Not enough data",
                    style: TextStyle(color: kTextSec)))
                : LineChart(LineChartData(
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFFF0EEF8), strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "${v.toInt()}%",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ),
                        reservedSize: 36)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          "S${v.toInt() + 1}",
                          style: const TextStyle(
                              fontSize: 10, color: kTextSec),
                        ))),
              ),
              minY: 0,
              maxY: 100,
              lineBarsData: [
                // Actual data
                LineChartBarData(
                  spots: filteredSessions.asMap().entries.map((e) => FlSpot(
                    e.key.toDouble(),
                    (e.value["overall_accuracy"] ?? 0).toDouble(),
                  )).toList(),
                  isCurved: true,
                  color: kPurple,
                  barWidth: 2.5,
                  dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) =>
                          FlDotCirclePainter(
                              radius: 3,
                              color: kPurple,
                              strokeWidth: 2,
                              strokeColor: Colors.white)),
                  belowBarData: BarAreaData(
                      show: true,
                      color: kPurple.withOpacity(0.07)),
                ),
                // Forecast (4 sessions ahead)
                LineChartBarData(
                  spots: () {
                    final n = filteredSessions.length;
                    final last = (filteredSessions.last["overall_accuracy"] ?? 0).toDouble();
                    return List.generate(5, (i) {
                      final x = (n - 1 + i).toDouble();
                      final y = (last + slope * i).clamp(0.0, 100.0);
                      return FlSpot(x, y);
                    });
                  }(),
                  isCurved: true,
                  color: kTeal,
                  barWidth: 2,
                  dashArray: [5, 4],
                  dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, i) => i == 0
                          ? FlDotCirclePainter(radius: 0, color: Colors.transparent)
                          : FlDotCirclePainter(
                          radius: 3,
                          color: kTeal,
                          strokeWidth: 2,
                          strokeColor: Colors.white)),
                  belowBarData: BarAreaData(
                      show: true,
                      color: kTeal.withOpacity(0.05)),
                ),
              ],
            )),
          ),
          const SizedBox(height: 8),
          Row(children: [
            _legendDot("Actual", kPurple),
            const SizedBox(width: 14),
            _legendDot("Forecast", kTeal),
          ]),
          if (sessionsToTarget != null && sessionsToTarget > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: kTealLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.trending_up_rounded,
                    color: kTeal, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "At the current pace (+${slope.toStringAsFixed(1)}%/session), "
                        "the 70% target can be reached in ~$sessionsToTarget more sessions.",
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF085041),
                        height: 1.5),
                  ),
                ),
              ]),
            ),
          ],
        ]),
      ),

      // Key observations
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Key observations"),
          _insightRow(
              "Fixation time is ${eyeMetrics["fixation"]!.toStringAsFixed(0)}ms — "
                  "${eyeMetrics["fixation"]! > 2500 ? "above" : "within"} grade norm (2500ms).",
              isWarning: eyeMetrics["fixation"]! > 2500),
          _insightRow(
              "Regression count ${eyeMetrics["regression"]!.toStringAsFixed(1)} — "
                  "${eyeMetrics["regression"]! > 1.5 ? "high backtracking detected" : "within normal range"}.",
              isWarning: eyeMetrics["regression"]! > 1.5),
          _insightRow(
              "Avg accuracy ${avgAccuracy.toStringAsFixed(1)}% with ${filteredSessions.length} sessions recorded."),
          if (eyeMetrics["blink"]! == 0)
            _insightRow(
                "Blink rate is zero — sensor calibration check recommended.",
                isWarning: true),
          if (trendSlope > 0)
            _insightRow(
                "Positive improvement trend detected. Student is consistently progressing."),
        ]),
      ),

      // Recommendations
      _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _sectionLabel("Recommendations"),
          _insightRow(
              "Practice daily 10-min Sinhala phoneme drills focusing on ම්, ි, ු vowel clusters.",
              isRec: true),
          _insightRow(
              "Use spaced repetition for the most-missed words shown in the Errors tab.",
              isRec: true),
          _insightRow(
              "Schedule a diagnostic session every 5 improvement sessions to reassess risk.",
              isRec: true),
          if (eyeMetrics["regression"]! > 1.5)
            _insightRow(
                "Try guided reading exercises to reduce backward eye movements.",
                isRec: true),
          if (eyeMetrics["blink"]! == 0)
            _insightRow(
                "Verify eye-tracking sensor calibration before next session.",
                isRec: true),
        ]),
      ),
    ]);
  }

  // ─── Risk Banner ──────────────────────────────────────────────────────────
  Widget _riskBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _riskBg(latestRiskLevel),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _riskColor(latestRiskLevel).withOpacity(0.25)),
      ),
      child: Row(children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: _riskColor(latestRiskLevel), shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          "$latestRiskLevel RISK",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _riskColor(latestRiskLevel)),
        ),
        const SizedBox(width: 8),
        Text(
          "· ${latestConfidence.toStringAsFixed(0)}% confidence · Machine Learning",
          style: TextStyle(
              fontSize: 12,
              color: _riskColor(latestRiskLevel).withOpacity(0.7)),
        ),
        const Spacer(),
        Icon(Icons.info_outline_rounded,
            size: 16, color: _riskColor(latestRiskLevel).withOpacity(0.5)),
      ]),
    );
  }

  // ─── Main Build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: kBg,
        body: Center(
            child: CircularProgressIndicator(color: kPurple, strokeWidth: 2)),
      );
    }

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            color: Colors.white,
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: kPurple, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'My Dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: kTextPri,
                      letterSpacing: -0.3),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: kPurple, size: 20),
                onPressed: loadData,
              ),
            ]),
          ),

          // Risk Banner (always visible)
          _riskBanner(),

          // Tab Bar
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 10),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                  color: kPurple,
                  borderRadius: BorderRadius.circular(20)),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: kPurple,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 12),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Errors"),
                Tab(text: "Behavior"),
                Tab(text: "Insights"),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _overviewTab(),
                _errorsTab(),
                _behaviorTab(),
                _insightsTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}