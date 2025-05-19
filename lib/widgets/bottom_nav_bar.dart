import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hope/Constants/colors.dart';
import 'package:hope/screens/chat_home_screen.dart';
//
// class BottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//
//   const BottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           height: 90.h,
//           width: 260.w,
//           margin: EdgeInsets.symmetric(horizontal: 12.w),
//           padding: EdgeInsets.all(8.sp),
//           decoration: BoxDecoration(
//             color: secondaryGrey,
//             borderRadius: BorderRadius.circular(99.sp),
//             border: Border.all(color: const Color(0xFF888888), width: .5),
//           ),
//           child: Row(
//             children: [
//               _NavIcon(
//                 label: 'Home',
//                 assetPath: 'assets/icons/home.svg',
//                 selected: currentIndex == 0,
//                 onTap: () => onTap(0),
//               ),
//               _NavIcon(
//                 label: 'Bible',
//                 assetPath: 'assets/icons/bible.svg',
//                 selected: currentIndex == 1,
//                 onTap: () => onTap(1),
//               ),
//               _NavIcon(
//                 label: 'Saved',
//                 assetPath: 'assets/icons/bookmark.svg',
//                 selected: currentIndex == 2,
//                 onTap: () => onTap(2),
//               ),
//               _NavIcon(
//                 label: 'Profile',
//                 assetPath: 'assets/icons/profile.svg',
//                 selected: currentIndex == 3,
//                 onTap: () => onTap(3),
//               ),
//             ],
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             HapticFeedback.selectionClick();
//             Navigator.push(
//               context,
//               CupertinoPageRoute(builder: (_) => ChatHome()),
//             );
//           },
//           child: Container(
//             height: 70.h,
//             width: 70.w,
//             margin: EdgeInsets.only(right: 12.w),
//             padding: EdgeInsets.all(20.sp),
//             decoration: BoxDecoration(
//               color: secondaryGrey,
//               shape: BoxShape.circle,
//             ),
//             child: SvgPicture.asset(
//               'assets/icons/sparkle.svg',
//               width: 18.w,
//               height: 18.h,
//               colorFilter: const ColorFilter.mode(
//                 CupertinoColors.white,
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _NavIcon extends StatelessWidget {
//   final String label;
//   final String assetPath;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const _NavIcon({
//     required this.assetPath,
//     required this.onTap,
//     this.selected = false,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60.h,
//         width: 60.w,
//         decoration: BoxDecoration(
//           color: selected ? accentWhite : secondaryGrey,
//           shape: BoxShape.circle,
//         ),
//         padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               assetPath,
//               width: 24.w,
//               height: 24.h,
//               colorFilter: ColorFilter.mode(
//                 selected ? CupertinoColors.black : CupertinoColors.white,
//                 BlendMode.srcIn,
//               ),
//             ),
//             SizedBox(height: 3.h),
//             Flexible(
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: AllText(
//                   text: label,
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     color:
//                         selected
//                             ? CupertinoColors.black
//                             : CupertinoColors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(color: CupertinoColors.black.withOpacity(0.8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavIcon(
            label: 'Home',
            assetPath:
                currentIndex == 0
                    ? 'assets/icons/home_fill.svg'
                    : 'assets/icons/home.svg',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavIcon(
            label: 'Bible',
            assetPath:
                currentIndex == 1
                    ? 'assets/icons/bible_fill.svg'
                    : 'assets/icons/bible.svg',
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const ChatHome()),
              );
            },
            child: Container(
              height: 61.h,
              width: 61.w,
              decoration: BoxDecoration(
                color: secondaryGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/sparkle.svg',
                  width: 25.w,
                  height: 25.h,
                  colorFilter: ColorFilter.mode(accentWhite, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          _NavIcon(
            label: 'Saved',
            assetPath:
                currentIndex == 2
                    ? 'assets/icons/bookmark_fill.svg'
                    : 'assets/icons/bookmark.svg',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavIcon(
            label: 'Profile',
            assetPath:
                currentIndex == 3
                    ? 'assets/icons/profile_fill.svg'
                    : 'assets/icons/profile.svg',
            selected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.label,
    required this.assetPath,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(assetPath, width: 24.w, height: 24.h),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? accentWhite : textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
