import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      width: 280.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: secondaryGrey,
      ),
    );
  }
}
