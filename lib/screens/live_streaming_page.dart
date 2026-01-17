import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/buttons.dart';
import '../widgets/ui_elements.dart';

class LiveStreamingPage extends StatefulWidget {
  const LiveStreamingPage({super.key});

  @override
  State<LiveStreamingPage> createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Minimal black layout
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: LiveBadge(),
          ),
        ],
      ),
      body: _isJoined ? _buildLiveView() : _buildJoinView(),
    );
  }

  Widget _buildJoinView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.live_tv, size: 80, color: AppColors.supportBlue),
            const SizedBox(height: 24),
            Text(
              'Innovation in the Age of AI',
              style: AppTypography.heading2.copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Starting in 5 minutes',
              style: AppTypography.monoMedium.copyWith(color: AppColors.secondaryAccent),
            ),
            const SizedBox(height: 48),
            PrimaryButton(
              text: 'JOIN LIVE',
              onPressed: () {
                setState(() {
                  _isJoined = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveView() {
    return Stack(
      children: [
        // Video Placeholder
        Center(
          child: Container(
            color: AppColors.darkContrast,
            child: const Center(
              child: Text('Video Stream Placeholder', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        
        // Controls Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, color: AppColors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.videocam, color: AppColors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen, color: AppColors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _isJoined = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
