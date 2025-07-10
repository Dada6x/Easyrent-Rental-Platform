import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/security/dialog/change_password_dialog.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/security/dialog/update_userName_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/mi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/security/dialog/delete_account_dialog.dart';
import 'package:easyrent/presentation/views/profile/widgets/custome_list_tile.dart';

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
          ListTile(
            onTap: () {
              showChangePasswordDialog(context);
            },
            leading: Iconify(
              Ph.password_bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            iconColor: grey,
            title: Text('Change Password'.tr, style: AppTextStyles.h18medium),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15.r, //!
            ),
          ),
          ListTile(
            onTap: () {
              showUpdateUsernameDialog(context);
            },
            leading: Iconify(
              Bi.person_badge,
              color: Theme.of(context).colorScheme.primary,
            ),
            iconColor: grey,
            title: Text('Change UserName'.tr, style: AppTextStyles.h18medium),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15.r, //!
            ),
          ),
          const CustomDivider(),
          customListRedTile(
              "Delete My Account ".tr,
              const Iconify(
                Mi.delete,
                color: red,
              ), () {
            showDeleteAccountDialog(context);
          }),
          const Spacer()
        ],
      ),
    );
  }
}
