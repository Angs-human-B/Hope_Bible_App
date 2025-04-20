import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/HomeSection/search_bar.dart';
import '../widgets/HomeSection/daily_verse_card.dart';
import '../widgets/HomeSection/feature_section.dart';
import '../widgets/HomeSection/horizontal_card_list.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(''),
        backgroundColor: CupertinoColors.black,
        border: null,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                SizedBox(height: 12.h),
                CupertinoSearchBar(),
                SizedBox(height: 16.h),
                FeaturedSection(),
                DailyVerseCard(),
                HorizontalCardList(title: 'Recommended'),
                SizedBox(height: 12.h),
                HorizontalCardList(title: 'Watch Now'),
              ],
            ),
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: BottomNavBar(home: true),
            ),
          ],
        ),
      ),
    );
  }
}
