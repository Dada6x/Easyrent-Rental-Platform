import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/presentation/views/property_homepage/controller/propertiy_controller.dart';
import 'package:easyrent/presentation/views/search/widgets/agent_feed.dart';
import 'package:easyrent/presentation/views/search/widgets/search_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/filterChips.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/searchbar.dart';
import 'package:easyrent/presentation/views/search/widgets/search_appbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';

enum SearchMode { properties, agents }

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}


class _SearchState extends State<Search> {
  final PropertiesController agentController = Get.put(PropertiesController());

  SearchMode _searchMode = SearchMode.properties;

  // List<int> propertyList = List.generate(9, (index) => index);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPropertyMode = _searchMode == SearchMode.properties;

    return Scaffold(
      appBar: searchAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            //! search textfield
            SliverToBoxAdapter(child: CustomSearchBar()),
            //! agent or prop toggle
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
                              .withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Wrap(
                      // spacing: 11.w,
                      children: [
                        ChoiceChip(
                          avatar: Iconify(MaterialSymbols.real_estate_agent_rounded,
                              color: _searchMode == SearchMode.agents
                                  ? white
                                  : blue),
                          side: BorderSide.none,
                          showCheckmark: false,
                          label: const Text(' Agents '),
                          selected: _searchMode == SearchMode.agents,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: _searchMode == SearchMode.agents
                                ? white
                                : (Get.isDarkMode ? white : black),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _searchMode = SearchMode.agents;
                              });
                              //!Only fetch agents the first time
                              agentController.fetchAgents();
                            }
                          },
                        ),
                        ChoiceChip(
                          avatar: Iconify(Mdi.house_group,
                              color: _searchMode == SearchMode.properties
                                  ? white
                                  : blue),
                          side: BorderSide.none,
                          showCheckmark: false,
                          label: const Text('Properties'),
                          selected: _searchMode == SearchMode.properties,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: _searchMode == SearchMode.properties
                                ? white
                                : (Get.isDarkMode ? white : black),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _searchMode = SearchMode.properties;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isPropertyMode)
              //! filter chips for properties
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
                  child: const PropertyFilterChips(),
                ),
              ),
            //! text found
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(vertical: 6.h),
            //     child: Text(
            //       isPropertyMode
            //           ? "Found ${propertyList.length} Properties"
            //           : "Found ${agentList.length} Agents",
            //       style: AppTextStyles.h20semi,
            //     ),
            //   ),
            // ),
            //! Content list
            isPropertyMode
                ? PropertySearchFeed(propertyList: [])
                : Obx(() {
                    if (agentController.isLoading.value) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (agentController.hasError.value) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text("Failed to load agents",
                              style: TextStyle(color: red)),
                        ),
                      );
                    }
                    return AgentSearchFeed(
                        agentList: agentController.agentList);
                  }),
          ],
        ),
      ),
    );
  }
}
