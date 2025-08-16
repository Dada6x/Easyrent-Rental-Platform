import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';


void showErrorSnackbar(String message) {
  Get.rawSnackbar(
    isDismissible: true,
    message: message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: red,
    margin: EdgeInsets.all(16.r),
    borderRadius: 12.r,
    duration: const Duration(seconds: 3),
    // icon: const Iconify(Carbon.wifi_off, color: white),
    snackStyle: SnackStyle.FLOATING,
  );
}

void showSuccessSnackbar(String message) {
  Get.rawSnackbar(
    isDismissible: true,
    // leftBarIndicatorColor: white,
    // icon: const Iconify(Carbon.wifi, color: white),
    message: message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: green,
    margin: EdgeInsets.all(16.r),
    borderRadius: 12.r,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
  );
}

void showSnackbarWithContext(String message, BuildContext context, {bool isTop = false}) {
  Get.rawSnackbar(
    leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
    isDismissible: true,
    messageText: Text(
      message,
      style: AppTextStyles.h16medium
          .copyWith(color: Theme.of(context).colorScheme.primary),
    ),
    snackPosition: isTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
    backgroundColor: Theme.of(context).colorScheme.surface,
    margin: EdgeInsets.all(22.r),
    borderRadius: 12.r,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
  );
}

