import 'package:card_swiper/card_swiper.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({super.key});

  // Hardcoded agent data
  final Map<String, dynamic> agent = const {
    "id": 2,
    "phone": "0953266661",
    "username": "Agency John",
    "profileImage": null,
    "properties": [
      {
        "rooms": 4,
        "bathrooms": 3,
        "area": 280,
        "propertyType": "Villa",
        "id": 1,
        "multi_title": {"en": "Luxury Villa"},
        "price": "2.00",
        "firstImage":
            "https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.1.0"
      },
      {
        "rooms": 3,
        "bathrooms": 2,
        "area": 180,
        "propertyType": "Apartment",
        "id": 2,
        "multi_title": {"en": "Modern Apartment"},
        "price": "5.00",
        "firstImage":
            "https://plus.unsplash.com/premium_photo-1689609950069-2961f80b1e70?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0"
      },
      {
        "rooms": 5,
        "bathrooms": 4,
        "area": 350,
        "propertyType": "Villa",
        "id": 3,
        "multi_title": {"en": "Spacious Modern Villa"},
        "price": "10.50",
        "firstImage":
            "https://images.unsplash.com/photo-1523217582562-09d0def993a6?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.1.0"
      },
      {
        "rooms": 2,
        "bathrooms": 1,
        "area": 90,
        "propertyType": "Apartment",
        "id": 4,
        "multi_title": {"en": "Cozy Apartment"},
        "price": "3.50",
        "firstImage":
            "https://images.unsplash.com/photo-1449844908441-8829872d2607?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0"
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final properties = agent['properties'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agent Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent profile
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70.sp,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: FancyShimmerImage(
                        imageUrl: agent['profileImage'] ?? '',
                        errorWidget: const Icon(Icons.person, size: 50),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(agent['username'] ?? '', style: AppTextStyles.h24bold),
                  SizedBox(height: 4.h),
                  Text("Real Estate Agent",
                      style: AppTextStyles.h14regular
                          .copyWith(color: Colors.grey[600])),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => launchPhoneCall(agent['phone'] ?? ''),
                        icon: const Icon(Icons.phone, size: 18),
                        label: Text(agent['phone'] ?? '',
                            style: TextStyle(fontSize: 14.sp)),
                      ),
                      SizedBox(width: 12.w),
                      OutlinedButton(
                        onPressed: () => openWhatsApp(agent['phone'] ?? '', ""),
                        child: Iconify(Ph.whatsapp_logo,
                            color: Colors.green, size: 28.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Experience
            Text("Experience", style: AppTextStyles.h18semi),
            SizedBox(height: 6.h),
            Text(
              "Over 7 years of experience in the real estate industry, specializing in residential and commercial properties. Successfully helped 300+ clients find their dream homes and investment properties.",
              style: AppTextStyles.h14regular.copyWith(color: Colors.grey[700]),
            ),
            SizedBox(height: 16.h),

            // About / Description
            Text("About", style: AppTextStyles.h18semi),
            SizedBox(height: 6.h),
            Text(
              "John is passionate about connecting people with their perfect property. Known for his professionalism, market expertise, and dedication to customer satisfaction. Always up-to-date with the latest market trends and investment opportunities.",
              style: AppTextStyles.h14regular.copyWith(color: Colors.grey[700]),
            ),
            SizedBox(height: 24.h),

            // Featured Properties
            Text("Featured Properties", style: AppTextStyles.h20semi),
            SizedBox(height: 12.h),
            SizedBox(
              height: 250.h,
              child: Swiper(
                viewportFraction: 0.72,
                scale: 0.78,
                curve: Curves.easeInOut,
                itemCount: properties.length,
                itemWidth: 180.w,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return _PropertyCard(property: property);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      width: 180.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 8.r,
              offset: const Offset(0, 4))
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  property['firstImage'] ?? '',
                  height: 140.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "${property['rooms']} beds • ${property['bathrooms']} baths • ${property['area']} m²",
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
                Text(property['multi_title']?['en'] ?? '',
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text("\$${property['price'] ?? ''}M",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Launch phone
Future<void> launchPhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch phone dialer for $phoneNumber';
  }
}

// Open WhatsApp
void openWhatsApp(String phoneNumber, String message) async {
  final url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
