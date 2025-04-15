import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: const [
              _NavIcon(assetPath: 'assets/icons/home.svg', selected: true),
              SizedBox(width: 12),
              _NavIcon(assetPath: 'assets/icons/bible.svg'),
              SizedBox(width: 12),
              _NavIcon(assetPath: 'assets/icons/bookmark.svg'),
              SizedBox(width: 12),
              _NavIcon(assetPath: 'assets/icons/profile.svg'),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/icons/sparkle.svg', 
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              CupertinoColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String assetPath;
  final bool selected;

  const _NavIcon({required this.assetPath, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? CupertinoColors.systemYellow : CupertinoColors.darkBackgroundGray,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(
        assetPath,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          selected ? CupertinoColors.black : CupertinoColors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
