import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class IFPortalPage extends StatefulWidget {
  const IFPortalPage({super.key});

  @override
  State<IFPortalPage> createState() => _IFPortalPageState();
}

class _IFPortalPageState extends State<IFPortalPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('IF Portal'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Timeline'),
              Tab(text: 'Resources'),
              Tab(text: 'About TVC'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TimelineTab(),
            _ResourcesTab(),
            _AboutTab(),
          ],
        ),
      ),
    );
  }
}

/* ================= TAB 1 ================= */

class _TimelineTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Placeholder(
      icon: Icons.timeline,
      title: 'Internship Timeline',
      subtitle: 'Coming Soon',
    );
  }
}

/* ================= TAB 2 ================= */

class _ResourcesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Placeholder(
      icon: Icons.folder,
      title: 'Resources',
      subtitle: 'PDFs, Links & Guides',
    );
  }
}

/* ================= TAB 3 ================= */

class _AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Placeholder(
      icon: Icons.info_outline,
      title: 'About TVC',
      subtitle: 'Thapar Venture Club',
    );
  }
}

/* ============== COMMON PLACEHOLDER ============== */

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Placeholder({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.supportBlue),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
