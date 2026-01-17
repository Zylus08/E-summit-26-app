import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const String _keyUserEmail = 'userEmail';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Session
  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  String? get userEmail => _prefs.getString(_keyUserEmail);

  Future<void> saveUserSession(String email) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserEmail, email);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserEmail);
  }

  // Onboarding
  bool get hasSeenOnboarding => _prefs.getBool(_keyHasSeenOnboarding) ?? false;

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_keyHasSeenOnboarding, true);
  }
}
