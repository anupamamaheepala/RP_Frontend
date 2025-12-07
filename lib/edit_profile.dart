import 'package:flutter/material.dart';
import 'theme.dart';
import 'profile.dart'; // To navigate back

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Mock Data
  int selectedAge = 9;
  int selectedGrade = 4;
  final TextEditingController _usernameController = TextEditingController(text: 'Username');

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
                padding: const EdgeInsets.all(24),
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
                    // --- Header Icon ---
                    const Icon(Icons.settings, size: 50, color: Color(0xFF9FA8DA)), // Light purple/blue gear
                    const SizedBox(height: 10),

                    // --- Header Text ---
                    const Text(
                      'පැතිකඩ සංස්කරණය',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D0050),
                      ),
                    ),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Avatar with Camera Icon ---
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.avatarBorder,
                          ),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFFE0E0E0),
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D3436), // Dark background for icon
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // --- Username Field ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username / පරිශීලක නාමය',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F6FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Age Selection ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ඔබේ වයස / Your Age 🎂',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [8, 9, 10, 11, 12].map((age) {
                        final isSelected = selectedAge == age;
                        return GestureDetector(
                          onTap: () => setState(() => selectedAge = age),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white, // Both white per design?
                              // Actually design shows white chips with shadows, maybe highlight border
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? Border.all(color: Colors.purple, width: 2) : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              age.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // --- Grade Selection ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ශ්‍රේණිය / Grade 📚',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [3, 4, 5, 6, 7].map((grade) {
                        final isSelected = selectedGrade == grade;
                        return GestureDetector(
                          onTap: () => setState(() => selectedGrade = grade),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: _getGradeColor(grade),
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              grade.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // --- Save Changes Button ---
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: AppGradients.greenAction, // Use the green gradient
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2ED573).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Navigate back to ProfilePage
                            // Using pushReplacement to refresh state if needed, or pop
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
                                'වෙනස්කම් සුරකින්න / Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                            ],
                          ),
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
}