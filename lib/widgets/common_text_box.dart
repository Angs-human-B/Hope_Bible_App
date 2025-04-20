import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hope/widgets/common_text.dart';



class CommonTextBox extends StatelessWidget {
  Color backgroundColor;
  Color TextColor;
  String text;
  CommonTextBox(this.text, this.TextColor, this.backgroundColor,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      width: 167.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.h),
        color: backgroundColor
      ),
      child: Center(child: CommonText(text, 18.sp)),
    );
  }
}
