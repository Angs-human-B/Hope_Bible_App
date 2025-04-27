import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/screens/app_settings_screen.dart';
import 'package:hope/screens/profile_settings_screen.dart';
import 'package:hope/widgets/ProfileSection/profile_upper_container.dart';
import '../Constants/icons.dart';
import '../utilities/language.change.utility.dart' show LanguageChangeUtility;
import '../utilities/language.utility.dart' show LanguageController;
import '../widgets/ProfileSection/settings_button_listtile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  selectedItem: "Male",
                  onDropdownChanged: (value) {
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
                SizedBox(height: 10.h),
                SettingsButtonListTile(
                  iconPath: notificationsIcon,
                  title: "Notifications",
                  trailingIconPath:
                      arrowRight2, // Not shown when toggle is enabled
                  enableToggle: true,
                  toggleValue: true,
                  onToggleChanged: (val) {
                    print("Notifications: $val");
                  },
                ),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
