import 'package:flutter/material.dart';

class Activity4 extends StatefulWidget {
  final String text;  // Text the student read

  const Activity4({super.key, required this.text});

  @override
  _Activity4State createState() => _Activity4State();
}

class _Activity4State extends State<Activity4> {
  final TextEditingController _answerController = TextEditingController();
  bool _isAnswered = false;
  int _score = 0;
  final List<Map<String, String>> _questions = [
    {
      "question": "What is the main subject of the text?",
      "answer": "fox",
    },
    {
      "question": "Which animal jumped over the lazy dog?",
      "answer": "fox",
    },
  ];

  // Function to check the student's answer
  void _checkAnswer(String studentAnswer, String correctAnswer) {
    setState(() {
      _isAnswered = true;
      if (studentAnswer.toLowerCase().trim() == correctAnswer.toLowerCase()) {
        _score += 1; // Increase score if the answer is correct
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 4 - Comprehension Questions'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.text,  // Display the text that the student read
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              "Answer the following questions based on the text above:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Display questions
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _questions[index]["question"]!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: "Type your answer here...",
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Check answer and move to next question
                          _checkAnswer(_answerController.text, _questions[index]["answer"]!);
                        },
                        child: const Text("Submit Answer"),
                      ),
                      const SizedBox(height: 20),
                      _isAnswered
                          ? Text(
                        _answerController.text.toLowerCase() == _questions[index]["answer"]!.toLowerCase()
                            ? "Correct!"
                            : "Wrong Answer. The correct answer is: ${_questions[index]["answer"]}",
                        style: TextStyle(
                          fontSize: 16,
                          color: _answerController.text.toLowerCase() == _questions[index]["answer"]!.toLowerCase()
                              ? Colors.green
                              : Colors.red,
                        ),
                      )
                          : const SizedBox(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Show score after the last question
            ElevatedButton(
              onPressed: () {
                // Show score on final submission
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Your Score"),
                      content: Text("Your Score: $_score/${_questions.length}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Finish Activity"),
            ),
          ],
        ),
      ),
    );
  }
}