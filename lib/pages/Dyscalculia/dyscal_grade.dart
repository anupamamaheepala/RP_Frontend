import 'package:flutter/material.dart';
import 'dyscal_g03.dart';
import 'dyscal_g04.dart';
import 'dyscal_g05.dart';
import 'dyscal_g06.dart';
import 'dyscal_g07.dart';

class DyscalGradePage extends StatelessWidget {
  const DyscalGradePage({super.key});

  // Beautiful gradient card builder
  Widget _buildGradeCard({
    required int grade,
    required List<Color> colors,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.calculate_rounded, color: Colors.white, size: 35),
        title: Text(
          "ශ්‍රේණිය $grade",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          "Grade Level",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8EC5FC), // Same background as Home/Dyslexia pages
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ගණනයේ දුෂ්කරතා – Grade Selection',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Select your grade level",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // Grade 3
              _buildGradeCard(
                grade: 3,
                colors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                context: context,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyscalG03Page()),
                  );
                },
              ),

              // Grade 4
              _buildGradeCard(
                grade: 4,
                colors: [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
                context: context,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyscalG04Page()),
                  );
                },
              ),

              // Grade 5
              _buildGradeCard(
                grade: 5,
                colors: [const Color(0xFFfa709a), const Color(0xFFfee140)],
                context: context,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyscalG05Page()),
                  );
                },
              ),

              // Grade 6
              _buildGradeCard(
                grade: 6,
                colors: [const Color(0xFFF68084), const Color(0xFF8EC5FC)],
                context: context,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyscalG06Page()),
                  );
                },
              ),

              // Grade 7
              _buildGradeCard(
                grade: 7,
                colors: [const Color(0xFFf7971e), const Color(0xFFffd200)],
                context: context,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DyscalG07Page()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}