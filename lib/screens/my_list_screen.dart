import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hope/screens/bible_screen.dart' show BibleScreen;
import '../Constants/colors.dart';
import '../Constants/icons.dart' show searchIcon;
import '../services/favorites_service.dart' show FavoritesController;
import '../utilities/text.utility.dart' show AllText;
import '../widgets/MyListSection/my_list_card.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  final favouritesController = Get.find<FavoritesController>();
  final PageController _pageController = PageController();
  final FocusNode _searchFocusNode = FocusNode();
  int selectedIndex = 0;
  final List<String> tabs = ['All', 'Videos', 'Hymns'];
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = favouritesController.getFavorites();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // Hide bottom bar when keyboard is visible
    BibleScreen.isBottomBarVisible.value = !_searchFocusNode.hasFocus;
  }

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
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading favorites: ${snapshot.error}',
              style: TextStyle(color: textWhite, fontSize: 16.sp),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: AllText(
                text: 'My List',
                style: TextStyle(
                  color: textWhite,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CupertinoSearchTextField(
                focusNode: _searchFocusNode,
                placeholder: 'Search for keyword or phrase',
                placeholderStyle: TextStyle(color: textFieldGrey),
                backgroundColor: textFieldGrey.withValues(alpha: .22),
                padding: EdgeInsets.all(15.sp),
                prefixInsets: EdgeInsets.only(left: 15.w),
                prefixIcon: SvgPicture.asset(searchIcon, height: 16.h),
                suffixInsets: EdgeInsets.only(right: 15.w),
                itemColor: textFieldGrey,
                style: TextStyle(color: textWhite),
                onChanged: (value) {
                  favouritesController.updateSearchQuery(value);
                },
                onTap: () {
                  // Hide bottom bar when search is tapped
                  BibleScreen.isBottomBarVisible.value = false;
                },
                onSuffixTap: () {
                  // Show bottom bar when search is cleared
                  BibleScreen.isBottomBarVisible.value = true;
                  _searchFocusNode.unfocus();
                },
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => selectedIndex = index);
                },
                children: const [
                  CardGridTab(), // All
                  // CardGridTab(), // Videos
                  // CardGridTab(), // Hymns
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardGridTab extends StatefulWidget {
  const CardGridTab({super.key});

  @override
  State<CardGridTab> createState() => _CardGridTabState();
}

class _CardGridTabState extends State<CardGridTab> {
  final ScrollController _scrollController = ScrollController();
  final favouritesController = Get.find<FavoritesController>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      favouritesController.loadMoreFavorites();
    }
    if (_scrollController.position.isScrollingNotifier.value) {
      final isScrollingDown =
          _scrollController.position.pixels >
          _scrollController.position.minScrollExtent + 50;
      BibleScreen.isBottomBarVisible.value = !isScrollingDown;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (favouritesController.isLoading.value &&
          favouritesController.favorites.isEmpty) {
        return const Center(child: CupertinoActivityIndicator());
      }

      if (favouritesController.isError.value) {
        return Center(
          child: Text(
            favouritesController.error.value,
            style: TextStyle(color: textWhite, fontSize: 16.sp),
          ),
        );
      }

      final favorites = favouritesController.filteredFavorites;

      if (favorites.isEmpty) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Center(
            key: ValueKey(favouritesController.searchQuery.value.isNotEmpty),
            child: AllText(
              text:
                  favouritesController.searchQuery.value.isNotEmpty
                      ? 'No matches found'
                      : 'No favorites added yet',
              style: TextStyle(color: textWhite, fontSize: 16.sp),
            ),
          ),
        );
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 167.w / 300.h,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final favorite = favorites[index];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: MyListCard(
                    key: ValueKey(favorite.media.id),
                    media: favorite.media,
                    mediaList: favorites.map((e) => e.media).toList(),
                  ),
                );
              }, childCount: favorites.length),
            ),
            if (favouritesController.isLoading.value)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: const Center(child: CupertinoActivityIndicator()),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 60.h)),
          ],
        ),
      );
    });
  }
}
