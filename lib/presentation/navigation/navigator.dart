import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easyrent/presentation/views/property_homepage/controller/propertiy_controller.dart';
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
import 'package:easyrent/presentation/views/map/map_page.dart';
import 'package:easyrent/presentation/views/profile/view/profile.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/notifications/views/notifications_drawer.dart';
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

  final List<Widget> _pages = [
    Homepage(),
    const MapPage(),
    const Search(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // late Future<List<PropertyModel>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    Get.find<PropertiesController>().fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ThemeSwitchingArea(
        child: Scaffold(
            key: HomeScreenNavigator.scaffoldKey,
            endDrawer: const NotificationsView(),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    width: 1.5.r,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                selectedLabelStyle: AppTextStyles.h12medium,
                showSelectedLabels: true,
                fixedColor: Theme.of(context).colorScheme.primary,

                unselectedLabelStyle: AppTextStyles.h12medium,
                iconSize: 30.r, //!
                onTap: _onItemTapped,
                items: [
                  BottomNavigationBarItem(
                      activeIcon: Iconify(
                        Bi.house_fill,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30.sp,
                      ),
                      icon: Iconify(
                        Bi.house,
                        color: grey,
                        size: 30.sp,
                      ),
                      label: 'Home'.tr),
                  BottomNavigationBarItem(
                      activeIcon: Iconify(
                        Bi.map_fill,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30.sp,
                      ),
                      icon: Iconify(
                        Bi.map,
                        color: grey,
                        size: 30.sp,
                      ),
                      label: 'Map'.tr),
                  BottomNavigationBarItem(
                      activeIcon: Iconify(
                        Ri.search_fill,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30.sp,
                      ),
                      icon: Iconify(
                        Ri.search_2_line,
                        color: grey,
                        size: 30.sp,
                      ),
                      label: 'Search'.tr),
                  BottomNavigationBarItem(
                      activeIcon: Iconify(
                        Bi.person_fill,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30.sp,
                      ),
                      icon: Iconify(
                        Bi.person,
                        color: grey,
                        size: 30.sp,
                      ),
                      label: 'Profile'.tr),
                ],
                elevation: 2,
                type: BottomNavigationBarType.fixed,
              ),
            ),
            body: Obx(() {
              return !Get.find<AppController>().isOffline.value
                  ? const Center(
                      child: OfflinePage(),
                    )
                  : IndexedStack(
                      index: _selectedIndex,
                      children: _pages,
                    );
            })),
      ),
    );
  }
}
