import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _submitFeedback() {
    String feedback = feedbackController.text.trim();

    if (feedback.isEmpty) {
      showErrorSnackbar("Please enter your feedback.");
      return;
    }

    showSuccessSnackbar("Thank you for your feedback!");
    Get.back();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("We'd love to hear from you!", style: AppTextStyles.h16bold),
                      SizedBox(height: 8.h),
                      Text(
                        "Please share any suggestions, bugs, or ideas you have to improve the app.",
                        style: AppTextStyles.h14medium,
                      ),
                      SizedBox(height: 24.h),
                      Text("Your Feedback", style: AppTextStyles.h14bold),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: feedbackController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: "Enter your message here...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text("Email (optional)", style: AppTextStyles.h14bold),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "you@example.com",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Spacer(),
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: AppTextStyles.h18semi.copyWith(color: white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
