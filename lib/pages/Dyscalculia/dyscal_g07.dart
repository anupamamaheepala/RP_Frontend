import 'package:flutter/material.dart';
// Required for Timers
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

class DyscalG07Page extends StatefulWidget {
  const DyscalG07Page({super.key});

  @override
  State<DyscalG07Page> createState() => _DyscalG07PageState();
}

class _DyscalG07PageState extends State<DyscalG07Page> {

  // --- GRADE 7 DATA ---
  final List<List<_QuizQuestion>> _allTasks = [
    // --- Task 01 ---
    [
      _QuizQuestion(question: "7/9 + 4/5 =", answers: ["71/45"], units: [""]),
      _QuizQuestion(question: "3/8 × 5/6 =", answers: ["5/16"], units: [""]),
      _QuizQuestion(question: "7/10, 2/5 න් බෙදන්න සහ පිළිතුර සරල කරන්න.", answers: ["7/4"], units: [""]),
      _QuizQuestion(question: "ප්‍රතිශත ගණනය කිරීම : 420 න් 35% ක් යනු කුමක්ද?", answers: ["147"], units: [""]),
      _QuizQuestion(question: "කූඩයක ඇපල් 5 ක්, කෙසෙල් 2 ක් සහ දොඩම් 3 ක් අඩංගු වේ.\nමුළු පලතුරෙන් කෙසෙල් යනු කුමන කොටසද?\n(පිළිතුර සරල කරන්න)", answers: ["1/5"], units: [""]),
    ],
    // --- Task 02 ---
    [
      _QuizQuestion(question: "x: 2x+5=17 විසඳන්න.", answers: ["6"], units: [""]),
      _QuizQuestion(question: "3a + 5a − 2b + 7b සරල කරන්න.", answers: ["8a + 5b"], units: [""]),
      _QuizQuestion(question: "5(x − 2) = 30 නම්, x හි අගය සොයන්න.", answers: ["8"], units: [""]),
      _QuizQuestion(question: "සංඛ්‍යා දෙකක එකතුව 29 කි.\nඑක් සංඛ්‍යාවක් අනෙකට වඩා දෙගුණයකට වඩා 5 වැඩිය.\nසංඛ්‍යා දෙක කුමක්ද? (විශාල \nසංඛ්‍යාව මුලින් සඳහන් කරන්න)", answers: ["21", "8"], units: ["", ""]),
      _QuizQuestion(question: "ප්‍රකාශනය සරල කරන්න : (4x − 2) + (3x + 5).", answers: ["7x + 3"], units: [""]),
    ],
    // --- Task 03 ---
    [
      _QuizQuestion(question: "පන්තියක පිරිමි ළමයින් හා ගැහැණු ළමයින් අතර අනුපාතය 5:3 කි.\nපිරිමි ළමයින් 40 ක් සිටී නම්, ගැහැණු ළමයින් කී දෙනෙක් සිටීද?", answers: ["24"], units: [""]),
      _QuizQuestion(question: "පොත් 8 ක් රුපියල් 240 ක් නම්, පොතකට එකම මිලකට පොත් 15 ක් කොපමණ මුදලක් වැය වේද?", answers: ["450"], units: ["rupees"]),
      _QuizQuestion(question: "වට්ටෝරුවකට පිටි කෝප්ප 2 ක් සහ සීනි කෝප්ප 3 ක් අවශ්‍ය වේ.\nපිටි කෝප්ප 6 ක් භාවිතා කරන්නේ නම් කොපමණ සීනි අවශ්‍ය වේද?", answers: ["9"], units: ["cups"]),
      _QuizQuestion(question: "x සඳහා 5/8 = x/12 අනුපාතයෙන් විසඳන්න.", answers: ["7.5"], units: [""]),
      _QuizQuestion(question: "සමීක්ෂණයක දී, තේ වලට කැමති පුද්ගලයින් සහ කෝපි වලට කැමති පුද්ගලයින් අතර අනුපාතය 7:5 කි.\nකෝපි වලට කැමති පුද්ගලයින් 70 ක් නම්, තේ වලට කැමති පුද්ගලයින් කී දෙනෙක්ද?", answers: ["98"], units: [""]),
    ],
    // --- Task 04 ---
    [
      _QuizQuestion(question: "ත්‍රිකෝණයක පාදම සෙන්ටිමීටර 13 ක් සහ උස සෙන්ටිමීටර 6 කි.\nත්‍රිකෝණයේ වර්ගඵලය කුමක්ද?", answers: ["39"], units: ["sq cm"]),
      _QuizQuestion(question: "සෘජුකෝණාස්‍රයක දිග සෙන්ටිමීටර 23 ක් සහ පළල සෙන්ටිමීටර 12 කි.\nසෘජුකෝණාස්‍රයේ පරිමිතිය කුමක්ද?", answers: ["70"], units: ["cm"]),
      _QuizQuestion(question: "උද්‍යානයක් මීටර් 37 ක් දිග සහ මීටර් 28 ක් පළල සෘජුකෝණාස්‍රයක හැඩයෙන් යුක්ත වේ.\nඋද්‍යානයේ වර්ගඵලය කොපමණද?", answers: ["1036"], units: ["sq m"]),
      _QuizQuestion(question: "සෙන්ටිමීටර 8 ක් දිග, සෙන්ටිමීටර 6 ක් පළල සහ සෙන්ටිමීටර 7 ක් උස ඝනකාභයක පරිමාව සොයන්න.", answers: ["336"], units: ["cubic cm"]),
      _QuizQuestion(question: "බස් රථයක් පැයට කිලෝමීටර 45 ක වේගයෙන් ගමන් කරයි.\nකිලෝමීටර 225 ක් ගමන් කිරීමට කොපමණ කාලයක් ගතවේද?", answers: ["5"], units: ["hours"]),
    ],
    // --- Task 05 ---
    [
      _QuizQuestion(question: "පන්තියක සිසුන් 5 දෙනෙකුගේ වයස අවුරුදු 10, 12, 14, 11 සහ 13 වේ.\nසාමාන්‍ය වයස කීයද?", answers: ["12"], units: ["years"]),
      _QuizQuestion(question: "බයිසිකල්කරුවෙකු පැය 6 කින් කිලෝමීටර 258 ක දුරක් ගමන් කරයි.\nබයිසිකල්කරුගේ සාමාන්‍ය වේගය කොපමණද?", answers: ["43"], units: ["km/h"]),
      _QuizQuestion(question: "සාප්පුවක් පොතක් රුපියල් 450 කට විකුණයි.\n20% ක වට්ටමක් ලබා දෙන්නේ නම්, පොතේ නව මිල කොපමණද?", answers: ["360"], units: ["rupees"]),
      _QuizQuestion(question: "වෙළෙන්දෙකු දොඩම් මල්ලක් රුපියල් 150 කට මිලදී ගෙන රුපියල් 180 කට විකුණයි.\nලාභ ප්‍රතිශතය කීයද?", answers: ["20"], units: ["%"]),
      _QuizQuestion(question: "භාණ්ඩයක මිල රුපියල් 500 සිට රුපියල් 600 දක්වා වැඩි වේ.\nමිලෙහි වැඩිවීමේ ප්‍රතිශතය කීයද?", answers: ["20"], units: ["%"]),
    ],
  ];

  int _selectedTaskIndex = -1;
  int _currentQuestionIndex = 0;
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

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
      grade: 7,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment, color: Colors.white, size: 30),
                const SizedBox(width: 20),
                Text(
                  "පැවරුම 0${index + 1} (Task ${index + 1})",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "ප්‍රශ්නය ${_currentQuestionIndex + 1} / 5",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
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
                return SizedBox(
                  width: 120,
                  child: _buildSingleInput(index, question.units[index]),
                );
              }),
            ),
          const SizedBox(height: 20),
          if (_isChecked)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _feedbackColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _feedbackColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _feedbackColor == Colors.green ? Icons.check_circle : Icons.error,
                    color: _feedbackColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _feedbackMessage,
                    style: TextStyle(
                      color: _feedbackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _checkAnswer,
                icon: const Icon(Icons.check),
                label: const Text("Check"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _resetQuestion,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentQuestionIndex > 0
                      ? IconButton(
                    onPressed: _prevQuestion,
                    icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.purple),
                  )
                      : const SizedBox(width: 30),
                  _currentQuestionIndex < _allTasks[_selectedTaskIndex].length - 1
                      ? IconButton(
                    onPressed: _nextQuestion,
                    icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.purple),
                  )
                      : const SizedBox(width: 30),
                ],
              ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "ප්‍රතිඵල බලන්න (View Results)",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Back to Tasks (අවසන් කරන්න)",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
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
        suffixStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.purple),
            onPressed: () {
              if (_selectedTaskIndex != -1) {
                _backToMenu();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            _selectedTaskIndex == -1 ? 'ශ්‍රේණිය 7 (Grade 7)' : 'පැවරුම 0${_selectedTaskIndex + 1}',
            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: _selectedTaskIndex == -1 ? _buildTaskMenu() : _buildQuizView(),
      ),
    );
  }
}