import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';
import 'login_page.dart';
import '/config.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int? selectedAge;
  int? selectedGrade;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        selectedAge == null ||
        selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Please fill all fields (කරුණාකර සියලුම විස්තර පුරවන්න)")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Passwords do not match (මුරපද නොගැලපේ)")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse("${Config.baseUrl}/auth/signup");
      final body = jsonEncode({
        "username": _usernameController.text.trim(),
        "password": _passwordController.text,
        "age": selectedAge,
        "grade": selectedGrade,
      });

      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("🔵 [SIGNUP] Attempting signup...");
      debugPrint("🔵 [SIGNUP] URL: $url");
      debugPrint("🔵 [SIGNUP] Body: $body");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      debugPrint("🟡 [SIGNUP] Status Code: ${response.statusCode}");
      debugPrint("🟡 [SIGNUP] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("🟢 [SIGNUP] Account created successfully!");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Account created! Please Login. (ගිණුම සාදන ලදී. කරුණාකර ඇතුල් වන්න.)"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } else {
        debugPrint("🔴 [SIGNUP] Failed with status: ${response.statusCode}");
        debugPrint("🔴 [SIGNUP] Error body: ${response.body}");
        final responseBody = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['detail'] ?? "Signup failed (${response.statusCode})"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint("🔴 [SIGNUP] Exception caught: $e");
      debugPrint("🔴 [SIGNUP] StackTrace: $stackTrace");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Connection Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: Center(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'ගිණුමක් සකසන්න',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const Text(
                          'Create an account',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _usernameController,
                          icon: Icons.person_outline,
                          hintText: 'පරිශීලක නාමය (Username)',
                        ),
                        const SizedBox(height: 15),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'වයස / Age 🎂',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
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
                                  color: isSelected
                                      ? AppColors.ageChipSelected
                                      : AppColors.ageChip,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  age.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 15),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ශ්‍රේණිය / Grade 🎒',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [3, 4, 5, 6, 7].map((grade) {
                            final isSelected = selectedGrade == grade;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedGrade = grade),
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _getGradeColor(grade),
                                  borderRadius: BorderRadius.circular(10),
                                  border: isSelected
                                      ? Border.all(
                                      color: Colors.black, width: 2.5)
                                      : null,
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

                        _buildTextField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hintText: 'මුරපදය (Password)',
                          isObscure: true,
                        ),
                        const SizedBox(height: 10),

                        _buildTextField(
                          controller: _confirmPasswordController,
                          icon: Icons.lock_reset,
                          hintText: 'මුරපදය තහවුරු කරන්න',
                          isObscure: true,
                        ),
                        const SizedBox(height: 30),

                        _isLoading
                            ? const CircularProgressIndicator()
                            : Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF758C),
                                Color(0xFFFF7EB3)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF758C)
                                    .withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _handleSignup,
                              borderRadius: BorderRadius.circular(30),
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
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
                                  Text('🚀',
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                        child: Icon(Icons.person_add,
                            color: Colors.white, size: 40),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.purple, size: 28),
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

  Widget _buildTextField({
    required TextEditingController controller,
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
        controller: controller,
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