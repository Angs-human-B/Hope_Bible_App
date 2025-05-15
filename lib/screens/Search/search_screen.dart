// import 'dart:ui' show ImageFilter;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import '../../Constants/colors.dart';
// import '../../Constants/icons.dart';
// import '../../media/controllers/media.controller.dart';
// import '../../media/models/media.model.dart';
// import '../../widgets/HomeSection/feature_card.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final mediaController = Get.find<MediaController>();
//   final TextEditingController _searchController = TextEditingController();
//   final RxList<Media> _searchResults = <Media>[].obs;
//   final RxBool _hasStartedTyping = false.obs;
//
//   void _onSearchChanged(String query) {
//     if (query.isEmpty) {
//       _hasStartedTyping.value = false;
//       _searchResults.clear();
//       return;
//     }
//
//     _hasStartedTyping.value = true;
//     final lowercaseQuery = query.toLowerCase();
//     _searchResults.value =
//         mediaController.mediaList.where((media) {
//           final title = media.title.toLowerCase();
//           return title.contains(lowercaseQuery);
//         }).toList();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: CupertinoColors.black,
//       navigationBar: CupertinoNavigationBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: ClipRRect(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//               child: Container(
//                 width: 42.w,
//                 height: 42.h,
//                 decoration: BoxDecoration(
//                   color: CupertinoColors.systemGrey.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     arrowLeft,
//                     height: 22.h,
//                     colorFilter: const ColorFilter.mode(
//                       CupertinoColors.white,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: CupertinoColors.black,
//         border: null,
//         middle: Container(
//           height: 60.h,
//           child: CupertinoSearchTextField(
//             controller: _searchController,
//             onChanged: _onSearchChanged,
//             placeholder: 'Search for keyword or phrase',
//             placeholderStyle: TextStyle(color: textFieldGrey),
//             backgroundColor: textFieldGrey.withOpacity(0.22),
//             // padding: EdgeInsets.all(15.sp),
//             prefixInsets: EdgeInsets.only(left: 15.w),
//             prefixIcon: SvgPicture.asset(searchIcon),
//             suffixInsets: EdgeInsets.only(right: 15.w),
//             itemColor: textFieldGrey,
//             style: TextStyle(color: CupertinoColors.white),
//           ),
//         ),
//       ),
//       child: Obx(() {
//         if (!_hasStartedTyping.value) {
//           return const SizedBox.shrink();
//         }
//
//         return GridView.builder(
//           padding: EdgeInsets.all(16.w),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 152.w / 234.h,
//             crossAxisSpacing: 16.w,
//             mainAxisSpacing: 16.h,
//           ),
//           itemCount: _searchResults.length,
//           itemBuilder:
//               (context, index) => FeatureCard(
//                 isSmall: true,
//                 media: _searchResults[index],
//                 mediaList: _searchResults,
//                 index: index,
//               ),
//         );
//       }),
//     );
//   }
// }
