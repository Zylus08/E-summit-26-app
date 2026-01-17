import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';

class VerifyProfileOtpPage extends StatefulWidget {
  const VerifyProfileOtpPage({super.key});

  @override
  State<VerifyProfileOtpPage> createState() => _VerifyProfileOtpPageState();
}

class _VerifyProfileOtpPageState extends State<VerifyProfileOtpPage> {
  final _otp = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      try {
                        await AuthService().verifyProfileOtpAndUpdate(
                          otp: _otp.text.trim(),
                          updatedData: args,
                        );

                        Navigator.popUntil(context, ModalRoute.withName('/profile'));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      } finally {
                        setState(() => _loading = false);
                      }
                    },
              child: const Text('Verify & Save'),
            ),
          ],
        ),
      ),
    );
  }
}
