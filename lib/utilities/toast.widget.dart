// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hope/utilities/text.utility.dart' show AllText;
import 'package:toastification/toastification.dart'
    show
        CloseButtonShowType,
        ToastificationCallbacks,
        ToastificationItem,
        ToastificationStyle,
        ToastificationType,
        toastification;

Future<ToastificationItem?> showCustomToast({
  required BuildContext context,
  required String title,
  required String description,
  bool? autoCloseFalse,
  required ToastificationType type,
  VoidCallback? onTap,
  required Color primaryColor,
  required IconData icon,
  AlignmentGeometry alignment = Alignment.topCenter,
}) async {
  return await toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.flat,
    autoCloseDuration:
        autoCloseFalse == true ? null : const Duration(seconds: 5),
    title: AllText(text: title),
    description: AllText(text: description),
    alignment: alignment,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: Icon(icon, color: primaryColor),
    primaryColor: primaryColor,
    backgroundColor: CupertinoColors.white,
    foregroundColor: CupertinoColors.black,
    padding: const EdgeInsets.only(left: 12, top: 14, bottom: 14, right: 8),
    margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: false,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) {
        if (onTap != null) {
          onTap();
          toastification.dismissAll();
        }
      },
      onCloseButtonTap:
          (toastItem) => print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted:
          (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

// Success

Future<void> showSuccessToast({
  required BuildContext context,
  required String title,
  required String description,
  AlignmentGeometry alignment = Alignment.topCenter, // Default alignment
}) async {
  await showCustomToast(
    context: context,
    title: title,
    description: description,
    type: ToastificationType.success,
    primaryColor: CupertinoColors.black,
    icon: CupertinoIcons.checkmark_circle_fill,
    alignment: alignment,
  );
}

// Info

Future<void> showInfoToast({
  required BuildContext context,
  required String title,
  required String description,
  AlignmentGeometry alignment = Alignment.topCenter, // Default alignment
}) async {
  await showCustomToast(
    context: context,
    title: title,
    description: description,
    type: ToastificationType.info,
    primaryColor: CupertinoColors.black,
    icon: CupertinoIcons.info_circle_fill,
    alignment: alignment,
  );
}

// Warning

Future<void> showWarningToast({
  required BuildContext context,
  required String title,
  required String description,
  AlignmentGeometry alignment = Alignment.topCenter, // Default alignment
}) async {
  await showCustomToast(
    context: context,
    title: title,
    description: description,
    type: ToastificationType.warning,
    primaryColor: CupertinoColors.black,
    icon: CupertinoIcons.exclamationmark_triangle_fill,
    alignment: alignment,
  );
  HapticFeedback.vibrate();
}

// Error

Future<void> showErrorToast({
  required BuildContext context,
  required String title,
  required String description,
  ToastificationItem? onTap,
  AlignmentGeometry alignment = Alignment.topCenter, // Default alignment
}) async {
  await showCustomToast(
    //onTap: onTap,
    context: context,
    title: title,
    description: description,
    type: ToastificationType.error,
    primaryColor: CupertinoColors.black,
    icon: CupertinoIcons.exclamationmark_circle_fill,
    alignment: alignment,
  );
  HapticFeedback.vibrate();
}
