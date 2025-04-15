import 'package:flutter/cupertino.dart';

class CupertinoSearchBar extends StatelessWidget {
  const CupertinoSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CupertinoSearchTextField(
        placeholder: 'Search for keyword or phrase',
        backgroundColor: CupertinoColors.darkBackgroundGray,
      ),
    );
  }
}
