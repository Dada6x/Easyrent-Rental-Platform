import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';

class noDataPage extends StatelessWidget {
  const noDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // So the column centers nicely
          children: [
            ThemedSvgReplacer(
                assetPath: noData,
                themeColor: Theme.of(context).colorScheme.primary,
                height: 220.h,
                width: double.infinity),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'No Data (404)',
                textAlign: TextAlign.center,
                style: AppTextStyles.h16medium.copyWith(color: grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
