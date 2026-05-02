import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/config.dart';
import '/profile.dart';

class DyscalImproveResultAllPage extends StatefulWidget {
  const DyscalImproveResultAllPage({super.key});

  @override
  State<DyscalImproveResultAllPage> createState() => _DyscalImproveResultAllPageState();
}

class _DyscalImproveResultAllPageState extends State<DyscalImproveResultAllPage> {
  bool _isLoading = true;
  List<dynamic> _results = [];
  List<dynamic> _currentCycleHistory = [];
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchAllSpecialResults();
  }

  Future<void> _fetchAllSpecialResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        if (mounted) {
          setState(() {
            _errorMessage = "පරිශීලකයා හඳුනාගත නොහැක. (User not found.)";
            _isLoading = false;
          });
        }
        return;
      }

      final url = Uri.parse("${Config.baseUrl}/dyscalculia/special-results-all/$userId");
      print("Fetching special results from: $url");

      final response = await http.get(url);
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response data keys: ${data.keys}");
        print("Results count: ${(data['results'] ?? []).length}");

        if (mounted) {
          setState(() {
            _results = data['results'] ?? [];
            _currentCycleHistory = data['current_cycle_history'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = "දත්ත ලබාගැනීමට නොහැකි විය.\n(Failed to fetch data - Status: ${response.statusCode})";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("ERROR in _fetchAllSpecialResults: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "සම්බන්ධතා දෝෂයකි.\n(Connection Error: ${e.toString().substring(0, e.toString().length > 50 ? 50 : e.toString().length)}...)";
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(dateStr).toLocal();
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      print("Date parse error: $e for date: $dateStr");
      return "";
    }
  }

  void _showDetailPopup(Map<String, dynamic> resultItem) {
    try {
      Map<String, dynamic> specialTask = resultItem['special_task'] ?? {};
      List<dynamic> cycleHistory = resultItem['cycle_history'] ?? [];

      String riskLevel = specialTask['risk_level'] ?? "Unknown";
      int grade = specialTask['grade'] ?? 3;
      String dateStr = _formatDate(specialTask['created_at']);
      int accuracy = specialTask['accuracy'] ?? 0;
      int retries = specialTask['retries'] ?? 0;
      double completionTime = (specialTask['completion_time'] ?? 0.0).toDouble();

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.analytics_rounded, color: Colors.purple, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Grade $grade - විශේෂ ඇගයීම",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          if (dateStr.isNotEmpty)
                            Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Special Task Result
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade100, Colors.pink.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "විශේෂ ඇගයීමේ ප්‍රතිඵලය",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        riskLevel,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMiniStat("Accuracy", "$accuracy/5"),
                          _buildMiniStat("Retries", "$retries"),
                          _buildMiniStat("Time", "${completionTime.toStringAsFixed(0)}s"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Learning Path History
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "ඉගෙනුම් මාර්ගය (Learning Path):",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      if (cycleHistory.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "මෙම චක්‍රය සඳහා ඉතිහාසයක් නොමැත.",
                            style: TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                        )
                      else
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cycleHistory.length,
                            itemBuilder: (context, index) {
                              return _buildHistoryItem(cycleHistory[index]);
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("වසන්න (Close)", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print("ERROR in _showDetailPopup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("දෝෂයක් ඇති විය: $e")),
      );
    }
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    String action = item['evaluated_action'] ?? "Unknown";
    Color actionColor = Colors.blue;
    IconData actionIcon = Icons.arrow_forward;

    if (action == "Promote") {
      actionColor = Colors.green;
      actionIcon = Icons.trending_up;
    } else if (action == "Regress") {
      actionColor = Colors.orange;
      actionIcon = Icons.trending_down;
    } else if (action == "Stay") {
      actionColor = Colors.blue;
      actionIcon = Icons.arrow_forward;
    }

    String levelPlayed = item['level_played'] ?? "N/A";
    String nextLevel = item['next_level'] ?? "N/A";
    int accuracy = item['accuracy'] ?? 0;
    int retries = item['retries'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: actionColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: actionColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(actionIcon, color: actionColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$levelPlayed ➔ $nextLevel",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            action,
            style: TextStyle(fontSize: 12, color: actionColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Text(
            "$accuracy/5",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(width: 6),
          Text(
            "R:$retries",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialTaskCard(Map<String, dynamic> resultItem, int index) {
    try {
      Map<String, dynamic> specialTask = resultItem['special_task'] ?? {};
      List<dynamic> cycleHistory = resultItem['cycle_history'] ?? [];

      String riskLevel = specialTask['risk_level'] ?? "Unknown";
      int grade = specialTask['grade'] ?? 3;
      String dateStr = _formatDate(specialTask['created_at']);
      int accuracy = specialTask['accuracy'] ?? 0;
      double completionTime = (specialTask['completion_time'] ?? 0.0).toDouble();

      // Count stats from cycle history
      int promoteCount = cycleHistory.where((h) => h['evaluated_action'] == 'Promote').length;
      int regressCount = cycleHistory.where((h) => h['evaluated_action'] == 'Regress').length;
      int stayCount = cycleHistory.where((h) => h['evaluated_action'] == 'Stay').length;

      Color cardBorderColor;
      IconData cardIcon;
      if (riskLevel == "No Dyscalculia") {
        cardBorderColor = Colors.green;
        cardIcon = Icons.check_circle_outline;
      } else if (riskLevel == "Mild Dyscalculia") {
        cardBorderColor = Colors.orange;
        cardIcon = Icons.warning_amber_rounded;
      } else {
        cardBorderColor = Colors.red;
        cardIcon = Icons.error_outline_rounded;
      }

      return GestureDetector(
        onTap: () => _showDetailPopup(resultItem),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: cardBorderColor.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: cardBorderColor.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Grade $grade",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(cardIcon, color: cardBorderColor, size: 22),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            riskLevel,
                            style: TextStyle(
                              color: cardBorderColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (dateStr.isNotEmpty)
                    Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 12),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStat("Accuracy", "$accuracy/5"),
                  _buildMiniStat("Time", "${completionTime.toStringAsFixed(0)}s"),
                  _buildMiniStat("Tasks", "${cycleHistory.length}"),
                ],
              ),
              const SizedBox(height: 10),

              // Action Summary
              if (cycleHistory.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (promoteCount > 0)
                      _buildActionChip("⬆ $promoteCount", Colors.green),
                    if (regressCount > 0)
                      _buildActionChip("⬇ $regressCount", Colors.orange),
                    if (stayCount > 0)
                      _buildActionChip("→ $stayCount", Colors.blue),
                  ],
                ),

              const SizedBox(height: 8),
              // Tap hint
              const Center(
                child: Text(
                  "තොරතුරු බැලීමට තට්ටු කරන්න (Tap for details)",
                  style: TextStyle(color: Colors.black38, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print("ERROR building card for index $index: $e");
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text("Error loading result card"),
      );
    }
  }

  Widget _buildActionChip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
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
                        'සියලුම විශේෂ ඇගයීම්',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                    : _errorMessage.isNotEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 50),
                        const SizedBox(height: 15),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = "";
                            });
                            _fetchAllSpecialResults();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("නැවත උත්සාහ කරන්න (Retry)"),
                        ),
                      ],
                    ),
                  ),
                )
                    : _results.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.analytics_outlined, color: Colors.black38, size: 60),
                      const SizedBox(height: 15),
                      const Text(
                        "මෙතෙක් විශේෂ ඇගයීම් කිසිවක් නොමැත.\n(No special evaluations yet.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = "";
                          });
                          _fetchAllSpecialResults();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade200,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("නැවුම් කරන්න (Refresh)"),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return _buildSpecialTaskCard(_results[index], index);
                  },
                ),
              ),
              // Bottom Back to Profile Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                          (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    child: const Text(
                      "පැතිකඩට ආපසු යන්න (Back to Profile)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}