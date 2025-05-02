import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/screens/onboarding/onboarding_screen_pageview.dart'
    show OnboardingPager;
import 'package:hope/utilities/app.constants.dart' show AppConstants;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show CupertinoScaffold;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import '../Constants/icons.dart';
import '../widgets/ProfileSection/settings_button_listtile.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  destroyData(context) async {
    AppConstants.userId = "";
    AppConstants.name = "";
    AppConstants.authToken = "";
    AppConstants.email = "";
    AppConstants.username = "";

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('userId');
    sp.remove('authToken');
    sp.remove('name');
    sp.remove('email');
    // CachedQuery.instance.invalidateCache();
    Navigator.of(context, rootNavigator: false).push(
      CupertinoPageRoute(
        builder:
            (context) => WillPopScope(
              onWillPop: () async => false,
              child: const CupertinoScaffold(body: OnboardingPager()),
            ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                destroyData(context);
                // TODO: Add your logout function here
              },
            ),
          ],
        );
      },
    );
  }

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
              // SizedBox(height: 10.h),
              // SettingsButtonListTile(
              //   iconPath: "assets/icons/bible.svg",
              //   title: "Language Settings",
              //   trailingIconPath: arrowRight2,
              //   enableDropdownTrailing: true,
              //   dropdownItems: ["EN", "BN", "FR", "SP"],
              //   selectedItem: "EN",
              //   onDropdownChanged: (value) {
              //     print("Language selected: $value");
              //   },
              //   onTap: () {},
              // ),
              // SizedBox(height: 16.h),
              Container(height: 1, width: 300.w, color: secondaryGrey),
              SizedBox(height: 16.h),
              SettingsButtonListTile(
                iconPath: logoutIcon,
                title: "Logout",
                trailingIconPath: arrowRight2,
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
