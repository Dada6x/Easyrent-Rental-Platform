import 'package:bounce/bounce.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/main.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:like_button/like_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';

class PropertyCardFavorite extends StatefulWidget {
  final String title;
  final int id;
  final String city;
  final String imagePath;
  final int numberOfBeds;
  final int numberOfBaths;
  final String quarter;
  final double area;
  final int priorityScore;

  const PropertyCardFavorite({
    super.key,
    required this.title,
    required this.city,
    required this.imagePath,
    required this.numberOfBeds,
    required this.numberOfBaths,
    required this.area,
    required this.priorityScore,
    required this.quarter,
    required this.id,
  });

  @override
  State<PropertyCardFavorite> createState() => _PropertyCardFavoriteState();
}

class _PropertyCardFavoriteState extends State<PropertyCardFavorite> {
  bool isvisable = true;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: isvisable,
        child: Bounce(
          onTapUp: (p0) {},
          child: Skeletonizer(
            ignoreContainers: false,
            ignorePointers: false,
            enabled: !Get.find<AppController>().isOffline.value,
            enableSwitchAnimation: true,
            child: SizedBox(
              child: Container(
                margin: EdgeInsets.only(right: 12.w, bottom: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Row(
                  children: [
                    //! image
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
                            imageUrl: "http://192.168.1.4:3000/property/images/${widget.imagePath}",
                            errorWidget: const ErrorLoadingWidget(),
                          ),
                        ],
                      ),
                    ),
                    //! details
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title, style: AppTextStyles.h18semi),
                            SizedBox(height: 4.h),
                            //! LOCATION
                            Row(
                              children: [
                                //! quarter
                                Text(
                                  widget.quarter,
                                  style: AppTextStyles.h14regular
                                      .copyWith(color: grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                //! city
                                Text(
                                  widget.city,
                                  style: AppTextStyles.h14regular
                                      .copyWith(color: grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //! Bath
                                _FeaturesIcon(
                                  number: widget.numberOfBaths,
                                  icon: Iconify(Ph.bathtub,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20.sp),
                                ),
                                //! Beds/Rooms
                                _FeaturesIcon(
                                  number: widget.numberOfBeds,
                                  icon: Iconify(Ph.bed,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20.sp),
                                ),
                                //! Area
                                _FeaturesIcon(
                                  number: widget.area.toInt(),
                                  icon: Iconify(Tabler.arrow_autofit_content,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //! likeButton
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: LikeButton(
                        isLiked: true,
                        onTap: (isLiked) async {
                          final newState = !isLiked;
                          try {
                            propertyDio.changeFavoriteState(widget.id);
                            showSnackbarWithContext(
                              "Property removed from Favorites",
                              context,
                            );
                            setState(() {
                              isvisable = !isvisable;
                            });
                            return newState;
                          } catch (e) {
                            showSnackbarWithContext(
                                "Unexpected Error ", context);
                            return isLiked;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _FeaturesIcon extends StatelessWidget {
  final int number;
  final Iconify icon;
  const _FeaturesIcon({required this.number, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(number.toString(), style: AppTextStyles.h14regular),
        SizedBox(width: 4.w),
        icon,
      ],
    );
  }
}
