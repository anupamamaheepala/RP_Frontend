import 'package:flutter/material.dart';
// Required for Timers
import '/theme.dart';
import 'task_result.dart';

// Changed to private class to avoid conflicts
class _QuizQuestion {
  final String question;
  final List<String> answers;
  final List<String> units;

  _QuizQuestion({
    required this.question,
    required this.answers,
    List<String>? units,
  }) : units = units ?? List.filled(answers.length, "");
}

class DyscalG03Page extends StatefulWidget {
  const DyscalG03Page({super.key});

  @override
  State<DyscalG03Page> createState() => _DyscalG03PageState();
}

class _DyscalG03PageState extends State<DyscalG03Page> {
  // --- GRADE 3 DATA ---
  final List<List<_QuizQuestion>> _allTasks = [
    [
      _QuizQuestion(question: "කූඩයකට ඇපල් 15 ක් තියෙනවා.\nඔබ තවත් ඇපල් 8 ක් එකතු කළහොත්, කූඩයේ ඇපල් කීයක් තිබේද?", answers: ["23"], units: ["Apples"]),
      _QuizQuestion(question: "සාරා ළඟ ස්ටිකර් 23 ක් තිබුණා.\nඇය ඇගේ මිතුරියට ස්ටිකර් 7 ක් දුන්නා.\nදැන් සාරා ළඟ ස්ටිකර් කීයක් තියෙනවද?", answers: ["16"], units: ["Stickers"]),
      _QuizQuestion(question: "සරල එකතු කිරීම : 34 + 19 = ______", answers: ["53"]),
      _QuizQuestion(question: "සරල අඩු කිරීම : 52 - 28 = ______", answers: ["24"]),
      _QuizQuestion(question: "නැතිවූ අංකය සොයා ගන්න : 45 + ___ = 68", answers: ["23"]),
    ],
    [
      _QuizQuestion(question: "සෑම පැන්සල් පැකට්ටුවකම පැන්සල් 6 ක් තිබේ නම්, ඇසුරුම් 5 ක පැන්සල් කීයක් තිබේද?", answers: ["30"], units: ["Pencils"]),
      _QuizQuestion(question: "පන්ති කාමර 6 ක සිසුන් 48 ක් සිටිති.\nසෑම පන්ති කාමරයකම සිසුන් කී දෙනෙක් සිටීද?", answers: ["8"], units: ["Students"]),
      _QuizQuestion(question: "සරල ගුණ කිරීම : 7 × 4 = ______", answers: ["28"]),
      _QuizQuestion(question: "සරල බෙදීම : 36 ÷ 4 = ______", answers: ["9"]),
      _QuizQuestion(question: "ඔබ බෑග් 3 ක් මිල දී ගෙන එක් බෑගයක මිල රුපියල් 12 ක් නම්, බෑග් 3 සඳහා කොපමණ මුදලක් වැය වේද?", answers: ["36"], units: ["Rupees"]),
    ],
    [
      _QuizQuestion(question: "රටාව සම්පූර්ණ කරන්න : 5, 10, 15, ___, ___, 30", answers: ["20", "25"]),
      _QuizQuestion(question: "අතුරුදහන් අංකය පුරවන්න : 24, __, 36, __, 48", answers: ["30", "42"]),
      _QuizQuestion(question: "දෙකෙන් ගණන් කරන්න : 2, 4, 6, ___, ___", answers: ["8", "10"]),
      _QuizQuestion(question: "සති 5 ක් තුළ දින කීයක් තිබේද?\n(ඉඟිය : සතිය 1 = දින 7)", answers: ["35"], units: ["Days"]),
      _QuizQuestion(question: "3, 6, 9, 12, ___ රටාවේ 8 වන අංකය කුමක්ද?", answers: ["24"]),
    ],
    [
      _QuizQuestion(question: "පැන්සලක් සෙන්ටිමීටර 12 ක් දිගයි.\nඔබට පැන්සල් 5 ක් තිබේ නම්, ඒවායේ මුළු දිග කොපමණද?", answers: ["60"], units: ["cm"]),
      _QuizQuestion(question: "සෘජුකෝණාස්‍රයක දිග සෙන්ටිමීටර 6 ක් සහ පළල සෙන්ටිමීටර 4 කි.\nසෘජුකෝණාස්‍රයේ වර්ගඵලය කුමක්ද?", answers: ["24"], units: ["square centimeters"]),
      _QuizQuestion(question: "ගසක් උස මීටර් 18 කි.\nගස සෑම වසරකම මීටර් 3 ක් වැඩෙන්නේ නම්, වසර 4 කට පසු එය කොපමණ උස වේද?", answers: ["30"], units: ["meters"]),
      _QuizQuestion(question: "ත්‍රිකෝණයක පැති කීයක් තිබේද?", answers: ["3"]),
      _QuizQuestion(question: "ඔබේ පන්තිය උදේ 9:00 ට ආරම්භ වී සවස 3:00 ට අවසන් වන්නේ නම්, පන්තිය පැය කීයක් පවතීද?", answers: ["6"], units: ["Hours"]),
    ],
    [
      _QuizQuestion(question: "ඔබට රුපියල් 50 ක් තිබේ.\nඔබ රුපියල් 15 බැගින් වූ සෙල්ලම් බඩු 2 ක් මිලදී ගන්නේ නම්, ඔබට කොපමණ මුදලක් ඉතිරි වේද?", answers: ["20"], units: ["Rupees"]),
      _QuizQuestion(question: "ඔබට රුපියල් 10 ක් ඇති අතර, ඔබේ මිතුරාගෙන් ඔබට රුපියල් 20 ක් ලැබේ.\nදැන් ඔබ සතුව කොපමණ මුදලක් තිබේද?", answers: ["30"], units: ["Rupees"]),
      _QuizQuestion(question: "දොඩම් මල්ලක් රුපියල් 35 කි.\nඔබ බෑග් 3 ක් මිලදී ගන්නේ නම්, ඔබ මුළු මුදල කොපමණද?", answers: ["105"], units: ["Rupees"]),
      _QuizQuestion(question: "ඔබට රුපියල් 100 ක් ඇත.\nඔබ රුපියල් 45 ක් වියදම් කරන්නේ නම්, කොපමණ මුදලක් ඉතිරි වේද?", answers: ["55"], units: ["Rupees"]),
      _QuizQuestion(question: "ඔබට රුපියල් 10 කාසි දෙකක්, රුපියල් 5 කාසි තුනක් සහ රුපියල් 1 කාසි හතරක් තිබේ නම්, ඔබට කොපමණ මුදලක් තිබේද?", answers: ["39"], units: ["Rupees"]),
    ],
  ];

  int _selectedTaskIndex = -1;
  int _currentQuestionIndex = 0;
  final List<TextEditingController> _controllers = [TextEditingController(), TextEditingController()];
  String _feedbackMessage = "";
  Color _feedbackColor = Colors.transparent;
  bool _isChecked = false;

  // --- NEW METRICS VARIABLES ---
  final Stopwatch _taskStopwatch = Stopwatch();
  final Stopwatch _questionStopwatch = Stopwatch();

  int _totalCorrect = 0;
  int _retryCount = 0;
  int _backtrackCount = 0;
  int _skippedCount = 0;
  List<double> _responseTimes = [];
  List<double> _hesitationTimes = [];
  bool _hasInteractedWithCurrent = false;
  DateTime? _questionLoadTime;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectTask(int index) {
    setState(() {
      _selectedTaskIndex = index;
      _currentQuestionIndex = 0;

      // Reset metrics
      _totalCorrect = 0;
      _retryCount = 0;
      _backtrackCount = 0;
      _skippedCount = 0;
      _responseTimes = [];
      _hesitationTimes = [];

      _taskStopwatch.reset();
      _taskStopwatch.start();

      _resetQuestion();
    });
  }

  void _resetQuestion() {
    for (var controller in _controllers) {
      controller.clear();
      controller.removeListener(_onTextChanged);
      controller.addListener(_onTextChanged);
    }
    setState(() {
      _feedbackMessage = "";
      _feedbackColor = Colors.transparent;
      _isChecked = false;

      _questionStopwatch.reset();
      _questionStopwatch.start();
      _questionLoadTime = DateTime.now();
      _hasInteractedWithCurrent = false;
    });
  }

  void _onTextChanged() {
    if (!_hasInteractedWithCurrent && _questionLoadTime != null) {
      bool isAnyText = _controllers.any((c) => c.text.isNotEmpty);
      if (isAnyText) {
        _hasInteractedWithCurrent = true;
        final hesitation = DateTime.now().difference(_questionLoadTime!).inMilliseconds / 1000.0;
        _hesitationTimes.add(hesitation);
      }
    }
  }

  void _checkAnswer() {
    if (_selectedTaskIndex == -1) return;
    List<_QuizQuestion> currentTaskList = _allTasks[_selectedTaskIndex];
    _QuizQuestion currentQ = currentTaskList[_currentQuestionIndex];
    int answerCount = currentQ.answers.length;
    bool allCorrect = true;
    for (int i = 0; i < answerCount; i++) {
      if (_controllers[i].text.trim() != currentQ.answers[i]) {
        allCorrect = false;
        break;
      }
    }
    setState(() {
      _isChecked = true;
      if (allCorrect) {
        _feedbackMessage = "නියමයි! (Correct!)";
        _feedbackColor = Colors.green;
      } else {
        _feedbackMessage = "නැවත උත්සාහ කරන්න (Try Again)";
        _feedbackColor = Colors.red;
        _retryCount++; // Metric
      }
    });
  }

  void _recordQuestionMetrics() {
    _questionStopwatch.stop();
    _responseTimes.add(_questionStopwatch.elapsedMilliseconds / 1000.0);

    List<_QuizQuestion> currentTaskList = _allTasks[_selectedTaskIndex];
    _QuizQuestion currentQ = currentTaskList[_currentQuestionIndex];
    bool allCorrect = true;
    bool isEmpty = true;

    for (int i = 0; i < currentQ.answers.length; i++) {
      String text = _controllers[i].text.trim();
      if (text.isNotEmpty) isEmpty = false;
      if (text != currentQ.answers[i]) {
        allCorrect = false;
      }
    }

    if (isEmpty) {
      _skippedCount++;
    } else if (allCorrect) {
      _totalCorrect++;
    }
  }

  void _nextQuestion() {
    if (_selectedTaskIndex == -1) return;

    _recordQuestionMetrics();

    if (_currentQuestionIndex < _allTasks[_selectedTaskIndex].length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _resetQuestion();
      });
    }
  }

  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _backtrackCount++; // Metric
        _currentQuestionIndex--;
        _resetQuestion();
      });
    }
  }

  void _finishTask() {
    _recordQuestionMetrics();
    _taskStopwatch.stop();

    double totalResponseTime = _responseTimes.fold(0, (sum, item) => sum + item);
    double avgResponse = _responseTimes.isEmpty ? 0 : totalResponseTime / _responseTimes.length;

    double totalHesitation = _hesitationTimes.fold(0, (sum, item) => sum + item);
    double avgHesitation = _hesitationTimes.isEmpty ? 0 : totalHesitation / _hesitationTimes.length;

    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskResultPage(
      grade: 3,
      taskNumber: _selectedTaskIndex + 1,
      accuracy: _totalCorrect,
      avgResponseTime: avgResponse,
      avgHesitationTime: avgHesitation,
      retries: _retryCount,
      backtracks: _backtrackCount,
      skipped: _skippedCount,
      totalCompletionTime: _taskStopwatch.elapsedMilliseconds / 1000.0,
    )));
  }

  void _backToMenu() {
    setState(() {
      _selectedTaskIndex = -1;
      _currentQuestionIndex = 0;
      _resetQuestion();
    });
  }

  Widget _buildTaskMenu() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _allTasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _selectTask(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.mathDetect,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(2, 4))],
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 30),
                const SizedBox(width: 20),
                Text("පැවරුම 0${index + 1} (Task ${index + 1})", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizView() {
    _QuizQuestion question = _allTasks[_selectedTaskIndex][_currentQuestionIndex];
    int answerCount = question.answers.length;
    bool isLastQuestion = _currentQuestionIndex == _allTasks[_selectedTaskIndex].length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text("ප්‍රශ්නය ${_currentQuestionIndex + 1} / 5", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 10),
                Text(question.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          answerCount == 1
              ? _buildSingleInput(0, question.units[0])
              : Row(children: [Expanded(child: _buildSingleInput(0, question.units[0])), const SizedBox(width: 10), Expanded(child: _buildSingleInput(1, question.units[1]))]),
          const SizedBox(height: 20),
          if (_isChecked)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _feedbackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: _feedbackColor)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_feedbackColor == Colors.green ? Icons.check_circle : Icons.error, color: _feedbackColor), const SizedBox(width: 10), Text(_feedbackMessage, style: TextStyle(color: _feedbackColor, fontWeight: FontWeight.bold, fontSize: 16))]),
            ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton.icon(onPressed: _checkAnswer, icon: const Icon(Icons.check), label: const Text("Check"), style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
            ElevatedButton.icon(onPressed: _resetQuestion, icon: const Icon(Icons.refresh), label: const Text("Retry"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
          ]),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _currentQuestionIndex > 0 ? IconButton(onPressed: _prevQuestion, icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.purple)) : const SizedBox(width: 30),
                _currentQuestionIndex < _allTasks[_selectedTaskIndex].length - 1 ? IconButton(onPressed: _nextQuestion, icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.purple)) : const SizedBox(width: 30),
              ]),
              const SizedBox(height: 20),
              if (isLastQuestion)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _finishTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        child: const Text("ප්‍රතිඵල බලන්න (View Results)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _backToMenu,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        child: const Text("අවසන් කරන්න (Back to Tasks)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleInput(int index, String unit) {
    return TextField(
      controller: _controllers[index],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "?",
        suffixText: unit.isNotEmpty ? unit : null,
        suffixStyle: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedTaskIndex != -1) {
          _backToMenu();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF8EC5FC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.purple), onPressed: () {
            if (_selectedTaskIndex != -1) {
              _backToMenu();
            } else {
              Navigator.pop(context);
            }
          }),
          title: Text(_selectedTaskIndex == -1 ? 'ශ්‍රේණිය 3 (Grade 3)' : 'පැවරුම 0${_selectedTaskIndex + 1}', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: _selectedTaskIndex == -1 ? _buildTaskMenu() : _buildQuizView(),
      ),
    );
  }
}