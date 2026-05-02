// screens/dysgraphia_dashboard_main.dart
// Main entry screen — handles data fetching and tab routing only.
// All UI is delegated to tab screens and components.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart';
import '/utils/sessions.dart';
import '../theme/app_theme.dart';
import 'tabs/overview_tab.dart';
import 'tabs/journey_tab.dart';
import 'tabs/activities_tab.dart';
import 'tabs/insights_tab.dart';

class DysgraphiaDashboardMain extends StatefulWidget {
  const DysgraphiaDashboardMain({super.key});

  @override
  State<DysgraphiaDashboardMain> createState() => _DysgraphiaDashboardMainState();
}

class _DysgraphiaDashboardMainState extends State<DysgraphiaDashboardMain> {
  bool _loading = true;
  bool _showXAI = false;
  Map<String, dynamic>? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    setState(() => _loading = true);
    try {
      final userId = Session.userId;
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/dysgraphia-improvement/user-results/$userId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body);
          _loading = false;
        });
      } else {
        setState(() {
          _error = "දත්ත ලබා ගැනීමට අපොහොසත් විය";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 60, color: AppTheme.textSecondary),
              const SizedBox(height: 16),
              Text(_error!, style: AppTheme.bodyRegular, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchResults,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                child: const Text("නැවත උත්සාහ කරන්න"),
              ),
            ],
          ),
        ),
      );
    }

    final summary  = _data!['summary']  as Map<String, dynamic>;
    final sessions = _data!['sessions'] as List<dynamic>? ?? [];
    final total    = _data!['total_sessions'] as int? ?? 0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            // Tab 1 – Overview
            OverviewTab(
              summary: summary,
              totalSessions: total,
              onRefresh: _fetchResults,
              showXAI: _showXAI,
            ),
            // Tab 2 – Journey (historical trends)
            JourneyTab(
              sessions: sessions,
              summary: summary,
            ),
            // Tab 3 – Activities (per-activity breakdown)
            ActivitiesTab(
              summary: summary,
              sessions: sessions,
            ),
            // Tab 4 – Insights (AI-driven recommendations)
            InsightsTab(
              summary: summary,
              sessions: sessions,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.cardBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ප්‍රගති වාර්තාව",
            style: AppTheme.headingMedium.copyWith(color: AppTheme.primary),
          ),
          Text("Progress Dashboard", style: AppTheme.labelSmall),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.primary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              Text(
                "AI",
                style: AppTheme.labelSmall.copyWith(
                  color: _showXAI ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Switch(
                value: _showXAI,
                onChanged: (val) => setState(() => _showXAI = val),
                activeColor: AppTheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: const TabBar(
            isScrollable: false,
            indicatorColor: AppTheme.primary,
            indicatorWeight: 3,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            tabs: [
              Tab(icon: Icon(Icons.dashboard_rounded,    size: 18), text: "Overview"),
              Tab(icon: Icon(Icons.timeline_rounded,     size: 18), text: "Journey"),
              Tab(icon: Icon(Icons.sports_esports_rounded, size: 18), text: "Activities"),
              Tab(icon: Icon(Icons.psychology_rounded,   size: 18), text: "Insights"),
            ],
          ),
        ),
      ),
    );
  }
}