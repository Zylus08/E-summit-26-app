import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'session_manager.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final SessionManager _sessionManager = SessionManager();

  String? _generatedOTP;
  String? _otpEmail;

  // ================= EMAIL OTP =================

  Future<bool> sendOTP(String email) async {
    final random = Random();
    _generatedOTP = (100000 + random.nextInt(900000)).toString();
    _otpEmail = email;

    // TEMP (later email backend)
    print("==================================");
    print("OTP for $email : $_generatedOTP");
    print("==================================");

    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyOTP(String otp, String email) async {
    if (_generatedOTP == otp && _otpEmail == email) {
      final cred = await _auth.signInAnonymously();

      await createOrUpdateUser(user: cred.user!, emailOverride: email);
      await _sessionManager.saveUserSession(email);

      _generatedOTP = null;
      _otpEmail = null;
      return true;
    }
    return false;
  }

  // ================= GOOGLE SIGN-IN =================

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) {
      throw Exception("Google ID token missing");
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user == null) return null;

    // 🔒 DOMAIN RESTRICTION
    final email = user.email ?? '';
    if (!email.endsWith('@thapar.edu')) {
      await _auth.signOut();
      await _googleSignIn.signOut();
      throw Exception('Only @thapar.edu emails are allowed');
    }

    // 🔥 Firestore user create/update
    await createOrUpdateUser(user: user);

    // 🔐 Session
    await _sessionManager.saveUserSession(email);

    return userCredential;
  } catch (e) {
    print("🔥 Google Sign-In Error: $e");
    rethrow;
  }
}

  // ================= FIRESTORE USER =================

  Future<void> createOrUpdateUser({
    required User user,
    String? emailOverride,
  }) async {
    final ref = _db.collection('users').doc(user.uid);

    await ref.set({
      'email': emailOverride ?? user.email ?? '',
      'name': user.displayName ?? '',
      'college': '',
      'phone': user.phoneNumber ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _sessionManager.clearSession();
  }

  // ================= DELETE ACCOUNT =================

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).delete();
      await user.delete();
    }
    await logout();
  }

  Future<void> verifyProfileOtpAndUpdate({
    required String otp,
    required Map<String, String> updatedData,
  }) async {
    if (_profileOtp != otp) {
      throw Exception("Invalid OTP");
    }

    final uid = _auth.currentUser!.uid;

    await _db.collection('users').doc(uid).update({
      ...updatedData,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _profileOtp = null;
    _profilePendingField = null;
    _profilePendingValue = null;
  }

  // ================= PROFILE UPDATE OTP =================

String? _profileOtp;
String? _profilePendingField;
String? _profilePendingValue;

Future<void> sendProfileUpdateOTP({
  required String field,
  required String value,
  required String email,
}) async {
  final random = Random();
  _profileOtp = (100000 + random.nextInt(900000)).toString();
  _profilePendingField = field;
  _profilePendingValue = value;

  // TEMP: terminal print
  print("==================================");
  print("PROFILE OTP for $email : $_profileOtp");
  print("Field: $field → $value");
  print("==================================");
}

Future<bool> verifyProfileUpdateOTP(String otp) async {
  if (otp == _profileOtp) {
    final user = _auth.currentUser;
    if (user == null) return false;

    await _db.collection('users').doc(user.uid).update({
      _profilePendingField!: _profilePendingValue,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _profileOtp = null;
    _profilePendingField = null;
    _profilePendingValue = null;

    return true;
  }
  return false;
}

}
