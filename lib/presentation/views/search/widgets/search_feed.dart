import 'package:easyrent/data/models/propertyModel.dart';
import 'package:flutter/material.dart';
import 'package:easyrent/presentation/views/search/widgets/property_widget_search_card.dart';

class PropertySearchFeed extends StatelessWidget {
  final List<PropertyModel> propertyList;

  const PropertySearchFeed({super.key, required this.propertyList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final property = propertyList[index];
          return PropertyWidgetSearchCard(
            id: property.id ?? 0,
            title: property.title ?? 'No Title',
            location: property.location!.governorate??"Unknown" ,
            imagePath: property.firstImage ?? '',
            price: 00,
            rating: 55,
          );
        },
        childCount: propertyList.length,
      ),
    );
  }
}
