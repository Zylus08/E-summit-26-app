import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InternshipFairService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> submitApplication({
    required String fullName,
    required String branch,
    required String institute,
    required double cgpa,
    required List<String> skills,
    required List<String> organisations,
    required String resumeFileName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final uid = user.uid;
    final ref = _db.collection('internship_applications').doc(uid);

    await ref.set({
      'uid': uid,
      'email': user.email,
      'fullName': fullName,
      'branch': branch,
      'institute': institute,
      'cgpa': cgpa,
      'skills': skills,
      'organisations': organisations,
      'resumeFileName': resumeFileName,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await ref.update({
      'createdAt': FieldValue.serverTimestamp(),
    }).catchError((_) async {
      await ref.set({
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }
}
