import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/presentation/views/property_homepage/views/seeall.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/filterChips.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/searchbar.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/property_card_big.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/property_card_smoll.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({
    super.key,
    required this.properties,
  });
  final List<OuterPropertyModel> properties;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.r),
          child: CustomSearchBar(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.r),
          child: Row(
            children: [
              Text(
                "Featured".tr,
                style: AppTextStyles.h24semi,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.to(() => SeeAll(
                        propertiesList: properties,
                      ));
                },
                child: Text(
                  "See All".tr,
                  style: AppTextStyles.h16semi
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        SizedBox(
          height: 320.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final property = properties[index];

              return PropertyCardBig(
                //TODO do the null safety shit
                id: property.id!,
                imagePath: property.firstImage!,
                city: property.location!.city!,
                streetName: property.location!.street!,
                price: property.price!,
                rating: 4.5,
                title: property.location!.country!,
              );
            },
          ),
          //! swiper
          // child: Swiper(
          //   itemCount: 4,
          //   autoplay: true,
          //   curve: Curves.linear,
          //   viewportFraction: 0.679,
          //   scale: 0.73,
          //   itemBuilder: (context, index) {
          //     final property = properties[index];
          //     return PropertyCardBig(
          //       id: property.id!,
          //       imagePath: property.firstImage!,
          //       city: property.location!.city!,
          //       streetName: property.location!.street!,
          //       price: property.price!,
          //       rating: 4.5,
          //       title: property.location!.country!,
          //     );
          //   },
          // ),
        ),
        SizedBox(
          height: 5.h,
        ),
        const PropertyFilterChips(),
        SizedBox(
          height: 10.h,
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: properties.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250.w,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyCardSmall(
              //TODO do the null safety shit
              id: property.id!,
              title: "House with ${property.rooms} rooms",
              location:
                  '${property.location?.city} ${property.location?.street}',
              price: property.price!,
              rating: 4.5, // Hardcoded
              image: property.firstImage!,
            );
          },
        ),
      ],
    );
  }
}
