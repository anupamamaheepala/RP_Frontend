import 'package:flutter/material.dart';
import 'dart:async';
import '/theme.dart';
import 'task_result.dart';

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

class DyscalG06Page extends StatefulWidget {
  const DyscalG06Page({super.key});

  @override
  State<DyscalG06Page> createState() => _DyscalG06PageState();
}

class _DyscalG06PageState extends State<DyscalG06Page> {
  // --- GRADE 6 DATA ---
  final List<List<_QuizQuestion>> _allTasks = [
    [
      _QuizQuestion(question: "\"හාරලක්ෂ පනස් හයදහස්, හත්සිය අසූ නවය\" යන වචන අංකයක් ලෙස ලියන්න.", answers: ["456790"], units: [""]),
      _QuizQuestion(question: "පහත සංඛ්‍යා ආරෝහණ අනුපිළිවෙලට සකසන්න : 5, -3, 0, 2.5, -1.", answers: ["-3", "-1", "0", "2.5", "5"], units: ["", "", "", "", ""]),
      _QuizQuestion(question: "7, 15, -3, සහ 10 හි එකතුව සොයන්න.", answers: ["29"], units: [""]),
      _QuizQuestion(question: "0.75 භාගයකට පරිවර්තනය කරන්න.", answers: ["3/4"], units: [""]),
      _QuizQuestion(question: "පහත සංඛ්‍යා අනුපිළිවෙලට සකසන්න : -6.2, 3.5, -1.8, 0.9, -2.4", answers: ["3.5", "0.9", "-1.8", "-2.4", "-6.2"], units: ["", "", "", "", ""]),
    ],
    [
      _QuizQuestion(question: "දුම්රියක් ගමනක් ආරම්භ කළේ පෙරවරු 8:45 ට ය.\nගමන නිම කිරීමට ගත වූ කාලය පැය 3 විනාඩි 30 ක් නම්, දුම්රිය ගමනාන්තයට ළඟා වූ වේලාව කීයද?", answers: ["12.15"], units: ["pm"]),
      _QuizQuestion(question: "එක් තේ කොළ පැකට් එකක බර ග්‍රෑම් 250 කි.\nඑවැනි පැකට් 8 ක මුළු බර කිලෝග්‍රෑම් කීයද?", answers: ["2"], units: ["kg"]),
      _QuizQuestion(question: "සීනි කිලෝග්‍රෑම් 5 ක බෑගයකින්, ග්‍රෑම් 750 ක් ඉවත් කළහොත් ඉතිරි වන සීනි ප්‍රමාණය කොපමණද?", answers: ["4", "250"], units: ["kg", "g"]),
      _QuizQuestion(question: "ඝනකයක් දිග සෙන්ටිමීටර 4 ක්, පළල සෙන්ටිමීටර 2 ක් සහ උස සෙන්ටිමීටර 6 කි.\nඝනකයේ පරිමාව සොයා ගන්න.", answers: ["48"], units: ["cubic cm"]),
      _QuizQuestion(question: "දිග සෙන්ටිමීටර 8 ක් සහ පළල සෙන්ටිමීටර 5 ක් වන සෘජුකෝණාස්‍රයක පරිමිතිය සහ ප්‍රදේශය සොයා ගන්න.", answers: ["26", "40"], units: ["cm", "sq cm"]),
    ],
    [
      _QuizQuestion(question: "1/8 දශමයක් ලෙස ලියන්න.", answers: ["0.125"], units: [""]),
      _QuizQuestion(question: "පහත භාගය සරල කරන්න : 12/36.", answers: ["1/3"], units: [""]),
      _QuizQuestion(question: "ඇපල් 7 ක් සහ දොඩම් 21 ක් අතර අනුපාතය සරලම ආකාරයෙන් සොයා ගන්න.", answers: ["1", "3"], units: [":", ""]),
      _QuizQuestion(question: "පීත්ත පටියක් මීටර් 12.5 ක් දිගයි.\nඑයින් මීටර් 0.75 ක කැබලි කීයක් කපා ගත හැකිද?", answers: ["16"], units: [""]),
      _QuizQuestion(question: "15.876 අංකය දශම ස්ථාන දෙකකට වට කරන්න.", answers: ["15.88"], units: [""]),
    ],
    [
      _QuizQuestion(question: "සවස 4:45 පැය 24 ඔරලෝසු ආකෘතියට පරිවර්තනය කරන්න.", answers: ["16:45"], units: [""]),
      _QuizQuestion(question: "සිදත් කිලෝග්‍රෑමයකට රු. 50 කට සහල් කිලෝග්‍රෑම් 10 ක්, කිලෝග්‍රෑමයකට රු. 60 කට සීනි කිලෝග්‍රෑම් 5 ක් සහ කිලෝග්‍රෑම් 150 කට තේ දළු කිලෝග්‍රෑම් 3 ක් මිලදී ගනී.\nමුළු පිරිවැය සොයන්න.", answers: ["1250"], units: ["rupees"]),
      _QuizQuestion(question: "කමිසයක මිල ඩොලර් 15 කි.\nඇමරිකානු ඩොලර් 1 = රු. 112.50 නම්, කමිසයේ පිරිවැය ශ්‍රී ලංකා රුපියල්වලින් ගණනය කරන්න.", answers: ["1687.50"], units: ["rupees"]),
      _QuizQuestion(question: "ප.ව. 4:45 සිට පැය 2 යි මිනිත්තු 30 ක් අඩු කරන්න.", answers: ["2:15"], units: ["PM"]),
      _QuizQuestion(question: "පළතුරු කූඩයක බර කිලෝග්‍රෑම් 3.75 කි.\nඑයින් අඩක් පිටතට ගත්තොත් එහි බර කොපමණ වේද?", answers: ["1.875"], units: ["kg"]),
    ],
    [
      _QuizQuestion(question: "උදෑසන 9 ට උෂ්ණත්වය 28°C වන අතර සවස 3 ට එය 30°C වේ.\nමුළු දවස සඳහාම මධ්‍යන්‍ය උෂ්ණත්වය තීරණය කිරීම ගණනය කරන්න.", answers: ["29"], units: ["°C"]),
      _QuizQuestion(question: "සෘජුකෝණාස්‍රයක උස සෙන්ටිමීටර 15 ක් සහ පාදම සෙන්ටිමීටර 20 කි.\nඉන්පසු උස දෙගුණ කළහොත්, සෘජුකෝණාස්‍රයේ නව ප්‍රදේශය සොයා ගන්න.", answers: ["600"], units: ["sq cm"]),
      _QuizQuestion(question: "ලීටර් 5.5 ක් ලීටර් 0.25 බෝතල් කීයක් පිරවිය හැකිදැයි සොයා ගන්න.", answers: ["22"], units: [""]),
      _QuizQuestion(question: "වාහනයක් පැය 3 කින් කිලෝමීටර 180 ක දුරක් ගමන් කරයි.\nවාහනය දින 5 ක් සෑම දිනකම එකම දුරක් ගමන් කරන්නේ නම්, එම දින 5 තුළ ආවරණය කළ මුළු දුර සහ ගත කළ මුළු කාලය ගණනය කරන්න.", answers: ["900", "15"], units: ["km", "hours"]),
      _QuizQuestion(question: "පියල්ගේ පන්තියේ සතියකට සිසුන්ගේ පැමිණීම පහත පරිදි වේ : සඳුදා (38), අඟහරුවාදා (40), බදාදා (36), බ්‍රහස්පතින්දා (32), සිකුරාදා (35).\nසතිය සඳහා මධ්‍යන්‍ය පැමිණීම ගණනය කරන්න.", answers: ["36"], units: [""]),
    ],
  ];

  // Colors for each task card to match theme
  final List<List<Color>> _taskGradients = [
    [Colors.purple.shade400, Colors.blue.shade400],
    [Colors.blue.shade400, Colors.teal.shade300],
    [Colors.green.shade400, Colors.teal.shade300],
    [Colors.orange.shade400, Colors.pink.shade300],
    [Colors.deepPurple.shade400, Colors.indigo.shade400],
  ];

  int _selectedTaskIndex = -1;
  int _currentQuestionIndex = 0;
  final List<TextEditingController> _controllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  String _feedbackMessage = "";
  Color _feedbackColor = Colors.transparent;
  bool _isChecked = false;

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
        _retryCount++;
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
        _backtrackCount++;
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
      grade: 6,
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
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _taskGradients[index % _taskGradients.length],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 28),
            ),
            title: Text(
              "පැවරුම 0${index + 1}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              "Task ${index + 1}",
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
            onTap: () => _selectTask(index),
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
              boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
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
          if (answerCount == 1)
            _buildSingleInput(0, question.units[0])
          else
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: List.generate(answerCount, (index) {
                return SizedBox(width: 80, child: _buildSingleInput(index, question.units[index]));
              }),
            ),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5),
                        child: const Text("ප්‍රතිඵල බලන්න (View Results)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _backToMenu,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5),
                        child: const Text("Back to Tasks (අවසන් කරන්න)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "?",
        suffixText: unit.isNotEmpty ? unit : null,
        suffixStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
                // HEADER
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                        onPressed: () {
                          if (_selectedTaskIndex != -1) {
                            _backToMenu();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          _selectedTaskIndex == -1 ? 'ශ්‍රේණිය 6 (Grade 6)' : 'පැවරුම 0${_selectedTaskIndex + 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(child: _selectedTaskIndex == -1 ? _buildTaskMenu() : _buildQuizView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}