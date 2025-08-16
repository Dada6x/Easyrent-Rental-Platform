import 'package:easyrent/data/models/plan_model.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  var plans = <SubscriptionPlan>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var isOrderLoading = false.obs;
  var orderhasError = false.obs;

  Future<void> getSubscriptionPlans() async {
    try {
      isLoading(true);
      final response = await userDio.getSubscriptionPlan();
      plans.assignAll(response);
      isLoading(false);
      hasError(false);
    } catch (e, s) {
      hasError(true);
      printError(info: e.toString());
      printError(info: s.toString());
    }
  }

  Future<void> orderSubscription(int planId, BuildContext context) async {
    try {
      isOrderLoading(true);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('canRedirect', true);
      final response = await userDio.goToStripePage(planId);
      if (await canLaunchUrl(Uri.parse(response.toString()))) {
        await launchUrl(
            Uri.parse(
              response.toString(),
            ),
            mode: LaunchMode.externalApplication);
      } else {
        debug.e("we cant print it nigger");
      }
      isOrderLoading(false);
      orderhasError(false);
    } catch (e, s) {
      orderhasError(true);
      printError(info: e.toString());
      printError(info: s.toString());
    }
  }
}
