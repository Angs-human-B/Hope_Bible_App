import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:hope/Constants/colors.dart';
import 'package:hope/screens/onboarding/onboarding_screen_pageview.dart'
    show OnboardingPager;
import 'package:hope/utilities/app.constants.dart' show AppConstants;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show CupertinoScaffold, showCupertinoModalBottomSheet;
import 'package:onesignal_flutter/onesignal_flutter.dart'
    show OSLogLevel, OneSignal;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import '../Constants/icons.dart';
import '../widgets/ProfileSection/settings_button_listtile.dart';
import 'auth/controllers/user.auth.controller.dart' show SignUpController;

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
                toggleValue: AppConstants.receiveNotifications,
                onToggleChanged: (val) async {
                  HapticFeedback.selectionClick();
                  final controller = Get.find<SignUpController>();
                  final Map<String, dynamic> params = {
                    "value": AppConstants.userId,
                    "data": {"receiveNotifications": val},
                  };
                  if (val == true) {
                    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
                    OneSignal.initialize(
                      "e01cb044-c3a0-4917-8f88-a899ecac24f5",
                    );
                    OneSignal.Notifications.requestPermission(true);
                  }
                  await controller.userUpdateFn(params, context, true);
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
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showLogoutDialog(context);
                },
              ),
              SizedBox(height: 16.h),
              Container(height: 1, width: 300.w, color: secondaryGrey),
              SizedBox(height: 16.h),
              SettingsButtonListTile(
                showIcon: false,
                iconPath: "assets/icons/account_deactivate.svg",
                title: "Delete Account",
                trailingIconPath: arrowRight2,
                onTap: () => _showDeactivationOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeactivationOptions(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400.h,
          decoration: BoxDecoration(
            color: CupertinoColors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: secondaryGrey, width: 0.5),
                  ),
                ),
                child: Text(
                  'Why are you deleting your account?',
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  children: [
                    _deactivationOption(
                      context,
                      'I want to focus on traditional prayer methods',
                      () => _confirmDeactivation(
                        context,
                        'I want to focus on traditional prayer methods',
                      ),
                    ),
                    _deactivationOption(
                      context,
                      'I need to take a spiritual break',
                      () => _confirmDeactivation(
                        context,
                        'I need to take a spiritual break',
                      ),
                    ),
                    _deactivationOption(
                      context,
                      'I prefer in-person church community',
                      () => _confirmDeactivation(
                        context,
                        'I prefer in-person church community',
                      ),
                    ),
                    _deactivationOption(
                      context,
                      'I want to reduce screen time',
                      () => _confirmDeactivation(
                        context,
                        'I want to reduce screen time',
                      ),
                    ),
                    _deactivationOption(
                      context,
                      'Other reason',
                      () => _confirmDeactivation(context, 'Other reason'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _deactivationOption(
    BuildContext context,
    String reason,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: secondaryGrey, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              reason,
              style: TextStyle(
                color: textWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SvgPicture.asset(
              arrowRight2,
              height: 20.h,
              colorFilter: ColorFilter.mode(textWhite, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeactivation(BuildContext context, String reason) {
    Navigator.pop(context); // Close the bottom sheet
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? You will lose all your data and this action cannot be undone.',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                final controller = Get.find<SignUpController>();
                controller.userDeactivateFn(
                  {"description": reason},
                  context,
                  true,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
