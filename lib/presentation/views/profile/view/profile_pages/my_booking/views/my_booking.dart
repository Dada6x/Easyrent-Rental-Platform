import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';

import 'package:easyrent/presentation/views/AgentFeatures/uploadProperties.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/plans/plans_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:get/get.dart'; // your color constants

class MyBooking extends StatelessWidget {
  const MyBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ThemedSvgReplacer(
              assetPath: AgentAvatar,
              themeColor: blue,
              height: 240,
              width: 240),
          SizedBox(height: 20.h),
          // Description
          Text(
            "Join us and start uploading your properties! Become a verified agent and gain more exposure to potential buyers and renters. It’s quick, easy, and secure.",
            style: AppTextStyles.h18regular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          // Button
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.off(const SubscriptionPage());
                // Get.to(PropertyDetailsPage(
                //     property: PropertyModel(
                //   rooms: 3,
                //   bathrooms: 1,
                //   area: 123.0,
                //   isFloor: false,
                //   floorNumber: 1,
                //   hasGarage: true,
                //   hasGarden: true,
                //   propertyType: "House",
                //   heatingType: "Gas",
                //   flooringType: "Wood",
                //   id: 33,
                //   title: "Modern Cozy Family House",
                //   description:
                //       "A lovely wooden house located in the heart of Cairo, featuring a cozy atmosphere and a charming garden.",
                //   price: 2,
                //   location: Location(
                //     country: "مصر",
                //     governorate: "القاهرة",
                //     city: "القاهرة",
                //     quarter: "باب اللوق",
                //     street: "unnamed road",
                //     lat: 30.0444,
                //     lon: 31.2357,
                //   ),
                //   isForRent: true,
                //   state: "hidden",
                //   propertyImage:
                //       "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                //   propertyImages: [
                //     "https://images.unsplash.com/photo-1519678767534-29483894b34d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                //     "https://images.unsplash.com/photo-1675279200694-8529c73b1fd0?q=80&w=1176&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                //     "https://images.unsplash.com/photo-1564078516393-cf04bd966897?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                //   ],
                //   panoramaImages: [
                //     {
                //       "title": "Living Room",
                //       "url":
                //           "https://images.unsplash.com/photo-1505252772853-08ed4d526ceb?q=80&w=2060&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                //     },
                //     {
                //       "title": "Kitchen",
                //       "url":
                //           "https://images.pexels.com/photos/737551/pexels-photo-737551.jpeg"
                //     }
                //   ],
                //   voteScore: 1,
                //   viewCount: 1,
                //   priorityScore: 49,
                //   createdAt: "2025-05-24T18:41:44.172Z",
                //   updatedAt: "2025-05-27T13:35:26.000Z",
                //   firstImage:
                //       "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                // )));
                // AppSession().user?.userType = 'Agent';
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blue, // your primary color
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                "Become an Agent",
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
