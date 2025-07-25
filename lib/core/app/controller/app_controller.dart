import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easyrent/core/app/theme/themes.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//! this controller manage three things theme , language , and internet connection
class AppController extends GetxController {
  RxBool isDarkMode = false.obs;
  RxBool isArabic = true.obs;
  RxBool isOffline = true.obs;
  final Rx<Color> primaryColor = blue.obs;

  Future<void> loadPrimaryColor() async {
    final colorValue = userPref?.getInt('primaryColor');
    if (colorValue != null) {
      primaryColor.value = Color(colorValue);
    }
  }

  Future<void> setPrimaryColor(Color color) async {
    primaryColor.value = color;
    await userPref?.setInt('primaryColor', color.value);
  }

  // change language
  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    Get.updateLocale(locale);
  }

  // check internet connection
  StreamSubscription? _internetConnectionStreamSubscription;

  void _checkInternetConnection() {
    bool isFirstCheck = true;
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          isOffline.value = true;
          if (isFirstCheck == true) {
            isFirstCheck = false;
            break;
          } else {
            Get.rawSnackbar(
              isDismissible: true,
              message: "You're connected back",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: green,
              margin: EdgeInsets.all(16.r),
              borderRadius: 12.r,
              duration: const Duration(seconds: 3),
              icon: const Iconify(Carbon.wifi, color: white),
              snackStyle: SnackStyle.FLOATING,
            );

            break;
          }
        case InternetStatus.disconnected:
          // isOffline.value = false;

          if (isFirstCheck == true) {
            isFirstCheck = false;
            break;
          } else {
            Get.rawSnackbar(
              isDismissible: true,
              message: "No internet connection",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: red,
              margin: EdgeInsets.all(16.r),
              borderRadius: 12.r,
              duration: const Duration(seconds: 3),
              icon: const Iconify(Carbon.wifi_off, color: white),
              snackStyle: SnackStyle.FLOATING,
            );
            break;
          }
      }
    });
  }

  void toggleTheme(BuildContext context) async {
    final themeSwitcher = ThemeSwitcher.of(context);
    final brightness = ThemeModelInheritedNotifier.of(context).theme.brightness;
    final isLight = brightness == Brightness.light;
    final colorValue = userPref?.getInt('primaryColor');
    final primary = colorValue != null ? Color(colorValue) : blue;
    final newTheme = isLight
        ? Themes().darkMode.copyWith(
              colorScheme:
                  Themes().darkMode.colorScheme.copyWith(primary: primary),
            )
        : Themes().lightMode.copyWith(
              colorScheme:
                  Themes().lightMode.colorScheme.copyWith(primary: primary),
            );
    if (userPref!.getBool('isDarkTheme') != isLight) {
      await userPref!.setBool('isDarkTheme', isLight);
    }
    isDarkMode.value = isLight;
    themeSwitcher.changeTheme(
      theme: newTheme,
      isReversed: isLight,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _checkInternetConnection();
    loadPrimaryColor();
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
