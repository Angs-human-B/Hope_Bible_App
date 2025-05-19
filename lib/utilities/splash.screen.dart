import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:hope/screens/Pricing&LoginSection/pricing_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show CupertinoScaffold;
import '../screens/Pricing&LoginSection/pricing_screen_1.dart'
    show PricingScreen1;
import '../screens/auth/auth_page.dart' show AuthPage;
import '../screens/auth/controllers/user.auth.controller.dart'
    show SignUpController;
import '../screens/onboarding/onboarding_screen_pageview.dart'
    show OnboardingPager;
import '../screens/persistent_botom_nav.dart' show PersistentBottomNav;
import '../utilities/app.constants.dart' show AppConstants;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<String> _determineInitialScreen() async {
    // await Future.delayed(const Duration(seconds: 3)); // Add splash screen delay

    if (AppConstants.userId.isEmpty && !AppConstants.isSubscriptionActive) {
      return 'onboarding'; // Id Empty & Subscription inactive
    }

    if (!AppConstants.isSubscriptionActive && AppConstants.userId.isNotEmpty) {
      return 'paywall'; // Id Exists & Subscription inactive
    }

    if (AppConstants.isSubscriptionActive && AppConstants.userId.isEmpty) {
      return 'login'; // Id Empty & Subscription active
    }

    return 'home'; // Both ID & subscription exists
  }

  Widget _buildScreen(String route) {
    final signUpcontroller = Get.find<SignUpController>();
    switch (route) {
      case 'paywall':
        // return PricingScreen1(
        //   isMainScreen: true,
        //   offering: signUpcontroller.offerings?.current,
        // ); // Paywall screen

        return PricingScreen();
      case 'onboarding':
        return const OnboardingPager(); // Onboarding screen
      case 'login':
        return const AuthPage(login: true, mainScreenRedirect: true);
      default:
        return const CupertinoScaffold(
          body: PersistentBottomNav(),
        ); // Main tab bar
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF0C111D),
      child: FutureBuilder<String>(
        future: _determineInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LogoOnly());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred. Please try again later.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            // final route = '';
            // final route = 'login';
            final route = 'paywall';
            // final route = 'onboarding';
            // final route = snapshot.data ?? 'onboarding';
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          _buildScreen(route),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            });
            return const Center(child: SizedBox());
          }
        },
      ),
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
