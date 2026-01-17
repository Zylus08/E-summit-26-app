import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/buttons.dart';

class SpeakerDetailPage extends StatelessWidget {
  const SpeakerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaker Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 80,
              backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop'),
              backgroundColor: AppColors.brandBlue,
            ),
            const SizedBox(height: 24),
            
            // Name & Role
            Text(
              'Dr. Sarah Connor',
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'AI Researcher & Tech Visionary',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.secondaryAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // About Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('About', style: AppTypography.heading3),
            ),
            const SizedBox(height: 16),
            Text(
              'Dr. Sarah Connor is a leading expert in Artificial Intelligence and its application in modern entrepreneurship. With over 15 years of experience, she has led groundbreaking research at top tech institutes and founded two successful AI startups.',
              style: AppTypography.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: 40),

            // LinkedIn CTA
            SecondaryButton(
              text: 'Connect on LinkedIn',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
