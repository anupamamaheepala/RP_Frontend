import 'package:flutter/material.dart';

class DysgraphiaPage extends StatelessWidget {
  const DysgraphiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ලිවීමේ දුෂ්කරතා (Dysgraphia)')),
      body: const Center(
        child: Text('This is the Dysgraphia test page',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
