import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';

class CommonText extends StatelessWidget {
  String text;
  double fontSize;
  Color textColor;
  CommonText(this.text, this.fontSize,{this.textColor = Colors.white,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      text,
      style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold
      ),
    );
  }
}
