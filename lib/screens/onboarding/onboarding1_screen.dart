import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import '../../Constants/colors.dart';
import 'onboarding_page_view.dart' show OnboardingPageView;

class Onboarding1Screen extends StatefulWidget {
  const Onboarding1Screen({super.key});

  @override
  State<Onboarding1Screen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<Onboarding1Screen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(onboarding1),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 1,
              child: Container(
                // width: 340.w,
                child: Column(
                  children: [
                    SizedBox(height: 52.5.h),
                    CommonText(
                      "Ready to\n Personalize Your Spiritual Journey?",
                      36.sp,
                    ),
                    SizedBox(height: 34.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => OnboardingPageView(),
                          ),
                        );
                      },
                      child: Container(
                        height: 56.h,
                        width: 350.h,
                        decoration: BoxDecoration(
                          color: accentYellow,
                          borderRadius: BorderRadius.circular(30.sp),
                        ),
                        child: Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: secondaryBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Or",
                      style: TextStyle(fontSize: 12.sp, color: textGrey),
                    ),
                    SizedBox(height: 10.h),
                    // SizedBox(height: 40.h,),
                    Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 14.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: textWhite,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 33.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      child: Text.rich(
                        TextSpan(
                          text: "By continuing, you agree to Bilble’s ",
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 14.sp,
                            // fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms of services",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: textWhite,
                              ),
                            ),
                            TextSpan(text: " & "),
                            TextSpan(
                              text: "Privacy policy.",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: textWhite,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
