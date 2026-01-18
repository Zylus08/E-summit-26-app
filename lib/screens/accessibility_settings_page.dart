import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/services/accessibility_service.dart';

class AccessibilitySettingsPage extends StatefulWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  State<AccessibilitySettingsPage> createState() =>
      _AccessibilitySettingsPageState();
}

class _AccessibilitySettingsPageState extends State<AccessibilitySettingsPage> {
  final _accessibilityService = AccessibilityService();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _accessibilityService.init();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Accessibility')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      body: ListenableBuilder(
        listenable: _accessibilityService,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.brandBlue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.accessibility_new,
                        color: AppColors.brandBlue,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Accessibility Features',
                                style: AppTypography.heading3),
                            const SizedBox(height: 4),
                            Text(
                              'Customize your app experience',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Assistive Features Section
                Text('Assistive Features', style: AppTypography.heading3),
                const SizedBox(height: 16),

                // TalkBack Toggle
                _buildSettingTile(
                  icon: Icons.record_voice_over_outlined,
                  title: 'TalkBack',
                  subtitle: 'Enhanced screen reader support with detailed semantic labels',
                  value: _accessibilityService.isTalkBackEnabled,
                  onChanged: (value) async {
                    await _accessibilityService.setTalkBackEnabled(value);
                  },
                ),
                const SizedBox(height: 16),

                // Read Aloud Toggle
                _buildSettingTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Read Aloud',
                  subtitle: 'Text-to-speech to read content. Long-press text to hear it.',
                  value: _accessibilityService.isReadAloudEnabled,
                  onChanged: (value) async {
                    await _accessibilityService.setReadAloudEnabled(value);
                  },
                ),

                // Speech Settings (only show when Read Aloud is enabled)
                if (_accessibilityService.isReadAloudEnabled) ...[
                  const SizedBox(height: 32),
                  Text('Speech Settings', style: AppTypography.heading3),
                  const SizedBox(height: 16),

                  // Speech Rate
                  _buildSliderTile(
                    icon: Icons.speed,
                    title: 'Speech Rate',
                    subtitle: 'Adjust how fast the text is read',
                    value: _accessibilityService.speechRate,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (value) async {
                      await _accessibilityService.setSpeechRate(value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Speech Pitch
                  _buildSliderTile(
                    icon: Icons.tune,
                    title: 'Speech Pitch',
                    subtitle: 'Adjust the pitch of the voice',
                    value: (_accessibilityService.speechPitch - 0.5) / 1.5,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) async {
                      final pitch = 0.5 + (value * 1.5);
                      await _accessibilityService.setSpeechPitch(pitch);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Test TTS Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (_accessibilityService.isSpeaking) {
                          _accessibilityService.stop();
                        } else {
                          _accessibilityService.announce(
                            'This is a test of the Read Aloud feature. '
                            'You can adjust the speech rate and pitch using the sliders above.',
                          );
                        }
                      },
                      icon: Icon(
                        _accessibilityService.isSpeaking
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      label: Text(
                        _accessibilityService.isSpeaking
                            ? 'Stop'
                            : 'Test Speech',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Usage Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.supportBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline,
                              color: AppColors.secondaryAccent, size: 20),
                          const SizedBox(width: 8),
                          Text('Usage Tips',
                              style: AppTypography.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip('• Long-press any text to hear it read aloud'),
                      _buildTip('• TalkBack adds detailed descriptions for screen readers'),
                      _buildTip('• Use the test button above to preview voice settings'),
                      _buildTip('• Settings are saved automatically'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // System Settings Link
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.supportBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.supportBlue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'For system-wide accessibility features, open your device\'s Accessibility Settings.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: AppTypography.bodySmall),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.supportBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? AppColors.primaryAccent.withOpacity(0.5)
              : AppColors.supportBlue.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primaryAccent.withOpacity(0.2)
                  : AppColors.brandBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primaryAccent : AppColors.brandBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryAccent,
            activeTrackColor: AppColors.primaryAccent.withOpacity(0.3),
            inactiveThumbColor: AppColors.supportBlue,
            inactiveTrackColor: AppColors.darkContrast,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.supportBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.supportBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brandBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.brandBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primaryAccent,
              inactiveTrackColor: AppColors.supportBlue.withOpacity(0.3),
              thumbColor: AppColors.primaryAccent,
              overlayColor: AppColors.primaryAccent.withOpacity(0.2),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
