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
        // FIXED: Increased size from 200 to 220 to prevent overflow
        width: 220,
        height: 220,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Colors.white),
            // Adjusted spacing slightly to fit content better
            const SizedBox(height: 10),
            Text(
              titleSi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              titleEn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // REMOVED: "Choose an Option" text was here

                const SizedBox(height: 20),

                // Button 1: Detect Dyscalculia
                _buildSquareButton(
                  context: context,
                  titleSi: 'දුෂ්කරතා හඳුනාගැනිම',
                  titleEn: 'Detect Dyscalculia',
                  icon: Icons.search_rounded,
                  gradient: AppGradients.mathDetect,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DyscalGradePage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40), // Spacing between vertical buttons

                // Button 2: Improve Skills
                _buildSquareButton(
                  context: context,
                  titleSi: 'හැකියාවන් දියුණු කිරීම',
                  titleEn: 'Improve Maths Skills',
                  icon: Icons.trending_up_rounded,
                  gradient: AppGradients.mathImprove,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DyscalImprovePage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}