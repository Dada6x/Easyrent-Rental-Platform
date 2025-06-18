import 'package:bounce/bounce.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/payment/widgets/creditCard_widget.dart';
import 'package:easyrent/presentation/views/web_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          // // Summary
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
                child: const CreditCardWidget(), // keep your visual card
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

          const SizedBox(height: 16),

          const SizedBox(height: 30),

          // Pay button
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

          // Stripe note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lock, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text("Payments are securely processed by Stripe",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
