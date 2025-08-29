import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/navigation/navigator.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:badges/badges.dart' as badges;

AppBar homePageAppbar() {
  return AppBar(
    scrolledUnderElevation: 0.0,
    surfaceTintColor: Colors.transparent,
    forceMaterialTransparency: true,
    elevation: 0,
    title: Row(
      children: [
        Skeletonizer(
          ignorePointers: false,
          ignoreContainers: false,
          enabled: AppSession().user == null,
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: AppSession().user?.profileImage != null
                  ? FancyShimmerImage(
                      boxFit: BoxFit.cover,
                      imageUrl:
                          "http://192.168.1.7:3000/user/images/${AppSession().user!.profileImage}",
                      errorWidget: const Icon(Icons.error),
                    )
                  : AppSession().user!.userType == 'agency'
                      ? Image.asset(
                          agentAvatar,
                          width: 56.w,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          avatar2,
                          width: 56.w,
                          fit: BoxFit.contain,
                        ),
            ),
          ),
        ),
        SizedBox(width: 12.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getGreeting(),
                style: AppTextStyles.h12regular,
                overflow: TextOverflow.ellipsis,
              ),
              Skeletonizer(
                enabled: false,
                containersColor: grey,
                child: Skeletonizer(
                  enabled: AppSession().user == null,
                  child: Text(
                    AppSession().user?.username ?? "Loading.......",
                    style: AppTextStyles.h16medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(top: 8.r, left: 5.w),
        child: const NotificationsButton(),
      ),
    ],
  );
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return "Good Morning! 🌅".tr;
  } else if (hour < 17) {
    return "Good Afternoon! 🌞".tr;
  } else {
    return "Good Evening! 🌙".tr;
  }
}

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(end: 1),
      showBadge: true,
      ignorePointer: false,
      onTap: () {},
      badgeContent: const Text(""),
      child: IconButton(
          onPressed: () {
            HomeScreenNavigator.scaffoldKey.currentState?.openEndDrawer();
          },
          icon: Icon(Icons.notifications,
              size: 30.r,
              color: Color(userPref?.getInt('primaryColor') ?? blue.value))),
    );
  }
}
