import 'package:flutter/material.dart';
import '/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Disorder Checker',
      theme: ThemeData(useMaterial3: true),
      // Set the initial route to StartPage
      home: const StartPage(),
    );
  }
}