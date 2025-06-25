import 'package:easyrent/core/services/api/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  const CurrentLocationMap(
      {super.key, latlng, required this.latitude, required this.longitude});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: EndPoints.lightMapTile,
            subdomains: const ['a', 'b', 'c'],
            // userAgentPackageName: 'com.example.easyrent',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: 36.w,
                height: 36.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.15), // Light translucent background
                    shape: BoxShape
                        .circle, // or BoxShape.rectangle with borderRadius
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 28.r,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
