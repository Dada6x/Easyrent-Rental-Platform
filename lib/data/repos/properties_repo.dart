import 'dart:convert';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/core/services/api/end_points.dart';
import 'package:easyrent/core/services/api/errors/exceptions.dart';
import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/data/models/favourite_model.dart';
import 'package:easyrent/data/models/outer_property_model.dart';
import 'package:easyrent/data/models/propertyModel.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/services.dart';

class PropertiesRepo {
  final DioConsumer api;
  PropertiesRepo(this.api);

  //!------------------------ get all properties(homePage)----------------------------->
  Future<List<OuterPropertyModel>> getProperties() async {
    try {
      final response = await api.get(
        EndPoints.getAllProperties,
      );
      if (response.statusCode == 200) {
        debug.i("Fetch Properties status code  ${response.statusCode} ._.");
        var responseData = response.data;
        List tempList = [];
        for (var v in responseData) {
          debug.e(v);
          tempList.add(v);
        }
        return OuterPropertyModel.propertiesFromSnapshot(response.data);
      }
      return [];
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return [];
    }
  }

  //!------------------------ get Favorite properties------------------------------->
  Future<List<FavoritePropertyModel>> getFavoriteProperties() async {
    try {
      final response = await api.get(
        EndPoints.favourite,
      );
      if (response.statusCode == 200) {
        debug.t(
            "Fetch Favorite Properties status code  ${response.statusCode} ");
        var responseData = response.data;
        List tempList = [];
        for (var v in responseData) {
          debug.e(v);
          tempList.add(v);
        }
        return FavoritePropertyModel.favoritePropertiesFromSnapshot(
            response.data);
      }
      return [];
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return [];
    }
  }

  //!------------------------ get Properties Details ------------------------------->
  Future<PropertyModel> propertyDetailsById(int id) async {
    try {
      final response = await api.get(
        EndPoints.getPropertyById(id),
      );
      if (response.statusCode == 200) {
        debug.i(
            "Fetched property with id $id, status code ${response.statusCode}");
        debug.i(response.data);
        return PropertyModel.fromJson(response.data);
      }
      return PropertyModel.fromJson({});
    } on ServerException catch (e,s) {
      debug.e("Exception $e");
      debug.e("Exception $s");
      return PropertyModel.fromJson({});
    }
  }

  //!------------------------ Change Favorite State ------------------------------->
  Future<void> changeFavoriteState(int id) async {
    try {
      final response = await api.post(EndPoints.changeFavoriteState(id));
      if (response.statusCode == 200) {
        debug.i("Changed favorite state for property id $id");
        return;
      }
      return;
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return;
    }
  }
  //!------------------------ Get All Agents  ------------------------------->

  Future<List<Agent>> getAgents() async {
    try {
      final response = await api.get(EndPoints.getAllAgents);
      List data = response.data;
      return data.map((e) => Agent.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to load agents: $e");
    }
  }

//$ JSON
  Future<List<Agent>> getAgentsJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/agents.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((e) => Agent.fromJson(e)).toList();
    } catch (e) {
      debug.i("ERROR :$e");
      throw Exception("Failed to load agents from local JSON: $e");
    }
  }

  //!------------------------ Get Agents Info By Id  ------------------------------->

  Future<Agent> getAgentsById(int id) async {
    try {
      final response = await api.get(EndPoints.getAgentDetalsById(id));
      if (response.statusCode == 200) {
        debug.i(
            "Fetched property with id $id, status code ${response.statusCode}");
        debug.i(response.data);
        return Agent.fromJson(response.data);
      }
      return Agent.fromJson({});
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return Agent.fromJson({});
    }
  }

//$$$ JSON
  Future<Agent> getAgentsByIdJson(int id) async {
    try {
      final response = await api.get(EndPoints.getAgentDetalsById(id));
      if (response.statusCode == 200) {
        debug.i(
            "Fetched property with id $id, status code ${response.statusCode}");
        debug.i(response.data);
        return Agent.fromJson(response.data);
      }
      return Agent.fromJson({});
    } on ServerException catch (e) {
      debug.e("Exception $e");
      return Agent.fromJson({});
    }
  }
}

// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$//TODOD REMOVE THIS NONSCENSE :D $$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// ///! mock alternative coz mocky.io not working
//   // 👇 Temporary helper to load mock data from JSON in assets

// import 'dart:convert';
// import 'package:flutter/services.dart';

// class PropertiesRepo {
//   final DioConsumer api;
//   PropertiesRepo(this.api);

//   Future<dynamic> _loadJson(String fileName) async {
//     final data = await rootBundle.loadString('assets/json/$fileName');
//     return json.decode(data);
//   }

//   //!------------------------ get all properties(homePage)----------------------------->
//   Future<List<OuterPropertyModel>> getProperties() async {
//     try {
//       final responseData = await _loadJson('getAllProperties.json');
//       return OuterPropertyModel.propertiesFromSnapshot(responseData);
//     } catch (e) {
//       debug.e("Mock error: $e");
//       return [];
//     }
//   }

//   //!------------------------ get Favorite properties------------------------------->
//   Future<List<FavoritePropertyModel>> getFavoriteProperties() async {
//     try {
//       final responseData = await _loadJson('favourite.json');
//       return FavoritePropertyModel.favoritePropertiesFromSnapshot(responseData);
//     } catch (e) {
//       debug.e("Mock error: $e");
//       return [];
//     }
//   }

//   //!------------------------ get Properties Details ------------------------------->
//   Future<PropertyModel> propertyDetailsById(int id) async {
//     try {
//       final json = await _loadJson('propertyDetails.json');
//       return PropertyModel.fromJson(json);
//     } catch (e) {
//       debug.e("Mock error: $e");
//       return PropertyModel.fromJson({});
//     }
//   }
// }

Future<Map<String, dynamic>> _loadJson(String fileName) async {
  final data = await rootBundle.loadString('assets/json/$fileName');
  return json.decode(data);
}
