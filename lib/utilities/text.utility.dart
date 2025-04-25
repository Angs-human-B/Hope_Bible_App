import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'language.utility.dart' show LanguageController;

class AllText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const AllText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Obx(() {
      final targetLanguage = languageController.selectedLanguage.value;

      // If the selected language is English, return the original text without translation.
      if (targetLanguage == 'en') {
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          overflow: textOverflow,
          maxLines: maxLines,
          softWrap: true,
        );
      }

      // Otherwise, translate the text to the selected language.
      final translator = GoogleTranslator();
      return FutureBuilder<Translation>(
        future: translator.translate(text, from: 'en', to: targetLanguage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting, show the original text as a fallback.
            return Text(
              text,
              style: style,
              textAlign: textAlign,
              overflow: textOverflow,
              maxLines: maxLines,
              softWrap: true,
            );
          }
          if (snapshot.hasError) {
            // Fallback to the original text in case of an error.
            return Text(
              text,
              style: style,
              textAlign: textAlign,
              overflow: textOverflow,
              maxLines: maxLines,
              softWrap: true,
            );
          }
          // Show translated text if available.
          return Text(
            snapshot.data?.text ?? text,
            style: style,
            textAlign: textAlign,
            overflow: textOverflow,
            maxLines: maxLines,
            softWrap: true,
          );
        },
      );
    });
  }
}
