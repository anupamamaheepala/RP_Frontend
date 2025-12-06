import 'package:flutter/material.dart';
import '/theme.dart'; // Ensure theme.dart is imported
import 'Dyscalculia/dyscal_grade.dart'; // Import for Detect page
import 'Dyscalculia/dyscal_improve.dart'; // Import for Improve page

class DyscalculiaPage extends StatelessWidget {
  const DyscalculiaPage({super.key});

  Widget _buildSquareButton({
    required BuildContext context,
    required String titleSi,
    required String titleEn,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              titleSi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14, // Slightly smaller to fit Sinhala text
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              titleEn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matching the Home Page background color
      backgroundColor: const Color(0xFF8EC5FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ගණනයේ දුෂ්කරතා',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Choose an Option",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // Row containing the two square buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button 1: Detect Dyscalculia
                  _buildSquareButton(
                    context: context,
                    titleSi: 'දුෂ්කරතා හඳුනාගැනිම',
                    titleEn: 'Detect Dyscalculia',
                    icon: Icons.search_rounded,
                    gradient: AppGradients.mathDetect, // Pink/Yellow
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DyscalGradePage(),
                        ),
                      );
                    },
                  ),

                  // Button 2: Improve Skills
                  _buildSquareButton(
                    context: context,
                    titleSi: 'හැකියාවන් දියුණු කිරීම',
                    titleEn: 'Improve Maths Skills',
                    icon: Icons.trending_up_rounded,
                    gradient: AppGradients.mathImprove, // Purple/Blue
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DyscalImprovePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}