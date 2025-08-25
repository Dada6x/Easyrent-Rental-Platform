import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
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

  void _submitFeedback() {}

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
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("We'd love to hear from you!!",
                          style: AppTextStyles.h32semi.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                      SizedBox(height: 10.h),
                      Text(
                        "Please share any suggestions, bugs, or ideas you have to improve the app ♡.",
                        style: AppTextStyles.h18medium,
                      ),
                      SizedBox(height: 10.h),
                      Text("Your Feedback", style: AppTextStyles.h12light),
                      SizedBox(height: 8.h),
                      TextField(
                        
                        controller: feedbackController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          
                          hintText: "Enter your message here...",
                          hintStyle:
                              AppTextStyles.h18regular.copyWith(color: grey),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(" Your Email ", style: AppTextStyles.h12light),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "you@example.com",
                          hintStyle:
                              AppTextStyles.h16regular.copyWith(color: grey),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Spacer(),
                      SizedBox(height: 25.h),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.0.r),
                          child: ThemedSvgReplacer(
                              assetPath: "assets/images/svg/feedback.svg",
                              themeColor: Theme.of(context).colorScheme.primary,
                              height: 200.h,
                              width: double.infinity),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: () {
                            String feedback = feedbackController.text.trim();

                            if (feedback.isEmpty) {
                              showSnackbarWithContext(
                                  "Report Sent , Thank you for your feedback!",
                                  context);
                              return;
                            }

                            Get.back();
                            showSnackbarWithContext(
                                "Report Sent , Thank you for your feedback!",
                                context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Submit FeedBack ",
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
