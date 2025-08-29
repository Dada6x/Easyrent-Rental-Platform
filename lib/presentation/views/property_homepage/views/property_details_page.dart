import 'package:card_swiper/card_swiper.dart';
import 'package:easyrent/main.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/tabler.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/pages/report_page.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/agent_widget.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/gallery_widget.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/map_location_widget.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/panorama_page.dart';

class PropertyDetailsPage extends StatelessWidget {
  final PropertyModel property;

  const PropertyDetailsPage({super.key, required this.property});

  // Helper to handle nulls and full URLs
  String getValidImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
    }
    if (imagePath.startsWith('http')) return imagePath;
    return 'http://192.168.1.4:3000/property/images/$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Skeletonizer(
            enabled: !Get.find<AppController>().isOffline.value,
            enableSwitchAnimation: true,
            containersColor: Theme.of(context).colorScheme.onTertiary,
            child: Column(
              children: [
                //! Preview Images Swiper
                Stack(
                  children: [
                    SizedBox(
                      height: 450.h,
                      width: double.infinity,
                      child: (property.propertyImages != null &&
                              property.propertyImages!.isNotEmpty)
                          ? Swiper(
                              itemCount: property.propertyImages!.length,
                              itemBuilder: (context, index) =>
                                  FancyShimmerImage(
                                imageUrl: getValidImageUrl(
                                    property.propertyImages![index]),
                                boxFit: BoxFit.cover,
                                errorWidget: const ErrorLoadingWidget(),
                              ),
                              pagination: SwiperPagination(
                                builder: ConnectedDotsPagination(
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  inactiveColor: Colors.white60,
                                ),
                              ),
                              autoplay: true,
                            )
                          : Image.network(
                              'https://via.placeholder.com/400x300?text=No+Image',
                              fit: BoxFit.cover,
                            ),
                    ),

                    //! Top buttons: Back, Favorite, Share, Report
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 15, right: 15),
                      child: Row(
                        children: [
                          _circleButton(
                              Iconify(MaterialSymbols.arrow_back,
                                  size: 28.sp, color: white), () {
                            Get.back();
                          }),
                          const Spacer(),
                          LikeButton(
                            isLiked: property.isFavorite ?? false,
                            onTap: (isLiked) async {
                              final newState = !isLiked;
                              try {
                                propertyDio.changeFavoriteState(property.id!);
                                showSnackbarWithContext(
                                    newState
                                        ? "Property added to Favorites"
                                        : "Property removed from Favorites",
                                    context);
                                return newState;
                              } catch (e) {
                                showSnackbarWithContext(
                                    "Failed to update favorite", context);
                                return isLiked;
                              }
                            },
                          ),
                          SizedBox(width: 12.w),
                          _circleButton(
                              Iconify(MaterialSymbols.share,
                                  size: 28.sp, color: white), () async {
                            final shareText = _buildShareText(property);
                            await SharePlus.instance
                                .share(ShareParams(text: shareText));
                          }),
                          SizedBox(width: 12.w),
                          _circleButton(
                            Iconify(Tabler.dots_vertical,
                                size: 28.sp, color: white),
                            () async {
                              final selected = await showMenu<String>(
                                context: context,
                                position:
                                    const RelativeRect.fromLTRB(100, 100, 0, 0),
                                items: [
                                  const PopupMenuItem<String>(
                                    value: 'report',
                                    child: Text('Report a problem'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'help',
                                    child: Text('Help'),
                                  ),
                                ],
                              );

                              if (selected == 'report') {
                                Get.to(ReportPage(
                                  propertyId: property.id ?? 0,
                                  propertyImage: getValidImageUrl(
                                      property.propertyImages?.first),
                                  title: property.title ?? "Unexpected Error",
                                ));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                // Details section
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(property.title ?? "", style: AppTextStyles.h24semi),
                      SizedBox(height: 8.h),

                      // Property Type & Rating
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
                                property.propertyType ?? "",
                                style: AppTextStyles.h10semi.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            SizedBox(width: 18.w),
                            Icon(Icons.star_rounded, color: orange, size: 25.r),
                            SizedBox(width: 5.w),
                            Text(
                              "${property.priorityScore} (${property.viewCount} reviews )",
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style:
                                  AppTextStyles.h14medium.copyWith(color: grey),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Beds, Baths, Area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _featureIcon(
                              Iconify(Ph.bed,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 26.r),
                              "${property.rooms ?? 0} Beds",
                              context),
                          _featureIcon(
                              Iconify(Ph.bathtub,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 26.r),
                              "${property.bathrooms ?? 0} Baths",
                              context),
                          _featureIcon(
                              Iconify(Tabler.space,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 26.r),
                              "${property.area ?? 0} sqft",
                              context),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      const CustomDivider(),

                      // Agent
                      _Headers(text: "Agent".tr),
                      //! this is HardCoded Data
                      const AgentWidget(
                        agentId: 2,
                        agentImage:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbrmM6dgWVMTOFm_JQ4_K0xtfD8hOOm1EYrw&s",
                        agentName: "Agent44",
                        agentRole: "+96380817760",
                      ),

                      // Overview
                      _Headers(text: "Overview".tr),
                      Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Text(
                          property.description ?? "",
                          style: AppTextStyles.h16medium.copyWith(color: grey),
                        ),
                      ),
                      const CustomDivider(),

                      // Panorama View
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
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Theme.of(context).colorScheme.primary,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      const CustomDivider(),

                      // Facilities
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child:
                            Text("Facilities".tr, style: AppTextStyles.h20semi),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (property.hasGarage ?? false)
                                _buildFacility(Icons.garage, 'Garage', context),
                              if (property.hasGarden ?? false)
                                _buildFacility(Icons.park, 'Garden', context),
                              _buildFacility(Icons.home_work,
                                  property.propertyType ?? "", context),
                              _buildFacility(Icons.fireplace,
                                  property.heatingType ?? "", context),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFacility(Icons.texture,
                                  property.flooringType ?? "", context),
                              if (property.isFloor ?? false)
                                _buildFacility(
                                    Icons.apartment,
                                    'Floor ${property.floorNumber ?? 0}',
                                    context),
                            ],
                          ),
                        ],
                      ),

                      // Gallery
                      const CustomDivider(),
                      _Headers(text: "Gallery".tr),
                      GalleryWidget(
                        images: property.propertyImages != null
                            ? property.propertyImages!
                                .map((e) => getValidImageUrl(e))
                                .toList()
                            : [],
                      ),

                      // Location
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
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "${property.location?.country ?? ''} ,${property.location?.city ?? ''} ,${property.location?.quarter ?? ''},${property.location?.street ?? ''}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300.h,
                        child: CurrentLocationMap(
                            latitude: property.location?.lat ?? 0.0,
                            longitude: property.location?.lon ?? 0.0),
                      ),

                      // Price & Book Now
                      SizedBox(height: 20.h),
                      const CustomDivider(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Price".tr,
                                    style: AppTextStyles.h12medium
                                        .copyWith(color: grey)),
                                Text("\$${property.price ?? 0}",
                                    style: AppTextStyles.h24extrabold.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))
                              ],
                            ),
                            SizedBox(width: 30.h),
                            Expanded(
                              child: SizedBox(
                                height: 44.h,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    elevation: 1,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {},
                                  child: Text("Book Now".tr,
                                      style: AppTextStyles.h16semi
                                          .copyWith(color: white)),
                                ),
                              ),
                            ),
                            SizedBox(width: 30.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _circleButton(Iconify icon, VoidCallback onPressed) {
    return GestureDetector(onTap: onPressed, child: icon);
  }
}

class _Headers extends StatelessWidget {
  final String text;
  const _Headers({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(text, style: AppTextStyles.h20semi),
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
      const SizedBox(width: 5),
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
        child:
            Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
      ),
      const SizedBox(height: 8),
      Text(label,
          style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
    ],
  );
}

String _buildShareText(PropertyModel property) {
  return '''
Hey! I found this beautiful home on EasyRent that you might love.

It has ${property.rooms ?? 0} bedrooms, ${property.bathrooms ?? 0} bathrooms, and a great location at
Latitude: ${property.location?.lat ?? 'N/A'}, Longitude: ${property.location?.lon ?? 'N/A'}.

Check it out here: https://your-app-link.com/property/${property.id ?? 0}
''';
}
