import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motion/motion.dart';
import 'package:skeletonizer/skeletonizer.dart';

void showDeleteAccountDialog(BuildContext context) {
  final TextEditingController _passwordController = TextEditingController();
  bool showPasswordField = false;
  bool isLoading = false;
  bool isError = false;

  showDialog(
    context: context,
    builder: (ctx) {
      return Skeletonizer(
        enabled: !Get.find<AppController>().isOffline.value,
        enableSwitchAnimation: true,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Motion(
              filterQuality: FilterQuality.high,
              controller: MotionController(maxAngle: 50, damping: 0.2),
              glare: const GlareConfiguration(maxOpacity: 0),
              shadow: const ShadowConfiguration(
                  color: Colors.transparent, opacity: 0),
              translation:
                  const TranslationConfiguration(maxOffset: Offset(100, 80)),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Are You sure to Delete Your Account?',
                          style: AppTextStyles.h20medium),
                      SizedBox(height: 12.h),
                      Text(
                        "This action cannot be undone. Please make sure you want to delete your account.",
                        style: AppTextStyles.h14regular,
                        textAlign: TextAlign.center,
                      ),
                      if (showPasswordField) ...[
                        SizedBox(height: 20.h),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Enter your password",
                            errorText: isError ? "Incorrect password" : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                // backgroundColor: Theme.of(context)
                                //     .colorScheme
                                //     .primary
                                //     .withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text('Cancel',
                                  style: AppTextStyles.h16medium),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                if (!showPasswordField) {
                                  setState(() => showPasswordField = true);
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                  isError = false;
                                });

                                final result = await userDio.deleteAccount(
                                  password: _passwordController.text.trim(),
                                );

                                setState(() => isLoading = false);

                                result.fold(
                                  (error) {
                                    setState(() => isError = true);
                                  },
                                  (_) async {
                                    Navigator.pop(context);
                                    await Future.delayed(
                                        const Duration(milliseconds: 400));
                                    userDio.logout(context);
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      showPasswordField
                                          ? 'Delete Now'
                                          : 'Yes, I\'m Sure',
                                      style: AppTextStyles.h16medium
                                          .copyWith(color: white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
