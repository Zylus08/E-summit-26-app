import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/cards.dart';
import '../widgets/ui_elements.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-SUMMIT\'26'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: AppTypography.bodySmall),
                      Text('Innovator', style: AppTypography.heading2),
                    ],
                  ),
                  const LiveBadge(),
                ],
              ),
              const SizedBox(height: 24),

              // Upcoming Events Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcoming Events', style: AppTypography.heading3),
                  TextButton(
                    onPressed: () {Navigator.pushNamed(context, '/events');},
                    child: Text('View All', style: AppTypography.bodySmall.copyWith(color: AppColors.brandBlue)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return EventCard(
                      title: 'Future of AI in Entrepreneurship',
                      date: 'March 15, 10:00 AM',
                      location: 'Main Auditorium',
                      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop',
                      onTap: () {
                         Navigator.pushNamed(context, '/event_detail');
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Quick Actions Grid
              Text('Quick Actions', style: AppTypography.heading3),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildQuickAction(context, 'Speakers', Icons.mic, '/speakers'),
                  _buildQuickAction(context, 'Startups', Icons.rocket_launch, '/startups'), // Placeholder route
                  _buildQuickAction(context, 'Internship Fair', Icons.business_center, '/internship_fair'),
                  _buildQuickAction(context, 'Timeline', Icons.timeline, '/timeline'), // Placeholder route
                ],
              ),
              const SizedBox(height: 80), // Space for floating CTA
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.pushNamed(context, '/tickets');
        },
        backgroundColor: AppColors.primaryAccent,
        icon: const Icon(Icons.confirmation_number, color: AppColors.white),
        label: Text('BUY TICKETS', style: AppTypography.buttonText.copyWith(fontSize: 14)),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.supportBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.supportBlue.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.brandBlue, size: 32),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
