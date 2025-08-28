import 'package:easyrent/core/constants/utils/pages/nodata_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/pages/error_page.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/filterChips.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/searchbar.dart';
import 'package:easyrent/presentation/views/search/controller/search_controller.dart';
import 'package:easyrent/presentation/views/search/widgets/agent_feed.dart';
import 'package:easyrent/presentation/views/search/widgets/search_appbar.dart';
import 'package:easyrent/presentation/views/search/widgets/search_feed.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(Search_Controller());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: searchAppbar(context),
      body: Padding(
        padding: EdgeInsets.all(12.r),
        child: Obx(() {
          final isPropertyMode =
              searchController.searchMode.value == SearchMode.properties;
          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              //! search textfield
              SliverToBoxAdapter(
                child: CustomSearchBar(
                  onSearch: (query) => searchController.search(query),
                ),
              ),
              //! toggle chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Wrap(
                        children: [
                          ChoiceChip(
                            avatar: Iconify(
                              MaterialSymbols.real_estate_agent_rounded,
                              color: searchController.searchMode.value ==
                                      SearchMode.agents
                                  ? white
                                  : blue,
                            ),
                            side: BorderSide.none,
                            showCheckmark: false,
                            label: const Text(' Agents '),
                            selected: searchController.searchMode.value ==
                                SearchMode.agents,
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(
                              color: searchController.searchMode.value ==
                                      SearchMode.agents
                                  ? white
                                  : (Get.isDarkMode ? white : black),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                searchController
                                    .setSearchMode(SearchMode.agents);
                              }
                            },
                          ),
                          ChoiceChip(
                            avatar: Iconify(
                              Mdi.house_group,
                              color: searchController.searchMode.value ==
                                      SearchMode.properties
                                  ? white
                                  : blue,
                            ),
                            side: BorderSide.none,
                            showCheckmark: false,
                            label: const Text('Properties'),
                            selected: searchController.searchMode.value ==
                                SearchMode.properties,
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(
                              color: searchController.searchMode.value ==
                                      SearchMode.properties
                                  ? white
                                  : (Get.isDarkMode ? white : black),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                searchController
                                    .setSearchMode(SearchMode.properties);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //! filter chips (for properties only)
              if (isPropertyMode && searchController.propertyList.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
                    child: const PropertyFilterChips(),
                  ),
                ),
              //$ content BODY
              Obx(() {
//! Loading
                if (searchController.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
// //! Properties
                if (searchController.propertyList.isEmpty) {
                  return const SliverFillRemaining(
                    // hasScrollBody: false,
                    child: Center(child: noDataPage()),
                  );
                }
// //! AGENT
                if (searchController.agentList.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: noDataPage()),
                  );
                }
//! error
                if (searchController.hasError.value) {
                  return const SliverFillRemaining(
                    // fillOverscroll: true,
                    // hasScrollBody: true,
                    child: Center(child: ErrorPage()),
                  );
                }
//$ found data
                final isPropertyMode =
                    searchController.searchMode.value == SearchMode.properties;
                if (isPropertyMode) {
                  return PropertySearchFeed(
                      propertyList: searchController.propertyList.toList());
                } else {
                  return AgentSearchFeed(agentList: searchController.agentList);
                }
              }),
            ],
          );
        }),
      ),
    );
  }
}
