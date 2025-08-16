import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find<AppController>();

    return RepaintBoundary(
      child: ThemeSwitcher(
        clipper: const ThemeSwitcherCircleClipper(),
        builder: (context) {
          final brightness =
              ThemeModelInheritedNotifier.of(context).theme.brightness;
          final isLight = brightness == Brightness.light;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.5.h, horizontal: 1.w),
            child: IconButton(
              icon: Icon(
                isLight ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => appController.toggleTheme(context),
            ),
          );
        },
      ),
    );
  }
}
