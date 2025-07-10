import 'dart:io';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion/motion.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/Faq/view/faq.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/chatbot/Ai_chatBot.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/favourite/view/favourite_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/feedback/feedback.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/friends/invite_friend_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/language/view/language.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/my_booking/views/my_booking.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/notifications/views/notifications_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/payment/views/payment.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/plans/plans_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/security/view/security_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/theme/theme_page.dart';
import 'package:easyrent/presentation/views/profile/widgets/custome_list_tile.dart';
import 'package:easyrent/presentation/views/profile/widgets/dialog/logout_dialog.dart';
import 'package:easyrent/presentation/views/profile/widgets/profile_appbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 26.h,
            ),
            // Text(AppSession().user?.userType??"hhdad"),
            // AppSession().user!.userType == "super_admin"
            //     ? const Text("Admin")
            //     : const SizedBox(),
            Material(
              shadowColor: Colors.transparent,
              child: Motion(
                filterQuality: FilterQuality.high,
                controller: MotionController(maxAngle: 50, damping: 0.2),
                glare: const GlareConfiguration(maxOpacity: 0),
                shadow: const ShadowConfiguration(color: Colors.transparent),
                translation:
                    const TranslationConfiguration(maxOffset: Offset(50, 120)),
                borderRadius: BorderRadius.circular(80),
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Skeletonizer(
                            enabled: AppSession().user == null,
                            child: CircleAvatar(
                              radius: 85.sp,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: _selectedImage != null
                                    ? Image.file(
                                        File(_selectedImage!.path),
                                        fit: BoxFit.cover,
                                        width: 170.sp,
                                        height: 170.sp,
                                      )
                                    : (AppSession()
                                                .user
                                                ?.profileImage
                                                ?.isNotEmpty ??
                                            false)
                                        ? FancyShimmerImage(
                                            width: 170.sp,
                                            height: 170.sp,
                                            boxFit: BoxFit.cover,
                                            errorWidget:
                                                const ErrorLoadingWidget(),
                                            //TODO REMOVE ITTTT
                                            imageUrl:
                                                "http://192.168.1.4:3000/user/images/${AppSession().user!.profileImage}",
                                          )
                                        : Image.asset(
                                            avatar2,
                                            width: 170.sp,
                                            height: 170.sp,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: AppSession().user != null,
                            child: Positioned(
                              bottom: 1.h,
                              right: -10.w,
                              height: 49.h,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Center(
                                          child: Text('Choose Image')),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                Get.back();
                                                final picker = ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.camera,
                                                );

                                                if (image != null) {
                                                  final result = await userDio
                                                      .uploadUserImage(image);
                                                  result.fold(
                                                    (error) =>
                                                        showErrorSnackbar(
                                                            error),
                                                    (success) {
                                                      showSuccessSnackbar(
                                                          success);
                                                      setState(() {
                                                        _selectedImage = image;
                                                      });
                                                    },
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.camera,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                semanticLabel: "Camera",
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                Get.back();
                                                final picker = ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                );

                                                if (image != null) {
                                                  final result = await userDio
                                                      .uploadUserImage(image);
                                                  result.fold(
                                                    (error) =>
                                                        showErrorSnackbar(
                                                            error),
                                                    (success) {
                                                      showSuccessSnackbar(
                                                          success);
                                                      setState(() {
                                                        _selectedImage = image;
                                                      });
                                                    },
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.image,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                semanticLabel: "Gallery",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                elevation: 2,
                                fillColor:
                                    Theme.of(context).colorScheme.secondary,
                                padding: EdgeInsets.all(10.r),
                                shape: const CircleBorder(),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 28.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // image
                      Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Skeletonizer(
                          enabled: AppSession().user == null,
                          child: Text(
                              textAlign: TextAlign.center,
                              AppSession().user?.username ?? "Loading.......",
                              style: AppTextStyles.h24semi),
                        ),
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
            customListTile(
              string: "My Booking".tr,
              leading: Iconify(
                Bi.calendar2,
                color: Theme.of(context).colorScheme.primary,
                size: 29.sp,
              ),
              destination_widget: const MyBooking(),
            ),
            customListTile(
              string: "Vip ".tr,
              leading: Iconify(
                Mdi.crown,
                color: orange,
                //! make it the Color of the plan
                size: 29.sp,
              ),
              destination_widget: const SubscriptionPage(),
            ),
            //! payment
            customListTile(
              string: "Payments".tr,
              leading: Iconify(
                Bi.credit_card_2_back,
                color: Theme.of(context).colorScheme.primary,
                size: 29.sp,
              ),
              destination_widget: const SecurePaymentWrapper(),
            ),
            //! favorite Page
            customListTile(
                string: "My Favorite".tr,
                leading: Iconify(
                  Bi.bookmark_heart,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const MyFavoritePage()),
            const CustomDivider(),
            //! Notifications
            customListTile(
                string: "Notifications".tr,
                leading: Iconify(
                  Bi.bell,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const NotificationsPage()),
            //! security
            customListTile(
              string: "Security".tr,
              leading: Iconify(
                Bi.shield_shaded,
                color: Theme.of(context).colorScheme.primary,
                size: 29.sp,
              ),
              destination_widget: const SecurityPage(),
            ),
            //! language
            customListTile(
                string: "Language".tr,
                leading: Iconify(
                  Bi.translate,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const LanguagePage()),
            customListTile(
                string: "Themes".tr,
                leading: Iconify(
                  Bi.paint_bucket,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const ThemePage()),
            //! FAQ

            customListTile(
                string: "FAQ".tr,
                leading: Iconify(
                  Bi.question_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const FAQPage()),
            //! invite Friends
            customListTile(
                string: "Invite Friends".tr,
                leading: Iconify(
                  Bi.people,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const InviteFriendPage()),
            customListTile(
                string: "Feed Back ".tr,
                leading: Iconify(
                  Ic.feedback,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const FeedbackPage()),
            customListTile(
                subtitle: "Beta",
                string: "AI Agent ".tr,
                leading: Iconify(
                  Bi.robot,
                  color: Theme.of(context).colorScheme.primary,
                  size: 29.sp,
                ),
                destination_widget: const Ai_ChatBot()),
            const CustomDivider(),
            //! LogOut
            customListRedTile(
                "Logout".tr,
                Iconify(
                  Mdi.logout,
                  size: 29.sp,
                  color: red,
                ), () {
              showDeleteDialog(context);
            }),
            Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Text(
                "Version 1.1o",
                style: AppTextStyles.h12light
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class Scaffold_page extends StatelessWidget {
  final Widget widget;
  final String title;
  const Scaffold_page({
    super.key,
    required this.widget,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 1.0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text(title.tr),
      ),
      body: widget,
    );
  }
}
