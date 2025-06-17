import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/filterChips.dart';
import 'package:easyrent/presentation/views/property_homepage/widgets/searchbar.dart';
import 'package:easyrent/presentation/views/search/widgets/property_widget_search_card.dart';
import 'package:easyrent/presentation/views/search/widgets/search_appbar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//! this is pagination or infinite scrolling , it primerly work with the API , to load even more data ,
//! dont just set it up like this without understanding its concept ,
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!
class _SearchState extends State<Search> {
  final ScrollController _scrollController = ScrollController();
  List<int> propertyList = List.generate(9, (index) => index);
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate network delay

    final nextItems = List.generate(6, (index) => propertyList.length + index);
    setState(() {
      propertyList.addAll(nextItems);
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: CustomSearchBar()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
                child: const PropertyFilterChips(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Text(
                  "Found ${propertyList.length} Properties",
                  style: AppTextStyles.h20semi,
                ),
              ),
            ),
            SliverList(
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
            ),
            if (isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

    //  FutureBuilder<List<PropertyModel>>(
    //                       future: _propertiesFuture,
    //                       builder: (context, snapshot) {
    //                         if (snapshot.connectionState ==
    //                             ConnectionState.waiting) {
    //                           return SizedBox(
    //                             height:
    //                                 MediaQuery.of(context).size.height * 0.9.h,
    //                             child: const Center(
    //                                 child: CircularProgressIndicator()),
    //                           );
    //                         }
    //                         if (snapshot.hasError) {
    //                           return const Center(child: ErrorPage());
    //                         }
    //                         if (!snapshot.hasData ||
    //                             snapshot.data == null ||
    //                             snapshot.data!.isEmpty) {
    //                           return const Center(
    //                               child: Text("No properties found."));
    //                         }
    //                         final properties = snapshot.data!;
    //                         return FeedPage(
    //                           properties: properties,
    //                         );
    //                       },
    //                     ),