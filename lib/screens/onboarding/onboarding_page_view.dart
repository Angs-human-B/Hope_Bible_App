import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/screens/onboarding/controllers/onboarding.controller.dart';
import 'package:hope/screens/onboarding/onboarding2_screen.dart';
import 'package:hope/screens/onboarding/onboarding3_screen.dart';
import 'package:hope/screens/onboarding/onboarding5_screen.dart';
import 'package:hope/screens/onboarding/onboarding6_screen.dart';
import 'package:hope/screens/onboarding/onboarding7_screen.dart';
import 'package:hope/screens/onboarding/onboarding9_screen.dart';
import 'package:hope/screens/onboarding/common_onboarding_screen.dart';
import 'package:hope/utilities/app.constants.dart';
import 'package:hope/widgets/progress_bar.dart';

import '../../Constants/colors.dart'
    show accentYellow, secondaryBlack, textGrey;

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final PageController _pageController = PageController();
  final OnboardingController controller = Get.find<OnboardingController>();

  void goToNextPage() {
    if (controller.canProceedFromPage(controller.currentPage)) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    Utils.logger.f(controller.currentPage.toString());
    if (controller.currentPage >= 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    // Ensure controller's page is synced with PageView
    controller.setCurrentPage(_pageController.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                // Update both local and controller state
                setState(() {
                  controller.currentProgress.value = page + 1;
                });
                controller.setCurrentPage(page);
                Utils.logger.f("Page changed to: $page");
              },
              children: [
                Onboarding2Screen(),
                const Onboarding3Screen(),
                CommonOnboardingScreen(ageGroup, onboarding4String, 'o5', ''),
                const Onboarding5Screen(),
                const Onboarding6Screen(),
                const Onboarding7Screen(),
                CommonOnboardingScreen(
                  readingFrequencies,
                  onboarding8String,
                  'o9',
                  '',
                ),
                const Onboarding9Screen(),
                CommonOnboardingScreen(
                  churchGoingFrequencies,
                  onboarding10String,
                  'o11',
                  '',
                ),
              ],
            ),
            // Navigation bar at top
            Container(
              alignment: Alignment.bottomCenter,
              height: 62.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: goToPreviousPage,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          height: 44.h,
                          width: 44.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: CupertinoColors.systemGrey.withOpacity(0.4),
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_left,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 26.w),
                  ProgressBar(
                    progress: controller.currentProgress.value / totalProgress,
                  ),
                ],
              ),
            ),
            // Next button at bottom
            Positioned(
              top: 695.h,
              left: 18.w,
              child: Obx(
                () => GestureDetector(
                  onTap: goToNextPage,
                  child: Container(
                    height: 56.h,
                    width: 350.h,
                    decoration: BoxDecoration(
                      color:
                          controller.canProceedFromPage(controller.currentPage)
                              ? accentYellow
                              : textGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30.sp),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color:
                              controller.canProceedFromPage(
                                    controller.currentPage,
                                  )
                                  ? secondaryBlack
                                  : textGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
