import 'package:flutter/material.dart';
import 'dyscal_g03.dart';
import 'dyscal_g04.dart';
import 'dyscal_g05.dart';
import 'dyscal_g06.dart';
import 'dyscal_g07.dart';

class DyscalGradePage extends StatelessWidget {
  const DyscalGradePage({super.key});

  Widget _buildGradeCard({
    required int grade,
    required List<Color> gradientColors,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
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
          child: const Icon(
            Icons.calculate_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "$grade ශ්‍රේණිය",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          "Grade Level",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'ගණනයේ දුෂ්කරතා',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "ඔබගේ ශ්‍රේණිය තෝරන්න",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // GRADE CARDS
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      _buildGradeCard(
                        grade: 3,
                        gradientColors: [Colors.purple.shade400, Colors.blue.shade400],
                        context: context,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DyscalG03Page())),
                      ),
                      _buildGradeCard(
                        grade: 4,
                        gradientColors: [Colors.blue.shade400, Colors.teal.shade300],
                        context: context,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DyscalG04Page())),
                      ),
                      _buildGradeCard(
                        grade: 5,
                        gradientColors: [Colors.green.shade400, Colors.teal.shade300],
                        context: context,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DyscalG05Page())),
                      ),
                      _buildGradeCard(
                        grade: 6,
                        gradientColors: [Colors.orange.shade400, Colors.pink.shade300],
                        context: context,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DyscalG06Page())),
                      ),
                      _buildGradeCard(
                        grade: 7,
                        gradientColors: [Colors.deepPurple.shade400, Colors.indigo.shade400],
                        context: context,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DyscalG07Page())),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}