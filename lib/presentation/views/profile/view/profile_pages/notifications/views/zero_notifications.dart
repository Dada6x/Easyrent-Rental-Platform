import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZeroNotifications extends StatelessWidget {
  const ZeroNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ThemedSvgReplacer(
            assetPath: reading,
            themeColor: blue,
            height: 300,
            width: 250,
          ),
          SizedBox(height: 10.h),
          Text(
            "Your inbox is currently empty.",
            style: AppTextStyles.h18semi,
            textAlign: TextAlign.center,
          ),
          const Text(
            "We’ll notify you when new\nmessages arrive.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
