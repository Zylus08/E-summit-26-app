import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/cards.dart';

class SpeakersPage extends StatelessWidget {
  const SpeakersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speakers'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search speakers...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.supportBlue),
                prefixIcon: const Icon(Icons.search, color: AppColors.supportBlue),
                filled: true,
                fillColor: AppColors.supportBlue.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
            ),
          ),

          // Speakers Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return SpeakerCard(
                  name: 'Dr. Sarah Connor',
                  role: 'AI Researcher',
                  imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop',
                  onLinkedInTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
