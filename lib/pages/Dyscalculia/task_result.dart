import 'package:flutter/material.dart';

class TaskResultPage extends StatelessWidget {
  const TaskResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC), // Matches app theme
      appBar: AppBar(
        title: const Text(
          "ප්‍රතිඵල (Results)",
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "නියමයි! (Great Job!)",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "ඔබ මෙම පැවරුම සාර්ථකව අවසන් කළා.\n(You have successfully completed this task.)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
                child: const Text("ආපසු (Back)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}