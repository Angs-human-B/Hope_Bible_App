import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 72.h,
          width: 250.w,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: secondaryGrey,
            borderRadius: BorderRadius.circular(99.sp),
            border: Border.all(color: Color(0xFF888888), width: .5),
          ),
          child: Row(
            children: [
              _NavIcon(assetPath: 'assets/icons/home.svg', selected: true),
              SizedBox(width: 4.w),
              _NavIcon(assetPath: 'assets/icons/bible.svg'),
              SizedBox(width: 4.w),
              _NavIcon(assetPath: 'assets/icons/bookmark.svg'),
              SizedBox(width: 4.w),
              _NavIcon(assetPath: 'assets/icons/profile.svg'),
            ],
          ),
        ),

        Container(
          height: 70.h,
          width: 70.w,
          margin: EdgeInsets.only(right: 12.w),
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: secondaryGrey,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/icons/sparkle.svg',
            width: 18.w,
            height: 18.h,
            colorFilter: const ColorFilter.mode(
              CupertinoColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String assetPath;
  final bool selected;

  const _NavIcon({required this.assetPath, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: 55.w,
      decoration: BoxDecoration(
        color: selected ? accentYellow : secondaryGrey,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(15.sp),
      child: SvgPicture.asset(
        assetPath,
        width: 19.w,
        height: 19.h,
        colorFilter: ColorFilter.mode(
          selected ? CupertinoColors.black : CupertinoColors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
