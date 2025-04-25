// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/widgets/common_text.dart';

class CommonTextBox extends StatelessWidget {
  Color backgroundColor;
  Color TextColor;
  Color borderColor;
  String text;
  bool clicked;
  CommonTextBox(
    this.text,
    this.TextColor,
    this.backgroundColor, {
    this.borderColor = Colors.transparent,
    this.clicked = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 48.h,
      // width: 167.w,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12.h),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (clicked) SizedBox(width: 34.w),
          Expanded(child: CommonText(text, 18.sp, textColor: TextColor)),
          if (clicked)
            Icon(Icons.radio_button_checked_rounded, color: accentYellow),
          if (clicked) SizedBox(width: 12.w),
        ],
      ),
    );
  }
}
