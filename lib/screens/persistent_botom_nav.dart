import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get, Inst, Obx;
import 'package:hope/screens/profile_screen.dart';

import '../streak/controllers/streak.controller.dart' show StreakController;
import '../widgets/AudioPlayer/floating_audio_player.dart';
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
  final StreakController streakController = Get.find<StreakController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await streakController.getStreakFn({}, context);
    });
  }

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
      Future.delayed(const Duration(milliseconds: 70), () {
        HapticFeedback.mediumImpact();
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
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomNavBar(
                    currentIndex: _selectedIndex,
                    onTap: _onTap,
                  ),
                )
                : const SizedBox.shrink();
          }),
          FloatingAudioPlayer(
            thumbnailUrl: 'cevcibeewv',
            title: 'The ArK Part 1 - Noah and The Great Journey',
            position: const Duration(minutes: 5, seconds: 12),
            isPlaying: true,
            onPlayPause: () {},
            onNext: () {},
            onPrevious: () {},
          ),
        ],
      ),
    );
  }
}
