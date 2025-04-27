import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope/Constants/colors.dart';
import '../Constants/icons.dart';
import '../widgets/ProfileSection/settings_button_listtile.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    arrowLeft,
                    height: 22.h,
                    colorFilter: const ColorFilter.mode(
                      CupertinoColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        middle: Text(
          'App Settings',
          style: TextStyle(
            color: textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CupertinoColors.black,
        border: null,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              SettingsButtonListTile(
                iconPath: notificationsIcon,
                title: "Notifications",
                trailingIconPath: arrowRight2,
                enableToggle: true,
                toggleValue: true,
                onToggleChanged: (val) {
                  print("Notifications: $val");
                },
              ),
              SizedBox(height: 10.h),
              SettingsButtonListTile(
                iconPath: "assets/icons/bible.svg",
                title: "Language Settings",
                trailingIconPath: arrowRight2,
                enableDropdownTrailing: true,
                dropdownItems: ["EN", "BN", "FR", "SP"],
                selectedItem: "EN",
                onDropdownChanged: (value) {
                  print("Language selected: $value");
                },
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              Container(height: 1, width: 300.w, color: secondaryGrey),
              SizedBox(height: 16.h),
              SettingsButtonListTile(
                iconPath: logoutIcon,
                title: "Logout",
                trailingIconPath: arrowRight2,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
