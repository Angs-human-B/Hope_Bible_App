import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListCard extends StatelessWidget {
  const MyListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 167.w,
      height: 250.h,
      margin:  EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/the_ark.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(6.sp),
      ),
    );
  }
}
