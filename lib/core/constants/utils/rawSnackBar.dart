import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/constants/colors.dart';

void showErrorSnackbar(String message) {
  Get.rawSnackbar(
    message: message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: red,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.error, color: white),
    snackStyle: SnackStyle.FLOATING,
  );
}

void showSuccessSnackbar(String message) {
  Get.rawSnackbar(
    message: message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: green,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
  );
}
