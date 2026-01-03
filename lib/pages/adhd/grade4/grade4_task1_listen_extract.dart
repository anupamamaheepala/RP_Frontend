// lib/adhd/grade4/grade4_task1_listen_extract.dart
import 'package:flutter/material.dart';
import 'grade4_success_page.dart';
import 'grade4_task2_stop_go_signals.dart';

class Grade4Task1ListenExtract extends StatefulWidget {
  const Grade4Task1ListenExtract({super.key});

  @override
  _Grade4Task1ListenExtractState createState() => _Grade4Task1ListenExtractState();
}

class _Grade4Task1ListenExtractState extends State<Grade4Task1ListenExtract> {
  int currentQuestion = 0;
  int correctCount = 0;
  int replayCount = 0;

  final List<Map<String, String>> tasks = [
    {
      'message': 'The bird is blue and flies high in the sky.',
      'question': 'What color is the bird?',
      'answer': 'blue',
    },
    {
      'message': 'The car is red and has four wheels.',
      'question': 'How many wheels does the car have?',
      'answer': 'four',
    },
    {
      'message': 'The tree is tall and has green leaves.',
      'question': 'What color are the leaves?',
      'answer': 'green',
    },
    {
      'message': 'My dog has three white spots on his black fur.',
      'question': 'How many white spots does the dog have?',
      'answer': 'three',
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _checkAnswer() {
    String userAnswer = _controller.text.trim().toLowerCase();
    String correct = tasks[currentQuestion]['answer']!.toLowerCase();

    if (userAnswer == correct) {
      correctCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correct! 🎉'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Try again! Answer: "$correct"'), backgroundColor: Colors.orange),
      );
    }

    _controller.clear();

    if (currentQuestion < tasks.length - 1) {
      setState(() {
        currentQuestion++;
        replayCount = 0;
      });
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Grade4SuccessPage(
            taskNumber: '1',
            nextPage: Grade4Task2StopGoSignals(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = tasks[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Task 1: Listen & Answer', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(  // ← THIS FIXES THE OVERFLOW!
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,  // Changed to start for better scrolling
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Listen to the sentence, then answer the question!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    task['message']!,
                    style: const TextStyle(fontSize: 22, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () => setState(() => replayCount++),
                child: const Icon(Icons.volume_up, size: 40),
              ),
              const SizedBox(height: 12),
              const Text('Tap to hear the sentence again', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Replays this question: $replayCount', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              Text(
                task['question']!,
                style: const TextStyle(fontSize: 28, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _checkAnswer(),
                decoration: const InputDecoration(
                  hintText: 'Type your answer here',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16)),
                child: const Text('Submit Answer', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 30),
              Text('Question ${currentQuestion + 1} of ${tasks.length}', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}