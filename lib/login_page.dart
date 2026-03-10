import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rp_frontend/utils/sessions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'theme.dart';
import 'profile.dart';
import 'signup_page.dart';
import '/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse("${Config.baseUrl}/auth/login");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      debugPrint("🔵 [LOGIN] Attempting login...");
      debugPrint("🔵 [LOGIN] URL: $url");
      debugPrint("🔵 [LOGIN] Username: ${_usernameController.text.trim()}");
      debugPrint("🔵 [LOGIN] Password length: ${_passwordController.text.length}");
      debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "password": _passwordController.text,
        }),
      );

      debugPrint("🟡 [LOGIN] Status Code: ${response.statusCode}");
      debugPrint("🟡 [LOGIN] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("🟢 [LOGIN] Success! user_id: ${data['user_id']}");
        debugPrint("🟢 [LOGIN] Username: ${data['username']}");
        debugPrint("🟢 [LOGIN] Grade: ${data['grade']}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', data['user_id']);
        await prefs.setString('username', data['username']);
        await prefs.setInt('age', data['age']);
        await prefs.setInt('grade', data['grade']);
        await prefs.setString('avatar_image', data['avatar_image'] ?? "plogo1");
        await Session.load();

        debugPrint("🟢 [LOGIN] Session saved to SharedPreferences");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful! (සාර්ථකයි!)"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      } else {
        debugPrint("🔴 [LOGIN] Failed with status: ${response.statusCode}");
        debugPrint("🔴 [LOGIN] Error body: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login failed (${response.statusCode}): ${response.body}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint("🔴 [LOGIN] Exception caught: $e");
      debugPrint("🔴 [LOGIN] StackTrace: $stackTrace");
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
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
                          'පිවිසෙන්න',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const Text(
                          'Sign In to your account',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),

                        _buildTextField(
                          controller: _usernameController,
                          icon: Icons.person_outline,
                          hintText: 'පරිශීලක නාමය (Username)',
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hintText: 'මුරපදය (Password)',
                          isObscure: true,
                        ),
                        const SizedBox(height: 30),

                        _isLoading
                            ? const CircularProgressIndicator()
                            : Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryButton,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF764BA2).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _handleLogin,
                              borderRadius: BorderRadius.circular(30),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('🚀', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 8),
                                  Text(
                                    'ඇතුල් වන්න',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'ගිණුමක් නොමැතිද? / Don\'t have an account?',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEFEFEF),
                              foregroundColor: Colors.purple,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'ලියාපදිංචි වන්න',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                        gradient: AppGradients.iconBackground,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.vpn_key_rounded,
                            color: Colors.white, size: 40),
                      ),
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