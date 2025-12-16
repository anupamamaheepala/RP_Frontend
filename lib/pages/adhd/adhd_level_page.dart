import 'package:flutter/material.dart';

class ADHDLevelPage extends StatelessWidget {
  final int grade;

  const ADHDLevelPage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'අවධාන ඌණතා – ශ්‍රේණිය $grade',
          style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "ADHD/ADD Diagnostic Tasks",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Selected Grade: $grade",
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),

            // Dummy placeholder content – this is where your real diagnostic tasks will go
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.psychology_alt_rounded,
                        size: 80,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "ADHD Diagnostic Tasks Coming Soon!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "This page will contain grade-appropriate tasks to assess:\n"
                            "• Sustained attention\n"
                            "• Impulse control\n"
                            "• Working memory\n"
                            "• Hyperactivity indicators",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                  Text(
                        "You selected Grade grade– tasks will be adjusted to this level.",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Dummy "Start Assessment" button (you can make it functional later)
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Assessment will start here!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf7971e),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Start Assessment",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}