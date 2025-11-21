import 'package:easyrent/data/models/agent_model.dart';
import 'package:get/get.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/main.dart';

class PropertiesController extends GetxController {
  var properties = <OuterPropertyModel>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  final agentList = <Agent>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (AppSession().user != null) {
      fetchProperties();
    }
  }

  Future<void> fetchProperties() async {
    debug.w("Fetching Properties in the GETX Controller ");
    try {
      isLoading(true);
      hasError(false);
      final result = await propertyDio.getProperties();
      properties.assignAll(result);
    } catch (e, s) {
      hasError(true);
      printError(info: e.toString());
      printError(info: s.toString());
    } finally {
      isLoading(false);
    }
  }

  void fetchAgents() async {
    debug.w("Fetching Agents in the GETX Controller ");
    try {

      isLoading(true);
      hasError(false);
      final agents = await propertyDio.getProperties();
      // agentList.assignAll(agents);
    } catch (e) {
      hasError(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshProperties() async {
    await fetchProperties();
  }
}
