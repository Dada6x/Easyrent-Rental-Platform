import 'package:easyrent/presentation/views/search/widgets/property_widget_search_card.dart';
import 'package:flutter/material.dart';

class PropertySearchFeed extends StatelessWidget {
  final List<int> propertyList;

  const PropertySearchFeed({super.key, required this.propertyList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const PropertyWidgetSearchCard(
            id: 1,
            title: 'Lucky Lake Apartments',
            location: 'Tokyo, Japan',
            imagePath:
                "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            price: 5000,
            rating: 4.3,
          );
        },
        childCount: propertyList.length,
      ),
    );
  }
}
