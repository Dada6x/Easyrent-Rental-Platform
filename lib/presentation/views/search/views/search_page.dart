import 'package:easyrent/core/constants/utils/pages/nodata_page.dart';
import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/data/models/location_model.dart';
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

                //! Mock Data
                // final isPropertyMode =
                //     searchController.searchMode.value == SearchMode.properties;

                // if (isPropertyMode) {
                //   // Example mock property list
                //   final mockProperties = [
                //     PropertyModel(
                //       id: 1,
                //       title: 'Luxury Apartment',
                //       location: Location(
                //         country: 'Syria',
                //         governorate: 'Damascus',
                //         city: 'Damascus',
                //         quarter: 'Al-Midan',
                //         street: 'Main Street',
                //         lat: 33.5,
                //         lon: 36.3,
                //       ),
                //       firstImage: 'https://via.placeholder.com/300',
                //       price: 1500,
                //       rooms: 3,
                //       bathrooms: 2,
                //     ),
                //     PropertyModel(
                //       id: 2,
                //       title: 'Cozy House',
                //       location: Location(
                //         country: 'Syria',
                //         governorate: 'Aleppo',
                //         city: 'Aleppo',
                //         quarter: 'Salahuddin',
                //         street: 'Second Street',
                //         lat: 36.2,
                //         lon: 37.1,
                //       ),
                //       firstImage: 'https://via.placeholder.com/300',
                //       price: 1200,
                //       rooms: 2,
                //       bathrooms: 1,
                //     ),
                //   ];

                //   return PropertySearchFeed(propertyList: mockProperties);
                // } else {
                //   // Example mock agent list
                //   final mockAgents = [
                //     Agent(
                //       id: 1,
                //       name: 'John Doe',
                //       photo: 'https://via.placeholder.com/150',
                //       rating: 4.5,
                //       properties: [],
                //     ),
                //     Agent(
                //       id: 2,
                //       name: 'Jane Smith',
                //       photo: 'https://via.placeholder.com/150',
                //       rating: 4.2,
                //       properties: [],
                //     ),
                //   ];

                //   return AgentSearchFeed(agentList: mockAgents);
                // }
              }),
            ],
          );
        }),
      ),
    );
  }
}




//#################
// import 'package:easyrent/presentation/views/search/controller/search_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Search extends StatelessWidget {
//   Search({super.key});
//   final   searchController = Get.put(Search_Controller());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Search Demo')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Obx(() {
//           final isPropertyMode =
//               searchController.searchMode.value == SearchMode.properties;
//           return Column(
//             children: [
//               // Search bar
//               TextField(
//                 onChanged: (value) => searchController.search(value),
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(Icons.search),
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Mode toggle
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ChoiceChip(
//                     label: Text('Agents'),
//                     selected:
//                         searchController.searchMode.value == SearchMode.agents,
//                     onSelected: (selected) {
//                       if (selected)
//                         searchController.setSearchMode(SearchMode.agents);
//                     },
//                   ),
//                   SizedBox(width: 10),
//                   ChoiceChip(
//                     label: Text('Properties'),
//                     selected: searchController.searchMode.value ==
//                         SearchMode.properties,
//                     onSelected: (selected) {
//                       if (selected)
//                         searchController.setSearchMode(SearchMode.properties);
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // Results
//               Expanded(
//                 child: Obx(() {
//                   if (searchController.isLoading.value) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (searchController.hasError.value) {
//                     return Center(
//                         child: Text(
//                             'Error: ${searchController.errorMessage.value}'));
//                   }
//                   final agentList = searchController.agentList;
//                   final propertyList = searchController.propertyList;

//                   if (isPropertyMode) {
//                     if (propertyList.isEmpty)
//                       return Center(child: Text('No properties found.'));
//                     return ListView.builder(
//                       itemCount: propertyList.length,
//                       itemBuilder: (_, index) {
//                         final p = propertyList[index];
//                         return ListTile(
//                           leading: p.firstImage != null
//                               ? Image.network(p.firstImage!,
//                                   width: 50, height: 50, fit: BoxFit.cover)
//                               : Icon(Icons.home, size: 50),
//                           title: Text(p.title ?? 'No Title'),
//                           subtitle: Text(p.location?.street ?? ''),
//                           trailing:
//                               Text('\$${p.price?.toStringAsFixed(0) ?? '0'}'),
//                         );
//                       },
//                     );
//                   } else {
//                     if (agentList.isEmpty)
//                       return Center(child: Text('No agents found.'));
//                     return ListView.builder(
//                       itemCount: agentList.length,
//                       itemBuilder: (_, index) {
//                         final a = agentList[index];
//                         return ListTile(
//                           leading: Image.network(a.photo,
//                               width: 50, height: 50, fit: BoxFit.cover),
//                           title: Text(a.name),
//                           subtitle: Text(
//                               'Rating: ${a.rating} | Properties: ${a.properties.length}'),
//                         );
//                       },
//                     );
//                   }
//                 }),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
