import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/auth/views/verification_code_page.dart';
import 'package:easyrent/presentation/views/auth/widgets/empty_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatelessWidget {
  //$----------------------text controllers------------------------->
  final TextEditingController emailController = TextEditingController();
  //$--------------------------------------------------------------->
  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: emptySearchBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Text('Reset Password', style: AppTextStyles.h32semi),
              SizedBox(height: 10.h),
              Text(
                'Enter your registered email address and we’ll send you instructions to reset your password.',
                style: AppTextStyles.h16light.copyWith(color: grey),
              ),
              SizedBox(height: 40.h),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  prefixIcon: const Icon(Icons.phone),
                  prefixIconColor: blue,
                  labelText: "Phone Number".tr,
                  labelStyle: AppTextStyles.h20regular.copyWith(color: grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement reset password logic
                    //TODO BIG PROPLEM HERE
                    Get.to(() => const VerificationCodePage(userId: 3));
                    //! there is another request called Reset account
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Send Reset Link',
                    style: AppTextStyles.h18semi.copyWith(color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
