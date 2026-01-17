import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/services/session_manager.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    await SessionManager().setOnboardingSeen();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    // Using network images for demo as we don't have local assets
    return Image.network(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: AppColors.supportBlue);

    final pageDecoration = PageDecoration(
      titleTextStyle: AppTypography.heading1.copyWith(color: AppColors.primaryAccent),
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: AppColors.darkContrast,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: AppColors.darkContrast,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "Innovation Lab",
          body: "Experience the future of entrepreneurship with E-SUMMIT'26.",
          image: _buildImage('https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Connect & Network",
          body: "Meet industry leaders, speakers, and fellow innovators.",
          image: _buildImage('https://images.unsplash.com/photo-1515187029135-18ee286d815b?q=80&w=2070&auto=format&fit=crop'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get Inspired",
          body: "Join workshops, competitions, and keynote sessions.",
          image: _buildImage('https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back, color: AppColors.white),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white)),
      next: const Icon(Icons.arrow_forward, color: AppColors.white),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryAccent)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: AppColors.supportBlue,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: AppColors.primaryAccent,
      ),
    );
  }
}
