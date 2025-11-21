import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';

class GalleryWidget extends StatelessWidget {
  final List<String> images;

  const GalleryWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          images.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  viewImage(images[index]);
                },
                child: Card(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 330.w,
                      height: 200.h,
                      child: FancyShimmerImage(
                        imageUrl: "${images[index]}",
                        boxFit: BoxFit.cover,
                        errorWidget: const ErrorLoadingWidget(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void viewImage(String imageUrl) {
  Get.to(() => Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
          iconTheme: const IconThemeData(color: white),
          elevation: 0,
        ),
        body: Center(
          child: PhotoView(
            imageProvider: NetworkImage(
                "http://192.168.1.4:3000/property/images/$imageUrl"),
            backgroundDecoration: const BoxDecoration(
              color: black,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      ));
}
