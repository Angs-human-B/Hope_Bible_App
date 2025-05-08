import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' show Inst, Obx;
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:hope/screens/Pricing&LoginSection/pricing_screen_1.dart';
import 'package:hope/screens/onboarding/onboarding27_screen.dart';
import 'package:hope/utilities/app.constants.dart' show Utils;
import 'package:purchases_flutter/purchases_flutter.dart'
    show CustomerInfo, Offerings, Purchases;

// import all your onboarding screens:
import '../../Constants/colors.dart';
import '../../Constants/global_variable.dart';
import '../../Constants/image.dart';
import '../../widgets/OnboardingSection/progress_bar.dart';
import '../../widgets/back_button.dart';
import 'Onboarding16_screen.dart';
import 'common_onboarding_screen.dart';
import 'controllers/onboarding.controller.dart' show OnboardingController;
import 'onboarding11_screen.dart';
import 'onboarding13_screen.dart';
import 'onboarding15_screen.dart';
import 'onboarding17_screen.dart';
import 'onboarding18_screen.dart';
import 'onboarding19_screen.dart';
import 'onboarding1_screen.dart';
import 'onboarding20_screen.dart';
import 'onboarding21_screen.dart';
import 'onboarding22_screen.dart';
import 'onboarding23_screen.dart';
import 'onboarding24_screen.dart';
import 'onboarding25_screen.dart';
import 'onboarding2_screen.dart';
// …
import 'onboarding26_screen.dart';
import 'onboarding33_screen.dart';
import 'onboarding5_screen.dart';
import 'onboarding6_screen.dart';
import 'onboarding7_screen.dart';
import 'onboarding9_screen.dart';

class OnboardingPager extends StatefulWidget {
  const OnboardingPager({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingPagerState createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<OnboardingPager> {
  final OnboardingController oboardingController =
      Get.find<OnboardingController>();
  final List<Widget> _pages = [
    Onboarding1Screen(controller),
    Onboarding2Screen(),
    // Onboarding3Screen(),
    CommonOnboardingScreen(ageGroup, onboarding4String, 'o5', 'age'),
    Onboarding5Screen(),
    Onboarding6Screen(),
    Onboarding7Screen(),
    CommonOnboardingScreen(
      readingFrequencies,
      onboarding8String,
      'o9',
      'attendChurch',
    ),
    Onboarding9Screen(),
    CommonOnboardingScreen(
      churchGoingFrequencies,
      onboarding10String,
      'o11',
      "meditate",
    ),
    Onboarding11Screen(),
    CommonOnboardingScreen(studyGroup, onboarding12String, 'o13', 'studyGroup'),
    Onboarding13Screen(),
    CommonOnboardingScreen(
      spiritualStages,
      onboarding14String,
      'o15',
      'spiritualJourney',
    ),
    Onboarding15Screen(),
    CommonOnboardingScreen(
      readingGoal,
      "Whats Your Daily\nReading Goal?",
      'o15',
      'readingGoal',
    ),
    // Onboarding33Screen(),
    Onboarding16Screen(),
    Onboarding17Screen(),
    Onboarding18Screen(),
    Onboarding19Screen(),
    Onboarding20Screen(),
    Onboarding21Screen(),
    Onboarding22Screen(),
    Onboarding23Screen(),
    Onboarding24Screen(),
    Onboarding25Screen(),
    Onboarding26Screen(),
    Onboarding27Screen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the values before first build
    oboardingController.currentProgress.value = 0;
    oboardingController.currentPageIndex.value = 0;
    oboardingController.isSelected.value = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getBackgroundImage(int index) {
    print(index);

    if (index == 9) {
      return onboarding11;
    }
    if (index == 22) {
      return onboarding23;
    }
    if (index == 23) {
      return onboarding24;
    }
    if (index == 24) {
      return onboarding25;
    }
    if (index == 25) {
      return onboarding26;
    }
    if (index == 26) {
      return onboarding27;
    } else {
      return spotLight;
    }
  }

  bool isOptionsSelected(int index) {
    if (index == 0 && ignorePages) {
      // denominationIsSelected = false;
      return true;
    }
    if (index == 1 && denominationIsSelected) {
      print(denominationIsSelected);
      return true;
    }
    if (index == 2 && ignorePages) {
      return true;
    }
    if (index == 3 && ageIsSelected) {
      return true;
    }
    if (index == 4 && ignorePages) {
      return true;
    }
    if (index == 5 && bibleVersionIsSelected) {
      return true;
    }
    if (index == 6 && ignorePages) {
      return true;
    }
    if (index == 7 && attendChurchIsSelected) {
      return true;
    }
    if (index == 8 && ignorePages) {
      return true;
    }
    if (index == 9 && meditateIsSelected) {
      return true;
    }
    if (index == 10 && ignorePages) {
      return true;
    }
    if (index == 11 && studyGroupIsSelected) {
      return true;
    }
    if (index == 12 && ignorePages) {
      return true;
    }
    if (index == 13 && journeyIsSelected) {
      return true;
    }
    if (index == 14 && ignorePages) {
      return true;
    }
    if (index == 15 && ignorePages) {
      return true;
    }
    if (index == 16 && ignorePages) {
      return true;
    }
    if (index == 17 && ignorePages) {
      return true;
    }
    if (index == 18 && ignorePages) {
      return true;
    }

    if (index == 19 && ignorePages) {
      return true;
    }
    if (index == 20 && ignorePages) {
      return true;
    }
    if (index == 21 && ignorePages) {
      return true;
    }
    if (index == 22 && ignorePages) {
      return true;
    }
    if (index == 23 && ignorePages) {
      return true;
    }
    if (index == 24 && ignorePages) {
      return true;
    }
    if (index == 25 && ignorePages) {
      return true;
    }
    if (index == 26 && ignorePages) {
      return true;
    }
    if (index == 27 && ignorePages) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            itemCount: _pages.length,
            onPageChanged: (index) {
              print("INDEX :, $index");

              oboardingController.currentPageIndex.value = index;
            },
            itemBuilder: (context, index) {
              print("index: ${oboardingController.currentProgress.value}");
              return CupertinoPageScaffold(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        getBackgroundImage(index),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            index == 0 ||
                                    index == 13 ||
                                    index == 14 ||
                                    index == 15 ||
                                    index == 18 ||
                                    index == 21
                                ? 0.w
                                : 18.w,
                      ),
                      // color: Colors.black,
                      child: _pages[index],
                    ),

                    // if (index != 0)
                  ],
                ),
              );
              // }
            },
          ),
          Obx(() {
            return oboardingController.currentProgress.value > 0
                ? Positioned(
                  top: 60.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      height: 62.h,
                      child: Row(
                        children: [
                          BackButtonOnboarding(controller),
                          SizedBox(width: 26.w),
                          ProgressBar(
                            progress:
                                oboardingController.currentProgress.value /
                                totalProgress,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : const SizedBox();
          }),
          Obx(() {
            return oboardingController.currentProgress.value > 0
                ? Positioned(
                  top: 750.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 19.w),
                    child: GestureDetector(
                      onTap: () {
                        final enabled = isOptionsSelected(
                          oboardingController.currentPageIndex.value,
                        );
                        if (enabled &&
                            oboardingController.isSelected.value &&
                            oboardingController.currentPageIndex.value != 26) {
                          oboardingController.currentProgress.value += 1;
                          controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          performRevenueCatInitialization();
                        }
                      },
                      child: Container(
                        height: 56.h,
                        width: 350.h,
                        decoration: BoxDecoration(
                          color:
                              oboardingController.isSelected.value
                                  ? accentWhite
                                  : secondaryGrey,
                          borderRadius: BorderRadius.circular(30.sp),
                        ),
                        child: Center(
                          child: Text(
                            oboardingController.currentPageIndex.value == 27
                                ? "Find Your Way Back"
                                : oboardingController.currentPageIndex.value ==
                                    28
                                ? "Enter the Experience"
                                : "Next",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: secondaryBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : const SizedBox();
          }),
        ],
      ),
    );
  }

  void performRevenueCatInitialization() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    Utils.logger.f(customerInfo.originalAppUserId);

    Offerings? offerings;

    try {
      offerings = await Purchases.getOfferings();

      await Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => PricingScreen1(offering: offerings?.current),
        ),
      );
    } on PlatformException catch (e) {
      Utils.logger.e(e);
    }

    if (offerings == null || offerings.current == null) {
      // offerings are empty, show a message to your user
    } else {}
  }
}
