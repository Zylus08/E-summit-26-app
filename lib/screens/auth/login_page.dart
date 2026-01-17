import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool sent = await _authService.sendOTP(email);
      if (sent) {
        if (mounted) {
          Navigator.pushNamed(context, '/otp', arguments: email);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send OTP. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue to E-SUMMIT\'26',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.supportBlue),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.supportBlue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.supportBlue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.brandBlue),
                ),
                prefixIcon: const Icon(Icons.email, color: AppColors.supportBlue),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'SEND OTP',
              onPressed: _handleLogin,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            Center(
              child: Text('OR', style: AppTypography.bodySmall),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                setState(() => _isLoading = true);
                try {
                  final user = await _authService.signInWithGoogle();
                  if (user != null && mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              icon: const Icon(Icons.login, color: AppColors.white), // Placeholder for Google Logo
              label: const Text('Sign in with Google'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.white),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

