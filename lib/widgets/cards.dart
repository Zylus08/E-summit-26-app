import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'buttons.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280, // Fixed width for horizontal scrolling
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl), // Placeholder or actual
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
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
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: AppTypography.heading3.copyWith(color: AppColors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.secondaryAccent),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.supportBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.secondaryAccent),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.supportBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: PrimaryButton(
                      text: 'View Details',
                      onPressed: onTap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeakerCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final VoidCallback? onLinkedInTap;

  const SpeakerCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    this.onLinkedInTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.supportBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.supportBlue.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: AppColors.brandBlue,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (onLinkedInTap != null)
            GestureDetector(
              onTap: onLinkedInTap,
              child: const Icon(
                Icons.link, // Using link icon as placeholder for LinkedIn
                color: AppColors.brandBlue,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String eventName;
  final String ticketType;
  final String ticketId;
  final String date;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.eventName,
    required this.ticketType,
    required this.ticketId,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.supportBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.supportBlue.withOpacity(0.3)),
        ),
        child: Stack(
          children: [
            // Blueprint background effect (subtle grid or lines could be added here)
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.qr_code_2,
                size: 120,
                color: AppColors.white.withOpacity(0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // QR Block
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.qr_code, color: AppColors.black, size: 50),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          style: AppTypography.heading3,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ticketType.toUpperCase(),
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.secondaryAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: $ticketId',
                          style: AppTypography.monoSmall.copyWith(color: AppColors.supportBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
