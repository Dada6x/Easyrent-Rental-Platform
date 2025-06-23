import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:motion/motion.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String currentPlan = "Platinum Plan";

  void _subscribeToPlan(String plan) {
    setState(() {
      currentPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ListView(
        children: [
          _buildPlanCard(
            context,
            title: "Basic Plan",
            duration: "LifeTime",
            description: "Free",
            price: "",
            icon: Icons.lock_open_rounded,
            color: const Color(0xFFE0F2F1),
            isCurrent: currentPlan == "Basic Plan",
            showButton: false,
          ),
          _buildPlanCard(
            context,
            title: "Trial Plan",
            duration: "1 day",
            description: "Trial",
            price: "Free",
            icon: Icons.timer_outlined,
            color: const Color(0xFFFFF8E1),
            isCurrent: currentPlan == "Trial Plan",
          ),
          _buildPlanCard(
            context,
            title: "Platinum Plan",
            duration: "3 months",
            description:
                "Publish unlimited properties with priority placement in search results 💎",
            price: "\$9",
            icon: Icons.workspace_premium_outlined,
            color: const Color(0xFFE8EAF6),
            isCurrent: currentPlan == "Platinum Plan",
          ),
          _buildPlanCard(
            context,
            title: "VIP Plan",
            duration: "10 months",
            description:
                "Premium features & enhanced property visibility for 10 months 🏅",
            price: "\$29",
            icon: Icons.verified_user_outlined,
            color: const Color(0xFFFCE4EC),
            isCurrent: currentPlan == "VIP Plan",
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String duration,
    required String description,
    required String price,
    required IconData icon,
    required Color color,
    bool isCurrent = false,
    bool showButton = true,
  }) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    void showPlanDialog() {
      showDialog(
        context: context,
        builder: (_) => Motion(
          filterQuality: FilterQuality.high,
          controller: MotionController(maxAngle: 50, damping: 0.2),
          glare: const GlareConfiguration(maxOpacity: 0),
          shadow:
              const ShadowConfiguration(color: Colors.transparent, opacity: 0),
          translation:
              const TranslationConfiguration(maxOffset: Offset(100, 80)),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)),
            title: Row(
              children: [
                Icon(icon, color: primaryColor, size: 28.sp),
                SizedBox(width: 8.w),
                Expanded(child: Text(title)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price: $price",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Duration: $duration"),
                  SizedBox(height: 12.h),
                  Text(description, style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 12.h),
                  const Text("Features:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 6.h),
                  _buildFeatureList(title),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  _subscribeToPlan(title);
                },
                child: const Text("Subscribe"),
              )
            ],
          ),
        ),
      );
    }

    return Bounce(
      duration: const Duration(milliseconds: 150),
      onTap: () {
        if (!showButton || isCurrent) return;
        showPlanDialog();
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        color: color,
        margin: EdgeInsets.only(bottom: 16.h),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 28.sp, color: primaryColor),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline, color: primaryColor),
                    onPressed: showPlanDialog,
                    tooltip: "Plan details",
                    splashRadius: 24.r,
                  ),
                  isCurrent
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "Current Plan",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.green[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Text(
                          price,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                ],
              ),
              SizedBox(height: 8.h),
              Text("Duration: $duration",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
              SizedBox(height: 6.h),
              Text(description,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[800])),
              if (showButton && !isCurrent) SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList(String planType) {
    List<String> features;
    switch (planType) {
      case "Trial Plan":
        features = [
          "Access to all listings",
          "Test publishing 1 property",
          "No promotion features",
          "Limited to 1 day usage",
        ];
        break;
      case "Platinum Plan":
        features = [
          "Unlimited property publishing",
          "Priority placement in search results",
          "Featured property badge",
          "Support via live chat",
        ];
        break;
      case "VIP Plan":
        features = [
          "Everything in Platinum",
          "Extended listing visibility (10 months)",
          "Premium badge on profile",
          "Direct access to top agents",
        ];
        break;
      default:
        features = ["Standard Access"];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map((f) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(child: Text(f)),
                ],
              ))
          .toList(),
    );
  }
}
