import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/services/session_manager.dart';
import 'core/services/accessibility_service.dart';
import 'widgets/accessibility_widgets.dart';

// screens
import 'screens/landing_page.dart';
import 'screens/main_screen.dart';
import 'screens/event_detail_page.dart';
import 'screens/speakers/speaker_detail_page.dart';
import 'screens/speakers/speakers_page.dart';
import 'screens/tickets_page.dart';
import 'screens/ticket_detail_page.dart';
import 'screens/if_portal_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/otp_verification_page.dart';
import 'screens/internship_fair/internship_fair_page.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'screens/profile_page.dart';
import 'screens/edit_profile_page.dart';
import 'screens/verify_profile_otp_page.dart';
import 'screens/events_page.dart';
import 'screens/accessibility_settings_page.dart';
import 'screens/qr_scanner_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SessionManager().init();
  await AccessibilityService().init();

  runApp(const ESummitApp());
}

class ESummitApp extends StatelessWidget {
  const ESummitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager();

    late final String initialRoute;

    if (!session.hasSeenOnboarding) {
      initialRoute = '/onboarding';
    } else if (session.isLoggedIn) {
      initialRoute = '/home';
    } else {
      initialRoute = '/login';
    }

    return MaterialApp(
      title: "E-SUMMIT'26",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LandingPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/otp': (context) => OTPVerificationPage(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/home': (context) => const MainScreen(),
        '/event_detail': (context) => const EventDetailPage(),
        '/speaker_detail': (context) => const SpeakerDetailPage(),
        '/tickets': (context) => const TicketsPage(),
        '/ticket_detail': (context) => const TicketDetailPage(),
        '/if_portal': (context) => const IFPortalPage(),
        '/internship_fair': (context) => const InternshipFairPage(),
        '/speakers': (context) => const SpeakersPage(),
        '/profile': (_) => const ProfilePage(),
        '/edit_profile': (_) => const EditProfilePage(),
        '/verify_profile_otp': (_) => const VerifyProfileOtpPage(),
        '/events': (_) => const EventsPage(),
        '/accessibility': (_) => const AccessibilitySettingsPage(),
        '/qr_scanner': (_) => const QRScannerPage(),
      },
    );
  }
}
