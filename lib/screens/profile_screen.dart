import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/screens/app_settings_screen.dart';
import 'package:hope/screens/profile_settings_screen.dart';
import 'package:hope/widgets/ProfileSection/profile_upper_container.dart';
import '../Constants/icons.dart';
import '../utilities/app.constants.dart' show AppConstants, Utils;
import '../utilities/language.change.utility.dart' show LanguageChangeUtility;
import '../utilities/language.utility.dart' show LanguageController;
import '../widgets/ProfileSection/settings_button_listtile.dart';
import 'auth/controllers/user.auth.controller.dart' show SignUpController;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.find<SignUpController>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Utils.logger.f("userId profile screen: ${AppConstants.userId}");
      await controller.getUserDetailsFn(AppConstants.userId, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileUpperContainer(),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " SETTINGS",
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                SettingsButtonListTile(
                  iconPath: profileIcon,
                  title: "My Account",
                  trailingIconPath: arrowRight2,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const ProfileSettingsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                SettingsButtonListTile(
                  iconPath: settingsIcon,
                  title: "App settings",
                  trailingIconPath: arrowRight2,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const AppSettingsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                SettingsButtonListTile(
                  iconPath: voiceoverIcon,
                  title: "Voiceover",
                  trailingIconPath: arrowRight2,
                  enableDropdownTrailing: true,
                  dropdownItems: ["Male", "Female"],
                  selectedItem: AppConstants.isMale ? "Male" : "Female",
                  onDropdownChanged: (value) {
                    AppConstants.isMale = value == "Male" ? true : false;

                    Utils.logger.f("Checking male ${AppConstants.isMale}");
                    print("Gender selected: $value");
                  },
                  onTap: () {},
                ),
                SizedBox(height: 10.h),
                SettingsButtonListTile(
                  iconPath: "assets/icons/bible.svg",
                  title: "Language Settings",
                  trailingIconPath: arrowRight2,
                  enableDropdownTrailing: false,
                  selectedItem: languageController.selectedLanguage.value,
                  onTap: () {
                    LanguageChangeUtility.showLanguageScreen(context);
                  },
                ),
                // SizedBox(height: 10.h),
                // SettingsButtonListTile(
                //   iconPath: notificationsIcon,
                //   title: "Notifications",
                //   trailingIconPath:
                //       arrowRight2, // Not shown when toggle is enabled
                //   enableToggle: true,
                //   toggleValue: true,
                //   onToggleChanged: (val) {
                //     print("Notifications: $val");
                //   },
                // ),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
