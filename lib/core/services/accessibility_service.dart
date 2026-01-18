import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Accessibility service that manages TalkBack and Read Aloud features
class AccessibilityService extends ChangeNotifier {
  static final AccessibilityService _instance = AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  static const String _talkBackKey = 'accessibility_talkback';
  static const String _readAloudKey = 'accessibility_read_aloud';
  static const String _speechRateKey = 'accessibility_speech_rate';
  static const String _speechPitchKey = 'accessibility_speech_pitch';

  SharedPreferences? _prefs;
  FlutterTts? _flutterTts;
  
  bool _isInitialized = false;
  bool _talkBackEnabled = false;
  bool _readAloudEnabled = false;
  double _speechRate = 0.5;
  double _speechPitch = 1.0;
  bool _isSpeaking = false;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isTalkBackEnabled => _talkBackEnabled;
  bool get isReadAloudEnabled => _readAloudEnabled;
  double get speechRate => _speechRate;
  double get speechPitch => _speechPitch;
  bool get isSpeaking => _isSpeaking;

  /// Initialize the service
  Future<void> init() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    
    // Load saved preferences
    _talkBackEnabled = _prefs?.getBool(_talkBackKey) ?? false;
    _readAloudEnabled = _prefs?.getBool(_readAloudKey) ?? false;
    _speechRate = _prefs?.getDouble(_speechRateKey) ?? 0.5;
    _speechPitch = _prefs?.getDouble(_speechPitchKey) ?? 1.0;

    // Initialize TTS engine
    await _initTts();
    
    _isInitialized = true;
    notifyListeners();
  }

  /// Initialize Text-to-Speech engine
  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    
    await _flutterTts?.setLanguage('en-US');
    await _flutterTts?.setSpeechRate(_speechRate);
    await _flutterTts?.setPitch(_speechPitch);
    await _flutterTts?.setVolume(1.0);

    // Set up callbacks
    _flutterTts?.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _flutterTts?.setCompletionHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });

    _flutterTts?.setCancelHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });

    _flutterTts?.setErrorHandler((msg) {
      _isSpeaking = false;
      notifyListeners();
      if (kDebugMode) {
        print('TTS Error: $msg');
      }
    });
  }

  // ==================== TalkBack ====================

  /// Enable or disable TalkBack (enhanced semantics)
  Future<void> setTalkBackEnabled(bool value) async {
    _talkBackEnabled = value;
    await _prefs?.setBool(_talkBackKey, value);
    notifyListeners();
    
    if (value && _readAloudEnabled) {
      await speak('TalkBack enabled. Screen reader mode is now active.');
    }
  }

  // ==================== Read Aloud (TTS) ====================

  /// Enable or disable Read Aloud feature
  Future<void> setReadAloudEnabled(bool value) async {
    _readAloudEnabled = value;
    await _prefs?.setBool(_readAloudKey, value);
    notifyListeners();
    
    if (value) {
      await speak('Read Aloud enabled.');
    } else {
      await stop();
    }
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.0, 1.0);
    await _prefs?.setDouble(_speechRateKey, _speechRate);
    await _flutterTts?.setSpeechRate(_speechRate);
    notifyListeners();
  }

  /// Set speech pitch (0.5 to 2.0)
  Future<void> setSpeechPitch(double pitch) async {
    _speechPitch = pitch.clamp(0.5, 2.0);
    await _prefs?.setDouble(_speechPitchKey, _speechPitch);
    await _flutterTts?.setPitch(_speechPitch);
    notifyListeners();
  }

  /// Speak the given text
  Future<void> speak(String text) async {
    if (!_readAloudEnabled || text.isEmpty) return;
    
    await _flutterTts?.speak(text);
  }

  /// Speak text regardless of Read Aloud setting (for accessibility announcements)
  Future<void> announce(String text) async {
    if (text.isEmpty) return;
    await _flutterTts?.speak(text);
  }

  /// Stop speaking
  Future<void> stop() async {
    await _flutterTts?.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  /// Pause speaking
  Future<void> pause() async {
    await _flutterTts?.pause();
  }

  // ==================== Semantic Helpers ====================

  /// Get semantic label for an element with enhanced description when TalkBack is enabled
  String getSemanticLabel(String label, {String? hint, String? value}) {
    if (!_talkBackEnabled) return label;
    
    final parts = <String>[label];
    if (value != null && value.isNotEmpty) {
      parts.add(value);
    }
    if (hint != null && hint.isNotEmpty) {
      parts.add(hint);
    }
    return parts.join('. ');
  }

  /// Read content if Read Aloud is enabled
  Future<void> readContent(String content, {bool force = false}) async {
    if (force || _readAloudEnabled) {
      await speak(content);
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _flutterTts?.stop();
    _flutterTts = null;
  }
}
