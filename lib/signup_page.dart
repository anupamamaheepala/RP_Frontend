import 'package:flutter/material.dart';
import 'theme.dart';
import 'profile.dart'; // Import to navigate to Profile Page

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // State variables to track selection
  int? selectedAge;
  int? selectedGrade;

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
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // --- White Card ---
                  Container(
                    margin: const EdgeInsets.only(top: 40), // Space for floating icon
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
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
                        // Title Sinhala
                        const Text(
                          'ගිණුමක් සකසන්න',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        // Title English
                        const Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- Username Field ---
                        _buildTextField(
                          icon: Icons.person_outline,
                          hintText: 'පරිශීලක නාමය',
                        ),

                        const SizedBox(height: 15),

                        // --- Age Selection ---
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'වයස / Age 🎂',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [8, 9, 10, 11, 12].map((age) {
                            final isSelected = selectedAge == age;
                            return GestureDetector(
                              onTap: () => setState(() => selectedAge = age),
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.ageChipSelected : AppColors.ageChip,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  age.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 15),

                        // --- Grade Selection ---
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ශ්‍රේණිය / Grade 🎒',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [3, 4, 5, 6, 7].map((grade) {
                            final isSelected = selectedGrade == grade;
                            return GestureDetector(
                              onTap: () => setState(() => selectedGrade = grade),
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getGradeColor(grade),
                                  borderRadius: BorderRadius.circular(10),
                                  // Add a border if selected to make it pop
                                  border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  grade.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // --- Password Field ---
                        _buildTextField(
                          icon: Icons.lock_outline,
                          hintText: 'මුරපදය',
                          isObscure: true,
                        ),
                        const SizedBox(height: 10),

                        // --- Confirm Password Field ---
                        _buildTextField(
                          icon: Icons.lock_reset,
                          hintText: 'මුරපදය තහවුරු කරන්න',
                          isObscure: true,
                        ),

                        const SizedBox(height: 30),

                        // --- Register Button ---
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              // Slightly redder pink for the Signup button as per image
                              colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF758C).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navigate to Profile Page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                                );
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ලියාපදිංචි වන්න',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('🚀', style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Floating Icon ---
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppGradients.userIconBackground,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  // --- Back Button ---
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper: Get Color based on Grade
  Color _getGradeColor(int grade) {
    switch (grade) {
      case 3: return AppColors.grade3;
      case 4: return AppColors.grade4;
      case 5: return AppColors.grade5;
      case 6: return AppColors.grade6;
      case 7: return AppColors.grade7;
      default: return Colors.grey;
    }
  }

  // Helper: Build Text Field
  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    bool isObscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}