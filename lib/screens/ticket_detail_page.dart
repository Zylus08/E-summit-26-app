import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/buttons.dart';

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Ticket Visual
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code_2, size: 200, color: Colors.black),
                  const SizedBox(height: 16),
                  Text(
                    'ES26-8842-9931',
                    style: AppTypography.monoLarge.copyWith(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Event Metadata
            Text(
              'E-SUMMIT\'26 Full Access',
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'March 15-17, 2026 • Innovation Hub',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.supportBlue),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            // Actions
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Download PDF',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SecondaryButton(
                    text: 'Share Ticket',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
