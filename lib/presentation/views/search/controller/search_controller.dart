// controllers/search_controller.dart
// import 'package:easyrent/data/models/agent_model.dart';
// import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/presentation/views/search/models/search_agent_model.dart';
import 'package:easyrent/presentation/views/search/models/search_property_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum SearchMode { agents, properties }

class Search_Controller extends GetxController {
  var searchMode = SearchMode.properties.obs;

  var agents = <SearchAgentModel>[].obs;
  var properties = <SearchPropertyModel>[].obs;

  var isLoading = false.obs;
  var hasError = false.obs;

  int currentPage = 1;
  bool hasMore = true;

  final String baseUrl = "https://18fbfdf5e6a5.ngrok-free.app"; 

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  void switchMode(SearchMode mode) {
    searchMode.value = mode;
    resetData();
    fetchInitial();
  }

  void resetData() {
    agents.clear();
    properties.clear();
    currentPage = 1;
    hasMore = true;
  }

  Future<void> fetchInitial() async {
    if (searchMode.value == SearchMode.properties) {
      await fetchProperties(reset: true);
    } else {
      await fetchAgents();
    }
  }

  Future<void> fetchAgents() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await http.get(Uri.parse("$baseUrl/users/agency"));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        agents.value = data.map((e) => SearchAgentModel.fromJson(e)).toList();
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProperties({bool reset = false}) async {
    if (!hasMore) return;
    try {
      isLoading.value = true;
      hasError.value = false;

      final res = await http.get(Uri.parse(
          "$baseUrl/properties/all?pageNum=$currentPage&numPerPage=10"));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final newProps =
            data.map((e) => SearchPropertyModel.fromJson(e)).toList();

        if (reset) properties.clear();
        properties.addAll(newProps);

        if (newProps.length < 10) {
          hasMore = false;
        } else {
          currentPage++;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
