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
  bool isOptionSelected;
  NextButton(this.isOptionSelected, {this.text = 'Next', super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      width: 350.h,
      decoration: BoxDecoration(
        color: widget.isOptionSelected ? accentYellow : secondaryGrey,
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
