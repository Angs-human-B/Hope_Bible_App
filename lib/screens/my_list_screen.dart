import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constants/colors.dart';
import '../widgets/MyListSection/my_list_card.dart';
import '../widgets/HomeSection/search_bar.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  final PageController _pageController = PageController();
  int selectedIndex = 0;

  final List<String> tabs = ['All', 'Videos', 'Hymns'];
  void onTabTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Text(
              'My List',
              style: TextStyle(
                color: textWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CupertinoSearchBar(),
          SizedBox(height: 24.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onTabTap(index),
                  child: Padding(
                    padding: EdgeInsets.only(right: 26.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            color: isSelected ? textWhite : textGrey,
                            fontSize: isSelected ? 17.sp : 16.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2,
                          width: 24.w,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? textWhite
                                    : CupertinoColors.transparent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 4.h),

          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => selectedIndex = index);
              },
              children: const [
                CardGridTab(), // All
                CardGridTab(), // Videos
                CardGridTab(), // Hymns
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardGridTab extends StatelessWidget {
  const CardGridTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.sp),
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 167.w / 250.h,
        ),
        itemBuilder: (context, index) {
          return const MyListCard();
        },
      ),
    );
  }
}
