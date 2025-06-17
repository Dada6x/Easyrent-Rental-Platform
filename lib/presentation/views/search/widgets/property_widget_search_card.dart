import 'package:bounce/bounce.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/repos/propertiesRepo.dart';
import 'package:easyrent/presentation/views/property_homepage/views/property_details_page.dart';

class PropertyWidgetSearchCard extends StatelessWidget {
  final String title;
  final String location;
  final String imagePath;
  final double rating;
  final int price;
  final int id;
  const PropertyWidgetSearchCard(
      {super.key,
      required this.title,
      required this.location,
      required this.imagePath,
      required this.price,
      required this.rating,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Bounce(
        onTapUp: (p0) async {
          SystemSound.play(SystemSoundType.click);
          final property = await PropertiesRepo.propertyDetailsById(id);
          Get.to(
            () => PropertyDetailsPage(property: property),
            duration: const Duration(milliseconds: 600),
          );
        },
        child: Skeletonizer(
          enabled: !Get.find<AppController>().isOffline.value,
          enableSwitchAnimation: true,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      FancyShimmerImage(
                        height: 120.h,
                        width: 120.w,
                        boxFit: BoxFit.cover,
                        imageUrl: imagePath,
                        errorWidget: const ErrorLoadingWidget(),
                      ),
                      Positioned(
                        top: 4.h,
                        left: 70.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14.r,
                                color: orange,
                              ),
                              SizedBox(width: 2.w),
                              Text("$rating", style: AppTextStyles.h10light),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //! Details
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.h18semi),
                        SizedBox(height: 4.h),
                        Text(location,
                            style:
                                AppTextStyles.h14regular.copyWith(color: grey)),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: 12.r),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        textAlign: TextAlign.end,
                        "\$$price",
                        style: AppTextStyles.h18semi.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
