import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/global_variable.dart';
import 'package:hope/screens/onboarding/common_onboarding_screen.dart';
import 'package:hope/screens/onboarding/onboarding24_screen.dart';
import 'package:hope/screens/onboarding/onboarding25_screen.dart';
import 'package:hope/screens/onboarding/onboarding26_screen.dart';

import '../../Constants/colors.dart';
import '../../screens/onboarding/Onboarding16_screen.dart';
import '../../screens/onboarding/onboarding11_screen.dart';
import '../../screens/onboarding/onboarding13_screen.dart';
import '../../screens/onboarding/onboarding15_screen.dart';
import '../../screens/onboarding/onboarding17_screen.dart';
import '../../screens/onboarding/onboarding18_screen.dart';
import '../../screens/onboarding/onboarding19_screen.dart';
import '../../screens/onboarding/onboarding20_screen.dart';
import '../../screens/onboarding/onboarding21_screen.dart';
import '../../screens/onboarding/onboarding23_screen.dart';
import '../../screens/onboarding/onboarding2_screen.dart';
import '../../screens/onboarding/onboarding3_screen.dart';
import '../../screens/onboarding/onboarding5_screen.dart';
import '../../screens/onboarding/onboarding6_screen.dart';
import '../../screens/onboarding/onboarding7_screen.dart';
import '../../screens/onboarding/onboarding9_screen.dart';

class NextButton extends StatefulWidget {
  String text;
  String onTapNextRouteString;
  NextButton( {this.text = 'Next', this.onTapNextRouteString = '', super.key});

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
          readingFrequencies,
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
          churchGoingFrequencies,
          onboarding10String,
          'o11'
      )));
    }
    if(onTapNextRouteString == 'o11'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding11Screen()));
    }
    if(onTapNextRouteString == 'o12'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CommonOnboardingScreen(
          studyGroup,
          onboarding12String,
          'o13'
      )));
    }
    if(onTapNextRouteString == 'o13'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding13Screen()));
    }
    if(onTapNextRouteString == 'o14'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CommonOnboardingScreen(
          spiritualStages,
          onboarding14String,
          'o15'
      )));
    }
    if(onTapNextRouteString == 'o15'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding15Screen()));
    }
    if(onTapNextRouteString == 'o16'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding16Screen()));
    }
    if(onTapNextRouteString == 'o17'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding17Screen()));
    }
    if(onTapNextRouteString == 'o18'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding18Screen()));
    }
    if(onTapNextRouteString == 'o19'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding19Screen()));
    }
    if(onTapNextRouteString == 'o20'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding20Screen()));
    }
    if(onTapNextRouteString == 'o21'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding21Screen()));
    }
    if(onTapNextRouteString == 'o23'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding23Screen()));
    }
    if(onTapNextRouteString == 'o24'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding24Screen()));
    }
    if(onTapNextRouteString == 'o25'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding25Screen()));
    }
    if(onTapNextRouteString == 'o26'){
      currentProgress += 1;
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Onboarding26Screen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

}
