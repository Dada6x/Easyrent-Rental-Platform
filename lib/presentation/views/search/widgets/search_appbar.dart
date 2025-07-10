import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/navigation/navigator.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

AppBar searchAppbar(BuildContext context) {
  return AppBar(
    scrolledUnderElevation: 1.0,
    surfaceTintColor: Colors.transparent,
    forceMaterialTransparency: true,
    elevation: 0,
    centerTitle: true,
    title: Row(
      children: [
        Flexible(
          child: ThemedSvgReplacer(
            assetPath: searchHouse,
            themeColor: Theme.of(context).colorScheme.primary,
            width: 30.w,
            height: 35.h,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Text("Search for Your Ideal Home".tr, style: AppTextStyles.h16medium),
      ],
    ),
    actions: [
      Padding(
        padding: EdgeInsets.all(8.0.r),
        child: const NotificationsButton(),
      )
    ],
  );
}
