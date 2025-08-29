import 'package:bounce/bounce.dart';
import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/constants/utils/textFields.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/main.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/el.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/presentation/views/property_homepage/views/property_details_page.dart';
import 'package:motion/motion.dart';

class MyPropertyCard extends StatelessWidget {
  final PropertyModel property;

  const MyPropertyCard({super.key, required this.property});

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Iconify(Bi.info_circle, color: blue),
                title: const Text("View Details"),
                onTap: () async {
                  Navigator.pop(context);
                  final prop =
                      await propertyDio.propertyDetailsById(property.id!);
                  Get.to(() => PropertyDetailsPage(property: prop));
                },
              ),
              ListTile(
                leading: const Iconify(Mi.edit_alt, color: blue),
                title: const Text("Edit Property"),
                onTap: () {
                  Navigator.pop(context);
                  Get.snackbar("Edit", "Navigate to edit property page here");
                },
              ),
              ListTile(
                leading: const Iconify(Mi.delete, color: blue),
                title: const Text(
                  "Delete Property",
                  style: TextStyle(color: red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDeletePropertyDialog(context, property.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeletePropertyDialog(BuildContext context, int propertyId) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Motion(
          filterQuality: FilterQuality.high,
          controller: MotionController(maxAngle: 50, damping: 0.2),
          glare: const GlareConfiguration(maxOpacity: 0),
          shadow:
              const ShadowConfiguration(color: Colors.transparent, opacity: 0),
          translation:
              const TranslationConfiguration(maxOffset: Offset(100, 80)),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Delete Property?',
                    style: AppTextStyles.h20medium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Enter your password to confirm deletion.\nThis action cannot be undone.',
                    style: AppTextStyles.h14regular,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  CustomTextfield(
                    controller: passwordController,
                    hint: 'password',
                    isPassword: true,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style:
                                AppTextStyles.h16medium.copyWith(color: white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            final password = passwordController.text.trim();
                            if (password.isEmpty) {
                              showErrorSnackbar("Please enter your password");
                              return;
                            }

                            Navigator.pop(context); // close dialog

                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final token = prefs.getString('token') ?? '';

                              final dio = Dio();
                              final response = await dio.delete(
                                "https://83b08d2bbc5a.ngrok-free.app/properties-on/$propertyId",
                                data: {"password": password}, // pass password
                                options: Options(
                                  headers: {
                                    "Authorization": "Bearer $token",
                                    "Accept": "application/json",
                                  },
                                  validateStatus: (status) => true,
                                ),
                              );

                              if (response.statusCode == 200 ||
                                  response.statusCode == 204) {
                                showSnackbarWithContext(
                                    "Property has been Deleted Successfully ",
                                    context);
                              } else {
                                debug.i(
                                    "Delete failed: ${response.statusCode} ${response.data}");

                                showErrorSnackbar("Failed to delete property ");
                              }
                            } on DioException catch (e) {
                              debug.i(
                                  "DioError: ${e.response?.statusCode} ${e.response?.data}");

                              showSnackbarWithContext("NetworkError", context);
                            } catch (e, s) {
                              debug.i("Unexpected error: $e\n$s");
                              showErrorSnackbar("Something Went Wrong ");
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Yes, Delete',
                            style:
                                AppTextStyles.h16medium.copyWith(color: white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Bounce(
        tapDelay: const Duration(milliseconds: 150),
        onTapUp: (p0) {
          SystemSound.play(SystemSoundType.click);
          _showOptions(context);
        },
        child: Skeletonizer(
          enabled: !Get.find<AppController>().isOffline.value,
          enableSwitchAnimation: true,
          containersColor: Theme.of(context).colorScheme.onTertiary,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + status badge
                Stack(
                  children: [
                    FancyShimmerImage(
                      height: 180.h,
                      width: double.infinity,
                      boxFit: BoxFit.cover,
                      imageUrl: EndPoints.imageUrl(property.firstImage ?? ""),
                      errorWidget: const ErrorLoadingWidget(),
                    ),
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          property.status ?? "Unknown",
                          style: AppTextStyles.h16semi.copyWith(color: blue),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title ?? "Unknown",
                        style: AppTextStyles.h24regular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${property.location?.city}, ${property.location?.country}",
                        style: AppTextStyles.h12regular.copyWith(color: grey),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "${property.rooms} rooms • ${property.bathrooms} baths • ${property.area} m²",
                        style: AppTextStyles.h12regular.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "${property.price} \$ ${property.isForRent == true ? "(Rent)" : "(Sale)"}",
                        style: AppTextStyles.h16semi.copyWith(
                          color: property.isForRent == true
                              ? Colors.orange
                              : Colors.green,
                        ),
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
