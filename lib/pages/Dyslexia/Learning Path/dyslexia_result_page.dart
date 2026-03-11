import 'package:flutter/material.dart';

class DyslexiaDetectResultPage extends StatelessWidget {
  const DyslexiaDetectResultPage({super.key});

  Color _riskColor(String level) {
    switch (level) {
      case "LOW":
        return Colors.green;
      case "MEDIUM":
        return Colors.orange;
      case "HIGH":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _metric(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Widget _resultCard() {
    final riskLevel = "LOW";
    final riskText = "අවම ඩිස්ලෙක්සියා අවදානමක්";

    final color = _riskColor(riskLevel);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "ශ්‍රේණිය 3 - Reading Task",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "2026-03-09",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),

          const Divider(height: 18),

          /// Risk message
          Row(
            children: [
              Icon(Icons.error_outline, color: color),
              const SizedBox(width: 6),
              Text(
                riskText,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Metrics row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metric("4/5", "Accuracy"),
              _metric("6", "Wrong Words"),
              _metric("180s", "Time"),
              _metric("28.2s", "Hesitation"),
            ],
          ),

          const SizedBox(height: 16),

          /// Metrics row 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metric("5", "Tasks"),
              // _metric("1", "Skips"),
              // _metric("0", "Backtracks"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "ඩිස්ලෙක්සියා ප්‍රතිඵල",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// Header
              _header(context),

              const SizedBox(height: 10),

              /// Result cards
              Expanded(
                child: ListView(
                  children: [
                    _resultCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}