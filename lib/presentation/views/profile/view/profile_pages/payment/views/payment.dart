import 'package:bounce/bounce.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/payment/widgets/creditCard_widget.dart';
import 'package:easyrent/presentation/views/web_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:motion/motion.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You're paying for:",
            style: AppTextStyles.h16medium,
          ),
          SizedBox(height: 4.h),
          Text("Premium Listing", style: AppTextStyles.h24bold),
          SizedBox(height: 8.h),
          Text("\$49.99",
              style: AppTextStyles.h32semi
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
          SizedBox(height: 28.h),
          Bounce(
            child: Center(
              child: Motion.elevated(
                elevation: 90,
                translation: true,
                shadow: true,
                glare: true,
                borderRadius: BorderRadius.circular(25.r),
                child: const CreditCardWidget(),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Move your phone and tap the card",
              style: AppTextStyles.h10light.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 250.h),
          // Spacer(),
          // const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const StripeWebPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Pay Now",
                style: AppTextStyles.h18medium.copyWith(color: white),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock,
                  size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              const Text("Payments are securely processed by Stripe",
                  style: TextStyle(color: grey, fontSize: 12)),
            ],
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}

class SecurePaymentWrapper extends StatefulWidget {
  const SecurePaymentWrapper({super.key});

  @override
  State<SecurePaymentWrapper> createState() => _SecurePaymentWrapperState();
}

class _SecurePaymentWrapperState extends State<SecurePaymentWrapper> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), _authenticateUser);
  }

  Future<void> _authenticateUser() async {
    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        Get.snackbar(
            "Not Supported", "Authentication is not supported on this device");
        Get.back();
        return;
      }

      final authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access payment page',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow device PIN/pattern/password fallback
          stickyAuth: false,
        ),
      );

      if (authenticated) {
        setState(() => _isAuthenticated = true);
      } else {
        Get.snackbar("Access Denied", "Authentication failed");
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Authentication error", e.toString());
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isAuthenticated
          ? const PaymentMethod()
          : const Center(child: CircularProgressIndicator()),
    );
  }
}