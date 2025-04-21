import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/screens/onboarding/common_onboarding_screen.dart';

import '../Constants/colors.dart';
import '../screens/onboarding/onboarding2_screen.dart';
import '../screens/onboarding/onboarding3_screen.dart';
import '../screens/onboarding/onboarding5_screen.dart';
import '../screens/onboarding/onboarding6_screen.dart';
import '../screens/onboarding/onboarding7_screen.dart';
import '../screens/onboarding/onboarding9_screen.dart';

class NextButton extends StatefulWidget {
  String text;
  String onTapNextRouteString;
  NextButton( this.text, this.onTapNextRouteString, {super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {

  onNext(String onTapNextRouteString) {
    if (onTapNextRouteString == 'o2') {
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding2Screen()));
    }
    if(onTapNextRouteString == 'o3'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding3Screen()));
    }
    if(onTapNextRouteString == 'o4'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CommonOnboardingScreen(
        ageGroup,
          onboarding4String,
        'o5'
      )));
    }
    if(onTapNextRouteString == 'o5'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding5Screen()));
    }
    if(onTapNextRouteString == 'o6'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding6Screen()));
    }
    if(onTapNextRouteString == 'o7'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding7Screen()));
    }
    if(onTapNextRouteString == 'o8'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CommonOnboardingScreen(
          churchGoingFrequencies,
          onboarding8String,
          'o9'
      )));
    }
    if(onTapNextRouteString == 'o9'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding9Screen()));
    }
    if(onTapNextRouteString == 'o10'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CommonOnboardingScreen(
          readingFrequencies,
          onboarding8String,
          'o11'
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onNext(widget.onTapNextRouteString);
      },
      child: Container(
        height: 56.h,
        width: 350.h,
        decoration: BoxDecoration(
          color: accentYellow,
          borderRadius: BorderRadius.circular(30.sp)
        ),
        child: Center(
            child: Text(
                widget.text,
              style: TextStyle(
                fontSize: 16.sp,
                color: secondaryBlack,
                fontWeight: FontWeight.bold
              ),
            )
        ),
      ),
    );
  }

}
