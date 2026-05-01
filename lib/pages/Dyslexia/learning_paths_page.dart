import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'Core/module_resolver.dart';
import 'module_activity_page.dart';

class LearningPathsPage extends StatefulWidget {
  final int grade;
  final int level;

  const LearningPathsPage({
    super.key,
    required this.grade,
    required this.level,
  });

  @override
  State<LearningPathsPage> createState() => _LearningPathsPageState();
}

class _LearningPathsPageState extends State<LearningPathsPage>
    with SingleTickerProviderStateMixin {

  bool _loading = true;
  bool _eligible = false;
  String? _riskLevel;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fetchAssignedLearningPath();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchAssignedLearningPath() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    final url = Uri.parse(
        "${Config.baseUrl}/learning/get-assigned-learning-path"
            "?user_id=$userId"
            "&grade=${widget.grade}"
            "&level=${widget.level}");

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data["ok"] == true && data["eligible"] == true) {
      setState(() {
        _eligible  = true;
        _riskLevel = data["risk_level"];
        _loading   = false;
      });
    } else {
      setState(() {
        _eligible = false;
        _loading  = false;
      });
    }
  }

  String _normalizeRisk(String raw) {
    final r = raw.toUpperCase();
    if (r.contains("HIGH")) return "HIGH";
    if (r.contains("MODERATE") || r.contains("MEDIUM")) return "MEDIUM";
    if (r.contains("LOW")) return "LOW";
    return "LOW";
  }

  // ── Risk helpers ───────────────────────────────────────────
  Color _riskColor(String risk) {
    switch (risk) {
      case "HIGH":   return const Color(0xFFEF4444);
      case "MEDIUM": return const Color(0xFFFBBF24);
      default:       return const Color(0xFF22C55E);
    }
  }

  Color _riskTextColor(String risk) {
    return risk == "MEDIUM"
        ? const Color(0xFF92400E)
        : Colors.white;
  }

  String _riskLabel(String risk) {
    switch (risk) {
      case "HIGH":   return "High Risk";
      case "MEDIUM": return "Medium Risk";
      default:       return "Low Risk";
    }
  }

  String _riskEmoji(String risk) {
    switch (risk) {
      case "HIGH":   return "🔴";
      case "MEDIUM": return "🟡";
      default:       return "🟢";
    }
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loading) return _buildLoading();

    if (!_eligible) return _buildNotEligible();

    final normalizedRisk = _normalizeRisk(_riskLevel!);

    final module = ModuleResolver.resolveModule(
      grade: widget.grade,
      level: widget.level,
      risk: normalizedRisk,
    );

    if (module == null) return _buildNoModule(normalizedRisk);

    return module;
  }

  // ── Loading screen ─────────────────────────────────────────
  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnim,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text("📚", style: TextStyle(fontSize: 42)),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              "ඔබේ ඉගෙනුම් මාර්ගය පූරණය කරමින්...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "ශ්‍රේණිය ${_gradeStr()} · ක්‍රියාකාරකම් සූදානම් කිරීම",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  minHeight: 5,
                  backgroundColor: Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Not eligible screen ────────────────────────────────────
  Widget _buildNotEligible() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: _appBar("ශ්‍රේණිය ${_gradeStr()} · මට්ටම ${widget.level} "),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            children: [
              // Illustration
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: const Color(0xFFFDE68A), width: 2),
                ),
                child: const Center(
                  child: Text("🔒", style: TextStyle(fontSize: 52)),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                "පළමුව කියවීමේ කාර්යය සම්පූර්ණ කරන්න",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // Text(
              //   "Grade ${_gradeStr()} · Level ${widget.level}",
              //   style: const TextStyle(
              //     fontSize: 13,
              //     color: Color(0xFF9CA3AF),
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFFDE68A), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("💡", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "මෙම ශ්‍රේණිය සහ මට්ටම සඳහා පළමුව කියවීමේ "
                                "කාර්යය සම්පූර්ණ කරන්න.",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF92400E),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFFDE68A)),
                    const SizedBox(height: 10),
                    const Text(
                      "ඉගෙනුම් ක්‍රියාකාරකම් වෙත ප්‍රවේශ වීමට පෙර ඔබ මෙම ශ්‍රේණිය සහ මට්ටම සඳහා කියවීමේ තක්සේරුව සම්පූර්ණ කළ යුතුය.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.arrow_back_rounded, size: 20),
                      SizedBox(width: 8),
                      Text("ආපසු යන්න",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── No module found screen ─────────────────────────────────
  Widget _buildNoModule(String risk) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: _appBar("Learning Paths"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            children: [
              // Risk badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _riskColor(risk),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_riskEmoji(risk),
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    _riskLabel(risk),
                    style: TextStyle(
                      color: _riskTextColor(risk),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // Illustration
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: const Color(0xFFBAE6FD), width: 2),
                ),
                child: const Center(
                  child: Text("🚧", style: TextStyle(fontSize: 52)),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Coming Soon!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),

              // Text(
              //   "Grade ${_gradeStr()} · Level ${widget.level} · ${_riskLabel(risk)}",
              //   style: const TextStyle(
              //     fontSize: 13,
              //     color: Color(0xFF9CA3AF),
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFBAE6FD), width: 1.5),
                ),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("📋", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "මෙම ශ්‍රේණිය, මට්ටම සහ අවදානම සඳහා ඉගෙනුම් "
                              "මාර්ගය තවමත් ක්‍රියාත්මක කර නොමැත.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0369A1),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xFFBAE6FD)),
                  const SizedBox(height: 8),
                  const Text(
                    "The learning module for this combination is being "
                        "prepared. Check back soon!",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.arrow_back_rounded, size: 20),
                      SizedBox(width: 8),
                      Text("Go Back",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Shared AppBar ──────────────────────────────────────────
  PreferredSizeWidget _appBar(String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: Colors.black87, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E))),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(children: [
            _gradeBadge(),
            const SizedBox(width: 6),
            _levelBadge(),
          ]),
        ),
      ],
    );
  }

  Widget _gradeBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF4A90D9),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      "Grade ${_gradeStr()}",
      style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700),
    ),
  );

  Widget _levelBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF6B7280), width: 1.5),
    ),
    child: Text(
      "Level ${widget.level}",
      style: const TextStyle(
          color: Color(0xFF374151),
          fontSize: 11,
          fontWeight: FontWeight.w700),
    ),
  );

  String _gradeStr() => widget.grade.toString();
}