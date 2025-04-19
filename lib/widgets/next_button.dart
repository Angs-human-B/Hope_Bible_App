import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';

class NextButton extends StatefulWidget {
  String text;
  String onTapNextRouteString;
  NextButton( this.text, this.onTapNextRouteString, {super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

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
                fontSize: 20.sp,
                color: secondaryBlack,
                fontWeight: FontWeight.bold
              ),
            )
        ),
      ),
    );
  }
}
