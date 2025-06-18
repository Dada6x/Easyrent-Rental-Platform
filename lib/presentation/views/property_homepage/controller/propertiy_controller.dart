import 'package:get/get.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/main.dart';

// chatgpt done this i was worinkg singletone
class PropertiesController extends GetxController {
  var properties = <OuterPropertyModel>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (AppSession().user != null) {
      fetchProperties();
    }
  }

  Future<void> fetchProperties() async {
    debug.w("Fetching Data in the GETX Controller ");

    try {
      isLoading(true);
      hasError(false);
      final result = await PropertyDio.getProperties();
      properties.assignAll(result);
    } catch (e) {
      hasError(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshProperties() async {
    await fetchProperties();
  }
//! how to Pagination
}
