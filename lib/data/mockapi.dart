import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:easyrent/data/models/user_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/data/models/plan_model.dart';

class MockApi {
  Future<List<User>> getUsers() async {
    final data = await rootBundle.loadString('assets/json/users.json');
    final jsonList = json.decode(data) as List;
    return jsonList.map((e) => User.fromJson(e)).toList();
  }

  Future<List<PropertyModel>> getProperties() async {
    final data = await rootBundle.loadString('assets/json/properties.json');
    final jsonList = json.decode(data) as List;
    return jsonList.map((e) => PropertyModel.fromJson(e)).toList();
  }

  Future<List<SubscriptionPlan>> getSubscriptions() async {
    final data = await rootBundle.loadString('assets/json/subscriptions.json');
    final jsonList = json.decode(data) as List;
    return jsonList.map((e) => SubscriptionPlan.fromJson(e)).toList();
  }

  Future<User?> login(String phone, String password) async {
    // Mock login: return the first user matching phone
    final users = await getUsers();
    return users.firstWhere(
      (u) => u.phone == phone,
      orElse: () => throw Exception("User not found"),
    );
  }

  Future<User?> verifyCode(int userId, int code) async {
    // Mock: always return the user
    final users = await getUsers();
    return users.firstWhere((u) => u.id == userId);
  }

  Future<String> uploadProperty(PropertyModel property) async {
    // Mock: just return success
    await Future.delayed(const Duration(seconds: 1));
    return "Property uploaded successfully!";
  }
}
