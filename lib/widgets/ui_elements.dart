import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class NotificationToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      onChanged: widget.onChanged,
      activeColor: AppColors.secondaryAccent,
      activeTrackColor: AppColors.secondaryAccent.withOpacity(0.3),
      inactiveThumbColor: AppColors.supportBlue,
      inactiveTrackColor: AppColors.darkContrast,
    );
  }
}

class AddToCalendarChip extends StatelessWidget {
  final VoidCallback onTap;

  const AddToCalendarChip({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.supportBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.supportBlue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.supportBlue),
            const SizedBox(width: 6),
            Text(
              'Add to Calendar',
              style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownBadge extends StatelessWidget {
  final String time;

  const CountdownBadge({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkContrast,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.secondaryAccent),
      ),
      child: Text(
        time,
        style: AppTypography.monoMedium.copyWith(color: AppColors.secondaryAccent),
      ),
    );
  }
}

class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondaryAccent),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryAccent.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.secondaryAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'LIVE',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.secondaryAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
