import 'package:flutter/material.dart';

class DyscalG07Page extends StatelessWidget {
  const DyscalG07Page({super.key});

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
          'ශ්‍රේණිය 7 (Grade 7)',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Dyscalculia Test for Grade 7',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}