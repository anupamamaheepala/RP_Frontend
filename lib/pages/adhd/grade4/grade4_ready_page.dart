// lib/adhd/grade4/grade4_ready_page.dart
import 'package:flutter/material.dart';
import 'grade4_task1_listen_extract.dart';

class Grade4ReadyPage extends StatelessWidget {
  const Grade4ReadyPage({super.key});

  // 60-30-10 වර්ණ පද්ධතිය
  static const Color color60 = Color(0xFFF8FAFC); // 60% - පසුබිම (සන්සුන් ලා වර්ණයක්)
  static const Color color30 = Color(0xFF0288D1); // 30% - ද්විතීයික (නිල්)
  static const Color color10 = Color(0xFFF59E0B); // 10% - උද්දීපන (තැඹිලි)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color60,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: color30, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'ශ්‍රේණිය 4 - ක්‍රියාකාරකම්',
          style: TextStyle(color: color30, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // දරුවාගේ උනන්දුව වැඩි කිරීමට රූපයක් හෝ අයිකනයක්

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: color30.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: const Icon(Icons.rocket_launch_rounded, size: 80, color: color10),
              ),
              const SizedBox(height: 40),

              const Text(
                'ඔබ සූදානම්ද?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: color30,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // කාර්යය පිළිබඳ පැහැදිලි විස්තරයක්
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color30.withOpacity(0.1)),
                ),
                child: const Text(
                  'අද අපිට පුංචි ක්‍රියාකාරකම් 4ක් තියෙනවා. අපි බලමු ඒවා ඔයා කොහොමද කරන්නේ කියලා!',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),

              // ආරම්භක බොත්තම (10% Rule - Call to Action)
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Grade4Task1ListenExtract()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color10,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: color10.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'දැන්ම පටන් ගනිමු!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.play_circle_fill, size: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // කුඩා දිරිගැන්වීමක්
              const Text(
                'උත්සාහ කරන්න, ඔයාට පුළුවන්! 🌟',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}