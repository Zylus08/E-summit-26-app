import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/services/auth_service.dart';

class VerifyProfileOtpPage extends StatefulWidget {
  const VerifyProfileOtpPage({super.key});

  @override
  State<VerifyProfileOtpPage> createState() => _VerifyProfileOtpPageState();
}

class _VerifyProfileOtpPageState extends State<VerifyProfileOtpPage> {
  final _otp = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Verify OTP')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Invalid navigation', style: AppTypography.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brandBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brandBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline, color: AppColors.brandBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter the OTP sent to your email to verify profile changes.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // OTP Field
            Text('Enter OTP', style: AppTypography.heading3),
            const SizedBox(height: 12),
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: AppTypography.monoLarge.copyWith(
                color: AppColors.white,
                letterSpacing: 8,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: AppTypography.monoLarge.copyWith(
                  color: AppColors.supportBlue.withOpacity(0.3),
                  letterSpacing: 8,
                ),
                counterText: '',
                filled: true,
                fillColor: AppColors.supportBlue.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.supportBlue.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.supportBlue.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTypography.bodySmall.copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Verify Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (_otp.text.trim().length != 6) {
                          setState(() {
                            _errorMessage = 'Please enter a 6-digit OTP';
                          });
                          return;
                        }

                        setState(() {
                          _loading = true;
                          _errorMessage = null;
                        });

                        try {
                          await AuthService().verifyProfileOtpAndUpdate(
                            otp: _otp.text.trim(),
                            updatedData: args,
                          );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Pop back to edit profile, then pop again to profile
                            // This avoids the black screen by using simple pops
                            Navigator.pop(context); // Pop verify OTP page
                            Navigator.pop(context); // Pop edit profile page
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = e.toString().replaceAll('Exception: ', '');
                          });
                        } finally {
                          if (mounted) {
                            setState(() => _loading = false);
                          }
                        }
                      },
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text('Verify & Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }
}
