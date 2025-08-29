import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:easyrent/core/app/controller/app_controller.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/offline_page.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/presentation/views/AgentFeatures/uploadProperties_agent.dart';
import 'package:easyrent/presentation/views/map/map_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/notifications/views/notifications_drawer.dart';
import 'package:easyrent/presentation/views/property_homepage/controller/propertiy_controller.dart';
import 'package:easyrent/presentation/views/property_homepage/views/homePage.dart';
import 'package:easyrent/presentation/views/search/views/search_page.dart';

class HomeScreenNavigator extends StatefulWidget {
  const HomeScreenNavigator({super.key});

  @override
  State<HomeScreenNavigator> createState() => _HomeScreenNavigatorState();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}

class _HomeScreenNavigatorState extends State<HomeScreenNavigator> {
  int _selectedIndex = 0;
  late final bool isAgency;

  @override
  void initState() {
    super.initState();
    isAgency = AppSession().user!.userType == "agency";
    Get.find<PropertiesController>().fetchProperties();
  }

  List<Widget> get _pages => [
        Homepage(),
        const MapPage(),
        if (isAgency) const UploadHomesPage(), // your agency-specific page
        const Search(),
        const Profile(),
      ];

  List<BottomNavigationBarItem> get _navItems {
    final items = [
      BottomNavigationBarItem(
        activeIcon: Iconify(Bi.house_fill,
            color: Theme.of(context).colorScheme.primary, size: 30.sp),
        icon: Iconify(Bi.house, color: grey, size: 30.sp),
        label: 'Home'.tr,
      ),
      BottomNavigationBarItem(
        activeIcon: Iconify(Bi.map_fill,
            color: Theme.of(context).colorScheme.primary, size: 30.sp),
        icon: Iconify(Bi.map, color: grey, size: 30.sp),
        label: 'Map'.tr,
      ),
    ];

    if (isAgency) {
      items.add(BottomNavigationBarItem(
        activeIcon: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8.r),
          child: Iconify(
            Ri.add_circle_fill,
            color: blue,
            size: 30.sp,
          ),
        ),
        icon: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8.r),
          child: Iconify(
            Ri.add_circle_line,
            color: grey,
            size: 30.sp,
          ),
        ),
        label: 'Add'.tr,
      ));
    }

    items.addAll([
      BottomNavigationBarItem(
        activeIcon: Iconify(Ri.search_fill,
            color: Theme.of(context).colorScheme.primary, size: 30.sp),
        icon: Iconify(Ri.search_2_line, color: grey, size: 30.sp),
        label: 'Search'.tr,
      ),
      BottomNavigationBarItem(
        activeIcon: Iconify(Bi.person_fill,
            color: Theme.of(context).colorScheme.primary, size: 30.sp),
        icon: Iconify(Bi.person, color: grey, size: 30.sp),
        label: 'Profile'.tr,
      ),
    ]);

    return items;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        key: HomeScreenNavigator.scaffoldKey,
        endDrawer: const NotificationsView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: _navItems,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTextStyles.h12medium,
          unselectedLabelStyle: AppTextStyles.h12medium,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          iconSize: 30.r,
        ),
        body: Obx(() {
          return !Get.find<AppController>().isOffline.value
              ? const Center(child: OfflinePage())
              : IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                );
        }),
      ),
    );
  }
}
