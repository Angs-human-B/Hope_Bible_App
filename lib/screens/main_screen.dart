import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hope/screens/bible_screen.dart';
import 'package:hope/screens/home_screen.dart';
import 'package:hope/screens/my_list_screen.dart';
import 'package:hope/screens/profile_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RxInt currentIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    const BibleScreen(),
    const MyListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Obx(
              () => IndexedStack(index: currentIndex.value, children: screens),
            ),
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedOpacity(
                  opacity:
                      currentIndex.value == 1
                          ? (BibleScreen.isBottomBarVisible.value ? 1.0 : 0.0)
                          : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: BottomNavBar(
                    currentIndex: currentIndex.value,
                    onTap: (index) => currentIndex.value = index,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
