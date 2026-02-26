import 'package:flutter/material.dart';

import 'G3_L1_Low_A4.dart';

class Activity3 extends StatefulWidget {
  final String text;  // Text to be read independently

  const Activity3({super.key, required this.text});

  @override
  _Activity3State createState() => _Activity3State();
}

class _Activity3State extends State<Activity3> {
  double _wpm = 0.0;  // Words per minute
  int _correctWords = 0;
  int _totalWords = 0;
  final TextEditingController _controller = TextEditingController();

  // Function to calculate WPM
  void _calculateWpm() {
    String userInput = _controller.text;
    List<String> inputWords = userInput.split(" ");
    _totalWords = widget.text.split(" ").length;
    _correctWords = 0;

    for (int i = 0; i < inputWords.length; i++) {
      if (inputWords[i] == widget.text.split(" ")[i]) {
        _correctWords++;
      }
    }

    setState(() {
      _wpm = (_correctWords / 1.0);  // Calculate WPM (time can be added later)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 3 - Independent Reading'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.text,  // Display the text to be read independently
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Type what you read",
              ),
              onChanged: (value) {
                _calculateWpm();
              },
            ),
            const SizedBox(height: 20),
            Text("Your WPM: $_wpm"),
            const SizedBox(height: 20),
            // Next button to go to the next activity
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Activity4(text: widget.text),  // Navigate to next activity
                  ),
                );
              },
              child: const Text("Next Activity"),
            ),
          ],
        ),
      ),
    );
  }
}