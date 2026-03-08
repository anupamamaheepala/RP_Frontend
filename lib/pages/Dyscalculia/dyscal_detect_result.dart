import 'package:flutter/material.dart';

class DyscalDetectResultPage extends StatefulWidget {
  const DyscalDetectResultPage({super.key});

  @override
  State<DyscalDetectResultPage> createState() => _DyscalDetectResultPageState();
}

class _DyscalDetectResultPageState extends State<DyscalDetectResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'හඳුනාගැනීමේ ප්‍රතිඵල',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Detection History will load here...",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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