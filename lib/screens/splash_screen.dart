import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/screens/ai_call_screen.dart';
import 'package:hope/screens/app_settings_screen.dart';
import 'package:hope/screens/profile_screen.dart';
import 'package:hope/screens/onboarding/onboarding1_screen.dart';
import 'package:hope/screens/profile_settings_screen.dart';
import 'package:hope/screens/streaks_screen.dart';
import '../screens/chat_home_screen.dart';
import '../screens/home_screen.dart';
import 'bible_screen.dart';
import 'onboarding/onboarding2_screen.dart';
import 'my_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: Color(0xFF0C111D),
      child: Center(child: LogoOnly()),
    );
  }
}

class LogoOnly extends StatelessWidget {
  const LogoOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/logo.svg', width: 80, height: 80);
  }
}
