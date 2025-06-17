import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';

class PropertyFilterChips extends StatefulWidget {
  const PropertyFilterChips({super.key});

  @override
  State<PropertyFilterChips> createState() => _PropertyFilterChipsState();
}

int selectedIndex = 0;

class _PropertyFilterChipsState extends State<PropertyFilterChips> {
  @override
  Widget build(BuildContext context) {
    final List<String> filters = [
      'All'.tr,
      'House'.tr,
      'Villa'.tr,
      'Apartments'.tr,
      'Lands'.tr,
      'Other'.tr
    ];
    return Visibility(
      child: SizedBox(
        height: 48.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: ChoiceChip(
                showCheckmark: false,
                label: Text(filters[index], style: AppTextStyles.h14regular),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                    )),
                onSelected: (_) {
                  setState(() {
                    selectedIndex = index;
                    // new Request of the vertical list view
                    // but i dont need setState by the way
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Theme.of(context).colorScheme.primary.withOpacity(0.05), for secondery 
      // color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
