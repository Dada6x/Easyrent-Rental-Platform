import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:easyrent/data/models/agent_model.dart';

class AgentController extends GetxController {
  final Dio dio;

  var isLoading = true.obs;
  var error = ''.obs;
  var agent = Rxn<Agent>();

  AgentController({required this.dio});

  Future<void> fetchAgent(int id) async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await dio.get('/users/agency/$id');

      if (response.statusCode == 200) {
        agent.value = Agent.fromJson(response.data);
      } else {
        error.value = 'Failed to load agent';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
