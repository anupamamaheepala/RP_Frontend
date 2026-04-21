import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/config.dart';
import '/profile.dart';
import 'dyscal_special_task_g04.dart';

class DyscalImproveG04Page extends StatefulWidget {
  const DyscalImproveG04Page({super.key});

  @override
  State<DyscalImproveG04Page> createState() => _DyscalImproveG04PageState();
}

class _DyscalImproveG04PageState extends State<DyscalImproveG04Page> {
  bool _isLoading = true;
  String _currentLevel = "easy";
  int _tasksCompleted = 0;
  List<dynamic> _questions = [];

  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  int _accuracy = 0;
  int _wrongCount = 0;
  int _totalRetries = 0;
  double _totalHesitation = 0.0;
  double _totalTime = 0.0;

  int _currentQuestionRetries = 0;
  DateTime? _questionStartTime;
  DateTime? _firstInteractionTime;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _initLearningPath();
  }

  Future<void> _initLearningPath() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? "";

      if (userId.isEmpty) {
        setState(() => _isLoading = false);
        _showAccessDeniedDialog();
        return;
      }

      final stateUrl = Uri.parse("${Config.baseUrl}/dyscalculia/learning-state/$userId/4");
      final stateRes = await http.get(stateUrl);

      if (stateRes.statusCode == 200) {
        final stateData = jsonDecode(stateRes.body);

        if (stateData['ok'] == false) {
          setState(() => _isLoading = false);
          _showAccessDeniedDialog();
          return;
        }

        _currentLevel = stateData['level'];
        _tasksCompleted = stateData['tasks_completed'];

        if (_tasksCompleted > 0 && _tasksCompleted % 5 == 0) {
          setState(() => _isLoading = false);
          _showSpecialTaskDialog();
          return;
        }

        _fetchQuestions();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchQuestions() async {
    try {
      final qUrl = Uri.parse("${Config.baseUrl}/dyscalculia/learning-questions/4/$_currentLevel");
      final qRes = await http.get(qUrl);

      if (qRes.statusCode == 200) {
        final data = jsonDecode(qRes.body);
        setState(() {
          _questions = data['questions'] ?? [];
          _resetMetrics();
          _isLoading = false;

          if (_questions.isNotEmpty) {
            _startQuestionTimer();
          }
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _resetMetrics() {
    _currentQuestionIndex = 0;
    _accuracy = 0;
    _wrongCount = 0;
    _totalRetries = 0;
    _totalHesitation = 0.0;
    _totalTime = 0.0;
    _currentQuestionRetries = 0;
    _hasInteracted = false;
  }

  void _startQuestionTimer() {
    _questionStartTime = DateTime.now();
    _firstInteractionTime = null;
    _hasInteracted = false;
    _currentQuestionRetries = 0;
    _answerController.clear();
  }

  void _onInputChanged(String val) {
    if (!_hasInteracted) {
      _firstInteractionTime = DateTime.now();
      _hasInteracted = true;
    }
  }

  void _checkAnswer() {
    if (_answerController.text.isEmpty) return;

    final correctAnswer = _questions[_currentQuestionIndex]['answer'].toString().trim();
    final userAnswer = _answerController.text.trim();

    DateTime now = DateTime.now();

    if (_firstInteractionTime != null) {
      _totalHesitation += _firstInteractionTime!.difference(_questionStartTime!).inMilliseconds / 1000.0;
    } else {
      _totalHesitation += now.difference(_questionStartTime!).inMilliseconds / 1000.0;
    }
    _totalTime += now.difference(_questionStartTime!).inMilliseconds / 1000.0;

    if (userAnswer == correctAnswer) {
      _accuracy++;
      _moveToNextQuestion();
    } else {
      setState(() {
        _wrongCount++;
        _totalRetries++;
        _currentQuestionRetries++;
        _answerController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('වැරදියි, නැවත උත්සාහ කරන්න (Incorrect, try again)'), backgroundColor: Colors.red),
      );
    }
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _startQuestionTimer();
      });
    } else {
      _submitTaskMetrics();
    }
  }

  Future<void> _submitTaskMetrics() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? "";

      final url = Uri.parse("${Config.baseUrl}/dyscalculia/submit-learning-task");
      final body = {
        "user_id": userId,
        "grade": 4,
        "accuracy": _accuracy,
        "wrong_count": _wrongCount,
        "hesitation_time_avg": _totalHesitation / _questions.length,
        "response_time_avg": _totalTime / _questions.length,
        "retries": _totalRetries,
        "backtracks": 0,
        "skipped_items": 0,
        "completion_time": _totalTime,
      };

      final res = await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _showResultDialog(data['action'], data['message'], data['next_level']);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showResultDialog(String action, String message, String nextLevel) {
    IconData icon = Icons.star;
    Color color = Colors.blue;

    if (action == "Promote") {
      icon = Icons.trending_up; color = Colors.green;
    } else if (action == "Regress") {
      icon = Icons.trending_down; color = Colors.orange;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(action, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ProfilePage()), (route) => false);
            },
            child: const Text("නතර කරන්න (Stop)", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {
              Navigator.pop(context);
              _initLearningPath();
            },
            child: const Text("ඊළඟ (Next)", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSpecialTaskDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.analytics, size: 50, color: Colors.purple),
        content: const Text(
          "ඔබ අදියර 5ක් සම්පූර්ණ කර ඇත! ඔබේ ප්‍රගතිය පරීක්ෂා කිරීමට විශේෂ ඇගයීමක් සඳහා කාලයයි.\n(You completed 5 stages! Time for a special evaluation.)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DyscalSpecialTaskG04Page())
              );
            },
            child: const Text("ආරම්භ කරන්න (Start Special Task)", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAccessDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.lock_outline, size: 50, color: Colors.redAccent),
            SizedBox(height: 10),
            Text(
              "ප්‍රවේශය නැත\n(Access Denied)",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          "ඔබ මුලින්ම හඳුනාගැනීමේ පරීක්ෂණය සම්පූර්ණ කළ යුතුය.\n(You must complete the detection test first.)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                        (route) => false
                );
              },
              child: const Text("පැතිකඩට යන්න (Go to Profile)", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
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
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.purple), onPressed: () => Navigator.pop(context)),
                title: const Text('දියුණු කිරීම - 4 ශ්‍රේණිය', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                    : _questions.isEmpty
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "ගැටළු සොයාගත නොහැක. (No questions found in the database.)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              Text("ප්‍රශ්නය ${_currentQuestionIndex + 1} / ${_questions.length} - Level: ${_currentLevel.toUpperCase()}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                              const SizedBox(height: 10),
                              Text(
                                _questions[_currentQuestionIndex]['question'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _answerController,
                          onChanged: _onInputChanged,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "පිළිතුර (Answer)",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            onPressed: _checkAnswer,
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text("පරීක්ෂා කරන්න (Check)", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
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