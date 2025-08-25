import 'package:easyrent/core/constants/utils/textFields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';

void showUpdateUsernameDialog(BuildContext context) {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool showFields = false;
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
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Update Username", style: AppTextStyles.h20medium),
                    SizedBox(height: 12.h),
                    Text(
                      "To update your username, please enter your current password and new username.",
                      style: AppTextStyles.h14regular,
                      textAlign: TextAlign.center,
                    ),
                    if (showFields) ...[
                      SizedBox(height: 20.h),
                      // TextField(
                      //   controller: passwordController,
                      //   obscureText: true,
                      //   decoration: InputDecoration(
                      //     labelText: "Current Password",
                      //     errorText: isError ? "Invalid credentials" : null,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12.r),
                      //     ),
                      //   ),
                      // ),
                      CustomTextfield(
                        hint: "Current Password ",
                        controller: passwordController,
                        isPassword: true,
                      ),
                      SizedBox(height: 12.h),
                      CustomTextfield(
                        hint: "New Username",
                        controller: usernameController,
                      ),
                    ],
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
                            child: Text("Cancel",
                                style: AppTextStyles.h16medium
                                    .copyWith(color: white)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              if (!showFields) {
                                setState(() => showFields = true);
                                return;
                              }

                              setState(() {
                                isLoading = true;
                                isError = false;
                              });

                              final result = await userDio.updateUsername(
                                context: context,
                                currentPassword: passwordController.text.trim(),
                                newUsername: usernameController.text.trim(),
                              );

                              setState(() => isLoading = false);

                              result.fold(
                                (error) {
                                  setState(() => isError = true);
                                },
                                (_) async {
                                  Navigator.pop(context);
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));
                                  userDio.getProfile();
                                  
                                  //! i think i need to Make an USer Controller so the values Update
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    showFields ? "Update Now" : "Continue",
                                    style: AppTextStyles.h16medium
                                        .copyWith(color: white),
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
