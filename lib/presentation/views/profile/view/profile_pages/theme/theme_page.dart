import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/app/theme/themes.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = Themes();
    final currentTheme = ThemeModelInheritedNotifier.of(context).theme;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          children: [
            _buildThemeTile(
              context,
              title: 'Light Mode',
              icon: Icons.light_mode,
              color: blue,
              theme: themes.lightMode,
              selected: currentTheme.brightness == Brightness.light,
            ),
            SizedBox(height: 10.h),
            _buildThemeTile(
              context,
              title: 'Dark Mode',
              icon: Icons.dark_mode,
              color: blue,
              theme: themes.darkMode,
              selected: currentTheme.brightness == Brightness.dark,
            ),
            SizedBox(height: 10.h),
            const CustomDivider(),
            const Text("Custom primary Color"),
            _buildThemeTile(
              context,
              title: 'Flaming Red',
              icon: Icons.circle,
              color: red,
              theme: currentTheme.copyWith(
                colorScheme: currentTheme.colorScheme.copyWith(
                  primary: red,
                ),
              ),
            ),
            _buildThemeTile(
              context,
              title: 'Emerald Green',
              icon: Icons.circle,
              color: green,
              theme: currentTheme.copyWith(
                colorScheme: currentTheme.colorScheme.copyWith(
                  primary: green,
                ),
              ),
            ),
            _buildThemeTile(
              context,
              title: 'Ash Grey',
              icon: Icons.circle,
              color: grey,
              theme: currentTheme.copyWith(
                colorScheme: currentTheme.colorScheme.copyWith(
                  primary: grey,
                ),
              ),
            ),
            _buildThemeTile(
              context,
              title: 'Royal Purple',
              icon: Icons.circle,
              color: purple,
              theme: currentTheme.copyWith(
                colorScheme: currentTheme.colorScheme.copyWith(
                  primary: purple,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const CustomDivider(),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      width: 130.w,
                      height: 250.h,
                      child: const MiniPhonePreview())),
            )
          ],
        ),
      ),
    );
  }

//Theme.of(context).extension<GradientColors>()!;

  Widget _buildThemeTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool selected = false,
  }) {
    return RepaintBoundary(
      child: ThemeSwitcher(
        builder: (context) {
          return ListTile(
            onTap: () {
              ThemeSwitcher.of(context).changeTheme(
                theme: theme,
                isReversed: false,
              );
              final appController = Get.find<AppController>();
              appController.setPrimaryColor(color);
            },
            leading: CircleAvatar(
              radius: 18.sp,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 18.sp),
            ),
            title: Text(
              title.tr,
              style: AppTextStyles.h18regular,
            ),
          );
        },
      ),
    );
  }
}

class MiniPhonePreview extends StatelessWidget {
  const MiniPhonePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: black.withOpacity(0.7), width: 1.2.w),
          ),
          child: Column(
            children: [
              Container(
                height: height * 0.03,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.8),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(23.r)),
                ),
              ),
              Container(
                height: height * 0.08,
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                alignment: Alignment.centerLeft,
                color: colorScheme.primary,
                child: Icon(
                  Icons.menu,
                  size: 14.sp,
                  color: colorScheme.onPrimary,
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: width * 0.38,
                    height: height * 0.2,
                    child: Icon(
                      Icons.home,
                      size: 50.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: width * 0.14,
                  height: height * 0.07,
                  margin: EdgeInsets.only(
                    right: width * 0.04,
                    bottom: height * 0.05,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
