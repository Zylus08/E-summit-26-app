import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data()!;
    _name.text = data['name'] ?? '';
    _college.text = data['college'] ?? '';
    _phone.text = data['phone'] ?? '';

    setState(() => _loading = false);
  }

    Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser!;
    final email = user.email ?? 'unknown@email';

    await AuthService().sendProfileUpdateOTP(
        email: email,
        field: 'profile',
        value: 'update',
    );

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


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _college, decoration: const InputDecoration(labelText: 'College')),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _save,
              child: const Text('Save & Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
