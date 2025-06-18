import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/theme/theme_page.dart';
import 'package:easyrent/presentation/views/profile/widgets/custome_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Column(
        children: [
          ThemedSvgReplacer(
              assetPath: security,
              themeColor: Theme.of(context).colorScheme.primary,
              height: 220.h,
              width: double.infinity),
          customListTile(
              string: 'Change Password'.tr,
              leading: Iconify(
                Ph.password,
                color: Theme.of(context).colorScheme.primary,
              ),
              destination_widget: const ThemePage()),
          customListTile(
            string: 'Change Phone Number'.tr,
            leading: Iconify(
              Bi.phone,
              color: Theme.of(context).colorScheme.primary,
            ),
            destination_widget: const ThemePage(),
          ),
          const CustomDivider(),
          const Spacer()
        ],
      ),
    );
  }
}
