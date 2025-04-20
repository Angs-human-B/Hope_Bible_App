import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/image.dart';
import 'package:hope/widgets/common_text.dart';
import 'package:hope/widgets/next_button.dart';

import '../../Constants/colors.dart';

class Onboarding1Screen extends StatefulWidget {
  const Onboarding1Screen({super.key});

  @override
  State<Onboarding1Screen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<Onboarding1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(onboarding1),
            fit: BoxFit.fill
          )
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: SizedBox()),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  CommonText("Ready to Personalize Your Spiritual Journey?"
                      , 41.sp),
                  SizedBox(height: 10.h,),
                  NextButton("Get Started", "o2"),
                  SizedBox(height: 30.h,),
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
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
                  SizedBox(height: 40.h,),
                  Text.rich(
                    TextSpan(
                      text: "By continuing, you agree to Bilble’s ",
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
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
                  )
                ],
              ),
            )
          ],
        ),
      ) ,
    );
  }
}
