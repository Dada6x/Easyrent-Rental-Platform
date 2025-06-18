import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';

class ReportPage extends StatefulWidget {
  final int propertyId;
  final String propertyImage;
  final String title;
  const ReportPage(
      {super.key,
      required this.propertyId,
      required this.propertyImage,
      required this.title});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _reportController = TextEditingController();
  String? selectedReason;

  final List<String> reportReasons = [
    'Incorrect Information',
    'Scam or Fraud',
    'Property Unavailable',
    'Abusive Content',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 1.0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        title: const Text("Report Property"),
        centerTitle: true,
      ),
      body: SafeArea(
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
                        Center(
                          child: Card(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 330.w,
                                height: 200.h,
                                child: FancyShimmerImage(
                                  imageUrl: widget.propertyImage,
                                  boxFit: BoxFit.cover,
                                  errorWidget: const ErrorLoadingWidget(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                            child: Text(widget.title,
                                style: AppTextStyles.h20regular)),
                        SizedBox(
                          height: 10.h,
                        ),
                        const CustomDivider(),
                        Text("Why are you reporting this property?",
                            style: AppTextStyles.h16medium),
                        SizedBox(height: 20.h),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Select Reason",
                              labelStyle: AppTextStyles.h18regular),
                          value: selectedReason,
                          items: reportReasons
                              .map((reason) => DropdownMenuItem(
                                    value: reason,
                                    child: Text(reason),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text("Add additional details:",
                            style: AppTextStyles.h14medium),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _reportController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Describe the issue...",
                            helperStyle: AppTextStyles.h16light,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedReason == null ||
                                    _reportController.text.trim().isEmpty) {
                                  Get.snackbar("Missing Info",
                                      "Please select a reason and add details.",
                                      backgroundColor: red.withOpacity(0.8),
                                      colorText: white);
                                  return;
                                }

                                // Replace with real request
                                Get.back();
                                debug.i(
                                    'Reported property ID ${widget.propertyId}');
                                debug.i('Reason: $selectedReason');
                                debug.i('Details: ${_reportController.text}');
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
                                "Submit Report",
                                style: AppTextStyles.h18semi
                                    .copyWith(color: white),
                              ),
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
      ),
    );
  }
}
