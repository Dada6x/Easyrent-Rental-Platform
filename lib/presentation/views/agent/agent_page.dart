import 'package:card_swiper/card_swiper.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({super.key, required int agentId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Agent Profile"),
          centerTitle: true,
          scrolledUnderElevation: 1.0,
          surfaceTintColor: Colors.transparent,
          forceMaterialTransparency: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Skeletonizer(
            enabled: !Get.find<AppController>().isOffline.value,
            enableSwitchAnimation: true,
            containersColor: Theme.of(context).colorScheme.onTertiary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      //! agent Profile Image
                      CircleAvatar(
                        radius: 70.sp,
                        child: ClipOval(
                          child: FancyShimmerImage(
                            imageUrl: 'https://i.pravatar.cc/150?img=47',
                            errorWidget: const ErrorLoadingWidget(),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Sarah Johnson",
                        style: AppTextStyles.h20medium,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Real Estate Agent • New York",
                        style: AppTextStyles.h14regular
                            .copyWith(color: Colors.grey[500]),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(width: 4.w),
                      OutlinedButton(
                          onPressed: () {},
                          child: Text("+ 963980817760",
                              style: TextStyle(fontSize: 14.sp))),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AgentActionButton(
                        onTap: () => launchPhoneCall("+123123123"),
                        icon: Iconify(
                          size: 32.sp,
                          Ph.phone,
                          //! copy number to clipboard
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: "Call"),
                    _AgentActionButton(
                        onTap: () => openWhatsApp("+963980817760", ""),
                        //! send textmessage through whatsapp
                        icon: Iconify(
                          size: 32.sp,
                          Ph.whatsapp_logo,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: "Message"),
                  ],
                ),
                SizedBox(height: 24.h),
                Text("About", style: AppTextStyles.h20semi),
                const CustomDivider(),
                SizedBox(height: 8.h),
                Text(
                  "Experienced real estate agent with over 10 years in the industry. Specializing in luxury apartments and family homes in NYC.",
                  style:
                      AppTextStyles.h14medium.copyWith(color: Colors.grey[700]),
                ),
                SizedBox(height: 12.h),
                const CustomDivider(),
                SizedBox(height: 12.h),
                //! Properties
                Text("Featured Properties", style: AppTextStyles.h20semi),
                SizedBox(height: 12.h),
                SizedBox(
                    height: 200.h,
                    child: Swiper(
                      viewportFraction: 0.679,
                      scale: 0.73,
                      curve: Curves.linear,
                      itemCount: 3,
                      itemWidth: 160.w,
                      itemBuilder: (context, index) => _PropertyCard(),
                    )),
                SizedBox(
                  height: 20.h,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: SizedBox(
                //     height: 50.h,
                //     width: double.infinity,
                //     child: TextButton(
                //       style: TextButton.styleFrom(
                //         elevation: 1,
                //         backgroundColor: Theme.of(context).colorScheme.primary,
                //       ),
                //       onPressed: () {},
                //       child: Text(
                //         "Book a Call".tr,
                //         style: AppTextStyles.h16semi.copyWith(color: white),
                //       ),
                //     ),
                //   ),
                // ),
                const CustomDivider()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _AgentActionButton extends StatelessWidget {
  final Iconify icon;
  final String label;
  final VoidCallback? onTap; // <-- Add this

  const _AgentActionButton({
    required this.icon,
    required this.label,
    this.onTap, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(10.r), // adjust for icon size
          ),
          child: icon,
        ),
        SizedBox(height: 6.h),
        Text(label, style: TextStyle(fontSize: 13.sp)),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: 150.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Image.network(
              "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              height: 100.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Modern Apartment",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Text("\$1,200 / month",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 13.sp)),
                  SizedBox(height: 4.h),
                  Text("2 Bed • 1 Bath",
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void openWhatsApp(String phoneNumber, String message) async {
  final url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchPhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch phone dialer for $phoneNumber';
  }
}


