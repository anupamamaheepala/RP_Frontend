import 'package:flutter/material.dart';

class G3_L1_Medium_A3 extends StatefulWidget {
  final List<String> sentences;

  const G3_L1_Medium_A3({super.key, required this.sentences});

  @override
  _G3_L1_Medium_A3State createState() => _G3_L1_Medium_A3State();
}

class _G3_L1_Medium_A3State extends State<G3_L1_Medium_A3> {
  int _currentRound = 0;
  int _tapCount = 0;

  void _onTap() {
    setState(() {
      _tapCount++;
    });
  }

  void _nextRound() {
    if (_currentRound < widget.sentences.length - 1) {
      setState(() {
        _currentRound++;
        _tapCount = 0;  // Reset tap count for the next round
      });
    } else {
      Navigator.pop(context, true); // Finished the activity
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.sentences[_currentRound];
    final syllables = word.split("");  // Split word into syllables for tapping
    final requiredTaps = syllables.length;  // Expect one tap per syllable

    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 3 - Tap the Syllables"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Round ${_currentRound + 1}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              word,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "Tap the syllables: $_tapCount / $requiredTaps",
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _onTap,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Tap Here for Each Syllable",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _tapCount == requiredTaps ? _nextRound : null,
              child: const Text("Next Round"),
            ),
          ],
        ),
      ),
    );
  }
}