import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    BibleScreen(),
    MyListScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens, // Disable swipe
          ),
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}
