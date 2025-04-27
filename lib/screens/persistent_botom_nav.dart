import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' show Obx;
import 'package:hope/screens/profile_screen.dart';

import '../widgets/bottom_nav_bar.dart';
import 'bible_screen.dart';
import 'home_screen.dart';
import 'my_list_screen.dart';

class PersistentBottomNav extends StatefulWidget {
  const PersistentBottomNav({super.key});

  @override
  State<PersistentBottomNav> createState() => _PersistentBottomNavState();
}

class _PersistentBottomNavState extends State<PersistentBottomNav> {
  int _selectedIndex = 0;
  double _opacity = 1.0;

  final List<Widget> _screens = const [
    HomeScreen(),
    BibleScreen(),
    MyListScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _opacity = 0.0;
      });

      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          _selectedIndex = index;
          _opacity = 1.0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _opacity,
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
          ),
          Obx(() {
            return BibleScreen.isBottomBarVisible.value
                ? Positioned(
                  bottom: 16.h,
                  left: 0,
                  right: 0,
                  child: BottomNavBar(
                    currentIndex: _selectedIndex,
                    onTap: _onTap,
                  ),
                )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
