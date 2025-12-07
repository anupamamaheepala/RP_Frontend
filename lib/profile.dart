import 'package:flutter/material.dart';
import '../theme.dart';
import 'pages/home_page.dart';
import 'edit_profile.dart'; // Import Edit Profile Page

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.mainBackground,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Avatar Section ---
                    Container(
                      padding: const EdgeInsets.all(4), // Border width
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.avatarBorder,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4), // White gap
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFFE0E0E0),
                          // Use an asset image for the boy avatar if available
                          // backgroundImage: AssetImage('assets/avatar_boy.png'),
                          child: Icon(Icons.person, size: 80, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --- Username ---
                    const Text(
                      'username',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D0050), // Deep purple/black
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Info Chips (Age & Grade) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoChip('Age: 9 🎂'),
                        const SizedBox(width: 16),
                        _buildInfoChip('Grade: 4 📚'),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- Green Action Button (Select Learning Difficulty) ---
                    Container(
                      width: double.infinity,
                      height: 80, // Taller button
                      decoration: BoxDecoration(
                        gradient: AppGradients.greenAction,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigate to HomePage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.psychology, color: Colors.white, size: 28),
                              SizedBox(height: 4),
                              Text(
                                'ඉගෙනුම් දුෂ්කරතා තෝරන්න',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Select Learning Difficulty',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Edit Profile Button ---
                    TextButton.icon(
                      onPressed: () {
                        // Navigate to EditProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.settings, size: 18, color: Colors.black54),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}