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
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 220,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Translucent Icon Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              titleSi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
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

              // BODY CONTENT
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          // Button 1: Detect Dyscalculia (Purple Theme)
                          _buildSquareButton(
                            context: context,
                            titleSi: 'දුෂ්කරතා හඳුනාගැනිම',
                            titleEn: 'Detect Dyscalculia',
                            icon: Icons.search_rounded,
                            gradientColors: [
                              Colors.purple.shade400,
                              Colors.blue.shade400
                            ],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DyscalGradePage(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30), // Spacing between buttons

                          // Button 2: Improve Skills (Orange/Pink Theme for contrast)
                          _buildSquareButton(
                            context: context,
                            titleSi: 'හැකියාවන් දියුණු කිරීම',
                            titleEn: 'Improve Maths Skills',
                            icon: Icons.trending_up_rounded,
                            gradientColors: [
                              Colors.orange.shade400,
                              Colors.pink.shade300
                            ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}