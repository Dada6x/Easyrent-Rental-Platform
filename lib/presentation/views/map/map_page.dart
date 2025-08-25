import 'package:bounce/bounce.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:easyrent/core/constants/utils/rawSnackBar.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:latlong2/latlong.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/pages/error_page.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/property_homepage/controller/propertiy_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  bool _isSwiperVisible = true;
  final bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    // _goToMyLocation;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _goToProperty(OuterPropertyModel property) {
    if (property.location != null) {
      _mapController.move(
          LatLng(property.location!.lat!, property.location!.lon!), 11);
    }
  }

  LatLng? _userLocation;

  // Future<void> _goToMyLocation() async {
  //   setState(() => _isLocating = true);

  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     setState(() => _isLocating = false);
  //     Get.snackbar("Location Disabled", "Please enable location services.");
  //     return;
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       setState(() => _isLocating = false);
  //       Get.snackbar("Permission Denied", "Location permission is required.");
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     setState(() => _isLocating = false);
  //     Get.snackbar(
  //         "Permission Permanently Denied", "Enable location from settings.");
  //     return;
  //   }

  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   setState(() {
  //     _userLocation = LatLng(position.latitude, position.longitude);
  //     _isLocating = false;
  //   });

  //   _mapController.move(_userLocation!, 15);
  // }

  final controller = Get.find<PropertiesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.hasError.value) {
        return const Center(child: ErrorPage());
      }
      final properties = controller.properties;

      return Stack(
        children: [
          //! GestureDetector just for map
          GestureDetector(
            onPanDown: (_) {
              if (_isSwiperVisible) {
                setState(() {
                  _isSwiperVisible = false;
                });
              }
            },
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                keepAlive: false,
                maxZoom: 19,
                initialCenter: properties.isNotEmpty
                    ? LatLng(properties.first.location!.lat!,
                        properties.first.location!.lon!)
                    : const LatLng(30.0444, 31.2357),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: Get.isDarkMode
                      ? EndPoints.darkMapTile
                      : EndPoints.lightMapTile,
                  subdomains: const ['a', 'b', 'c'],
                  //  tileProvider: CachingTileProvider(),
                ),
                MarkerLayer(
                  markers: [
                    // Property Markers
                    ...properties.where((p) => p.location != null).map(
                          (property) => Marker(
                            width: 30.w,
                            height: 30.h,
                            point: LatLng(
                              property.location!.lat!,
                              property.location!.lon!,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _goToProperty(property);
                                setState(() {
                                  _isSwiperVisible = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.circle,
                                  size: 24.r,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                    // Current user location marker
                    if (_userLocation != null)
                      Marker(
                        width: 40.w,
                        height: 40.h,
                        point: _userLocation!,
                        child: Iconify(
                          Mdi.location,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40.r,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          if (!_isSwiperVisible)
            Positioned(
              bottom: 95.h,
              right: 25.w,
              child: FloatingActionButton.small(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const OvalBorder(),
                child: const Icon(Icons.keyboard_arrow_up),
                onPressed: () => setState(() => _isSwiperVisible = true),
              ),
            ),
          //! Zoom buttons
          Positioned(
            top: 60.h,
            right: 15.w,
            child: Container(
              height: 140.h,
              width: 56.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Get.isDarkMode ? black : white,
                    ),
                    onPressed: () {
                      final currentZoom = _mapController.camera.zoom;
                      _mapController.move(
                        _mapController.camera.center,
                        currentZoom + 1,
                      );
                    },
                    iconSize: 30.r,
                    constraints: const BoxConstraints(),
                  ),
                  Divider(
                    color: Get.isDarkMode ? black : white,
                    thickness: 1,
                    indent: 10.w,
                    endIndent: 10.w,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Get.isDarkMode ? black : white,
                    ),
                    onPressed: () {
                      final currentZoom = _mapController.camera.zoom;
                      _mapController.move(
                        _mapController.camera.center,
                        currentZoom - 1,
                      );
                    },
                    iconSize: 30.r,
                  ),
                ],
              ),
            ),
          ),

          //! FAB that moves with swiper
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isSwiperVisible ? 280.h : 20.h,
            right: 20.w,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              // onPressed: _goToMyLocation,
              onPressed: () {},
              child: const Icon(
                Icons.my_location,
              ),
            ),
          ),

          //! Swiper stays responsive
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isSwiperVisible ? 20.h : -300.h,
            left: 0,
            right: 0,
            height: 250.h,
            child: Swiper(
              //! the Card
              onTap: (index) {
                debug.i(properties[index].id);
                //! depening on this You Can GO SEE the DETAILS BY INDEX
              },
              itemCount: properties.length,
              viewportFraction: 0.85,
              scale: 0.95,
              onIndexChanged: (index) {
                _goToProperty(properties[index]);
              },
              itemBuilder: (context, index) {
                final property = properties[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Bounce(
                    onTapUp: (p0) {},
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(15.r),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: FancyShimmerImage(
                                imageUrl: property.firstImage!,
                                boxFit: BoxFit.cover,
                                errorWidget: const ErrorLoadingWidget(),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: black.withOpacity(0.6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('\$${property.price}/mo',
                                        style: AppTextStyles.h18bold.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    Text(
                                      '${property.rooms} bds · ${property.bathrooms} ba · ${property.area} sqft',
                                      style: AppTextStyles.h14medium.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                        '${property.location?.city}, ${property.location?.street}',
                                        style: AppTextStyles.h12light.copyWith(
                                          color: Colors.white70,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLocating)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      );
    }));
  }
}
