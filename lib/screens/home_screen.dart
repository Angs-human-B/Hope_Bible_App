import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/HomeSection/search_bar.dart';
import '../widgets/HomeSection/daily_verse_card.dart';
import '../widgets/HomeSection/feature_section.dart';
import '../widgets/HomeSection/horizontal_card_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 10),
      children: [
        SizedBox(height: 60.h),
        // CupertinoButton(
        //   onPressed: () {
        //     LanguageChangeUtility.showLanguageScreen(context);
        //   },
        //   padding: EdgeInsets.zero,
        //   child: LanguageSelector(),
        // ),
        CupertinoSearchBar(),
        SizedBox(height: 16.h),
        FeaturedSection(),
        DailyVerseCard(),
        HorizontalCardList(title: 'Recommended'),
        SizedBox(height: 12.h),
        HorizontalCardList(title: 'Watch Now'),

        const SizedBox(height: 100),
      ],
    );
  }
}
