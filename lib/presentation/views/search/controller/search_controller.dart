import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';

enum SearchMode { properties, agents }

class Search_Controller extends GetxController {
  final dio = Dio(BaseOptions(baseUrl: "http://192.168.1.7:3000/"));

  var searchMode = SearchMode.properties.obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var agentList = <Agent>[].obs;
  var propertyList = <PropertyModel>[].obs;

  Future<void> search(String query) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = "";

    try {
      if (searchMode.value == SearchMode.agents) {
        final res = await dio.get(
          '/user/agency',
          queryParameters: {'search': query},
        );

        final data = res.data as List;
        agentList.value = data.map((e) => Agent.fromJson(e)).toList();
      } else {
        final res = await dio.get(
          '/property/all',
          queryParameters: {'search': query},
        );

        final data = res.data as List;
        propertyList.value =
            data.map((e) => PropertyModel.fromJson(e)).toList();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchMode(SearchMode mode) {
    if (searchMode.value != mode) {
      searchMode.value = mode;
      clear();
    }
  }

  void clear() {
    agentList.clear();
    propertyList.clear();
    hasError.value = false;
    errorMessage.value = '';
  }
}


//###################
// import 'package:easyrent/data/models/agent_model.dart';
// import 'package:easyrent/data/models/propertyModel.dart';
// import 'package:easyrent/presentation/views/search/views/mockdata.dart';
// import 'package:get/get.dart';


// enum SearchMode { properties, agents }

// class Search_Controller extends GetxController {
//   var searchMode = SearchMode.properties.obs;

//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var errorMessage = ''.obs;

//   var agentList = <Agent>[].obs;
//   var propertyList = <PropertyModel>[].obs;

//   Future<void> search(String query) async {
//     isLoading.value = true;
//     hasError.value = false;
//     errorMessage.value = "";

//     await Future.delayed(Duration(seconds: 1)); // simulate network delay

//     try {
//       if (searchMode.value == SearchMode.agents) {
//         agentList.value = mockAgents
//             .where((agent) => agent.name.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       } else {
//         propertyList.value = mockProperties
//             .where((property) => property.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
//             .toList();
//       }
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void setSearchMode(SearchMode mode) {
//     if (searchMode.value != mode) {
//       searchMode.value = mode;
//       clear();
//     }
//   }

//   void clear() {
//     agentList.clear();
//     propertyList.clear();
//     hasError.value = false;
//     errorMessage.value = '';
//   }
// }
