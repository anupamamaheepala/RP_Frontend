import 'package:flutter/material.dart';

class ADHDPage extends StatelessWidget {
  const ADHDPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('අධිමානසික නෝයීන්තා (ADHD)')),
      body: const Center(
        child: Text('This is the ADHD test page',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
