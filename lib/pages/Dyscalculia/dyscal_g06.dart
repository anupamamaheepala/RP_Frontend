import 'package:flutter/material.dart';

class DyscalG06Page extends StatelessWidget {
  const DyscalG06Page({super.key});

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
          'ශ්‍රේණිය 6 (Grade 6)',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Dyscalculia Test for Grade 6',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}