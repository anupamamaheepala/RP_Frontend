import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/config.dart';
import '/profile.dart';
import 'dart:math' as math;

class DyscalDashboardInstructionsPage extends StatefulWidget {
  const DyscalDashboardInstructionsPage({super.key});

  @override
  State<DyscalDashboardInstructionsPage> createState() => _DyscalDashboardInstructionsPageState();
}

class _DyscalDashboardInstructionsPageState extends State<DyscalDashboardInstructionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  String _errorMessage = "";
  int _selectedGrade = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        if (mounted) {
          setState(() {
            _errorMessage = "පරිශීලකයා හඳුනාගත නොහැක.";
            _isLoading = false;
          });
        }
        return;
      }

      final url = Uri.parse("${Config.baseUrl}/dashboard/$userId/$_selectedGrade");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _dashboardData = data;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = "දත්ත ලබාගැනීමට නොහැකි විය.";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "සම්බන්ධතා දෝෂයකි.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'ප්‍රතිඵල පුවරුව',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Grade Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                color: Colors.white.withOpacity(0.5),
                child: Row(
                  children: [
                    const Text("ශ්‍රේණිය:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: _selectedGrade,
                      items: [3, 4, 5, 6, 7].map((grade) {
                        return DropdownMenuItem(
                          value: grade,
                          child: Text("Grade $grade", style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGrade = value);
                          _fetchDashboardData();
                        }
                      },
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                    : _errorMessage.isNotEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 50),
                      const SizedBox(height: 15),
                      Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _fetchDashboardData,
                        child: const Text("නැවත උත්සාහ කරන්න"),
                      ),
                    ],
                  ),
                )
                    : _dashboardData == null
                    ? const Center(child: Text("දත්ත නොමැත"))
                    : _buildDashboardContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    final riskLevel = _dashboardData!['risk_level'] ?? {};
    final quickStats = _dashboardData!['quick_stats'] ?? {};
    final overview = _dashboardData!['overview'] ?? {};
    final errors = _dashboardData!['errors'] ?? {};
    final behavior = _dashboardData!['behavior'] ?? {};
    final insights = _dashboardData!['insights'] ?? {};

    return Column(
      children: [
        // Risk Banner
        _buildRiskBanner(riskLevel),

        // Quick Stats Cards
        _buildQuickStatsRow(quickStats),

        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
              _buildOverviewTab(overview),
              _buildErrorsTab(errors),
              _buildBehaviorTab(behavior),
              _buildInsightsTab(insights),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== RISK BANNER ====================

  Widget _buildRiskBanner(Map<String, dynamic> riskLevel) {
    String level = riskLevel['level'] ?? "Unknown";
    int confidence = riskLevel['confidence'] ?? 0;
    Color bannerColor;
    IconData bannerIcon;

    if (level == "No Dyscalculia") {
      bannerColor = Colors.green;
      bannerIcon = Icons.check_circle_outline;
    } else if (level == "Mild Dyscalculia") {
      bannerColor = Colors.orange;
      bannerIcon = Icons.warning_amber_rounded;
    } else {
      bannerColor = Colors.red;
      bannerIcon = Icons.error_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bannerColor.withOpacity(0.7), bannerColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: bannerColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(bannerIcon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$confidence% confidence · Machine Learning",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== QUICK STATS ====================

  Widget _buildQuickStatsRow(Map<String, dynamic> stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Expanded(child: _buildQuickStatCard("Accuracy", "${stats['overall_accuracy'] ?? 0}%", Icons.grade_rounded, Colors.blue)),
          const SizedBox(width: 10),
          Expanded(child: _buildQuickStatCard("Tasks", "${stats['total_tasks'] ?? 0}", Icons.assignment_rounded, Colors.green)),
          const SizedBox(width: 10),
          Expanded(child: _buildQuickStatCard("Time", _formatTime(stats['total_time_spent'] ?? 0), Icons.timer_rounded, Colors.orange)),
          const SizedBox(width: 10),
          Expanded(child: _buildQuickStatCard("Level", (stats['current_level'] ?? "N/A").toString().toUpperCase(), Icons.trending_up_rounded, Colors.purple)),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==================== TAB 1: OVERVIEW ====================

  Widget _buildOverviewTab(Map<String, dynamic> overview) {
    List<dynamic> journey = overview['learning_journey'] ?? [];
    List<dynamic> markers = overview['special_task_markers'] ?? [];
    int improvementRate = overview['improvement_rate'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Learning Journey Chart
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Learning Journey", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  child: journey.isEmpty
                      ? const Center(child: Text("No data yet"))
                      : _buildJourneyChart(journey, markers),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  "Improvement Rate",
                  "$improvementRate%",
                  improvementRate > 0 ? Icons.trending_up : Icons.trending_down,
                  improvementRate > 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  "Total Sessions",
                  "${journey.length}",
                  Icons.layers_rounded,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  "Special Evaluations",
                  "${markers.length}",
                  Icons.analytics_rounded,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  "Current Streak",
                  _calculateStreak(journey),
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyChart(List<dynamic> journey, List<dynamic> markers) {
    return CustomPaint(
      painter: _JourneyChartPainter(journey, markers),
      size: const Size(double.infinity, 200),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  String _calculateStreak(List<dynamic> journey) {
    // Simple streak calculation based on accuracy
    if (journey.isEmpty) return "0";
    int streak = 0;
    for (int i = journey.length - 1; i >= 0; i--) {
      int accuracy = journey[i]['accuracy'] ?? 0;
      if (accuracy >= 4) {
        streak++;
      } else {
        break;
      }
    }
    return "$streak";
  }

  // ==================== TAB 2: ERRORS ====================

  Widget _buildErrorsTab(Map<String, dynamic> errors) {
    List<dynamic> perSession = errors['per_session'] ?? [];
    Map<String, dynamic> totals = errors['totals'] ?? {};
    String trend = errors['trend'] ?? "stable";
    int trendPercentage = errors['trend_percentage'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Trend Card
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: trend == "decreasing" ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  trend == "decreasing" ? Icons.trending_down : Icons.trending_up,
                  color: trend == "decreasing" ? Colors.green : Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    trend == "decreasing"
                        ? "Errors decreased by $trendPercentage% in recent sessions"
                        : "Errors increased by $trendPercentage% - needs attention",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: trend == "decreasing" ? Colors.green.shade700 : Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Error Bar Chart (Simplified)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Wrong Answers Per Session", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                SizedBox(
                  height: 180,
                  child: perSession.isEmpty
                      ? const Center(child: Text("No data yet"))
                      : _buildErrorBarChart(perSession),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Error Stats Cards
          Row(
            children: [
              _buildErrorStatCard("Total Wrong", "${totals['total_wrong'] ?? 0}", Colors.red),
              const SizedBox(width: 10),
              _buildErrorStatCard("Retries", "${totals['total_retries'] ?? 0}", Colors.orange),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildErrorStatCard("Skipped", "${totals['total_skipped'] ?? 0}", Colors.grey),
              const SizedBox(width: 10),
              _buildErrorStatCard("Challenging", errors['most_challenging_level'] ?? "N/A", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBarChart(List<dynamic> perSession) {
    return CustomPaint(
      painter: _ErrorBarChartPainter(perSession),
      size: const Size(double.infinity, 180),
    );
  }

  Widget _buildErrorStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.1), blurRadius: 5),
          ],
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 3: BEHAVIOR ====================

  Widget _buildBehaviorTab(Map<String, dynamic> behavior) {
    Map<String, dynamic> averages = behavior['averages'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Response Time Chart
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Response Time Trend", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: _buildBehaviorLineChart(behavior['response_time_trend'] ?? [], Colors.blue, "s"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Hesitation Time Chart
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hesitation Time Trend", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: _buildBehaviorLineChart(behavior['hesitation_trend'] ?? [], Colors.orange, "s"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Behavior Summary Cards
          Row(
            children: [
              _buildErrorStatCard("Avg Response", "${(averages['avg_response_time'] ?? 0).toStringAsFixed(1)}s", Colors.blue),
              const SizedBox(width: 10),
              _buildErrorStatCard("Avg Hesitation", "${(averages['avg_hesitation'] ?? 0).toStringAsFixed(1)}s", Colors.orange),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildErrorStatCard("Backtracks", "${averages['total_backtracks'] ?? 0}", Colors.brown),
              const SizedBox(width: 10),
              _buildErrorStatCard("Sessions", "${(behavior['session_duration'] ?? []).length}", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorLineChart(List<dynamic> data, Color color, String unit) {
    return CustomPaint(
      painter: _BehaviorLineChartPainter(data, color),
      size: const Size(double.infinity, 150),
    );
  }

  // ==================== TAB 4: INSIGHTS ====================

  Widget _buildInsightsTab(Map<String, dynamic> insights) {
    Map<String, dynamic> radarData = insights['radar_data'] ?? {};
    Map<String, dynamic> prediction = insights['prediction'] ?? {};
    List<dynamic> strengths = insights['strengths'] ?? [];
    List<dynamic> weaknesses = insights['weaknesses'] ?? [];
    List<dynamic> recommendations = insights['recommendations'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radar Chart Placeholder
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Skill Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  child: _buildRadarChart(radarData),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // AI Prediction Card
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade100, Colors.blue.shade100],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.purple, size: 24),
                    SizedBox(width: 8),
                    Text("AI Prediction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Trend: ${prediction['trend'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Predicted Risk: ${prediction['predicted_risk'] ?? 'N/A'}",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "Confidence: ${prediction['confidence'] ?? 0}%",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Strengths & Weaknesses
          if (strengths.isNotEmpty) ...[
            const Text("💪 Strengths", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...strengths.map((s) => _buildBulletCard(s.toString(), Colors.green)),
            const SizedBox(height: 10),
          ],
          if (weaknesses.isNotEmpty) ...[
            const Text("🎯 Areas to Improve", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...weaknesses.map((w) => _buildBulletCard(w.toString(), Colors.orange)),
            const SizedBox(height: 10),
          ],

          // Recommendations
          if (recommendations.isNotEmpty) ...[
            const Text("💡 Recommendations", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...recommendations.asMap().entries.map((entry) => _buildRecommendationCard(entry.value.toString(), entry.key + 1)),
          ],
        ],
      ),
    );
  }

  Widget _buildRadarChart(Map<String, dynamic> data) {
    return CustomPaint(
      painter: _RadarChartPainter(data),
      size: const Size(double.infinity, 200),
    );
  }

  Widget _buildBulletCard(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 10),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String text, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text("$index", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 12))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  String _formatTime(dynamic totalSeconds) {
    double seconds = (totalSeconds ?? 0).toDouble();
    if (seconds < 60) return "${seconds.toInt()}s";
    if (seconds < 3600) return "${(seconds / 60).toStringAsFixed(1)}m";
    return "${(seconds / 3600).toStringAsFixed(1)}h";
  }
}

// ==================== CUSTOM PAINTERS ====================

class _JourneyChartPainter extends CustomPainter {
  final List<dynamic> journey;
  final List<dynamic> markers;

  _JourneyChartPainter(this.journey, this.markers);

  @override
  void paint(Canvas canvas, Size size) {
    if (journey.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final dotPaint = Paint()..style = PaintingStyle.fill;

    double maxX = (journey.length - 1).toDouble();
    if (maxX == 0) maxX = 1;
    double maxY = 5.0;

    double leftPadding = 30;
    double bottomPadding = 25;
    double chartWidth = size.width - leftPadding - 10;
    double chartHeight = size.height - bottomPadding - 10;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 5; i++) {
      double y = 10 + (chartHeight * (1 - i / maxY));
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width - 10, y), gridPaint);
    }

    // Draw line path
    final path = Path();
    for (int i = 0; i < journey.length; i++) {
      double x = leftPadding + (chartWidth * (i / maxX));
      double y = 10 + (chartHeight * (1 - (journey[i]['accuracy'] ?? 0) / maxY));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw line
    linePaint.color = Colors.purple;
    canvas.drawPath(path, linePaint);

    // Draw dots
    for (int i = 0; i < journey.length; i++) {
      double x = leftPadding + (chartWidth * (i / maxX));
      double y = 10 + (chartHeight * (1 - (journey[i]['accuracy'] ?? 0) / maxY));
      String action = journey[i]['action'] ?? 'Stay';

      if (action == 'Promote') {
        dotPaint.color = Colors.green;
      } else if (action == 'Regress') {
        dotPaint.color = Colors.orange;
      } else {
        dotPaint.color = Colors.blue;
      }

      canvas.drawCircle(Offset(x, y), 6, dotPaint);
      canvas.drawCircle(Offset(x, y), 8, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    // Draw special task markers
    for (var marker in markers) {
      int session = (marker is int) ? marker : (marker['session'] ?? 0);
      if (session > 0 && session <= journey.length) {
        double x = leftPadding + (chartWidth * ((session - 1) / maxX));
        final markerPaint = Paint()
          ..color = Colors.red.withOpacity(0.15)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(x - 8, 10, 16, chartHeight), markerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ErrorBarChartPainter extends CustomPainter {
  final List<dynamic> data;

  _ErrorBarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double maxY = 0;
    for (var d in data) {
      int wrong = d['wrong'] ?? 0;
      if (wrong > maxY) maxY = wrong.toDouble();
    }
    if (maxY == 0) maxY = 5;

    double barWidth = (size.width - 40) / data.length - 8;
    // Ensure minimum bar width
    if (barWidth < 10) barWidth = 10;

    for (int i = 0; i < data.length; i++) {
      int wrong = data[i]['wrong'] ?? 0;
      double x = 20 + i * ((size.width - 40) / data.length) + 4;
      double height = (wrong / maxY) * (size.height - 30);
      double y = size.height - height - 20;

      // FIX: Use proper color interpolation
      double ratio = wrong / 5.0;
      if (ratio > 1.0) ratio = 1.0;

      final paint = Paint()
        ..color = Color.fromARGB(
          255,
          (255 * ratio).round(),
          (165 + (90 * (1 - ratio))).round(),
          0,
        )
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x, y, barWidth, height),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        paint,
      );

      // Draw value on top
      final textPainter = TextPainter(
        text: TextSpan(
          text: "$wrong",
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + barWidth / 2 - textPainter.width / 2, y - 15));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BehaviorLineChartPainter extends CustomPainter {
  final List<dynamic> data;
  final Color color;

  _BehaviorLineChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double maxY = 0;
    for (var d in data) {
      double val = (d['avg_time'] ?? d['avg_hesitation'] ?? 0).toDouble();
      if (val > maxY) maxY = val;
    }
    if (maxY == 0) maxY = 10;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      double val = (data[i]['avg_time'] ?? data[i]['avg_hesitation'] ?? 0).toDouble();
      double x = 30 + (size.width - 40) * (i / (data.length - 1));
      double y = 10 + (size.height - 30) * (1 - val / maxY);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, Paint()..color = color..style = PaintingStyle.fill);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _RadarChartPainter extends CustomPainter {
  final Map<String, dynamic> data;

  _RadarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = math.min(centerX, centerY) - 30;

    List<String> labels = data.keys.toList();
    // FIX: Cast dynamic values to double properly
    List<double> values = data.values.map((v) {
      if (v is int) return v.toDouble();
      if (v is double) return v;
      return 0.0;
    }).toList();
    int n = labels.length;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.purple.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw grid
    for (int level = 1; level <= 5; level++) {
      final path = Path();
      double r = radius * level / 5;
      for (int i = 0; i < n; i++) {
        double angle = -math.pi / 2 + 2 * math.pi * i / n;
        double x = centerX + r * math.cos(angle);
        double y = centerY + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axes
    for (int i = 0; i < n; i++) {
      double angle = -math.pi / 2 + 2 * math.pi * i / n;
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(centerX + radius * math.cos(angle), centerY + radius * math.sin(angle)),
        gridPaint,
      );
    }

    // Draw data polygon
    final dataPath = Path();
    for (int i = 0; i < n; i++) {
      double angle = -math.pi / 2 + 2 * math.pi * i / n;
      double r = radius * values[i] / 100;
      double x = centerX + r * math.cos(angle);
      double y = centerY + r * math.sin(angle);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    // Draw dots at data points
    final dotPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;
    for (int i = 0; i < n; i++) {
      double angle = -math.pi / 2 + 2 * math.pi * i / n;
      double r = radius * values[i] / 100;
      double x = centerX + r * math.cos(angle);
      double y = centerY + r * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    // Draw labels
    for (int i = 0; i < n; i++) {
      double angle = -math.pi / 2 + 2 * math.pi * i / n;
      double x = centerX + (radius + 25) * math.cos(angle);
      double y = centerY + (radius + 25) * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}