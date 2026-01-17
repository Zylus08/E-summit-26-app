import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/buttons.dart';
import '../widgets/cards.dart';
import '../widgets/ui_elements.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image with Overlay
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.darkContrast.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LiveBadge(),
                        const SizedBox(height: 8),
                        Text(
                          'Innovation in the Age of AI',
                          style: AppTypography.heading2.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover how AI is reshaping the entrepreneurial landscape.',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.supportBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.secondaryAccent, size: 20),
                      const SizedBox(width: 8),
                      Text('March 15, 2026', style: AppTypography.bodyMedium),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: AppColors.secondaryAccent, size: 20),
                      const SizedBox(width: 8),
                      Text('10:00 AM', style: AppTypography.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.secondaryAccent, size: 20),
                      const SizedBox(width: 8),
                      Text('Main Auditorium, Tech City', style: AppTypography.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // CTA Block
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'BUY TICKET',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      AddToCalendarChip(onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Notify me 30min before', style: AppTypography.bodySmall),
                      const Spacer(),
                      NotificationToggle(value: true, onChanged: (val) {}),
                    ],
                  ),
                  const Divider(height: 48),

                  // About Section
                  Text('About Event', style: AppTypography.heading3),
                  const SizedBox(height: 8),
                  Text(
                    'Join us for an immersive session on the future of Artificial Intelligence in business. Industry leaders will share insights on leveraging AI for growth, innovation, and operational efficiency.',
                    style: AppTypography.bodyMedium.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 32),

                  // Speakers Preview
                  Text('Speakers', style: AppTypography.heading3),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: SpeakerCard(
                            name: 'Dr. Sarah Connor',
                            role: 'AI Researcher',
                            imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop',
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
