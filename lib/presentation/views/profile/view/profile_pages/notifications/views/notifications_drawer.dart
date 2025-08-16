import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 300.w,
        height: double.infinity,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.r,
                  )),
              centerTitle: true,
            ),
            body: Center(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Add this
                  children: [
                    const ThemedSvgReplacer(
                      assetPath: reading,
                      themeColor: blue,
                      height: 300,
                      width: 250,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Your inbox is currently empty.",
                      style: AppTextStyles.h18semi,
                      textAlign: TextAlign.center, // Add this
                    ),
                    const Text(
                      "We’ll notify you when new\nmessages arrive.",
                      textAlign: TextAlign.center, // Add this
                    ),
                  ],
                ),
              ),
            )
            //  Padding(
            //   padding: EdgeInsets.all(5.0.r),
            //   child: const Column(
            //     children: [
            //       CustomDivider(),
            //       NotificationWidget(),
            //       NotificationWidget(),
            //       NotificationWidget(),
            //       NotificationWidget(),
            //     ],
            //   ),
            // ),
            ),
      ),
    );
  }
}
