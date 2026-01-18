import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _name = TextEditingController();
  final _college = TextEditingController();
  final _phone = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }

      _email = user.email;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _name.text = data['name'] ?? '';
        _college.text = data['college'] ?? '';
        _phone.text = data['phone'] ?? '';
      }

      if (mounted) {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final email = _email ?? 'unknown@email';

      await AuthService().sendProfileUpdateOTP(
        email: email,
        field: 'profile',
        value: 'update',
      );

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/verify_profile_otp',
          arguments: {
            'name': _name.text.trim(),
            'college': _college.text.trim(),
            'phone': _phone.text.trim(),
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryAccent),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar placeholder
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.darkContrast,
                  child: Text(
                    _name.text.isNotEmpty ? _name.text[0].toUpperCase() : 'U',
                    style: AppTypography.heading2.copyWith(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            Text('Full Name', style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _name,
              hintText: 'Enter your name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            // College field
            Text('College', style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _college,
              hintText: 'Enter your college name',
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 20),

            // Phone field
            Text('Phone Number', style: AppTypography.bodySmall),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _phone,
              hintText: 'Enter your phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),

            // Info card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.supportBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, 
                      color: AppColors.supportBlue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'An OTP will be sent to your email to verify changes.',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text('Save & Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.supportBlue.withOpacity(0.5),
        ),
        prefixIcon: Icon(icon, color: AppColors.brandBlue),
        filled: true,
        fillColor: AppColors.supportBlue.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.supportBlue.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.supportBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _college.dispose();
    _phone.dispose();
    super.dispose();
  }
}
