import 'dart:async';
import 'package:bounce/bounce.dart';
import 'package:easyrent/core/constants/utils/enums.dart';
import 'package:easyrent/core/constants/utils/pages/error_page.dart';
import 'package:easyrent/core/constants/utils/pages/nodata_page.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/property_homepage/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:motion/motion.dart';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:uni_links/uni_links.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri?>? _deepLinkSubscription;
  bool _hasHandledPaymentLink = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    final prefs = await SharedPreferences.getInstance();

    // Cold start
    final initialLink = prefs.getBool('canRedirect') ?? true
        ? await _appLinks.getInitialLink()
        : null;
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    _deepLinkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  void _handleDeepLink(Uri uri) async {
    if (uri.scheme == 'myapp' &&
        uri.host == 'payment' &&
        !_hasHandledPaymentLink) {
      _hasHandledPaymentLink = true; // only handle once
      final status = uri.queryParameters['status'];
      if (status == 'success' && mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/homepage', (Route<dynamic> r) => false);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('canRedirect', false);
      }
    }
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  String currentPlan = "Platinum Plan";
  final bool _pendingLogout = false;

  void _subscribeToPlan(String plan) {
    setState(() {
      currentPlan = plan;
    });
  }

  final SubscriptionController planController = Get.find();
  int userPlanId = AppSession().user!.planId!;
  @override
  Widget build(BuildContext context) {
    planController.getSubscriptionPlans();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        title: const Text("Choose a plan"),
      ),
      body: RefreshIndicator(
        onRefresh: () => planController.getSubscriptionPlans(),
        child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() {
              if (planController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (planController.hasError.value) {
                return const ErrorPage();
              }
              if (planController.plans.isEmpty) {
                return const noDataPage();
              }
              return ListView.builder(
                  itemCount: planController.plans.length,
                  itemBuilder: (context, index) {
                    final plan = planController.plans[index];
                    return _buildPlanCard(context,
                        planId: plan.id,
                        isCurrent: plan.id == userPlanId,
                        title: plan.planType.value,
                        duration: plan.planDuration,
                        description: plan.description,
                        isLoading: planController.isOrderLoading,
                        price: plan.planPrice.toString(),
                        icon: plan.planType.icon, onTap: () {
                      debug.d("yezzir skiii ghhhhhhhh");
                      planController.orderSubscription(plan.id, context);
                    }, color: Colors.white);
                  });
            })),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context,
      {required int planId,
      required String title,
      required String duration,
      required String description,
      required String price,
      required IconData icon,
      required Color color,
      required RxBool isLoading,
      bool isCurrent = false,
      bool showButton = true,
      required VoidCallback onTap}) {
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
                  // const Text("Features:",
                  //     style: TextStyle(fontWeight: FontWeight.bold)),
                  // SizedBox(height: 6.h),
                  // _buildFeatureList(title),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              SizedBox(
                width: 14.w,
              ),
              Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor:
                        isLoading.value ? Colors.grey : primaryColor,
                  ),
                  onPressed: isLoading.value ? () {} : onTap,
                  child: isLoading.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26.sp),
                          child: SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.sp,
                                color: Colors.amber,
                              )),
                        )
                      : const Text(
                          "Subscribe",
                          style: TextStyle(color: Colors.amber),
                        )))
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
