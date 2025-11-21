import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PanoramaPage extends StatefulWidget {
  final List<Map<String, String>> rooms;

  const PanoramaPage({super.key, required this.rooms});

  @override
  State<PanoramaPage> createState() => _PanoramaPageState();
}

class _PanoramaPageState extends State<PanoramaPage> {
  int currentIndex = 0;

  void _nextRoom() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.rooms.length;
    });
  }

  static String baseUrl =
      'https://9f7fa8d46ede.ngrok-free.app/properties-media/images/';

  var currentRommImage = [
    "assets/panorama/panoramaPartment3.jpg",
    "assets/panorama/panoramaPartment2.jpg",
    "assets/panorama/panoramaPartment3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoom = widget.rooms[currentIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: PanoramaViewer(
                maxZoom: 3,
                sensitivity: 1.5,
                // child: Image.network('${currentRoom['url']}'),
                child: Image.asset(currentRommImage[currentIndex]),
              ),
            ),
            Positioned(
              top: 15.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: lightBorder),
                      color: const Color.fromARGB(22, 60, 59, 58),
                      shape: BoxShape.circle,
                    ),
                    child: const BackButton(color: white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: Text(
                        currentRoom['title'] ?? "unknown ",
                        style: AppTextStyles.h20regular.copyWith(color: white),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            Positioned(
              bottom: 40.h,
              right: 20.w,
              child: ElevatedButton(
                onPressed: _nextRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: white.withOpacity(0.03),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: const BorderSide(color: white)),
                ),
                child: Text("Next Room".tr,
                    style: AppTextStyles.h20semi.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
