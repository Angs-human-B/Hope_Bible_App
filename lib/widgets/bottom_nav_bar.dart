import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';

import '../screens/bible_screen.dart';
import '../screens/home_screen.dart';
import '../screens/my_list_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final bool home;
  final bool bible;
  final bool myList;
  final bool profile;
  const BottomNavBar({this.home = false, this.bible = false,this.myList = false,this.profile = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 72.h,
          width: 240.w,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: secondaryGrey,
            borderRadius: BorderRadius.circular(99.sp),
            border: Border.all(color: Color(0xFF888888), width: .5),
          ),
          child: Row(
            children: [
              _NavIcon(
                assetPath: 'assets/icons/home.svg',
                selected: home,
                onTap: () {
                  if (!home) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                },
              ),
              _NavIcon(
                assetPath: 'assets/icons/bible.svg',
                selected: bible,
                onTap: () {
                  if (!bible) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const BibleScreen()),
                    );
                  }
                },
              ),
              _NavIcon(
                assetPath: 'assets/icons/bookmark.svg',
                selected: myList,
                onTap: () {
                  if (!myList) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const MyListScreen()),
                    );
                  }
                },
              ),
              _NavIcon(
                assetPath: 'assets/icons/profile.svg',
                selected: profile,
                onTap: () {
                  if (!profile) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }
                },
              ),

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
  final VoidCallback onTap;

  const _NavIcon({
    required this.assetPath,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
