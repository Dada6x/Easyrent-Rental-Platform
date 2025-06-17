import 'package:easyrent/data/repos/propertiesRepo.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/property_homepage/views/property_details_page.dart';

class PropertyCardSmall extends StatelessWidget {
  final String title;
  final double rating;
  final String location;
  final double price;
  final String image;
  final int id;

  const PropertyCardSmall(
      {super.key,
      required this.title,
      required this.rating,
      required this.location,
      required this.price,
      required this.image,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Skeletonizer(
        enabled: !Get.find<AppController>().isOffline.value,
        enableSwitchAnimation: true,
        containersColor: Theme.of(context).colorScheme.onTertiary,
        child: RawMaterialButton(
          onPressed: () async {
            final property = await PropertiesRepo.propertyDetailsById(id);
            Get.to(
              () => PropertyDetailsPage(property: property),
              duration: const Duration(milliseconds: 600),
            );
          },
          child: Card(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                      child: FancyShimmerImage(
                        height: 140.h,
                        boxFit: BoxFit.cover,
                        imageUrl: image,
                        errorWidget: const ErrorLoadingWidget(),
                      ),
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, size: 12.r, color: orange),
                            SizedBox(width: 2.w),
                            Text(
                              "$rating",
                              style: AppTextStyles.h10semi.copyWith(
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.h16semi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        location,
                        style: AppTextStyles.h12regular.copyWith(color: grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        " ${price.toString()} \$",
                        style: AppTextStyles.h16semi.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
