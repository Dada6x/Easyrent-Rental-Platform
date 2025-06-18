import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/property_card_smoll.dart';

class SeeAll extends StatelessWidget {
  final List<OuterPropertyModel> propertiesList;
  const SeeAll({super.key, required this.propertiesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            scrolledUnderElevation: 1.0,
            surfaceTintColor: Colors.transparent,
            forceMaterialTransparency: true,
            pinned: false,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('All Properties'),
            centerTitle: true,
          ),

          // SliverGrid for property items
          SliverPadding(
            padding: EdgeInsets.all(12.w),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final property = propertiesList[index];
                  return PropertyCardSmall(
                    id: property.id!,
                    title: "House with ${property.rooms} rooms",
                    location:
                        '${property.location?.city ?? ''} ${property.location?.street ?? ''}',
                    price: property.price!,
                    rating: 4.5,
                    image: property.firstImage!,
                  );
                },
                childCount: propertiesList.length,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.w,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 0.76,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
