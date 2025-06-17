import 'package:card_swiper/card_swiper.dart';
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
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/agent_widget.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/gallery_widget.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/map_location_widget.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/panorama_page.dart';

class PropertyDetailsPage extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailsPage({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Skeletonizer(
            // ignoreContainers: true,

            enabled: !Get.find<AppController>().isOffline.value,
            enableSwitchAnimation: true,
            // effect: ShimmerEffect(),
            containersColor: Theme.of(context).colorScheme.onTertiary,
            child: Column(
              children: [
                //! preview images
                Stack(
                  children: [
                    SizedBox(
                      height: 450.h,
                      width: double.infinity,
                      child: Swiper(
                        itemCount: property.propertyImages!.length,
                        itemBuilder: (context, index) => FancyShimmerImage(
                          imageUrl: property.propertyImages![index],
                          boxFit: BoxFit.cover,
                          errorWidget: const ErrorLoadingWidget(),
                        ),
                        pagination: SwiperPagination(
                          builder: ConnectedDotsPagination(
                            activeColor: Theme.of(context).colorScheme.primary,
                            inactiveColor: Colors.white60,
                          ),
                        ),
                        autoplay: true,
                      ),
                    ),
                    //! share buttons and favorite
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 15, right: 15),
                      child: Row(
                        children: [
                          _circleButton(Icons.arrow_back, () {
                            Get.back();
                          }),
                          const Spacer(),
                          const LikeButton(), //
                          _circleButton(Icons.share, () {}),
                          SizedBox(width: 12.w),
                        ],
                      ),
                    ),
                  ],
                ),
                //details
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! property title
                      Text(
                        property.title ?? "",
                        style: AppTextStyles.h24semi,
                      ),
                      SizedBox(height: 8.h),
                      //! property Type and rating
                      Padding(
                        padding: EdgeInsets.all(5.0.sp),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  //! type
                                  property.propertyType ?? "",
                                  style: AppTextStyles.h10semi.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )),
                            SizedBox(
                              width: 18.w,
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: orange,
                              size: 25.r,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              //! rating and reviews
                              "${property.priorityScore} (${property.viewCount} reviews )",
                              style:
                                  AppTextStyles.h14medium.copyWith(color: grey),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      //! beds and baths and area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _featureIcon(
                              Iconify(
                                Ph.bed,
                                color: Theme.of(context).colorScheme.primary,
                                size: 26.r,
                              ),
                              "${property.rooms} Beds".tr,
                              context),
                          _featureIcon(
                              Iconify(Ph.bathtub,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 26.r),
                              "${property.bathrooms} Baths",
                              context),
                          _featureIcon(
                              Iconify(Tabler.space,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 26.r),
                              "${property.area} sqft",
                              context),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const CustomDivider(),
                      //! Agent Widget
                      _Headers(text: "Agent".tr),
                      const AgentWidget(
                        agentImage: avatar2,
                        agentName: "Yahea Dada",
                        agentRole: "+96380817760",
                      ),
                      //! Overview
                      _Headers(text: "Overview".tr),
                      Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Text(
                          property.description ?? "",
                          style: AppTextStyles.h16medium.copyWith(color: grey),
                        ),
                      ),
                      const CustomDivider(),
                      //! Panorama View
                      const _Headers(text: "Panorama View"),
                      SizedBox(height: 10.h),
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () {
                            Get.to(PanoramaPage(
                                rooms: property.panoramaImages ?? [{}]));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7.r),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5))),
                                  child: Icon(Icons.panorama_horizontal_select,
                                      size: 40.r,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "View Property in 360°",
                                  style: AppTextStyles.h16semi.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const CustomDivider(),

                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          "Facilities".tr,
                          style: AppTextStyles.h20semi,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (property.hasGarage!)
                                _buildFacility(Icons.garage, 'Garage', context),
                              if (property.hasGarden!)
                                _buildFacility(Icons.park, 'Garden', context),
                              _buildFacility(Icons.home_work,
                                  property.propertyType!, context),
                              _buildFacility(Icons.fireplace,
                                  property.heatingType!, context),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFacility(Icons.texture,
                                  property.flooringType!, context),
                              if (property.isFloor!)
                                _buildFacility(Icons.apartment,
                                    'Floor ${property.floorNumber}', context),
                            ],
                          ),
                        ],
                      ),

                      //! GALLERY
                      const CustomDivider(),
                      _Headers(text: "Gallery".tr),
                      GalleryWidget(images: property.propertyImages ?? []),
                      _Headers(text: "Location".tr),
                      //! Location
                      const CustomDivider(),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Skeleton.ignore(
                              child: Iconify(
                                Tabler.location,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "${property.location!.country} ,${property.location!.city} ,${property.location!.quarter},${property.location!.street}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300.h,
                        child: CurrentLocationMap(
                            latitude: property.location!.lat!,
                            longitude: property.location!.lon!),
                      ),
                      //! COMMENTS
                      SizedBox(
                        height: 20.h,
                      ),
                      const CustomDivider(),
                      SizedBox(
                        height: 10.h,
                      ),
                      //! property Price
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price".tr,
                                  style: AppTextStyles.h12medium
                                      .copyWith(color: grey),
                                ),
                                Text(
                                  "\$${property.price}",
                                  style: AppTextStyles.h24extrabold.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 30.h,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 44.h,
                                // width: 200,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    elevation: 1,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Book Now".tr,
                                    style: AppTextStyles.h16semi
                                        .copyWith(color: white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.h,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _circleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        icon,
        size: 28.sp,
        color: white,
      ),
    );
  }
}

class _Headers extends StatelessWidget {
  final String text;
  const _Headers({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        text,
        style: AppTextStyles.h20semi,
      ),
    );
  }
}

Widget _featureIcon(Iconify icon, String label, BuildContext context) {
  return Row(
    children: [
      Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Skeleton.ignore(child: icon)),
      const SizedBox(
        width: 5,
      ),
      Text(label, style: AppTextStyles.h14medium),
    ],
  );
}

class ConnectedDotsPagination extends SwiperPlugin {
  final double dotSize;
  final double activeWidth;
  final Color activeColor;
  final Color inactiveColor;

  ConnectedDotsPagination({
    this.dotSize = 8.0,
    this.activeWidth = 24.0,
    this.activeColor = blue,
    this.inactiveColor = grey,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(config.itemCount, (index) {
            final isActive = index == config.activeIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: dotSize,
              width: isActive ? activeWidth : dotSize,
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(dotSize),
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget _buildFacility(IconData icon, String label, BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: Icon(
          icon,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
