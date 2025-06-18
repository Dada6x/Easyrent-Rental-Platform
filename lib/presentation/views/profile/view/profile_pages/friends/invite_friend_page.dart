import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';

class InviteFriendPage extends StatelessWidget {
  const InviteFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemedSvgReplacer(
                assetPath: invite,
                themeColor: Theme.of(context).colorScheme.primary,
                height: 220.h,
                width: double.infinity),
            SizedBox(height: 32.h),
            Text("Invite Your Friends", style: AppTextStyles.h32medium),
            SizedBox(height: 16.h),
            Text("Share the app with your friends and enjoy using it together!",
                textAlign: TextAlign.center, style: AppTextStyles.h14regular),
            const Spacer(),
            CustomButton(
              hint: "Share Now",
              function: () async {
                const String shareText =
                    'Check out this awesome app! Download it now:\nhttps://your-app-link.com';
                await SharePlus.instance.share(ShareParams(text: shareText));
              },
            ),
          ],
        ),
      ),
    );
  }
}
//TODO add the Strings to localization 
