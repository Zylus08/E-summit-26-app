import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/buttons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Blueprint Overlay
          Image.network(
            'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop', // Futuristic tech background
            fit: BoxFit.cover,
          ),
          
          // Dark Overlay
          Container(
            color: AppColors.darkContrast.withOpacity(0.85),
          ),

          // Animated Grid/Blueprint Lines (Subtle)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: GridPainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'E-SUMMIT\'26',
                  style: AppTypography.heading1.copyWith(
                    fontSize: 48,
                    color: AppColors.primaryAccent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'INNOVATION LAB\nTRANSFORMED',
                  style: AppTypography.heading2.copyWith(
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Bold yet controlled. Futuristic yet serious.\nThe entrepreneurship companion you need.',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.supportBlue,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.secondaryAccent, size: 20),
                    const SizedBox(width: 8),
                    Text('March 15-17, 2026', style: AppTypography.monoMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.secondaryAccent, size: 20),
                    const SizedBox(width: 8),
                    Text('Innovation Hub, Tech City', style: AppTypography.monoMedium),
                  ],
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'EXPLORE EVENTS',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double animationValue;

  GridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandBlue.withOpacity(0.1)
      ..strokeWidth = 1;

    final double gridSize = 40;
    final double offset = gridSize * animationValue;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = offset; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
