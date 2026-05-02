import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/config.dart';
import '/profile.dart';
import 'dyscal_improve_result_all.dart';  // NEW IMPORT

class DyscalImproveResultPage extends StatefulWidget {
  const DyscalImproveResultPage({super.key});

  @override
  State<DyscalImproveResultPage> createState() => _DyscalImproveResultPageState();
}

class _DyscalImproveResultPageState extends State<DyscalImproveResultPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _specialResult;
  List<dynamic> _historyList = [];

  @override
  void initState() {
    super.initState();
    _fetchLearningHistory();
  }

  Future<void> _fetchLearningHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != null) {
        final url = Uri.parse("${Config.baseUrl}/dyscalculia/learning-history/$userId");
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _specialResult = data['special_result'];
            _historyList = data['history'] ?? [];
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSpecialResultCard() {
    if (_specialResult == null) return const SizedBox.shrink();

    String riskLevel = _specialResult!['risk_level'] ?? "Unknown";
    Color cardColor = Colors.grey;
    IconData cardIcon = Icons.help_outline;

    if (riskLevel == "No Dyscalculia") {
      cardColor = Colors.green;
      cardIcon = Icons.check_circle_outline;
    } else if (riskLevel == "Mild Dyscalculia") {
      cardColor = Colors.orange;
      cardIcon = Icons.warning_amber_rounded;
    } else if (riskLevel == "Severe Dyscalculia") {
      cardColor = Colors.red;
      cardIcon = Icons.error_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardColor, width: 2),
      ),
      child: Column(
        children: [
          const Text("නවතම විශේෂ ඇගයීම (Latest Special Task)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(cardIcon, color: cardColor, size: 30),
              const SizedBox(width: 10),
              Text(
                riskLevel,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cardColor),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat("Accuracy", "${_specialResult!['accuracy'] ?? 0}/5"),
              _buildStat("Retries", "${_specialResult!['retries'] ?? 0}"),
              _buildStat("Time", "${(_specialResult!['completion_time'] ?? 0).toStringAsFixed(0)}s"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, int index) {
    String action = item['evaluated_action'] ?? "Unknown";
    Color actionColor = Colors.blue;
    IconData actionIcon = Icons.remove;

    int grade = item['grade'] ?? 3;

    if (action == "Promote") {
      actionColor = Colors.green;
      actionIcon = Icons.arrow_upward;
    } else if (action == "Regress") {
      actionColor = Colors.orange;
      actionIcon = Icons.arrow_downward;
    } else if (action == "Stay") {
      actionColor = Colors.blue;
      actionIcon = Icons.arrow_forward;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: actionColor.withOpacity(0.2),
          child: Icon(actionIcon, color: actionColor),
        ),
        title: Text(
          "Grade $grade | Level: ${item['level_played']} ➔ ${item['next_level']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Accuracy: ${item['accuracy']}/5 | Retries: ${item['retries']}"),
        trailing: Text(
          action,
          style: TextStyle(color: actionColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('දියුණු කිරීමේ ප්‍රතිඵල', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Special Result Section
            if (_specialResult != null) _buildSpecialResultCard(),

            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "මෑත කාලීන කාර්යයන් (Recent Tasks)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ),

            // History List
            if (_historyList.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("No history available yet.")))
            else
              ..._historyList.asMap().entries.map((entry) => _buildHistoryCard(entry.value, entry.key)),

            const SizedBox(height: 20),

            // --- NEW: SEE ALL RESULTS BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DyscalImproveResultAllPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.list_alt_rounded),
                  label: const Text(
                    "සියලුම ප්‍රතිඵල බලන්න (See All Results)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // --- BACK TO PROFILE BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}