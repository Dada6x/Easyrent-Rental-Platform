import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // your color constants
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/core/constants/utils/pages/error_page.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/plans/plans_page.dart';

class MyBooking extends StatelessWidget {
  const MyBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ThemedSvgReplacer(
            assetPath: Business,
            themeColor: Theme.of(context).colorScheme.primary,
            height: 240,
            width: 240,
            originalColors: const ['#0061FF', '#0061ff'],
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .move(
                duration: NumDurationExtensions(3).seconds,
                curve: Curves.easeInOut,
                begin: const Offset(0, -8),
                end: const Offset(0, 6),
              ),
          SizedBox(height: 20.h),
          // Description
          Text(
            "Join us and start uploading your properties! Become a verified agent and gain more exposure to potential buyers and renters. It’s quick, easy, and secure.",
            style: AppTextStyles.h18regular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          // Button
          const Spacer(),

          CustomButton(
              hint: "Become an Agent",
              function: () async {
                Get.off(const SubscriptionPage());
              })
        ],
      ),
    );
  }
}
