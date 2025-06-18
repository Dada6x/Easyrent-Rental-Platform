import 'package:easyrent/core/app/notifications/notificationsApi.dart';
import 'package:easyrent/core/constants/colors.dart';
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
          ListTile(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                )),
            tileColor: Theme.of(context).colorScheme.secondary,
            title: Text(
              "Enable Notifications",
              style: AppTextStyles.h18regular,
            ),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                // Will be connected to state management later
                // For now, this does nothing
              },
              inactiveThumbColor: grey,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SwitchListTile(
            value: notificationsEnabled,
            onChanged: (val) {},
            title: const Text("Save this card for future use"),
            activeColor: Colors.green,
            contentPadding: EdgeInsets.zero,
          ),
          SizedBox(
            height: 15.h,
          ),
          const CustomDivider(),
          IconButton(
              onPressed: () async {
                await NotificationsService().showNotification(
                  id: 12,
                  title: "Hello HELLOO ",
                  body: "Velit dolorum iste distinctio ratione tempore.",
                );
              },
              icon: const Icon(Icons.message)),
        ],
      ),
    );
  }
}
