import 'package:easyrent/core/constants/utils/pages/nodata_page.dart';
import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
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
import 'package:easyrent/presentation/views/search/widgets/agent_feed.dart';
import 'package:easyrent/presentation/views/search/widgets/search_appbar.dart';
import 'package:easyrent/presentation/views/search/widgets/search_feed.dart';
import 'package:dio/dio.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SearchController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: searchAppbar(context),
      body: Padding(
        padding: EdgeInsets.all(12.r),
        child: Obx(() {
          final isPropertyMode =
              searchController.searchMode.value == SearchMode.properties;

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (isPropertyMode &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !searchController.isLoading.value &&
                  searchController.hasMoreProperties) {
                searchController.fetchProperties();
              }
              return false;
            },
            child: CustomScrollView(
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
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
                //! content body
                Obx(() {
                  if (searchController.isLoading.value &&
                      searchController.propertyList.isEmpty &&
                      searchController.agentList.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (searchController.hasError.value) {
                    return const SliverFillRemaining(
                      child: Center(child: ErrorPage()),
                    );
                  }

                  if (isPropertyMode) {
                    if (searchController.propertyList.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: noDataPage()),
                      );
                    }
                    return PropertySearchFeed(
                        propertyList: searchController.propertyList.toList());
                  } else {
                    if (searchController.agentList.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: noDataPage()),
                      );
                    }
                    return AgentSearchFeed(
                        agentList: searchController.agentList.toList());
                  }
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}

//#######################
// Controller with pagination

class SearchController extends GetxController {
  RxList<PropertyModel> propertyList = <PropertyModel>[].obs;
  RxList<Agent> agentList = <Agent>[].obs;

  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  Rx<SearchMode> searchMode = SearchMode.properties.obs;

  int currentPage = 1;
  final int numPerPage = 10;
  bool hasMoreProperties = true;

  void setSearchMode(SearchMode mode) {
    searchMode.value = mode;
    if (mode == SearchMode.properties) {
      if (propertyList.isEmpty) fetchProperties(reset: true);
    } else {
      if (agentList.isEmpty) fetchAgents();
    }
  }

  Future<void> fetchProperties({bool reset = false}) async {
    if (isLoading.value || !hasMoreProperties) return;
    try {
      isLoading.value = true;
      if (reset) {
        currentPage = 1;
        hasMoreProperties = true;
        propertyList.clear();
      }
      final response = await Dio().get(
        'https://9f7fa8d46ede.ngrok-free.app/properties/all',
        queryParameters: {
          'pageNum': currentPage,
          'numPerPage': numPerPage,
        },
      );

      final List<PropertyModel> fetched = (response.data['data'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList();

      if (fetched.length < numPerPage) hasMoreProperties = false;
      propertyList.addAll(fetched);
      currentPage++;
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAgents() async {
    try {
      isLoading.value = true;
      final response =
          await Dio().get('https://9f7fa8d46ede.ngrok-free.app/users/agency');
      final List<Agent> fetched = (response.data['data'] as List)
          .map((e) => Agent.fromJson(e))
          .toList();
      agentList.assignAll(fetched);
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (searchMode.value == SearchMode.properties) {
      fetchProperties(reset: true); // optionally add query param
    } else {
      fetchAgents(); // optionally filter by query
    }
  }
}

enum SearchMode { properties, agents }
