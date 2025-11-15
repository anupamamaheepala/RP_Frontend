import 'package:flutter/material.dart';

class DyscalculiaPage extends StatelessWidget {
  const DyscalculiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ගණනයේ දුෂ්කරතා (Dyscalculia)')),
      body: const Center(
        child: Text('This is the Dyscalculia test page',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
