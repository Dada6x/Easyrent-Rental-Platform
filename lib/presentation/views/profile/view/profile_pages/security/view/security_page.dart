import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/theme/theme_page.dart';
import 'package:easyrent/presentation/views/profile/widgets/custome_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:motion/motion.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Column(
        children: [
          ThemedSvgReplacer(
              assetPath: security,
              themeColor: Theme.of(context).colorScheme.primary,
              height: 220.h,
              width: double.infinity),
          customListTile(
              string: 'Change Password'.tr,
              leading: Iconify(
                Ph.password,
                color: Theme.of(context).colorScheme.primary,
              ),
              destination_widget: const ThemePage()),
          customListTile(
            string: 'Change Phone Number'.tr,
            leading: Iconify(
              Bi.phone,
              color: Theme.of(context).colorScheme.primary,
            ),
            destination_widget: const ThemePage(),
          ),
          const CustomDivider(),
          customListRedTile(
              "Delete My Account ".tr,
              const Iconify(
                Mi.delete_alt,
                color: red,
              ), () {
            showDeleteAccountDialog(context);
          }),
          const Spacer()
        ],
      ),
    );
  }
}

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Motion(
        filterQuality: FilterQuality.high,
        controller: MotionController(maxAngle: 50, damping: 0.2),
        glare: const GlareConfiguration(maxOpacity: 0),
        shadow:
            const ShadowConfiguration(color: Colors.transparent, opacity: 0),
        translation: const TranslationConfiguration(maxOffset: Offset(100, 80)),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are You sure to Delete Your Account ?',
                    style: AppTextStyles.h20medium),
                SizedBox(height: 12.h),
                Text(
                  "This action cannot be undone. Please make sure you want to delete your account.",
                  style: AppTextStyles.h14regular,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text('Cancel',
                                style: AppTextStyles.h16medium
                                    .copyWith(color: white)))),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          //! deleting his account
                          userDio.logout(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Yes, Im Sure ',
                            style:
                                AppTextStyles.h16medium.copyWith(color: white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
