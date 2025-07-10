import 'package:easyrent/core/app/notifications/notificationsApi.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary value since we're not using state management yet
    bool notificationsEnabled = false;

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        children: [
          ThemedSvgReplacer(
              assetPath: notification,
              themeColor: Theme.of(context).colorScheme.primary,
              height: 250.h,
              width: double.infinity),
          //!
          ListTile(
            title: Text(
              "Enable Notifications",
              style: AppTextStyles.h18regular,
            ),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) async{
                    await NotificationsService().showNotification(
                  id: 12,
                  title: "Hello HELLOO ",
                  body: "Velit dolorum iste distinctio ratione tempore.",
                );
              },
              inactiveThumbColor: grey,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          const CustomDivider(),
        ],
      ),
    );
  }
}
