import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../core/controllers/translation.controller.dart';
import '../utilities/language.change.utility.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TranslationController>();

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.globe, size: 16),
            SizedBox(width: 6),
            Obx(
              () => Text(
                controller.getLanguageName(controller.currentLanguage.value),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      onPressed: () => LanguageChangeUtility.showLanguageScreen(context),
    );
  }
}
