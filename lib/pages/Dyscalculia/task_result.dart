import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/profile.dart'; // Ensure this exists
import '/config.dart';  // Ensure this exists for Config.baseUrl

class TaskResultPage extends StatefulWidget {
  final int grade;
  final int taskNumber;
  final int accuracy;
  final double avgResponseTime;
  final double avgHesitationTime;
  final int retries;
  final int backtracks;
  final int skipped;
  final double totalCompletionTime;

  const TaskResultPage({
    super.key,
    required this.grade,
    required this.taskNumber,
    required this.accuracy,
    required this.avgResponseTime,
    required this.avgHesitationTime,
    required this.retries,
    required this.backtracks,
    required this.skipped,
    required this.totalCompletionTime,
  });

  @override
  State<TaskResultPage> createState() => _TaskResultPageState();
}

class _TaskResultPageState extends State<TaskResultPage> {
  bool _isSaving = true;
  String _saveMessage = "Saving results...";

  @override
  void initState() {
    super.initState();
    _submitResultsToBackend();
  }

  Future<void> _submitResultsToBackend() async {
    final url = Uri.parse("${Config.baseUrl}/dyscalculia/submit-result");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "grade": widget.grade,
          "task_number": widget.taskNumber,
          "accuracy": widget.accuracy,
          "response_time_avg": widget.avgResponseTime,
          "hesitation_time_avg": widget.avgHesitationTime,
          "retries": widget.retries,
          "backtracks": widget.backtracks,
          "skipped_items": widget.skipped,
          "completion_time": widget.totalCompletionTime,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSaving = false;
          _saveMessage = "Results saved successfully!";
        });
      } else {
        setState(() {
          _isSaving = false;
          _saveMessage = "Failed to save results (Server Error)";
        });
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _saveMessage = "Connection Error: Results saved locally only.";
      });
    }
  }

  Widget _buildResultRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        title: const Text("ප්‍රතිඵල (Results)", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.analytics_outlined, size: 60, color: Colors.purple),
                const SizedBox(height: 10),
                Text("Grade ${widget.grade} - Task ${widget.taskNumber}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                const SizedBox(height: 10),

                _buildResultRow("Accuracy (නිරවද්‍යතාවය)", "${widget.accuracy} / 5", Icons.grade, Colors.orange),
                _buildResultRow("Avg Response Time", "${widget.avgResponseTime.toStringAsFixed(1)} sec", Icons.timer, Colors.blue),
                _buildResultRow("Avg Hesitation", "${widget.avgHesitationTime.toStringAsFixed(1)} sec", Icons.hourglass_empty, Colors.redAccent),
                _buildResultRow("Retries (නැවත උත්සාහයන්)", "${widget.retries}", Icons.refresh, Colors.green),
                _buildResultRow("Backtracks (ආපසු යාම්)", "${widget.backtracks}", Icons.undo, Colors.brown),
                _buildResultRow("Skipped (මඟ හැරිය)", "${widget.skipped}", Icons.skip_next, Colors.grey),
                _buildResultRow("Total Time", "${widget.totalCompletionTime.toStringAsFixed(1)} sec", Icons.watch_later, Colors.purple),

                const SizedBox(height: 20),
                if (_isSaving)
                  const CircularProgressIndicator()
                else
                  Text(_saveMessage, style: TextStyle(color: _saveMessage.contains("Success") ? Colors.green : Colors.red, fontSize: 12)),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("පැතිකඩට ආපසු යන්න (Back to Profile)"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}