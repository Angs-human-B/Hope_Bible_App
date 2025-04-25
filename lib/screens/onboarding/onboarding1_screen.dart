import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/OnboardingSection/next_button.dart';

import '../../Constants/colors.dart';

class Onboarding1Screen extends StatefulWidget {
  late PageController pageController;
  Onboarding1Screen(this.pageController,{super.key});

  @override
  State<Onboarding1Screen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<Onboarding1Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(onboarding1),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
              child: SizedBox()),
          Expanded(
            flex: 1,
            child: Container(
              // width: 340.w,
              child: Column(
                children: [
                  SizedBox(height: 30.h,),
                  CommonText("Ready to\n Personalize Your Spiritual Journey?"
                      , 36.sp),
                  SizedBox(height: 34.h,),
                  GestureDetector(
                    onTap: (){
                      widget.pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                      child: NextButton(text: "Get Started")),
                  SizedBox(height: 10.h,),
                  Text("Or",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textGrey,
                    ),
                  ),
                  SizedBox(height: 10.h,),
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
                  SizedBox(height: 33.h,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 26.w),
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
                          TextSpan(
                            text: " & ",
                          ),
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
