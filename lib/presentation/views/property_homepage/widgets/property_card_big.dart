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
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/property_homepage/views/property_details_page.dart';

class PropertyCardBig extends StatelessWidget {
  final String imagePath;
  final int id;
  final String title;
  final String city;
  final String streetName;
  final double price;
  final double rating;
  const PropertyCardBig(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.city,
      required this.price,
      required this.rating,
      required this.streetName,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Bounce(
        tapDelay: const Duration(milliseconds: 150),
        onTapUp: (p0) async {
          SystemSound.play(SystemSoundType.click);
          final property = await propertyDio.propertyDetailsById(id);
          Get.to(
            () => PropertyDetailsPage(property: property),
            duration: const Duration(milliseconds: 600),
          );
        },
        child: Skeletonizer(
          enabled: !Get.find<AppController>().isOffline.value,
          enableSwitchAnimation: true,
          containersColor: Theme.of(context).colorScheme.onTertiary,
          child: Container(
            width: 250.w,
            margin: EdgeInsets.only(right: 16.w),
            child: Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1,
                  child: Stack(
                    children: [
                      // !Background Image
                      FancyShimmerImage(
                          height: 340.h,
                          width: 250.w,
                          boxFit: BoxFit.cover,
                          imageUrl: imagePath,
                          errorWidget: const ErrorLoadingWidget()),
                      //! Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Text Info
                      Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 16.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.h20semi.copyWith(
                                color: white,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  city,
                                  style: AppTextStyles.h16regular.copyWith(
                                    color: white,
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  streetName,
                                  style: AppTextStyles.h16regular.copyWith(
                                    color: white,
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '\$$price',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating Badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, color: orange, size: 18.sp),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
